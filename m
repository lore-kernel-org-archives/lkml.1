Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZCFBv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZCFBv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 20:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbZCFBvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 20:51:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbZCFBvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 20:51:46 -0500
Date: Thu, 5 Mar 2009 17:51:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Titz <olaf@bigred.inka.de>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [DRM] NULL pointer oops in radeon_do_wait_for_idle
Message-Id: <20090305175129.610e60dc.akpm@linux-foundation.org>
In-Reply-To: <E1LfGph-0001V0-Cl@bigred.inka.de>
References: <E1LfGph-0001V0-Cl@bigred.inka.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc added)

On Thu, 05 Mar 2009 17:54:05 +0100 Olaf Titz <olaf@bigred.inka.de> wrote:

> I have this problem since upgrading Xorg to 7.4 (Ubuntu "Intrepid",
> radeon driver 6.9.0). Some minutes after starting X locks up
> completely, the rest of the system remains alive, the following Oops
> is left in the log.
> 
> Known workaround: disable DRI in xorg.conf.
> 
> The system is an UP Athlon XP desktop, currently running Linux
> 2.6.28.7 but I've had this problem for several kernel versions.
> No PM stuff or suspend/resume involved, no framebuffer driver, only
> one X server running.
> 
> this is the graphics card:
> 
> 01:00.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200 PRO] (rev 01)
>         Subsystem: PC Partner Limited Device 0260
>         Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
>         Memory at d8000000 (32-bit, prefetchable) [size=128M]
>         I/O ports at d800 [size=256]
>         Memory at c7000000 (32-bit, non-prefetchable) [size=64K]
>         Expansion ROM at d7fe0000 [disabled] [size=128K]
>         Capabilities: [58] AGP version 3.0
>         Capabilities: [50] Power Management version 2
> 
> 01:00.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200 PRO] (Secondary) (rev 01)
>         Subsystem: PC Partner Limited Device 0261
>         Flags: bus master, 66MHz, medium devsel, latency 64
>         Memory at c8000000 (32-bit, prefetchable) [size=128M]
>         Memory at c6800000 (32-bit, non-prefetchable) [size=64K]
>         Capabilities: [50] Power Management version 2
> 
> 
> <<snip>>
> 
> Mar  5 17:19:20 bigred kernel: [drm:radeon_cp_indirect] *ERROR* sending pending buffer 22
> Mar  5 17:19:20 bigred kernel: BUG: unable to handle kernel NULL pointer dereference at 00000330
> Mar  5 17:19:20 bigred kernel: IP: [<f0b12e02>] radeon_do_wait_for_idle+0x12/0x160 [radeon]
> Mar  5 17:19:20 bigred kernel: *pde = 00000000
> Mar  5 17:19:20 bigred kernel: Oops: 0000 [#1] PREEMPT
> Mar  5 17:19:20 bigred kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:10.2/pools
> Mar  5 17:19:20 bigred kernel: Modules linked in: nfsd auth_rpcgss exportfs fan st nfs lockd sunrpc radeon drm asb100 hwmon_vid hwmon snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd soundcore sg sr_mod cdrom usb_storage 8250_pnp 8250 serial_core button
> Mar  5 17:19:20 bigred kernel:
> Mar  5 17:19:20 bigred kernel: Pid: 2175, comm: Xorg Not tainted (2.6.28.7 #1) System Name
> Mar  5 17:19:20 bigred kernel: EIP: 0060:[<f0b12e02>] EFLAGS: 00213206 CPU: 0
> Mar  5 17:19:20 bigred kernel: EIP is at radeon_do_wait_for_idle+0x12/0x160 [radeon]
> Mar  5 17:19:20 bigred kernel: EAX: 000186a0 EBX: f0b30b30 ECX: 0003ffff EDX: 0003e420
> Mar  5 17:19:20 bigred kernel: ESI: 00000000 EDI: eed31400 EBP: ee017420 ESP: ee1f8ec8
> Mar  5 17:19:20 bigred kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Mar  5 17:19:20 bigred kernel: Process Xorg (pid: 2175, ti=ee1f8000 task=ef909b00 task.ti=ee1f8000)
> Mar  5 17:19:20 bigred kernel: Stack:
> Mar  5 17:19:20 bigred kernel:  e65f78f0 fffffff4 f0b30b30 00000000 00000000 f0ad45b6 ef8ad100 c024b8dd
> Mar  5 17:19:20 bigred kernel:  00000000 00000001 ffffffff efb85080 00000000 00006444 eed31424 f0b13ed0
> Mar  5 17:19:20 bigred kernel:  f0b2efb4 ee1fa900 00000000 00006444 c017eb78 00000000 ee1fa900 ef512e00
> Mar  5 17:19:20 bigred kernel: Call Trace:
> Mar  5 17:19:20 bigred kernel:  [<f0ad45b6>] drm_ioctl+0xf6/0x310 [drm]
> Mar  5 17:19:20 bigred kernel:  [<c024b8dd>] tty_ioctl+0xcd/0x890
> Mar  5 17:19:20 bigred kernel:  [<f0b13ed0>] radeon_cp_idle+0x0/0xc0 [radeon]
> Mar  5 17:19:20 bigred kernel:  [<c017eb78>] vfs_ioctl+0x78/0x90
> Mar  5 17:19:20 bigred kernel:  [<c017ed27>] do_vfs_ioctl+0x67/0x4f0
> Mar  5 17:19:20 bigred kernel:  [<c0172a22>] vfs_write+0x102/0x140
> Mar  5 17:19:20 bigred kernel:  [<c017f1ed>] sys_ioctl+0x3d/0x70
> Mar  5 17:19:20 bigred kernel:  [<c0103261>] sysenter_do_call+0x12/0x25
> Mar  5 17:19:20 bigred kernel: Code: 00 00 46 e8 01 68 6f cf 39 73 68 7f dc b8 f0 ff ff ff eb 81 90 8d 74 26 00 56 89 c6 53 83 ec 10 83 48 70 08 8b 40 68 85 c0 7e 46 <8b> 86 30 03 00 00 8b 40 10 05 40 0e 00 00 8b 00 83 e0 7f 31 db
> Mar  5 17:19:20 bigred kernel: EIP: [<f0b12e02>] radeon_do_wait_for_idle+0x12/0x160 [radeon] SS:ESP 0068:ee1f8ec8
> Mar  5 17:19:20 bigred kernel: ---[ end trace a5c0e64d6e3ca307 ]---
> Mar  5 17:19:20 bigred kernel: [drm:drm_release] *ERROR* Device busy: 1 0
> Mar  5 17:19:21 bigred kernel: BUG: unable to handle kernel NULL pointer dereference at 00000005
> Mar  5 17:19:21 bigred kernel: IP: [<ee184800>] 0xee184800
> Mar  5 17:19:21 bigred kernel: *pde = 00000000
> Mar  5 17:19:21 bigred kernel: Oops: 0002 [#2] PREEMPT
> Mar  5 17:19:21 bigred kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/enable
> Mar  5 17:19:21 bigred kernel: Modules linked in: nfsd auth_rpcgss exportfs fan st nfs lockd sunrpc radeon drm asb100 hwmon_vid hwmon snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd soundcore sg sr_mod cdrom usb_storage 8250_pnp 8250 serial_core button
> Mar  5 17:19:21 bigred kernel:
> Mar  5 17:19:21 bigred kernel: Pid: 6292, comm: Xorg Tainted: G      D    (2.6.28.7 #1) System Name
> Mar  5 17:19:21 bigred kernel: EIP: 0060:[<ee184800>] EFLAGS: 00213282 CPU: 0
> Mar  5 17:19:21 bigred kernel: EIP is at 0xee184800
> Mar  5 17:19:21 bigred kernel: EAX: fffffff0 EBX: 00000027 ECX: 0003ffff EDX: 0003e42c
> Mar  5 17:19:21 bigred kernel: ESI: 00000008 EDI: eed31400 EBP: 00000000 ESP: e6747f4c
> Mar  5 17:19:21 bigred kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Mar  5 17:19:21 bigred kernel: Process Xorg (pid: 6292, ti=e6747000 task=dc8670e0 task.ti=e6747000)
> Mar  5 17:19:21 bigred kernel: Stack:
> Mar  5 17:19:21 bigred kernel:  eed31400 f0ad48f8 ee184800 00000000 eed31500 eed314f4 00000008 ee184800
> Mar  5 17:19:21 bigred kernel:  ef99f98c ef512e00 c01733df 00000000 00000000 ef803f80 ee184800 dc883540
> Mar  5 17:19:21 bigred kernel:  00000000 e6747000 c0170317 e6747000 dc883540 ee184800 0000000a c01703b5
> Mar  5 17:19:21 bigred kernel: Call Trace:
> Mar  5 17:19:21 bigred kernel:  [<f0ad48f8>] drm_lastclose+0x28/0x3a0 [drm]
> Mar  5 17:19:21 bigred kernel:  [<c01733df>] __fput+0x9f/0x1c0
> Mar  5 17:19:21 bigred kernel:  [<c0170317>] filp_close+0x47/0x80
> Mar  5 17:19:22 bigred kernel:  [<c01703b5>] sys_close+0x65/0xf0
> Mar  5 17:19:22 bigred kernel:  [<c0103261>] sysenter_do_call+0x12/0x25
> Mar  5 17:19:22 bigred kernel: Code: 00 00 00 ff ff ff ff ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 ec 47 18 ee ec 47 18 ee 2c 5f 5a d7 00 00 00 00 00 00 00 00 <80> 44 18 ee 88 ee 81 ef 80 3f 80 ef 00 2e 51 ef b4 ef b2 f0 00
> Mar  5 17:19:22 bigred kernel: EIP: [<ee184800>] 0xee184800 SS:ESP 0068:e6747f4c
> Mar  5 17:19:22 bigred kernel: ---[ end trace a5c0e64d6e3ca307 ]---
> Mar  5 17:19:23 bigred kernel: usb usb1: uevent
> Mar  5 17:19:23 bigred kernel: usb usb1: uevent
> Mar  5 17:19:23 bigred kernel: usb 1-2: uevent
> Mar  5 17:19:23 bigred kernel: usb usb1: uevent
> Mar  5 17:19:23 bigred kernel: usb 1-3: uevent
> Mar  5 17:19:23 bigred kernel: usb 1-3.3: uevent
> Mar  5 17:19:23 bigred kernel: usb 1-3: uevent
> Mar  5 17:19:23 bigred kernel: usb 1-3.4: uevent
> Mar  5 17:19:23 bigred kernel: usb 1-3: uevent
> Mar  5 17:19:23 bigred kernel: usb usb1: uevent
> Mar  5 17:19:23 bigred kernel: usb 1-4: uevent
> Mar  5 17:19:23 bigred kernel: usb usb1: uevent
> Mar  5 17:19:23 bigred kernel: usb 1-5: uevent
> Mar  5 17:19:23 bigred kernel: usb usb2: uevent
> Mar  5 17:19:23 bigred kernel: usb usb3: uevent
> Mar  5 17:19:23 bigred kernel: usb usb4: uevent
> Mar  5 17:19:24 bigred kernel: BUG: unable to handle kernel NULL pointer dereference at 00000058
> Mar  5 17:19:24 bigred kernel: IP: [<ee1e7c80>] 0xee1e7c80
> Mar  5 17:19:24 bigred kernel: *pde = 00000000
> Mar  5 17:19:24 bigred kernel: Oops: 0002 [#3] PREEMPT
> Mar  5 17:19:24 bigred kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/enable
> Mar  5 17:19:24 bigred kernel: Modules linked in: nfsd auth_rpcgss exportfs fan st nfs lockd sunrpc radeon drm asb100 hwmon_vid hwmon snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd soundcore sg sr_mod cdrom usb_storage 8250_pnp 8250 serial_core button
> Mar  5 17:19:24 bigred kernel:
> Mar  5 17:19:24 bigred kernel: Pid: 6316, comm: Xorg Tainted: G      D    (2.6.28.7 #1) System Name
> Mar  5 17:19:24 bigred kernel: EIP: 0060:[<ee1e7c80>] EFLAGS: 00213282 CPU: 0
> Mar  5 17:19:24 bigred kernel: EIP is at 0xee1e7c80
> Mar  5 17:19:24 bigred kernel: EAX: fffffff0 EBX: 00000027 ECX: 0003ffff EDX: 0003e432
> Mar  5 17:19:24 bigred kernel: ESI: 00000008 EDI: eed31400 EBP: 00000000 ESP: ebb17f4c
> Mar  5 17:19:24 bigred kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Mar  5 17:19:24 bigred kernel: Process Xorg (pid: 6316, ti=ebb17000 task=dc866d80 task.ti=ebb17000)
> Mar  5 17:19:24 bigred kernel: Stack:
> Mar  5 17:19:25 bigred kernel:  eed31400 f0ad48f8 ee1e7c80 00000000 eed31500 eed314f4 00000008 ee1e7c80
> Mar  5 17:19:25 bigred kernel:  ef99f98c ef512e00 c01733df 00000000 00000000 ef803f80 ee1e7c80 dc883d80
> Mar  5 17:19:25 bigred kernel:  00000000 ebb17000 c0170317 ebb17000 dc883d80 ee1e7c80 0000000a c01703b5
> Mar  5 17:19:25 bigred kernel: Call Trace:
> Mar  5 17:19:25 bigred kernel:  [<f0ad48f8>] drm_lastclose+0x28/0x3a0 [drm]
> Mar  5 17:19:25 bigred kernel:  [<c01733df>] __fput+0x9f/0x1c0
> Mar  5 17:19:25 bigred kernel:  [<c0170317>] filp_close+0x47/0x80
> Mar  5 17:19:25 bigred kernel:  [<c01703b5>] sys_close+0x65/0xf0
> Mar  5 17:19:25 bigred kernel:  [<c0103261>] sysenter_do_call+0x12/0x25
> Mar  5 17:19:25 bigred kernel: Code: ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 6c 7c 1e ee 6c 7c 1e ee 2c 8f 41 ef 00 00 00 00 00 00 00 00 <00> 65 58 e6 88 ee 81 ef 80 3f 80 ef 00 2e 51 ef b4 ef b2 f0 00
> Mar  5 17:19:25 bigred kernel: EIP: [<ee1e7c80>] 0xee1e7c80 SS:ESP 0068:ebb17f4c
> Mar  5 17:19:25 bigred kernel: ---[ end trace a5c0e64d6e3ca307 ]---
> Mar  5 17:19:26 bigred kernel: usb usb1: uevent
> Mar  5 17:19:26 bigred kernel: usb usb1: uevent
> Mar  5 17:19:26 bigred kernel: usb 1-2: uevent
> Mar  5 17:19:26 bigred kernel: usb usb1: uevent
> Mar  5 17:19:26 bigred kernel: usb 1-3: uevent
> Mar  5 17:19:26 bigred kernel: usb 1-3.3: uevent
> Mar  5 17:19:26 bigred kernel: usb 1-3: uevent
> Mar  5 17:19:26 bigred kernel: usb 1-3.4: uevent
> Mar  5 17:19:26 bigred kernel: usb 1-3: uevent
> Mar  5 17:19:26 bigred kernel: usb usb1: uevent
> Mar  5 17:19:26 bigred kernel: usb 1-4: uevent
> Mar  5 17:19:26 bigred kernel: usb usb1: uevent
> Mar  5 17:19:26 bigred kernel: usb 1-5: uevent
> Mar  5 17:19:26 bigred kernel: usb usb2: uevent
> Mar  5 17:19:26 bigred kernel: usb usb3: uevent
> Mar  5 17:19:26 bigred kernel: usb usb4: uevent
> Mar  5 17:19:27 bigred kernel: BUG: unable to handle kernel NULL pointer dereference at 00000010
> Mar  5 17:19:27 bigred kernel: IP: [<f0b12e08>] radeon_do_wait_for_idle+0x18/0x160 [radeon]
> Mar  5 17:19:27 bigred kernel: *pde = 00000000
> Mar  5 17:19:28 bigred kernel: Oops: 0000 [#4] PREEMPT
> Mar  5 17:19:28 bigred kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/enable
> Mar  5 17:19:28 bigred kernel: Modules linked in: nfsd auth_rpcgss exportfs fan st nfs lockd sunrpc radeon drm asb100 hwmon_vid hwmon snd_via82xx snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd soundcore sg sr_mod cdrom usb_storage 8250_pnp 8250 serial_core button
> Mar  5 17:19:28 bigred kernel:
> Mar  5 17:19:28 bigred kernel: Pid: 6345, comm: Xorg Tainted: G      D    (2.6.28.7 #1) System Name
> Mar  5 17:19:28 bigred kernel: EIP: 0060:[<f0b12e08>] EFLAGS: 00213206 CPU: 0
> Mar  5 17:19:28 bigred kernel: EIP is at radeon_do_wait_for_idle+0x18/0x160 [radeon]
> Mar  5 17:19:28 bigred kernel: EAX: 00000000 EBX: eed30400 ECX: 0003ffff EDX: 0003e438
> Mar  5 17:19:28 bigred kernel: ESI: ebb87680 EDI: eed31400 EBP: 00000000 ESP: e6562f20
> Mar  5 17:19:28 bigred kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Mar  5 17:19:28 bigred kernel: Process Xorg (pid: 6345, ti=e6562000 task=ebaad7a0 task.ti=e6562000)
> Mar  5 17:19:28 bigred kernel: Stack:
> Mar  5 17:19:28 bigred kernel:  eed30400 00203286 f0b2071c 00000000 ebb87680 f0b14ba6 eed31400 f0ad5109
> Mar  5 17:19:28 bigred kernel:  00000027 00000008 ebb87680 eed31400 f0ad48f8 ebb87680 00000000 eed31500
> Mar  5 17:19:28 bigred kernel:  eed314f4 00000008 ebb87680 ef99f98c ef512e00 c01733df 00000000 00000000
> Mar  5 17:19:28 bigred kernel: Call Trace:
> Mar  5 17:19:28 bigred kernel:  [<f0b2071c>] radeon_driver_preclose+0x3c/0x70 [radeon]
> Mar  5 17:19:28 bigred kernel:  [<f0b14ba6>] radeon_do_release+0xb6/0x120 [radeon]
> Mar  5 17:19:28 bigred kernel:  [<f0ad5109>] drm_release+0x309/0x480 [drm]
> Mar  5 17:19:28 bigred kernel:  [<f0ad48f8>] drm_lastclose+0x28/0x3a0 [drm]
> Mar  5 17:19:28 bigred kernel:  [<c01733df>] __fput+0x9f/0x1c0
> Mar  5 17:19:28 bigred kernel:  [<c0170317>] filp_close+0x47/0x80
> Mar  5 17:19:28 bigred kernel:  [<c01703b5>] sys_close+0x65/0xf0
> Mar  5 17:19:28 bigred kernel:  [<c0103261>] sysenter_do_call+0x12/0x25
> Mar  5 17:19:28 bigred kernel: Code: 6f cf 39 73 68 7f dc b8 f0 ff ff ff eb 81 90 8d 74 26 00 56 89 c6 53 83 ec 10 83 48 70 08 8b 40 68 85 c0 7e 46 8b 86 30 03 00 00 <8b> 40 10 05 40 0e 00 00 8b 00 83 e0 7f 31 db 83 f8 3f 7e 1c eb
> Mar  5 17:19:28 bigred kernel: EIP: [<f0b12e08>] radeon_do_wait_for_idle+0x18/0x160 [radeon] SS:ESP 0068:e6562f20
> Mar  5 17:19:28 bigred kernel: ---[ end trace a5c0e64d6e3ca307 ]---
> 
> <<snip>>

