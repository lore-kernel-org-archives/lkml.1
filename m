Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbZIGId4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbZIGId4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZIGIdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:33:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbZIGIdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:33:55 -0400
Subject: Re: vfs-fix-d_path-for-unreachable-paths.patch
From: Miklos Szeredi <mszeredi@suse.cz>
To: Valdis.Kletnieks@vt.edu
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, miklos@szeredi.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Andreas Gruenbacher <agruen@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <2818.1252160549@turing-police.cc.vt.edu>
References: <2818.1252160549@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 10:30:54 +0200
Message-Id: <1252312254.4733.12.camel@tucsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 10:22 -0400, Valdis.Kletnieks@vt.edu wrote:
> Somebody is buggy here, but I'm not sure who. The initrd for leaving a dangling
> reference, the patch for breaking /proc/mounts, or /sbin/restorecon and the
> shutdown script for being far too trusting of what the kernel tells it?
> 

Hugh Dickins reported a similar issue, where gnome-vfs chokes on
that /proc/mounts line as well.

I think the conclusion is that this change in /proc/mounts is not going
to work.  There are two solutions:

 1) leave out unreachable mounts from /proc/PID/mounts altogether
 2) completely revert /proc/PID/mounts to the old behavior

The first option is much less likely to break something than the current
patch, but it's still an ABI change.

So I think it's better to go with the second option.  Patches coming
up...

Thanks,
Miklos


