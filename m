Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZC3NdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZC3NdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZC3Ncv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:32:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:34649 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753221AbZC3Nct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:32:49 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+BbPAhwMOBTNdrajUnvf/o4DzBo6gJnNxbchWh1P
	lwpXRaW/H82fB9
Date: Mon, 30 Mar 2009 15:32:45 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org
Subject: Suspend Warning in libata-core
Message-ID: <20090330133245.GA4631@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.29 (x86_64)
X-Uptime: 15:21:29 up 5 days,  4:20,  9 users,  load average: 0.13, 0.44,
	0.61
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

todays -git (Last commit is Merge branch 'bzip2-lzma-for-linus') gives me two 
warnings during suspend/resume selftest, which I did not see with 2.6.29-rc8

[   22.854791] Freezing user space processes ... (elapsed 0.00 seconds) done.
[   22.855183] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[   22.855870] Suspending console(s) (use no_console_suspend to debug)
[   22.867304] serial 00:08: disabled
[   22.867733] matroxfb 0000:01:00.0: PCI INT A disabled
[   22.868530] RIPTIDE 0000:00:12.0: PCI INT A disabled
[   22.901218] aic7xxx 0000:00:0c.0: PCI INT A disabled
[   22.916337] uhci_hcd 0000:00:07.2: PCI INT D disabled
[   22.916617] ------------[ cut here ]------------
[   22.916625] WARNING: at drivers/ata/libata-core.c:5360 ata_host_request_pm+0x136/0x140()
[   22.916633] Modules linked in:
[   22.916644] Pid: 1, comm: swapper Not tainted 2.6.29 #108
[   22.916651] Call Trace:
[   22.916677]  [<c012a1ab>] warn_slowpath+0x8b/0x100
[   22.916700]  [<c0150c9c>] ? __lock_acquire+0x26c/0x1110
[   22.916712]  [<c0150531>] ? mark_held_locks+0x41/0x80
[   22.916730]  [<c0626425>] ? _spin_unlock_irqrestore+0x35/0x60
[   22.916741]  [<c0150791>] ? trace_hardirqs_on_caller+0x151/0x1c0
[   22.916752]  [<c015080b>] ? trace_hardirqs_on+0xb/0x10
[   22.916772]  [<c04590fa>] ? ata_port_wait_eh+0x7a/0xb0
[   22.916795]  [<c013eb20>] ? autoremove_wake_function+0x0/0x50
[   22.916806]  [<c044aaa6>] ata_host_request_pm+0x136/0x140
[   22.916816]  [<c044d45b>] ata_host_suspend+0xcb/0xf0
[   22.916832]  [<c046268a>] piix_pci_device_suspend+0x1a/0x140
[   22.916846]  [<c033b472>] pci_legacy_suspend+0x32/0xf0
[   22.916856]  [<c033b794>] pci_pm_suspend+0x94/0x130
[   22.916866]  [<c062386d>] ? printk+0x18/0x1b
[   22.916877]  [<c0403620>] ? pm_dev_dbg+0x90/0xe0
[   22.916886]  [<c0403281>] pm_op+0x141/0x190
[   22.916896]  [<c0403abf>] device_suspend+0x36f/0x4e0
[   22.916912]  [<c015c199>] suspend_devices_and_enter+0x69/0x1e0
[   22.916922]  [<c015c469>] enter_state+0x129/0x190
[   22.916932]  [<c015c5a9>] pm_suspend+0x19/0x20
[   22.916945]  [<c092220e>] test_suspend+0x166/0x19b
[   22.916955]  [<c09220a8>] ? test_suspend+0x0/0x19b
[   22.916965]  [<c0101125>] do_one_initcall+0x35/0x180
[   22.916985]  [<c01ed600>] ? proc_create_data+0x60/0xb0
[   22.917002]  [<c016ee9d>] ? register_irq_proc+0x9d/0xc0
[   22.917020]  [<c090d51d>] kernel_init+0x8b/0xe2
[   22.917029]  [<c090d492>] ? kernel_init+0x0/0xe2
[   22.917043]  [<c0103913>] kernel_thread_helper+0x7/0x14
[   22.917051] ---[ end trace 70c65dce96240608 ]---
[   22.917647] PM: suspend devices took 0.064 seconds
[   22.917829] ACPI: Preparing to enter system sleep state S1
[   22.954682] ACPI: Waking up from system sleep state S1
[   22.956970] ------------[ cut here ]------------
[   22.956978] WARNING: at drivers/ata/libata-core.c:5335 ata_host_request_pm+0x115/0x140()
[   22.956986] Modules linked in:
[   22.956997] Pid: 1, comm: swapper Tainted: G        W  2.6.29 #108
[   22.957004] Call Trace:
[   22.957031]  [<c012a1ab>] warn_slowpath+0x8b/0x100
[   22.957044]  [<c01270bf>] ? wakeup_preempt_entity+0x15f/0x1c0
[   22.957067]  [<c015080b>] ? trace_hardirqs_on+0xb/0x10
[   22.957087]  [<c04590fa>] ? ata_port_wait_eh+0x7a/0xb0
[   22.957110]  [<c013eb20>] ? autoremove_wake_function+0x0/0x50
[   22.957120]  [<c044aa85>] ata_host_request_pm+0x115/0x140
[   22.957130]  [<c044aad5>] ata_host_resume+0x25/0x60
[   22.957144]  [<c0462618>] piix_pci_device_resume+0x58/0xb0
[   22.957158]  [<c033b212>] pci_legacy_resume+0x32/0x60
[   22.957168]  [<c033b3f7>] pci_pm_resume+0x77/0xc0
[   22.957179]  [<c0403202>] pm_op+0xc2/0x190
[   22.957189]  [<c040400b>] device_resume+0xfb/0x420
[   22.957205]  [<c015c1fd>] suspend_devices_and_enter+0xcd/0x1e0
[   22.957215]  [<c015c469>] enter_state+0x129/0x190
[   22.957225]  [<c015c5a9>] pm_suspend+0x19/0x20
[   22.957238]  [<c092220e>] test_suspend+0x166/0x19b
[   22.957248]  [<c09220a8>] ? test_suspend+0x0/0x19b
[   22.957259]  [<c0101125>] do_one_initcall+0x35/0x180
[   22.957278]  [<c01ed600>] ? proc_create_data+0x60/0xb0
[   22.957295]  [<c016ee9d>] ? register_irq_proc+0x9d/0xc0
[   22.957312]  [<c090d51d>] kernel_init+0x8b/0xe2
[   22.957322]  [<c090d492>] ? kernel_init+0x0/0xe2
[   22.957336]  [<c0103913>] kernel_thread_helper+0x7/0x14
[   22.957343] ---[ end trace 70c65dce96240609 ]---
[   22.957423] uhci_hcd 0000:00:07.2: PCI INT D -> Link[LNKD] -> GSI 9 (level, low) -> IRQ 9
[   22.957536] aic7xxx 0000:00:0c.0: enabling device (0116 -> 0117)
[   22.957552] aic7xxx 0000:00:0c.0: PCI INT A -> Link[LNKB] -> GSI 5 (level, low) -> IRQ 5
[   23.954281] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1

root@computer-desktop:/usr/src/linux# lspci 
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03)
00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
00:0a.0 Ethernet controller: Intel Corporation 82556 EtherExpress PRO/100 Smart (rev 03)
00:0c.0 SCSI storage controller: Adaptec AIC-7861 (rev 03)
00:0e.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
00:12.0 Multimedia audio controller: Rockwell International Device 4310
00:12.1 Communication controller: Rockwell International Riptide HSF 56k PCI Modem
00:12.2 Input device controller: Rockwell International Device 4312
01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200 AGP (rev 03)

.config can be found at http://www.cccmz.de/~snakebyte/config_200

Greetings, Eric
