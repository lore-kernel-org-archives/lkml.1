Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0BIQ3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:29:42 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:48005 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0BIQ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:29:41 -0500
Message-ID: <4B718D71.10308@mandriva.org>
Date: Tue, 09 Feb 2010 18:29:37 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: dri-devel@lists.sf.net, glisse@freedesktop.org, airlied@linux.ie
Subject: 2.6.33-rc7-git1: Radeon KMS and plymouthd hits kernel BUG
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please cc me on replies)

Hi, Is this known ?

Kernel: 2.6.33-rc7-git1
Arch: x86_64
Distro: Mandriva Cooker

RADEON_KMS is enabled.

Plymouth is version 0.7.2

I hit the bug below:


> < ... >
>
> [    0.000000] Command line: BOOT_IMAGE=Cooker-tmb root=/dev/sda2 resume=/dev/sda1 splash=silent vga=791
>
> < ... >
>
> [   18.703916] [drm] Initialized drm 1.1.0 20060810
> [   18.968389] [drm] radeon defaulting to kernel modesetting.
> [   18.968392] [drm] radeon kernel modesetting enabled.
> [   18.968468] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   18.968475] radeon 0000:01:00.0: setting latency timer to 64
> [   18.970523] [drm] radeon: Initializing kernel modesetting.
> [   18.971122] [drm] register mmio base: 0xCFEF0000
> [   18.971124] [drm] register mmio size: 65536
> [   18.971208] ATOM BIOS: MXM
> [   18.971223] [drm] Clocks initialized !
> [   18.971245] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
> [   18.971248] [drm] Detected VRAM RAM=256M, BAR=256M
> [   18.971249] [drm] RAM width 128bits DDR
> [   18.971291] [TTM] Zone  kernel: Available graphics memory: 2028530 kiB.
> [   18.971306] [drm] radeon: 256M of VRAM memory ready
> [   18.971308] [drm] radeon: 512M of GTT memory ready.
> [   18.971365] radeon 0000:01:00.0: irq 29 for MSI/MSI-X
> [   18.971372] [drm] radeon: using MSI.
> [   18.971407] [drm] radeon: irq initialized.
> [   18.971409] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [   18.972290] [drm] Loading RV630 Microcode
> [   18.972295] platform radeon_cp.0: firmware: requesting radeon/RV630_pfp.bin
> [   18.973590] platform radeon_cp.0: firmware: requesting radeon/RV630_me.bin
> [   18.974702] platform radeon_cp.0: firmware: requesting radeon/R600_rlc.bin
> [   19.044477] [drm] ring test succeeded in 1 usecs
> [   19.044562] [drm] radeon: ib pool ready.
> [   19.044633] [drm] ib test succeeded in 0 usecs
> [   19.044635] [drm] Enabling audio support
> [   19.044709] [drm] Default TV standard: NTSC
> [   19.044786] [drm] Radeon Display Connectors
> [   19.044788] [drm] Connector 0:
> [   19.044789] [drm]   LVDS
> [   19.044791] [drm]   DDC: 0xac0 0xac0 0xac4 0xac4 0xac8 0xac8 0xacc 0xacc
> [   19.044792] [drm]   Encoders:
> [   19.044793] [drm]     LCD1: INTERNAL_LVTM1
> [   19.044794] [drm] Connector 1:
> [   19.044795] [drm]   DIN
> [   19.044796] [drm]   Encoders:
> [   19.044797] [drm]     TV1: INTERNAL_KLDSCP_DAC2
> [   19.044799] [drm] Connector 2:
> [   19.044799] [drm]   VGA
> [   19.044801] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
> [   19.044803] [drm]   Encoders:
> [   19.044804] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [   19.044805] [drm] Connector 3:
> [   19.044806] [drm]   DVI-I
> [   19.044807] [drm]   HPD1
> [   19.044808] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
> [   19.044810] [drm]   Encoders:
> [   19.044811] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
> [   19.614327] [drm] fb mappable at 0xD0141000
> [   19.614329] [drm] vram apper at 0xD0000000
> [   19.614330] [drm] size 4096000
> [   19.614332] [drm] fb depth is 24
> [   19.614333] [drm]    pitch is 5120
> [   19.614337] fb: conflicting fb hw usage radeondrmfb vs VESA VGA - removing generic driver
> [   19.614353] Console: switching to colour dummy device 80x25
> [   19.614598] Console: switching to colour frame buffer device 160x50
> [   20.069974] fb0: radeondrmfb frame buffer device
> [   20.069976] registered panic notifier
> [   20.069984] [drm] Initialized radeon 2.0.0 20080528 for 0000:01:00.0 on minor 0
>
> < ... >
>
> [   24.214473] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> [   24.215135] BUG: unable to handle kernel paging request at ffff88013f8bb3c0
> [   24.215137] IP: [<ffff88013f8bb3c0>] 0xffff88013f8bb3c0
> [   24.215143] PGD 14a7063 PUD 19067 PMD 800000013f8001e3
> [   24.215146] Oops: 0011 [#1] PREEMPT SMP
> [   24.215148] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/size
> [   24.215150] CPU 1
> [   24.215153] Pid: 35, comm: plymouthd Not tainted 2.6.33-tmb-desktop-0.rc7.1.2mdv #1 Columbia                       /TravelMate 5720
> [   24.215155] RIP: 0010:[<ffff88013f8bb3c0>]  [<ffff88013f8bb3c0>] 0xffff88013f8bb3c0
> [   24.215158] RSP: 0018:ffff88013e7f9eb0  EFLAGS: 00010286
> [   24.215160] RAX: ffff88013f8bb3c0 RBX: ffff88013f8bb000 RCX: 0000000000000003
> [   24.215161] RDX: ffff88013f8bb3b0 RSI: 0000000000000001 RDI: ffff88013f8bb000
> [   24.215163] RBP: ffff88013e7f9ec8 R08: 0000000000000000 R09: 0000000000000000
> [   24.215164] R10: 0000000000000000 R11: 0000000000000246 R12: ffff88013f8bb008
> [   24.215166] R13: ffff88013f422b40 R14: ffff88013f8b2e38 R15: ffff88013e70a400
> [   24.215168] FS:  00007f7575149700(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
> [   24.215170] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   24.215171] CR2: ffff88013f8bb3c0 CR3: 000000013e7bc000 CR4: 00000000000006e0
> [   24.215173] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   24.215174] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   24.215176] Process plymouthd (pid: 35, threadinfo ffff88013e7f8000, task ffff88013e7c12f0)
> [   24.215178] Stack:
> [   24.215178]  ffffffff811aa56e ffff88013e7b6900 0000000000000008 ffff88013e7f9f08
> [   24.215181] <0> ffffffff810d025a 00007f7574fc8000 ffff88013e7b6900 ffff88013e7cc840
> [   24.215183] <0> 0000000000000000 ffff88013e7cc8c0 00000000006f3c40 ffff88013e7f9f18
> [   24.215186] Call Trace:
> [   24.215192]  [<ffffffff811aa56e>] ? fb_release+0x3e/0x70
> [   24.215197]  [<ffffffff810d025a>] __fput+0xda/0x1f0
> [   24.215205]  [<ffffffff810d038d>] fput+0x1d/0x30
> [   24.215207]  [<ffffffff810ccb28>] filp_close+0x58/0x90
> [   24.215214]  [<ffffffff810ccc1c>] sys_close+0xbc/0x110
> [   24.215218]  [<ffffffff81002e6b>] system_call_fastpath+0x16/0x1b
> [   24.215220] Code: 88 ff ff 90 b3 8b 3f 01 88 ff ff a0 b3 8b 3f 01 88 ff ff a0 b3 8b 3f 01 88 ff ff b0 b3 8b 3f 01 88 ff ff b0 b3 8b 3f 01 88 ff ff <c0> b3 8b 3f 01 88 ff ff c0 b3 8b 3f 01 88 ff ff d0 b3 8b 3f 01
> [   24.215234] RIP  [<ffff88013f8bb3c0>] 0xffff88013f8bb3c0
> [   24.215237]  RSP <ffff88013e7f9eb0>
> [   24.215238] CR2: ffff88013f8bb3c0
> [   24.215239] ---[ end trace 5b06034eebbc9527 ]---

--
Thomas

