Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZLUVjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZLUVjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZLUVjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:39:00 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:46342 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164AbZLUVi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:38:59 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Alex Deucher <alexdeucher@gmail.com>
Subject: [Oops:] radeon KMS in 2.6.33-rc1-00154-gf7b84a6
Date: Mon, 21 Dec 2009 22:38:53 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32.2; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212238.54069.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When loading the radeon module with modeset=1, the kernel oopses:

Dec 21 21:58:14 datengrab kernel: [drm] Loading RV635 Microcode
Dec 21 21:58:14 datengrab kernel: platform radeon_cp.0: firmware: requesting 
radeon/RV635_pfp.bin
Dec 21 21:58:14 datengrab kernel: platform radeon_cp.0: firmware: requesting 
radeon/RV635_me.bin
Dec 21 21:58:14 datengrab kernel: platform radeon_cp.0: firmware: requesting 
radeon/R600_rlc.bin
Dec 21 21:58:14 datengrab kernel: r600_cp: Failed to load firmware 
"radeon/R600_rlc.bin"
Dec 21 21:58:14 datengrab kernel: [drm:r600_startup] *ERROR* Failed to load 
firmware!
Dec 21 21:58:14 datengrab kernel: radeon 0000:01:00.0: ffff880119451e00 unpin 
not necessary
Dec 21 21:58:14 datengrab kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000000000000048
Dec 21 21:58:14 datengrab kernel: IP: [<ffffffffa01c9d94>] 
ttm_bo_reserve+0x18/0xe7 [ttm]
Dec 21 21:58:14 datengrab kernel: PGD 0
Dec 21 21:58:14 datengrab kernel: Oops: 0000 [#1] SMP
Dec 21 21:58:14 datengrab kernel: last sysfs file: 
/sys/devices/platform/radeon_cp.0/firmware/radeon_cp.0/loading
Dec 21 21:58:14 datengrab kernel: CPU 0
Dec 21 21:58:14 datengrab kernel: Pid: 2524, comm: work_for_cpu Not tainted 
2.6.33-rc1 #1 TYAN Tiger K8W Dual AMD Opteron, S2875/To Be Filled By O.E.M.
Dec 21 21:58:14 datengrab kernel: RIP: 0010:[<ffffffffa01c9d94>]  [<ffffffffa01c9d94>] 
ttm_bo_reserve+0x18/0xe7 [ttm]
Dec 21 21:58:14 datengrab kernel: RSP: 0018:ffff880119731db0  EFLAGS: 00010282
Dec 21 21:58:14 datengrab kernel: RAX: ffff880119451e80 RBX: 0000000000000048 
RCX: 0000000000000000
Dec 21 21:58:14 datengrab kernel: RDX: 0000000000000000 RSI: 0000000000000001 
RDI: 0000000000000048
Dec 21 21:58:14 datengrab kernel: RBP: 0000000000000000 R08: 0000000000000000 
R09: ffffffff817361c0
Dec 21 21:58:14 datengrab kernel: R10: ffff8801196f4bd8 R11: ffffffffa023dda6 R12: 
ffff88011fb74001
Dec 21 21:58:14 datengrab kernel: R13: 0000000000000000 R14: ffffffffa0247700 R15: 
ffff8801196f4bd8
Dec 21 21:58:14 datengrab kernel: FS:  00007f4aa0f83700(0000) 
GS:ffff880028200000(0000) knlGS:0000000000000000
Dec 21 21:58:14 datengrab kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Dec 21 21:58:14 datengrab kernel: CR2: 0000000000000048 CR3: 000000000161c000 
CR4: 00000000000006f0
Dec 21 21:58:14 datengrab kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
Dec 21 21:58:14 datengrab kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
Dec 21 21:58:14 datengrab kernel: Process work_for_cpu (pid: 2524, threadinfo 
ffff880119730000, task ffff88011b2bf6c0)
Dec 21 21:58:14 datengrab kernel: Stack:
Dec 21 21:58:14 datengrab kernel: ffff880119473000 ffff880119601180 ffff880119473000 
0000000000000000
Dec 21 21:58:14 datengrab kernel: <0> ffff88011fb74000 0000000000000020 
ffffffffa02477e0 ffffffffa021da29
Dec 21 21:58:14 datengrab kernel: <0> ffff880119473000 ffff8801196f4800 
ffff88011fb74000 ffffffffa0220ac9
Dec 21 21:58:14 datengrab kernel: Call Trace:
Dec 21 21:58:14 datengrab kernel: [<ffffffffa021da29>] ? r600_suspend+0x49/0xa7 
[radeon]
Dec 21 21:58:14 datengrab kernel: [<ffffffffa0220ac9>] ? r600_init+0x1e3/0x27d 
[radeon]
Dec 21 21:58:14 datengrab kernel: [<ffffffffa01f0501>] ? 
radeon_device_init+0x24e/0x2cd [radeon]
Dec 21 21:58:14 datengrab kernel: [<ffffffffa01f0e66>] ? 
radeon_driver_load_kms+0xb2/0x12c [radeon]
Dec 21 21:58:14 datengrab kernel: [<ffffffffa0193321>] ? drm_get_dev+0x341/0x450 
[drm]
Dec 21 21:58:14 datengrab kernel: [<ffffffff8103f872>] ? do_work_for_cpu+0x0/0x1b
Dec 21 21:58:14 datengrab kernel: [<ffffffff811ba915>] ? local_pci_probe+0x12/0x16
Dec 21 21:58:14 datengrab kernel: [<ffffffff8103f87d>] ? do_work_for_cpu+0xb/0x1b
Dec 21 21:58:14 datengrab kernel: [<ffffffff81042665>] ? kthread+0x75/0x7d
Dec 21 21:58:14 datengrab kernel: [<ffffffff81002b94>] ? 
kernel_thread_helper+0x4/0x10
Dec 21 21:58:14 datengrab kernel: [<ffffffff810425f0>] ? kthread+0x0/0x7d
Dec 21 21:58:14 datengrab kernel: [<ffffffff81002b90>] ? 
kernel_thread_helper+0x0/0x10
Dec 21 21:58:14 datengrab kernel: Code: 00 00 31 c0 48 83 c4 28 5b 5d 41 5c 41 
5d 41 5e 41 5f c3 41 56 41 88 ce 41 55 41 88 d5 41 54 41 88 f4 55 53 48 89 fb 
48 83 ec 10 <48> 8b 2f 44 89 44 24 08 48 8d bd 88 00 00 00 e8 39 09 18 e1 44
Dec 21 21:58:14 datengrab kernel: RIP  [<ffffffffa01c9d94>] 
ttm_bo_reserve+0x18/0xe7 [ttm]
Dec 21 21:58:14 datengrab kernel: RSP <ffff880119731db0>
Dec 21 21:58:14 datengrab kernel: CR2: 0000000000000048
Dec 21 21:58:14 datengrab kernel: ---[ end trace b76801f20af7b25e ]---
Dec 21 21:58:14 datengrab firmware.sh[2542]: Cannot find  firmware file 
'radeon/R600_rlc.bin'

regards,
  Johannes
