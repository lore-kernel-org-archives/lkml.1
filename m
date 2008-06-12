Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYFLB0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYFLB0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbYFLB0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:26:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbYFLB0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:26:05 -0400
Subject: [2.6.26-rc5-git4] kernel BUG at fs/dcache.c:637
From: Eric Paris <eparis@redhat.com>
To: ecryptfs-devel@lists.sourceforge.net
Cc: mhalcrow@us.ibm.com, phillip@hellewell.homeip.net,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 11 Jun 2008 21:21:41 -0400
Message-Id: <1213233701.4597.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel is git from yesterday (around 2.6.26-rc5-git4) using the fedora
ecryptfs-utils-46-0.fc10.x86_64 I can reliably hit a BUG()

mkdir /tmp/mntpnt
mount -t tmpfs /tmp/mntpnt /tmp/mntpnt
mount -t encryptfs /tmp/mntpnt /tmp/mntpnt
  # passphrase
  # aes
  # 32 bytes
touch /tmp/mntpnt/hello
umount /tmp/mntpnt
umount /tmp/mntpnt

Is there other information people would like me to collect, or file a
kernel.org bugzilla?  Don't know if this is a ecryptfs or a tmpfs bug,
hopefully someone who knows the relevant code areas can help.

BUG: Dentry ffff81000e839668{i=1cc2,n=hello2} still in use (1) [unmount of tmpfs tmpfs]
------------[ cut here ]------------
kernel BUG at fs/dcache.c:637!
invalid opcode: 0000 [1] SMP DEBUG_PAGEALLOC
CPU 1 
Modules linked in: cbc aes_x86_64 aes_generic ecb crypto_blkcipher ecryptfs sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 ext3 jbd loop ppdev sr_mod cdrom parport_pc parport floppy e1000 pcspkr pata_acpi ata_generic sg ata_piix libata i2c_piix4 shpchp ac button i2c_core dm_snapshot dm_zero dm_mirror dm_log dm_mod mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext4dev jbd2 mbcache crc16 uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2205, comm: umount Not tainted 2.6.26-rc5 #104
RIP: 0010:[<ffffffff810bed3a>]  [<ffffffff810bed3a>] shrink_dcache_for_umount_subtree+0x166/0x246
RSP: 0018:ffff81000d825d78  EFLAGS: 00010296
RAX: 000000000000005b RBX: ffff81000e8007c0 RCX: ffffffff813ec9d8
RDX: ffff810015874b40 RSI: 000000000000005b RDI: 0000000000000096
RBP: ffff81000d825da8 R08: ffffffff813ec9c0 R09: ffff8100010765c8
R10: 0000000000000001 R11: 0000000000000000 R12: ffff81000e839668
R13: ffff81000e8396f8 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f36426407d0(0000) GS:ffff810017411640(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3641f9e160 CR3: 000000000e53d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 2205, threadinfo ffff81000d824000, task ffff810015874b40)
Stack:  ffff8100169867f8 ffffffff812ca9a0 ffff810016986360 ffffffff812ca9a0
 0000000000000040 ffff810016986360 ffff81000d825dc8 ffffffff810bfc32
 ffff810016986360 ffff810016986360 ffff81000d825de8 ffffffff810afa79
Call Trace:
 [<ffffffff810bfc32>] shrink_dcache_for_umount+0x37/0x47
 [<ffffffff810afa79>] generic_shutdown_super+0x1a/0xd8
 [<ffffffff810afb72>] kill_anon_super+0x11/0x42
 [<ffffffff810afbc5>] kill_litter_super+0x22/0x27
 [<ffffffff810afc32>] deactivate_super+0x68/0x7d
 [<ffffffff810c453e>] mntput_no_expire+0xea/0x129
 [<ffffffff810c4b2a>] sys_umount+0x2f0/0x355
 [<ffffffff81073a0e>] ? audit_syscall_entry+0x141/0x17c
 [<ffffffff8100c090>] tracesys+0xd5/0xda


Code: 08 49 8b 44 24 40 48 85 c0 74 04 48 8b 50 40 48 8d 86 98 04 00 00 48 c7 c7 3f 57 39 81 4c 89 e6 48 89 04 24 31 c0 e8 f0 7f f7 ff <0f> 0b eb fe 49 8b 5c 24 58 4c 39 e3 75 04 31 db eb 03 f0 ff 0b 
RIP  [<ffffffff810bed3a>] shrink_dcache_for_umount_subtree+0x166/0x246
 RSP <ffff81000d825d78>
---[ end trace eefd8d16176b81fe ]---

