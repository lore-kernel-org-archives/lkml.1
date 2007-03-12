Return-Path: <linux-kernel-owner+w=401wt.eu-S1030678AbXCLRAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030678AbXCLRAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030672AbXCLRAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:00:36 -0400
Received: from pat.uio.no ([129.240.10.15]:49646 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030678AbXCLRAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:00:35 -0400
Subject: Re: 2.6.20.2: kernel BUG at fs/nfs/write.c:505!
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stresslinux Kernel <lk@stresslinux.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45F5582C.1050100@stresslinux.org>
References: <45F5582C.1050100@stresslinux.org>
Content-Type: multipart/mixed; boundary="=-Es+9Qaa7lGUn+oDkhfp7"
Date: Mon, 12 Mar 2007 13:00:31 -0400
Message-Id: <1173718831.6436.30.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: E8917BA46238B3AEF2C380C030A4EFDE534F98A1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 5 total 413253 max/h 7466 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Es+9Qaa7lGUn+oDkhfp7
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-03-12 at 14:39 +0100, Stresslinux Kernel wrote:
> Hello List,
> 
> running the following command
> 
> /sbin/grub-install --root-directory=/mnt --no-floppy /dev/sda
> 
> from a nfsroot system with kernel 2.6.20.2 (x86_64) results in:
> 
> ------------[ cut here ]------------
> kernel BUG at fs/nfs/write.c:505!
> invalid opcode: 0000 [1] SMP
> CPU 0
> Modules linked in: ipv6 genrtc
> Pid: 1464, comm: grub-install Not tainted 2.6.20.2 #1
> RIP: 0010:[<ffffffff8032fb83>]  [<ffffffff8032fb83>] nfs_wait_on_requests_locked+0x43/0xb2
> RSP: 0018:ffff81007d669ca8  EFLAGS: 00010246
> RAX: 00000000fffff0ba RBX: 0000000000000000 RCX: ffffffff802917aa
> RDX: 0000000000000000 RSI: ffff81007d669cb0 RDI: ffff810002f5f9d8
> RBP: ffff810002f5f898 R08: 0000000000000001 R09: 0000000000000286
> R10: 7fffffffffffffff R11: 0000000000000286 R12: 74d83948d2310001
> R13: 0000000000000000 R14: ffffffffffffffff R15: 0000000000000000
> FS:  00002b24eb8214a0(0000) GS:ffffffff809d6000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000596d88 CR3: 000000007d594000 CR4: 00000000000006e0
> Process grub-install (pid: 1464, threadinfo ffff81007d668000, task ffff81007e885840)
> Stack:  ffff810002f5f898 ffffffff802917aa 0000000000000000 ffff810002f5fb58
>  0000000000000020 ffff810002f5f898 ffff81007d669da8 ffffffff80331245
>  000000000000002e ffff81007d669e48 0000000000000020 0000000000000000
> Call Trace:
>  [<ffffffff802917aa>] bd_forget+0x8d/0x8e
>  [<ffffffff80331245>] nfs_sync_mapping_wait+0xbe/0x1ec
>  [<ffffffff80331486>] nfs_sync_mapping_range+0x80/0xa1
>  [<ffffffff80328a1c>] nfs_getattr+0x2e/0x9b
>  [<ffffffff80272313>] vfs_getattr+0x1d/0x2b
>  [<ffffffff802723aa>] vfs_lstat_fd+0x2f/0x47
>  [<ffffffff8021c3ce>] do_page_fault+0x279/0x572
>  [<ffffffff80237c17>] do_sigaction+0x6b/0x1b0
>  [<ffffffff8027270a>] sys_newlstat+0x19/0x31
>  [<ffffffff807231ed>] error_exit+0x0/0x84
>  [<ffffffff80209dde>] system_call+0x7e/0x83
> 
> 
> Code: 0f 0b eb fe f0 ff 41 44 c7 85 18 01 00 00 01 00 00 00 48 8b
> RIP  [<ffffffff8032fb83>] nfs_wait_on_requests_locked+0x43/0xb2
>  RSP <ffff81007d669ca8>

Known issue. There is already a fix available in the -mm kernel
(attached).

Cheers
  Trond


--=-Es+9Qaa7lGUn+oDkhfp7
Content-Disposition: inline; filename=linux-2.6.20-001-fix_block_device_getattr.dif
Content-Type: text/plain; name=linux-2.6.20-001-fix_block_device_getattr.dif; charset=utf-8
Content-Transfer-Encoding: 7bit

commit 090ad38f8ceea3cc048981e9fe9cc62ed43fee58
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Tue Feb 20 19:28:07 2007 -0500

    NFS: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index af53c02..93d046c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -429,7 +429,8 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	int err;
 
 	/* Flush out writes to the server in order to update c/mtime */
-	nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
+	if (S_ISREG(inode->i_mode))
+		nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
 
 	/*
 	 * We may force a getattr if the user cares about atime.

--=-Es+9Qaa7lGUn+oDkhfp7--

