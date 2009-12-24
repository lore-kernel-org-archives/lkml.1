Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZLXLRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZLXLRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbZLXLRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:17:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:40648 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbZLXLRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:17:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Y6ecdsKscn+82ETYsUVn7lEMJ3lr2Ecs5R5RQcAeC8HEc4bWKoTyMVLlFH03ToZ36I
         Iek/v7RZoHehl5qMIwdclsAmX+nyC4HwFvrZ6vWE1e6sEbjyxjIQXYRECNE5xWJOvaEH
         S5wp3rSjKTKo6K2gPWmPniYTFiQ5QId/ouqlE=
MIME-Version: 1.0
Date: Thu, 24 Dec 2009 14:09:50 +0300
Message-ID: <f19d625d0912240309g5c066de7pc4dc9d95c084d4df@mail.gmail.com>
Subject: 2.6.28.10 - kernel BUG at mm/rmap.c:725
From: CoolCold <coolthecold@gmail.com>
To: Linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3 days ago LA on server become very high and it was working very
strange, so was rebooted. There are such entryies in log about kernel
bug - kernel BUG at mm/rmap.c:725! . Googling didn't provide me with
exact answer is it bug or hardware problems, something similar was
here https://bugs.launchpad.net/ubuntu/+source/linux/+bug/252977/comments/56
In general this server had number of unexpected stalls during several
months, but there is no ipkvm, so i can't say where something on
console or not. Hope you will help.

Kernel version is 2.6.28.10 , self-builded. System - Debian stable/testing.

Please reply to me directly, cuz i'm not subsribed to list.

