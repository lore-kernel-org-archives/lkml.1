Return-Path: <linux-kernel-owner+w=401wt.eu-S1767282AbXDTVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767282AbXDTVsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767281AbXDTVsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:48:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:45673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767273AbXDTVsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:48:43 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: linux-kernel@vger.kernel.org
Subject: BUG: Dentry still in use during umount in 2.6.21-rc5-git6
Date: Fri, 20 Apr 2007 23:48:39 +0200
User-Agent: KMail/1.9.6
Cc: linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704202348.39357.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


One of my autoboot test clients gave me this during shutdown. It used
reiserfs and autofs and NFS heavily.

Unmounting file systems
BUG: Dentry ffff8100f3693a40{i=2352220,n=xattrs} still in use (1) [unmount of reiserfs sda9]
------------[ cut here ]------------
kernel BUG at /mnt/dm-2/newautoboot/autoboot/lsrc/mainline/linux/fs/dcache.c:623!
invalid opcode: 0000 [1] SMP 
CPU 1 
Modules linked in:
Pid: 15791, comm: umount Not tainted 2.6.21-rc5-git6 #44
RIP: 0010:[<ffffffff80287454>]  [<ffffffff80287454>] shrink_dcache_for_umount_subtree+0x178/0x250
RSP: 0018:ffff8100f5f67e18  EFLAGS: 00010292
RAX: 0000000000000060 RBX: ffff8100f3693a40 RCX: 0000000000005207
RDX: 00000000ffffffff RSI: 0000000000000046 RDI: 0000000000014661
RBP: ffff8100f6dc9cc0 R08: 00000000000000a0 R09: 00000005ffffffff
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8100f3693aa0
R13: 0000000000014661 R14: 000000000050ea70 R15: 000000000050ead0
FS:  00002adc863a86d0(0000) GS:ffff8100f7fdc1c0(0000) knlGS:00000000b7be38d0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002adc8626a688 CR3: 00000000f628b000 CR4: 00000000000006e0
Process umount (pid: 15791, threadinfo ffff8100f5f66000, task ffff8100f7a08100)
Stack:  ffff810004dab218 ffff810004dab000 ffffffff80558860 ffff810004dab000
 0000000000000000 ffffffff8028815b ffff810004dab000 ffffffff8027a1a5
 0000000000000000 ffff8100f6c50980 ffffffff806c1600 ffffffff8027a2a4
Call Trace:
 [<ffffffff8028815b>] shrink_dcache_for_umount+0x2f/0x3d
 [<ffffffff8027a1a5>] generic_shutdown_super+0x19/0xf2
 [<ffffffff8027a2a4>] kill_block_super+0x26/0x3b
 [<ffffffff8027a350>] deactivate_super+0x47/0x60
 [<ffffffff8028bf94>] sys_umount+0x1f7/0x22a
 [<ffffffff8027b64d>] sys_newstat+0x19/0x31
 [<ffffffff8020932e>] system_call+0x7e/0x83


Code: 0f 0b eb fe 48 8b 6b 28 48 39 dd 75 04 31 ed eb 04 f0 ff 4d 
RIP  [<ffffffff80287454>] shrink_dcache_for_umount_subtree+0x178/0x250
 RSP <ffff8100f5f67e18>
/etc/init.d/boot.d/K14boot.localfs: line 93: 15791 Segmentation fault      umount -avt noproc,nonfs,nonfs4,nosmbfs,nocifs,notmpfs



-Andi
