Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZKBNr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZKBNr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZKBNr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:47:58 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:61406 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbZKBNr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:47:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=UPX4TR4V7FOm/WplXR1f/hd5jcvdRhswYfsaWcKRg42AP8J1oH4bGRipRaks3QC1ip
         c1slPIXu6zsuuZ7T9ZAQg4SSemxL6OKNckdLDHuoXp7SzSkJ5ZVHXqaq9qbzi/MQtxQJ
         qqDw5Y/G+YoeozlreXqRriSUtOHN+HK0BCjEk=
MIME-Version: 1.0
From: James Wilson <jww1066@gmail.com>
Date: Mon, 2 Nov 2009 08:47:40 -0500
Message-ID: <bb14879a0911020547u5fdb507er5e2efde9f314df1f@mail.gmail.com>
Subject: general protection faults with 2.6.26
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm running lenny on an K9A2 Platinum 790FX with an Athlon Dual
Core (5050e) and have had several mysterious crashes over the last
several months; the machine would lock up showing a panic message, but
I wasn't able to get ahold of the full set of error messages. Tonight
I happened to be logged in when I got a message on the console about a
general protection fault in the kernel, and was able to grab the error
messages from dmesg. I see several similar "general protection fault"
errors which I hope are the same problem as has been causing the
lockups.

Note that this happened with the BIOS set to automatically scale the
CPU frequency; this post (although with a different motherboard)
suggests that it might be a problem:

http://lkml.indiana.edu/hypermail/linux ... /0886.html

uname -a output:
Linux gabriel 2.6.26-2-amd64 #1 SMP Wed Aug 19 22:33:18 UTC 2009
x86_64 GNU/Linux

This is debian linux-image-2.6.26-2-amd64_2.6.26-19_amd64, FWIW.

I'm not subscribed to the list so please cc jww1066@gmail.com. Thanks
in advance.