Dec 21 22:05:01 gamma kernel: Eeek! page_mapcount(page) went negative! (-1)
Dec 21 22:05:01 gamma kernel:   page pfn = 1f2c81
Dec 21 22:05:01 gamma kernel:   page->flags = 20000000008007c
Dec 21 22:05:01 gamma kernel:   page->count = 2
Dec 21 22:05:01 gamma kernel:   page->mapping = ffff8801fd870b58
Dec 21 22:05:01 gamma kernel:   vma->vm_ops = 0xffffffff80535020
Dec 21 22:05:01 gamma kernel:   vma->vm_ops->fault = shmem_fault+0x0/0x69
Dec 21 22:05:01 gamma kernel:   vma->vm_file->f_op->mmap = shmem_mmap+0x0/0x2e
Dec 21 22:05:01 gamma kernel: ------------[ cut here ]------------
Dec 21 22:05:01 gamma kernel: kernel BUG at mm/rmap.c:725!
Dec 21 22:05:01 gamma kernel: invalid opcode: 0000 [#1] SMP
Dec 21 22:05:01 gamma kernel: last sysfs file: /sys/class/i2c-adapter/i2c-0/name
Dec 21 22:05:01 gamma kernel: CPU 2
Dec 21 22:05:01 gamma kernel: Modules linked in: tun xfs loop rtc_cmos
rtc_core rtc_lib i2c_piix4 i2c_core pcspkr button shpchp pci_hotplug
evdev ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot
dm_mod raid1 md_mod ata_generic sd_mod ide_pci_generic ahci libata
atiixp scsi_mod ide_core ohci_hcd r8169 mii thermal processor fan
thermal_sys [last unloaded: scsi_wait_scan]
Dec 21 22:05:01 gamma kernel: Pid: 20160, comm: searchd Not tainted
2.6.28.10-gamma #2
Dec 21 22:05:01 gamma kernel: RIP: 0010:[<ffffffff802881c0>]
[<ffffffff802881c0>] page_remove_rmap+0xff/0x11b
Dec 21 22:05:01 gamma kernel: RSP: 0018:ffff8801ebd11d68  EFLAGS: 00010296
Dec 21 22:05:01 gamma kernel: RAX: 0000000000000034 RBX:
ffffe20006d1bc38 RCX: 0000000000007c8d
Dec 21 22:05:01 gamma kernel: RDX: ffff8800a7a2a000 RSI:
0000000000000046 RDI: ffffffff8065b194
Dec 21 22:05:01 gamma kernel: RBP: ffff8800bbf88818 R08:
ffff8801c70e3c90 R09: 0000000000000000
Dec 21 22:05:01 gamma kernel: R10: 00000000ffffffff R11:
0000000000000000 R12: 00007fbdbc792000
Dec 21 22:05:01 gamma kernel: R13: ffff8801c70e3c90 R14:
ffff8800bbf88818 R15: ffff88002804f300
Dec 21 22:05:01 gamma kernel: FS:  0000000000000000(0000)
GS:ffff88020f093ec0(0000) knlGS:0000000000000000
Dec 21 22:05:01 gamma kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 21 22:05:01 gamma kernel: CR2: 00007fbdbd5c2e10 CR3:
0000000000201000 CR4: 00000000000006e0
Dec 21 22:05:01 gamma kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Dec 21 22:05:01 gamma kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Dec 21 22:05:01 gamma kernel: Process searchd (pid: 20160, threadinfo
ffff8801ebd10000, task ffff88020c881990)
Dec 21 22:05:01 gamma kernel: Stack:
Dec 21 22:05:01 gamma kernel:  00007fbdbc537000 ffffe20006d1bc38
0000000000000020 ffffffff802806cb
Dec 21 22:05:01 gamma kernel:  ffffe2000729a9d0 0000000000000000
ffff8801ebd11e68 ffffffffffffffff
Dec 21 22:05:01 gamma kernel:  0000000000000000 ffff8801ebd11e70
0000000000186392 0000000000000000
Dec 21 22:05:01 gamma kernel: Call Trace:
Dec 21 22:05:01 gamma kernel:  [<ffffffff802806cb>] ? unmap_vmas+0x49f/0x7ea
Dec 21 22:05:01 gamma kernel:  [<ffffffff802848d5>] ? exit_mmap+0xbb/0x12f
Dec 21 22:05:01 gamma kernel:  [<ffffffff80232343>] ? mmput+0x2c/0xa2
Dec 21 22:05:01 gamma kernel:  [<ffffffff80235c2f>] ? exit_mm+0xf7/0x102
Dec 21 22:05:01 gamma kernel:  [<ffffffff8023720d>] ? do_exit+0x1f9/0x7a4
Dec 21 22:05:01 gamma kernel:  [<ffffffff8023781e>] ? do_group_exit+0x66/0x96
Dec 21 22:05:01 gamma kernel:  [<ffffffff80237860>] ? sys_exit_group+0x12/0x17
Dec 21 22:05:01 gamma kernel:  [<ffffffff8020bc8b>] ?
system_call_fastpath+0x16/0x1b
Dec 21 22:05:01 gamma kernel: Code: 80 e8 76 df fc ff 48 8b 85 90 00
00 00 48 85 c0 74 19 48 8b 40 20 48 85 c0 74 10 48 8b 70 58 48 c7 c7
e4 92 4c 80 e8 51 df fc ff <0f> 0b eb fe 8b 77 18 41 58 5b 5d 83 e6 01
f7 de 83 c6 08 e9 b3
Dec 21 22:05:01 gamma kernel: RIP  [<ffffffff802881c0>]
page_remove_rmap+0xff/0x11b
Dec 21 22:05:01 gamma kernel:  RSP <ffff8801ebd11d68>
Dec 21 22:05:01 gamma kernel: ---[ end trace eead3ee4e83b9bf3 ]---
Dec 21 22:05:01 gamma kernel: Fixing recursive fault but reboot is needed!
Dec 21 22:05:01 gamma kernel: Eeek! page_mapcount(page) went negative! (-1)
Dec 21 22:05:01 gamma kernel:   page pfn = 1f2c81
Dec 21 22:05:01 gamma kernel:   page->flags = 20000000008007c
Dec 21 22:05:01 gamma kernel:   page->count = 3
Dec 21 22:05:01 gamma kernel:   page->mapping = ffff8801fd870b58
Dec 21 22:05:01 gamma kernel:   vma->vm_ops = 0xffffffff80535020
Dec 21 22:05:01 gamma kernel:   vma->vm_ops->fault = shmem_fault+0x0/0x69
Dec 21 22:05:01 gamma kernel:   vma->vm_file->f_op->mmap = shmem_mmap+0x0/0x2e
Dec 21 22:05:01 gamma kernel: ------------[ cut here ]------------
Dec 21 22:05:01 gamma kernel: kernel BUG at mm/rmap.c:725!
Dec 21 22:05:01 gamma kernel: invalid opcode: 0000 [#2] SMP
Dec 21 22:05:01 gamma kernel: last sysfs file: /sys/class/i2c-adapter/i2c-0/name
Dec 21 22:05:01 gamma kernel: CPU 2
Dec 21 22:05:01 gamma kernel: Modules linked in: tun xfs loop rtc_cmos
rtc_core rtc_lib i2c_piix4 i2c_core pcspkr button shpchp pci_hotplug
evdev ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot
dm_mod raid1 md_mod ata_generic sd_mod ide_pci_generic ahci libata
atiixp scsi_mod ide_core ohci_hcd r8169 mii thermal processor fan
thermal_sys [last unloaded: scsi_wait_scan]
Dec 21 22:05:01 gamma kernel: Pid: 20168, comm: searchd Tainted: G
 D    2.6.28.10-gamma #2
Dec 21 22:05:01 gamma kernel: RIP: 0010:[<ffffffff802881c0>]
[<ffffffff802881c0>] page_remove_rmap+0xff/0x11b
Dec 21 22:05:01 gamma kernel: RSP: 0018:ffff88011e0e5d68  EFLAGS: 00010296
Dec 21 22:05:01 gamma kernel: RAX: 0000000000000034 RBX:
ffffe20006d1bc38 RCX: 0000000000008780
Dec 21 22:05:01 gamma kernel: RDX: 0000000000009595 RSI:
0000000000000046 RDI: ffffffff8065b194
Dec 21 22:05:01 gamma kernel: RBP: ffff8800e306c348 R08:
ffff8800db84ec90 R09: ffff88002806c040
Dec 21 22:05:01 gamma kernel: R10: 00000000ffffffff R11:
ffffffff8033e5b0 R12: 00007fbdbc792000
Dec 21 22:05:01 gamma kernel: R13: ffff8800db84ec90 R14:
ffff8800e306c348 R15: ffff88002804f300
Dec 21 22:05:01 gamma kernel: FS:  0000000000000000(0000)
GS:ffff88020f093ec0(0000) knlGS:0000000000000000
Dec 21 22:05:01 gamma kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 21 22:05:01 gamma kernel: CR2: 00007fbdbd5c2e10 CR3:
0000000000201000 CR4: 00000000000006e0
Dec 21 22:05:01 gamma kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Dec 21 22:05:01 gamma kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Dec 21 22:05:01 gamma kernel: Process searchd (pid: 20168, threadinfo
ffff88011e0e4000, task ffff88020c9986a0)
Dec 21 22:05:01 gamma kernel: Stack:
Dec 21 22:05:01 gamma kernel:  00007fbdbc537000 ffffe20006d1bc38
0000000000000020 ffffffff802806cb
Dec 21 22:05:01 gamma kernel:  ffffe2000729a9d0 0000000000000000
ffff88011e0e5e68 ffffffffffffffff
Dec 21 22:05:01 gamma kernel:  0000000000000000 ffff88011e0e5e70
0000000000186392 0000000000000000
Dec 21 22:05:01 gamma kernel: Call Trace:
Dec 21 22:05:01 gamma kernel:  [<ffffffff802806cb>] ? unmap_vmas+0x49f/0x7ea
Dec 21 22:05:01 gamma kernel:  [<ffffffff802848d5>] ? exit_mmap+0xbb/0x12f
Dec 21 22:05:01 gamma kernel:  [<ffffffff80232343>] ? mmput+0x2c/0xa2
Dec 21 22:05:01 gamma kernel:  [<ffffffff80235c2f>] ? exit_mm+0xf7/0x102
Dec 21 22:05:01 gamma kernel:  [<ffffffff8023720d>] ? do_exit+0x1f9/0x7a4
Dec 21 22:05:01 gamma kernel:  [<ffffffff8023781e>] ? do_group_exit+0x66/0x96
Dec 21 22:05:01 gamma kernel:  [<ffffffff80237860>] ? sys_exit_group+0x12/0x17
Dec 21 22:05:01 gamma kernel:  [<ffffffff8020bc8b>] ?
system_call_fastpath+0x16/0x1b
Dec 21 22:05:01 gamma kernel: Code: 80 e8 76 df fc ff 48 8b 85 90 00
00 00 48 85 c0 74 19 48 8b 40 20 48 85 c0 74 10 48 8b 70 58 48 c7 c7
e4 92 4c 80 e8 51 df fc ff <0f> 0b eb fe 8b 77 18 41 58 5b 5d 83 e6 01
f7 de 83 c6 08 e9 b3
Dec 21 22:05:01 gamma kernel: RIP  [<ffffffff802881c0>]
page_remove_rmap+0xff/0x11b
Dec 21 22:05:01 gamma kernel:  RSP <ffff88011e0e5d68>
Dec 21 22:05:01 gamma kernel: ---[ end trace eead3ee4e83b9bf3 ]---


-- 
Best regards,
[COOLCOLD-RIPN]
