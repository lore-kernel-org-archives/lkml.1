Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934524Ab0BYXbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:31:14 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:54290 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934511Ab0BYXbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=kIp1ipXxg5zi6DJNqSNxctrWi4oZHTZqqrwMIMjuaXv9U67h9xFEhKckmOCtVwezQi
         IwEAcPUttxCyzyKMxDqq3EyjW1r9+/Pi7uy+owH7JLn7b44MMO43B+vKuMutmzk5QQEr
         ARSm/uHdibqE37AZytQgZ7HsTrXpC/NcNioTY=
MIME-Version: 1.0
Date: Thu, 25 Feb 2010 15:31:05 -0800
Message-ID: <dd18b0c31002251531k34043f8j5a4cdc99d4ddeb06@mail.gmail.com>
Subject: xserver + radeon + latest git kernel = crash and burn with startx
From: Justin Mattock <justinmattock@gmail.com>
To: xorg@freedesktop.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is new:


 kernel: [   92.899961] pci 0000:01:00.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   93.019936] [drm] Initialized drm 1.1.0 20060810
[   93.097704] [drm] radeon defaulting to userspace modesetting.
[   93.100104] [drm] Initialized radeon 1.32.0 20080528 for
0000:01:00.0 on minor 0
[   93.489194] [drm] Setting GART location based on new memory map
[   93.490948] [drm] Loading R500 Microcode
[   93.491178] platform radeon_cp.0: firmware: requesting radeon/R520_cp.bin
[   93.552496] [drm] Num pipes: 1
[   93.552509] [drm] writeback test succeeded in 1 usecs
[   93.604070] [drm] Num pipes: 1
[   93.835904] CPU 1
[   93.835904] Pid: 2091, comm: X Not tainted 2.6.33-dirty #1
Mac-F42187C8/MacBookPro2,2
[   93.835904] RIP: 0010:[<ffffffffa02df11b>]  [<ffffffffa02df11b>]
radeon_read_ring_rptr+0x2b/0x2f [radeon]
[   93.835904] RSP: 0018:ffff8800369fdc70  EFLAGS: 00010202
[   93.835904] RAX: ffff88003df3bd48 RBX: ffff880038996360 RCX: ffffc90000aec000
[   93.835904] RDX: 0000000000000028 RSI: 6b6b6b6b6b6b6b6b RDI: ffff880038996360
[   93.835904] RBP: ffff8800369fdc70 R08: ffff880038996540 R09: 0000000000000010
[   93.835904] R10: ffffffffffffffff R11: ffffea0000d8e550 R12: 0000000000000010
[   93.835904] R13: ffff8800389973f0 R14: ffff8800389964e0 R15: ffff880038997568
[   93.835904] FS:  00007f14884e47a0(0000) GS:ffff880001900000(0000)
knlGS:0000000000000000
[   93.835904] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.835904] CR2: 00007f1483ee28d8 CR3: 00000000015f6000 CR4: 00000000000006e0
[   93.835904] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   93.835904] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   93.835904] Process X (pid: 2091, threadinfo ffff8800369fc000, task
ffff88003743d8b0)
[   93.835904]  ffff8800369fdc80 ffffffffa02df130 ffff8800369fdc98
ffffffffa02df81c
[   93.835904] <0> ffff880038996360 ffff8800369fdcb8 ffffffffa02e0a6a
0000000000000000
[   93.835904] <0> ffff880038996360 ffff8800369fdcd8 ffffffffa02e38fd
ffff880038996360
[   93.835904]  [<ffffffffa02df130>] radeon_get_ring_head+0x11/0x3c [radeon]
[   93.835904]  [<ffffffffa02df81c>] radeon_commit_ring+0x48/0x97 [radeon]
[   93.835904]  [<ffffffffa02e0a6a>] radeon_do_cp_idle+0x140/0x14d [radeon]
[   93.835904]  [<ffffffffa02e38fd>]
radeon_apply_surface_regs+0x22/0x138 [radeon]
[   93.835904]  [<ffffffffa02e3aeb>] free_surface+0xd8/0xee [radeon]
[   93.835904]  [<ffffffffa02ebcb3>] radeon_driver_lastclose+0x3c/0x56 [radeon]
[   93.835904]  [<ffffffffa029e14b>] drm_lastclose+0x44/0x2ad [drm]
[   93.835904]  [<ffffffffa029ec1a>] drm_release+0x656/0x6a3 [drm]
[   93.835904]  [<ffffffff810ed254>] __fput+0x112/0x1e1
[   93.835904]  [<ffffffff810ed338>] fput+0x15/0x17
[   93.835904]  [<ffffffff810ea559>] filp_close+0x63/0x6d
[   93.835904]  [<ffffffff8105c744>] put_files_struct+0x65/0xb3
[   93.835904]  [<ffffffff8105c7d8>] exit_files+0x46/0x4e
[   93.835904]  [<ffffffff8105de6b>] do_exit+0x20f/0x6a8
[   93.835904]  [<ffffffff81077dcb>] ? up_read+0x9/0xb
[   93.835904]  [<ffffffff813eca44>] ? do_page_fault+0x2aa/0x2da
[   93.835904]  [<ffffffff8105e377>] do_group_exit+0x73/0x9c
[   93.835904]  [<ffffffff8105e3b2>] sys_exit_group+0x12/0x16
[   93.835904]  [<ffffffff810264c2>] system_call_fastpath+0x16/0x1b
[   93.835904]  RSP <ffff8800369fdc70>
[   94.524994] ---[ end trace 603c2d6e0ba70b7f ]---

I can try a bisect, but might be difficult because
of reproducing this.

-- 
Justin P. Mattock