errors from dmesg:
---------------------------------------------------
[448129.946457] general protection fault: 0000 [1] SMP
[448129.946481] CPU 1
[448129.946497] Modules linked in: xt_tcpudp nf_conntrack_ipv4
xt_state nf_conntrack iptable_filter ip_tables x_tables ipv6 ext2
sata_promise sbp2 loop snd_hda_intel snd_pcm snd_seq snd_timer
snd_seq_device pcspkr k8temp snd soundcore i2c_piix4 snd_page_alloc
i2c_core wmi button evdev ext3 jbd mbcache dm_mirror dm_log
dm_snapshot dm_mod raid456 async_xor async_memcpy async_tx xor raid1
md_mod ata_generic sd_mod atiixp floppy ohci1394 ieee1394
ide_pci_generic ide_core ehci_hcd ahci libata scsi_mod dock ohci_hcd
r8169 thermal processor fan thermal_sys [last unloaded:
scsi_wait_scan]
[448129.947100] Pid: 23315, comm: find Not tainted 2.6.26-2-amd64 #1
[448129.947100] RIP: 0010:[<ffffffff8029dfeb>] [<ffffffff8029dfeb>]
vfs_getattr+0x28/0x5e
[448129.947100] RSP: 0018:ffff81000e2b9e28 EFLAGS: 00010246
[448129.947100] RAX: 1344b0fbffc89c10 RBX: ffff81003001cbe0 RCX:
0000000000001000
[448129.947100] RDX: ffff81000e2b9f08 RSI: ffff81003001cbe0 RDI:
ffff8100378facc0
[448129.947100] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[448129.947100] R10: 0000000000000100 R11: ffffffff802f2347 R12:
ffff81001001d740
[448129.947100] R13: ffff81000e2b9f08 R14: ffff8100378facc0 R15:
00000000ffffff9c
[448129.947100] FS: 00007f63db2696e0(0000) GS:ffff8100cf69e9c0(0000)
knlGS:0000000000000000
[448129.947100] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[448129.947100] CR2: 00007f63db270000 CR3: 00000000a14fe000 CR4:
00000000000006e0
[448129.947100] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[448129.947100] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[448129.947100] Process find (pid: 23315, threadinfo ffff81000e2b8000,
task ffff810037803020)
[448129.947100] Stack: 0000000000000000 ffff81000e2b9f08
0000000000000100 000000000225dc20
[448129.947100] 000000000225dc88 ffffffff8029e0dc ffff8100378facc0
ffff81003001cbe0
[448129.947100] ffff8100cb800c00 ffffffff80238bf9 0000000100000000
0000000000000000
[448129.947100] Call Trace:
[448129.947100] [<ffffffff8029e0dc>] vfs_lstat_fd+0x2f/0x47
[448129.947100] [<ffffffff80238bf9>] current_fs_time+0x1e/0x24
[448129.947100] [<ffffffff802b0ae3>] mnt_want_write+0x2d/0x6e
[448129.947100] [<ffffffff8029e1d2>] sys_newfstatat+0x22/0x43
[448129.947100] [<ffffffff802af93d>] mntput_no_expire+0x20/0x117
[448129.947100] [<ffffffff8029954b>] filp_close+0x5d/0x65
[448129.947100] [<ffffffff8029a76a>] sys_close+0x7e/0xb7
[448129.947100] [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f
[448129.947100]
[448129.947100]
[448129.947100] Code: 5b 5d c3 41 56 49 89 fe 41 55 49 89 d5 41 54 55
53 48 89 f3 4c 8b 66 10 e8 73 3f 05 00 85 c0 89 c5 75 33 49 8b 84 24
e8 00 00 00 <48> 8b 40 78 48 85 c0 74 17 48 89 de 4c 89 ea 4c 89 f7 5b
5d 41
[448129.947100] RIP [<ffffffff8029dfeb>] vfs_getattr+0x28/0x5e
[448129.947100] RSP <ffff81000e2b9e28>
[448129.948053] ---[ end trace e6be891e2e95344a ]---
[545231.092160] general protection fault: 0000 [2] SMP
[545231.092184] CPU 1
[545231.092200] Modules linked in: xt_tcpudp nf_conntrack_ipv4
xt_state nf_conntrack iptable_filter ip_tables x_tables ipv6 ext2
sata_promise sbp2 loop snd_hda_intel snd_pcm snd_seq snd_timer
snd_seq_device pcspkr k8temp snd soundcore i2c_piix4 snd_page_alloc
i2c_core wmi button evdev ext3 jbd mbcache dm_mirror dm_log
dm_snapshot dm_mod raid456 async_xor async_memcpy async_tx xor raid1
md_mod ata_generic sd_mod atiixp floppy ohci1394 ieee1394
ide_pci_generic ide_core ehci_hcd ahci libata scsi_mod dock ohci_hcd
r8169 thermal processor fan thermal_sys [last unloaded:
scsi_wait_scan]
[545231.092463] Pid: 30058, comm: find Tainted: G D 2.6.26-2-amd64 #1
[545231.092482] RIP: 0010:[<ffffffff8029dfeb>] [<ffffffff8029dfeb>]
vfs_getattr+0x28/0x5e
[545231.092513] RSP: 0018:ffff810084b95e28 EFLAGS: 00010246
[545231.092530] RAX: 1344b0fbffc89c10 RBX: ffff81003001cbe0 RCX:
0000000000001000
[545231.092557] RDX: ffff810084b95f08 RSI: ffff81003001cbe0 RDI:
ffff8100378facc0
[545231.092583] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[545231.092610] R10: 0000000000000100 R11: ffffffff802f2347 R12:
ffff81001001d740
[545231.092637] R13: ffff810084b95f08 R14: ffff8100378facc0 R15:
00000000ffffff9c
[545231.092664] FS: 00007ffe385946e0(0000) GS:ffff8100cf69e9c0(0000)
knlGS:0000000000000000
[545231.092691] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[545231.092708] CR2: 00007ffe3859b000 CR3: 00000000a1540000 CR4:
00000000000006e0
[545231.092735] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[545231.092762] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[545231.092789] Process find (pid: 30058, threadinfo ffff810084b94000,
task ffff8100ced66a90)
[545231.092816] Stack: 0000000000000000 ffff810084b95f08
0000000000000100 0000000000800c20
[545231.092854] 0000000000800c88 ffffffff8029e0dc ffff8100378facc0
ffff81003001cbe0
[545231.092889] ffff8100cb800c00 ffffffff80238bf9 0000000100000000
0000000000000000
[545231.092914] Call Trace:
[545231.092941] [<ffffffff8029e0dc>] vfs_lstat_fd+0x2f/0x47
[545231.092960] [<ffffffff80238bf9>] current_fs_time+0x1e/0x24
[545231.092979] [<ffffffff802b0ae3>] mnt_want_write+0x2d/0x6e
[545231.093000] [<ffffffff8029e1d2>] sys_newfstatat+0x22/0x43
[545231.093019] [<ffffffff802af93d>] mntput_no_expire+0x20/0x117
[545231.093039] [<ffffffff8029954b>] filp_close+0x5d/0x65
[545231.093057] [<ffffffff8029a76a>] sys_close+0x7e/0xb7
[545231.093076] [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f
[545231.093097]
[545231.093110]
[545231.093122] Code: 5b 5d c3 41 56 49 89 fe 41 55 49 89 d5 41 54 55
53 48 89 f3 4c 8b 66 10 e8 73 3f 05 00 85 c0 89 c5 75 33 49 8b 84 24
e8 00 00 00 <48> 8b 40 78 48 85 c0 74 17 48 89 de 4c 89 ea 4c 89 f7 5b
5d 41
[545231.093327] RIP [<ffffffff8029dfeb>] vfs_getattr+0x28/0x5e
[545231.093346] RSP <ffff810084b95e28>
[545231.093724] ---[ end trace e6be891e2e95344a ]---
[643842.913074] general protection fault: 0000 [3] SMP
[643842.913099] CPU 0
[643842.913115] Modules linked in: xt_tcpudp nf_conntrack_ipv4
xt_state nf_conntrack iptable_filter ip_tables x_tables ipv6 ext2
sata_promise sbp2 loop snd_hda_intel snd_pcm snd_seq snd_timer
snd_seq_device pcspkr k8temp snd soundcore i2c_piix4 snd_page_alloc
i2c_core wmi button evdev ext3 jbd mbcache dm_mirror dm_log
dm_snapshot dm_mod raid456 async_xor async_memcpy async_tx xor raid1
md_mod ata_generic sd_mod atiixp floppy ohci1394 ieee1394
ide_pci_generic ide_core ehci_hcd ahci libata scsi_mod dock ohci_hcd
r8169 thermal processor fan thermal_sys [last unloaded:
scsi_wait_scan]
[643842.913382] Pid: 1211, comm: find Tainted: G D 2.6.26-2-amd64 #1
[643842.913401] RIP: 0010:[<ffffffff8029dfeb>] [<ffffffff8029dfeb>]
vfs_getattr+0x28/0x5e
[643842.913432] RSP: 0018:ffff8100244ffe28 EFLAGS: 00010246
[643842.913449] RAX: 1344b0fbffc89c10 RBX: ffff81003001cbe0 RCX:
0000000000001000
[643842.913476] RDX: ffff8100244fff08 RSI: ffff81003001cbe0 RDI:
ffff8100378facc0
[643842.913502] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[643842.913529] R10: 0000000000000100 R11: ffffffff802f2347 R12:
ffff81001001d740
[643842.913556] R13: ffff8100244fff08 R14: ffff8100378facc0 R15:
00000000ffffff9c
[643842.913583] FS: 00007ff876fdf6e0(0000) GS:ffffffff8053c000(0000)
knlGS:0000000000000000
[643842.913611] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[643842.913628] CR2: 00007ff876fe6000 CR3: 0000000084b38000 CR4:
00000000000006e0
[643842.913654] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[643842.913681] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[643842.913710] Process find (pid: 1211, threadinfo ffff8100244fe000,
task ffff8100cecf93f0)
[643842.913737] Stack: 0000000000000000 ffff8100244fff08
0000000000000100 0000000000dc2c20
[643842.913775] 0000000000dc2c88 ffffffff8029e0dc ffff8100378facc0
ffff81003001cbe0
[643842.913810] ffff8100cb800c00 ffffffff80238bf9 0000000100000000
0000000000000000
[643842.917065] Call Trace:
[643842.917065] [<ffffffff8029e0dc>] vfs_lstat_fd+0x2f/0x47
[643842.917065] [<ffffffff80238bf9>] current_fs_time+0x1e/0x24
[643842.917065] [<ffffffff802b0ae3>] mnt_want_write+0x2d/0x6e
[643842.917065] [<ffffffff8029e1d2>] sys_newfstatat+0x22/0x43
[643842.917065] [<ffffffff802af93d>] mntput_no_expire+0x20/0x117
[643842.917065] [<ffffffff8029954b>] filp_close+0x5d/0x65
[643842.917065] [<ffffffff8029a76a>] sys_close+0x7e/0xb7
[643842.917065] [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f
[643842.917065]
[643842.917065]
[643842.917065] Code: 5b 5d c3 41 56 49 89 fe 41 55 49 89 d5 41 54 55
53 48 89 f3 4c 8b 66 10 e8 73 3f 05 00 85 c0 89 c5 75 33 49 8b 84 24
e8 00 00 00 <48> 8b 40 78 48 85 c0 74 17 48 89 de 4c 89 ea 4c 89 f7 5b
5d 41
[643842.917065] RIP [<ffffffff8029dfeb>] vfs_getattr+0x28/0x5e
[643842.917065] RSP <ffff8100244ffe28>
[643842.920295] ---[ end trace e6be891e2e95344a ]---
[745330.956676] general protection fault: 0000 [4] SMP
[745330.956701] CPU 1
[745330.956717] Modules linked in: xt_tcpudp nf_conntrack_ipv4
xt_state nf_conntrack iptable_filter ip_tables x_tables ipv6 ext2
sata_promise sbp2 loop snd_hda_intel snd_pcm snd_seq snd_timer
snd_seq_device pcspkr k8temp snd soundcore i2c_piix4 snd_page_alloc
i2c_core wmi button evdev ext3 jbd mbcache dm_mirror dm_log
dm_snapshot dm_mod raid456 async_xor async_memcpy async_tx xor raid1
md_mod ata_generic sd_mod atiixp floppy ohci1394 ieee1394
ide_pci_generic ide_core ehci_hcd ahci libata scsi_mod dock ohci_hcd
r8169 thermal processor fan thermal_sys [last unloaded:
scsi_wait_scan]
[745330.956980] Pid: 5290, comm: find Tainted: G D 2.6.26-2-amd64 #1
[745330.956999] RIP: 0010:[<ffffffff8029dfeb>] [<ffffffff8029dfeb>]
vfs_getattr+0x28/0x5e
[745330.957030] RSP: 0018:ffff81001f61de28 EFLAGS: 00010246
[745330.957047] RAX: 1344b0fbffc89c10 RBX: ffff81003001cbe0 RCX:
0000000000001000
[745330.957074] RDX: ffff81001f61df08 RSI: ffff81003001cbe0 RDI:
ffff8100378facc0
[745330.957100] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[745330.957127] R10: 0000000000000100 R11: ffffffff802f2347 R12:
ffff81001001d740
[745330.957154] R13: ffff81001f61df08 R14: ffff8100378facc0 R15:
00000000ffffff9c
[745330.957181] FS: 00007f6b9cd4f6e0(0000) GS:ffff8100cf69e9c0(0000)
knlGS:0000000000000000
[745330.957209] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[745330.957226] CR2: 00007f6b9cd56000 CR3: 000000006e7b3000 CR4:
00000000000006e0
[745330.957253] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[745330.957279] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[745330.957307] Process find (pid: 5290, threadinfo ffff81001f61c000,
task ffff8100ced70440)
[745330.957334] Stack: 0000000000000000 ffff81001f61df08
0000000000000100 0000000001a9cc20
[745330.957372] 0000000001a9cc88 ffffffff8029e0dc ffff8100378facc0
ffff81003001cbe0
[745330.957407] ffff8100cb800c00 ffffffff80238bf9 0000000100000000
0000000000000000
[745330.957432] Call Trace:
[745330.957459] [<ffffffff8029e0dc>] vfs_lstat_fd+0x2f/0x47
[745330.957479] [<ffffffff80238bf9>] current_fs_time+0x1e/0x24
[745330.957497] [<ffffffff802b0ae3>] mnt_want_write+0x2d/0x6e
[745330.957518] [<ffffffff8029e1d2>] sys_newfstatat+0x22/0x43
[745330.957537] [<ffffffff802af93d>] mntput_no_expire+0x20/0x117
[745330.957557] [<ffffffff8029954b>] filp_close+0x5d/0x65
[745330.957575] [<ffffffff8029a76a>] sys_close+0x7e/0xb7
[745330.957594] [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f
[745330.957615]
[745330.957628]
[745330.957641] Code: 5b 5d c3 41 56 49 89 fe 41 55 49 89 d5 41 54 55
53 48 89 f3 4c 8b 66 10 e8 73 3f 05 00 85 c0 89 c5 75 33 49 8b 84 24
e8 00 00 00 <48> 8b 40 78 48 85 c0 74 17 48 89 de 4c 89 ea 4c 89 f7 5b
5d 41
[745330.957846] RIP [<ffffffff8029dfeb>] vfs_getattr+0x28/0x5e
[745330.957865] RSP <ffff81001f61de28>
[745330.958243] ---[ end trace e6be891e2e95344a ]---
[823600.590645] md: data-check of RAID array md0
[823600.590645] md: minimum _guaranteed_ speed: 1000 KB/sec/disk.
[823600.590645] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for data-check.
[823600.590645] md: using 128k window, over a total of 19534912 blocks.
[823600.594648] md: delaying data-check of md1 until md0 has finished
(they share one or more physical units)
[823900.005631] md: md0: data-check done.
[823900.036266] md: data-check of RAID array md1
[823900.036266] md: minimum _guaranteed_ speed: 1000 KB/sec/disk.
[823900.036266] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for data-check.
[823900.036266] md: using 128k window, over a total of 879100800 blocks.
[823900.159405] RAID1 conf printout:
[823900.159426] --- wd:2 rd:2
[823900.159441] disk 0, wo:0, o:1, dev:sda1
[823900.159457] disk 1, wo:0, o:1, dev:sdb1
[839443.769178] md: md1: data-check done.
[839443.920921] RAID5 conf printout:
[839443.920921] --- rd:4 wd:4
[839443.920921] disk 0, o:1, dev:sda4
[839443.920921] disk 1, o:1, dev:sdb4
[839443.920921] disk 2, o:1, dev:sdc4
[839443.920921] disk 3, o:1, dev:sdd4
[849098.995975] general protection fault: 0000 [5] SMP
[849098.996000] CPU 1
[849098.996016] Modules linked in: xt_tcpudp nf_conntrack_ipv4
xt_state nf_conntrack iptable_filter ip_tables x_tables ipv6 ext2
sata_promise sbp2 loop snd_hda_intel snd_pcm snd_seq snd_timer
snd_seq_device pcspkr k8temp snd soundcore i2c_piix4 snd_page_alloc
i2c_core wmi button evdev ext3 jbd mbcache dm_mirror dm_log
dm_snapshot dm_mod raid456 async_xor async_memcpy async_tx xor raid1
md_mod ata_generic sd_mod atiixp floppy ohci1394 ieee1394
ide_pci_generic ide_core ehci_hcd ahci libata scsi_mod dock ohci_hcd
r8169 thermal processor fan thermal_sys [last unloaded:
scsi_wait_scan]
[849098.996279] Pid: 8926, comm: find Tainted: G D 2.6.26-2-amd64 #1
[849098.996297] RIP: 0010:[<ffffffff8029dfeb>] [<ffffffff8029dfeb>]
vfs_getattr+0x28/0x5e
[849098.996328] RSP: 0018:ffff8100b70b9e28 EFLAGS: 00010246
[849098.996345] RAX: 835323180a53c8ca RBX: ffff81003001cbe0 RCX:
0000000000001000
[849098.996372] RDX: ffff8100b70b9f08 RSI: ffff81003001cbe0 RDI:
ffff8100378facc0
[849098.996399] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[849098.996425] R10: 0000000000000100 R11: ffffffff802f2347 R12:
ffff81001001d740
[849098.996452] R13: ffff8100b70b9f08 R14: ffff8100378facc0 R15:
00000000ffffff9c
[849098.996479] FS: 00007f75876076e0(0000) GS:ffff8100cf69e9c0(0000)
knlGS:0000000000000000
[849098.996507] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[849098.996524] CR2: 00007f758760e000 CR3: 000000007df22000 CR4:
00000000000006e0
[849098.996551] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[849098.996578] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[849098.996605] Process find (pid: 8926, threadinfo ffff8100b70b8000,
task ffff8100ced70440)
[849098.996632] Stack: 0000000000000000 ffff8100b70b9f08
0000000000000100 00000000010b1c20
[849098.996670] 00000000010b1c88 ffffffff8029e0dc ffff8100378facc0
ffff81003001cbe0
[849098.996705] ffff8100cb800c00 ffffffff80238bf9 0000000100000000
0000000000000000
[849098.996730] Call Trace:
[849098.996758] [<ffffffff8029e0dc>] vfs_lstat_fd+0x2f/0x47
[849098.996777] [<ffffffff80238bf9>] current_fs_time+0x1e/0x24
[849098.996795] [<ffffffff802b0ae3>] mnt_want_write+0x2d/0x6e
[849098.996816] [<ffffffff8029e1d2>] sys_newfstatat+0x22/0x43
[849098.996835] [<ffffffff802af93d>] mntput_no_expire+0x20/0x117
[849098.996855] [<ffffffff8029954b>] filp_close+0x5d/0x65
[849098.996874] [<ffffffff8029a76a>] sys_close+0x7e/0xb7
[849098.996892] [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f
[849098.996914]
[849098.996926]
[849098.996939] Code: 5b 5d c3 41 56 49 89 fe 41 55 49 89 d5 41 54 55
53 48 89 f3 4c 8b 66 10 e8 73 3f 05 00 85 c0 89 c5 75 33 49 8b 84 24
e8 00 00 00 <48> 8b 40 78 48 85 c0 74 17 48 89 de 4c 89 ea 4c 89 f7 5b
5d 41
[849098.997144] RIP [<ffffffff8029dfeb>] vfs_getattr+0x28/0x5e
[849098.997164] RSP <ffff8100b70b9e28>
[849098.997541] ---[ end trace e6be891e2e95344a ]---

James
