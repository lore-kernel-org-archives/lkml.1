Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbXLSNoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbXLSNoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXLSNnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:43:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbXLSNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:43:52 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
To: Al Viro <viro@ftp.linux.org.uk>, Mark Lord <lkml@rtr.ca>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 19 Dec 2007 14:43:26 +0100
References: <9BTqk-2ck-31@gated-at.bofh.it> <9BTJN-2Sv-21@gated-at.bofh.it> <9BTTr-35L-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1J4zCp-0003fj-5I@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/9gxyAdqEP/9PuOY7SvIK9Hh9T3FBabBbwaak
 fmKVLEFXR5wq0jkDiimI6sPiXiK67v7Oud+X5BGdlMj0ueuN4e
 z0ec1uoiuDJkUDWehcvKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:
> On Tue, Dec 18, 2007 at 11:00:16PM +0000, Al Viro wrote:
>> On Tue, Dec 18, 2007 at 05:46:21PM -0500, Mark Lord wrote:

>> > Why does link(2) not support hard-linking across bind mount points
>> > of the same underlying filesystem ?
>> 
>> Because it gives you a security boundary around a subtree.
> 
> PS: that had been discussed quite a few times, but to avoid searches:
> consider e.g. mount --bind /tmp /tmp; now you've got a situation when
> users can't create links to elsewhere no root fs, even though they
> have /tmp writable to them.  Similar technics works for other isolation
> needs - basically, you can confine rename/link to given subtree.  IOW,
> it's a deliberate feature.  Note that you can bind a bunch of trees
> into chroot and get predictable restrictions regardless of how the
> stuff might get rearranged a year later in the main tree, etc.

Since nobody knows about this "security boundary" and everybody knows about
the annoying "can't link across bind-mountpoints bug", what about introducing
a mount option to allow link()ing?

