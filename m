Return-Path: <linux-kernel-owner+w=401wt.eu-S933117AbXA2FJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117AbXA2FJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbXA2FJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:09:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117AbXA2FJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:09:12 -0500
From: Neil Brown <neilb@suse.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Date: Mon, 29 Jan 2007 16:08:44 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17853.33116.113629.65031@notabene.brown>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, nfs@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [NFS] 2.6.17.8 - do_vfs_lock: VFS is out of sync with lock
	manager!
In-Reply-To: message from Trond Myklebust on Monday August 21
References: <9a8748490608080739w2e14e5ceg44a7bf0a3b475704@mail.gmail.com>
	<17636.4462.975774.528003@cse.unsw.edu.au>
	<9a8748490608170258s32df0272r60c8c540e5871485@mail.gmail.com>
	<17641.10665.116168.867041@cse.unsw.edu.au>
	<1156190098.6158.109.camel@localhost>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday August 21, trond.myklebust@fys.uio.no wrote:
> 
> Could we instead replace it with a dprintk() that returns the value of
> "res"? That will keep it useful for debugging purposes.

(only 5 months later...)

Sure, how about this?

Thanks,
NeilBrown


Remove warning: VFS is out of sync with lock manager.

But keep it as a dprintk

The message can be generated in a quite normal situation:
 If a 'lock' request is interrupted, then the lock client needs to
  record that the server has the lock, incase it does.
 When we come the unlock, the server might say it doesn't, even
  though we think it does (or might) and this generates the message.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfs/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff .prev/fs/nfs/file.c ./fs/nfs/file.c
--- .prev/fs/nfs/file.c	2007-01-29 16:04:09.000000000 +1100
+++ ./fs/nfs/file.c	2007-01-29 16:04:45.000000000 +1100
@@ -434,8 +434,9 @@ static int do_vfs_lock(struct file *file
 			BUG();
 	}
 	if (res < 0)
-		printk(KERN_WARNING "%s: VFS is out of sync with lock manager!\n",
-				__FUNCTION__);
+		dprintk(KERN_WARNING "%s: VFS is out of sync with lock manager"
+			" - error %d!\n",
+				__FUNCTION__, res);
 	return res;
 }
 
