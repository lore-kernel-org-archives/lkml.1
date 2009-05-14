Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZENWDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZENWDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZENWDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:03:37 -0400
Received: from internal.actusa.net ([208.83.100.16]:34912 "EHLO
	internal.actusa.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbZENWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:03:36 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2009 18:03:36 EDT
Message-ID: <4A0C93BD.3000706@actusa.net>
Date: Thu, 14 May 2009 14:57:17 -0700
From: Stuart Sheldon <stu@actusa.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at lib/radix-tree.c:485!
X-Enigmail-Version: 0.95.7
OpenPGP: id=C3252192;
	url=http://www.actusa.net/~stu/StuartSheldon.asc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Clueless Sys Admin here...

I have no idea how to trace this. But I can duplicate it pretty
easily... Here's what I have:

Kernel Version: 2.6.29.3 Vanilla with drbd-8.3.1 module built against
that source.

Systems runs heartbeat v.1 to manage drbd fallover.

Both systems run identical hardware.

Crash occurs when a system is moving from primary to standby.

Appears to crash when drbd xfs file system is unmounted.

System never responds to more then a ping after crash.

Functions flawlessly running on 2.6.28.9

Here is the "cut here" stuff:

May 14 12:50:24 drbd-2 Filesystem[6548]: INFO: Trying to unmount /data
May 14 12:50:24 drbd-2 kernel: ------------[ cut here ]------------
May 14 12:50:24 drbd-2 kernel: kernel BUG at lib/radix-tree.c:485!
May 14 12:50:24 drbd-2 kernel: invalid opcode: 0000 [#1] SMP
May 14 12:50:24 drbd-2 kernel: last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
May 14 12:50:24 drbd-2 kernel: CPU 1
May 14 12:50:24 drbd-2 kernel: Modules linked in: nfsd nfs lockd nfs_acl
auth_rpcgss sunrpc xfs exportfs drbd cn ipv6 sbp2 loop serio_raw psmouse
rtc_cmos pcspkr rtc_core rtc_lib i2c_i801 i2c_core iTCO_wdt intel_agp
button evdev usbhid hid ext3 jbd mbcache dm_mirror dm_region_hash dm_log
dm_snapshot dm_mod raid1 md_mod sd_mod pata_marvell pata_acpi ohci1394
ieee1394 firewire_ohci firewire_core uhci_hcd ata_piix e1000 ehci_hcd
ata_generic e1000e crc_itu_t usbcore libata scsi_mod ide_pci_generic
ide_core thermal processor fan
May 14 12:50:24 drbd-2 kernel: Pid: 6597, comm: umount Not tainted
2.6.29-3-xeon-actusa #1
May 14 12:50:24 drbd-2 kernel: RIP: 0010:[<ffffffff80311268>]
[<ffffffff80311268>] radix_tree_tag_set+0x67/0x97
May 14 12:50:24 drbd-2 kernel: RSP: 0018:ffff880211e15db8  EFLAGS: 00010246
May 14 12:50:24 drbd-2 kernel: RAX: 000000000000003a RBX:
0000000000000000 RCX: 000000000000003a
May 14 12:50:24 drbd-2 kernel: RDX: 0000000000000000 RSI:
000000000000023a RDI: ffff88021aaa1490
May 14 12:50:24 drbd-2 kernel: RBP: ffff88021814fbc0 R08:
0000000000000000 R09: ffff880218162f98
May 14 12:50:24 drbd-2 kernel: R10: 0000000000000001 R11:
0000000000000000 R12: ffff88021814fbc0
May 14 12:50:24 drbd-2 kernel: R13: ffff880219396400 R14:
ffff88021814fcb8 R15: ffff88021aaa148c
May 14 12:50:24 drbd-2 kernel: FS:  00007f019e125730(0000)
GS:ffff88021b863540(0000) knlGS:0000000000000000
May 14 12:50:24 drbd-2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
May 14 12:50:24 drbd-2 kernel: CR2: 00007f019d7f8ca6 CR3:
00000002145ac000 CR4: 00000000000006e0
May 14 12:50:24 drbd-2 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 14 12:50:24 drbd-2 kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 14 12:50:24 drbd-2 kernel: Process umount (pid: 6597, threadinfo
ffff880211e14000, task ffff88021940b0d0)
May 14 12:50:24 drbd-2 kernel: Stack:
May 14 12:50:24 drbd-2 kernel: ffff88021aaa1450 ffffffffa031a912
ffff88021814fd40 000000000000000f
May 14 12:50:24 drbd-2 kernel: ffff880211e15e58 0000000000000001
ffff88021814f5e0 ffffffffa030d353
May 14 12:50:24 drbd-2 kernel: ffff88021814fd50 ffff88021814fd40
ffff88021814fd50 ffffffffa0319223
May 14 12:50:24 drbd-2 kernel: Call Trace:
May 14 12:50:24 drbd-2 kernel: [<ffffffffa031a912>] ?
xfs_inode_set_reclaim_tag+0x69/0x89 [xfs]
May 14 12:50:24 drbd-2 kernel: [<ffffffffa030d353>] ?
xfs_reclaim+0x99/0x9f [xfs]
May 14 12:50:24 drbd-2 kernel: [<ffffffffa0319223>] ?
xfs_fs_destroy_inode+0x36/0x54 [xfs]
May 14 12:50:24 drbd-2 kernel: [<ffffffff802997ea>] ? dispose_list+0xcd/0xfb
May 14 12:50:24 drbd-2 kernel: [<ffffffff80299b35>] ?
invalidate_inodes+0xf3/0x111
May 14 12:50:24 drbd-2 kernel: [<ffffffff8028a81b>] ?
generic_shutdown_super+0x49/0xfd
May 14 12:50:24 drbd-2 kernel: [<ffffffff8028a8f1>] ?
kill_block_super+0x22/0x3a
May 14 12:50:24 drbd-2 kernel: [<ffffffff8028a9b4>] ?
deactivate_super+0x5f/0x78
May 14 12:50:24 drbd-2 kernel: [<ffffffff8029cfad>] ? sys_umount+0x2e5/0x314
May 14 12:50:24 drbd-2 kernel: [<ffffffff8020bedb>] ?
system_call_fastpath+0x16/0x1b
May 14 12:50:24 drbd-2 kernel: Code: 18 02 00 00 48 d3 e8 89 c1 83 e1 3f
41 0f a3 0c 11 19 c0 85 c0 75 07 49 8d 04 11 0f ab 08 48 63 c1 4d 8b 44
c0 18 4d 85 c0 75 04 <0f> 0b eb fe 41 83 eb 06 41 ff ca 45 85 d2 75 bc
4d 85 c0 74 16
May 14 12:50:24 drbd-2 kernel: RIP  [<ffffffff80311268>]
radix_tree_tag_set+0x67/0x97
May 14 12:50:24 drbd-2 kernel: RSP <ffff880211e15db8>
May 14 12:50:24 drbd-2 kernel: ---[ end trace ae7d2605c7a95f7b ]---
May 14 12:50:24 drbd-2 kernel: ------------[ cut here ]------------
May 14 12:50:24 drbd-2 kernel: WARNING: at kernel/exit.c:983
do_exit+0x3b/0x731()

How this is all the info you programmers need...

Feel free to contact me for more information.

Thanks again.

Stu

- --
For six long years I've been in trouble, no pleasure here on earth
I found. For in this world I'm bound to ramble, I have no friends
to help me now.
           -- The Soggy Bottom Boys - "I am a man of constant sorrow"
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKDJO6AAoJEFKVLITDJSGSQ8oP/RbNRrVKtdXt4BPmSaNGEAAa
B3iwIzj7Km20MeWhd2zUUYQ1Zb/afnGB60zOLfN5RzbYzi2bwknQnLFdl55b3cN5
BJD+AtjzZbvWDB5b4u3nXqHhZhMqSyMmZCoOy+G67++Tf4zWX0DSdLJNeKGIQOoA
OVL3ZZsKm2KZnoDIcJCLWea7Wn8SpXFUijQeHBEFm2nVqtJ+ZpOVhwpWiAsKvXVm
WApPvEAXui+zlojK41QlafBRbwYVVmx3EdXI5OhGdLpyVvnH7+pF3NnkmLdFwTRl
0QW5ntSVEruuNEi5gAjx3nc6/WXuoo/v9E2GvFNVXEISdMVYBmX4H52Mfc1eYboI
JLKs6HUdKq9YSmFffwJlSZYmvgv5vw9yvaeHRhzb0SfDtMlyF17yJjJHH1FXGo1g
3DWM/yCSgTQaT/ef4sXRgCzMc0y7hqbVBHTalcVMU/57Fj3HXnv/UpxJ95jBMthU
HELSEv8Zcf73ez3T0kKoMM+rcTRDJa/CyN/Y+8YGMIUOHz3p4mrnNCgl0lOTTfjQ
pW9WCJyLUpVKFqmDTb4hGvRyv0oCP27Q5r+NUs1me/NBdSWG8WUXhxfxD2ZdW9g0
ZXvL8MxMbusGNg88F2vqc3WcYywVL2WP3B0qJe2+8J878c25l0AcDUYStPWht/Di
AiOaPJUlrkFD1LqbVXrm
=xleX
-----END PGP SIGNATURE-----
