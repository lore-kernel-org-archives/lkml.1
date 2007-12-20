Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbXLTU4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbXLTU4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXLTU4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:56:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50753 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbXLTU4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:56:09 -0500
Date: Thu, 20 Dec 2007 21:55:55 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Bodo Eggert <7eggert@gmx.de>, Mark Lord <lkml@rtr.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
In-Reply-To: <20071219142351.GI8181@ftp.linux.org.uk>
Message-ID: <alpine.LSU.0.999.0712191627220.14864@be1.lrz>
References: <9BTqk-2ck-31@gated-at.bofh.it> <9BTJN-2Sv-21@gated-at.bofh.it>
 <9BTTr-35L-13@gated-at.bofh.it> <E1J4zCp-0003fj-5I@be1.7eggert.dyndns.org>
 <20071219142351.GI8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19BFaEXH+nWItQHH2qDn1xCIOhzIkFU1gTXCLd
 ccLXmunNZFU+9HsvFX8EUsu4Wcuafy1/EazhwvUBTv53JAzyrV
 CcvxTjBuR01K4dOGOj6tA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, Al Viro wrote:
> On Wed, Dec 19, 2007 at 02:43:26PM +0100, Bodo Eggert wrote:

> > Since nobody knows about this "security boundary" and everybody knows about
> > the annoying "can't link across bind-mountpoints bug",
> 
> ... how about teaching people to RTFM?  Starting, perhaps, with man 2 link?

What about reading POSIX which says 

1264 [EXDEV]
1265 Improper link. A link to a file on another file system was attempted.

So if the link creates a file on NOT another filesystem (which is the point 
of bind mounts), it should NOT return EXDEV.

Having an artificial boundary between different views to a fs may happen to 
be a security feature if used with care, but most users do expect the 
opposite and wonder why mv is needlessly slow. I'm not even sure if 
defaulting to having a barrier is sane at all, but if people confuse 
filesystems and mountpoints^W^W^W^Wuse this feature, they will depend on 
this feature not changing:-)

-- 
"It is generally inadvisable to eject directly over the area you just
bombed."
-U.S. Air Force Manual
