Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZLYNPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZLYNPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 08:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZLYNPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 08:15:12 -0500
Received: from lo.gmane.org ([80.91.229.12]:54446 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbZLYNPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 08:15:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Miguel Calleja <mcalleja1@telecable.es>
Subject: Re: Linux 2.6.33-rc2 - Blank screen for Intel KMS
Date: Fri, 25 Dec 2009 13:10:58 +0000 (UTC)
Message-ID: <hh2dl2$ler$1@ger.gmane.org>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cm-83-97-192-133.telecable.es
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 24 Dec 2009 14:00:24 -0800, Linus Torvalds escribió:

Hi.

I've upgraded from 2.6.32 and I get a blank screen when the system is 
starting KMS. My motherboard is an Intel DG43NB with onboard video. I 
traced back to the patch that stopped working on my system and it is 
patch-2.6.32-git7. patch-2.6.32-git6 works fine. From dmesg of git7 I see 
this:

i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-
combining
[drm] MTRR allocation failed.  Graphics performance may suffer.
i915 0000:00:02.0: irq 28 for MSI/MSI-X
[drm] set up 31M of stolen space
------------[ cut here ]------------
WARNING: at drivers/gpu/drm/drm_crtc_helper.c:1035 
drm_helper_initial_config+0x5e/0x60 [drm_kms_helper]()
Hardware name:         
No connectors reported connected with modes
Modules linked in: i915(+) snd_hda_codec bttv(+) v4l2_common videodev 
ir_common videobuf_dma_sg videobuf_core drm_kms_helper snd_pcm btcx_risc 
uhci_hcd i2c_i801 tveeprom drm snd_timer i2c_algo_bit snd cfbcopyarea 
ehci_hcd psmouse video i2c_core soundcore e1000e sr_mod intel_agp usbcore 
backlight 8139too output cfbimgblt cfbfillrect snd_page_alloc cdrom 
agpgart evdev thermal rtc_cmos rtc_core rtc_lib button
Pid: 628, comm: modprobe Not tainted 2.6.32-git7 #1
Call Trace:
 [<c103215e>] ? warn_slowpath_common+0x6e/0xb0
 [<f8875abe>] ? drm_helper_initial_config+0x5e/0x60 [drm_kms_helper]
 [<c10321eb>] ? warn_slowpath_fmt+0x2b/0x30
 [<f8875abe>] ? drm_helper_initial_config+0x5e/0x60 [drm_kms_helper]
 [<f89a3a91>] ? i915_driver_load+0x1321/0x14c0 [i915]
 [<f89a2750>] ? i915_vga_set_decode+0x0/0x20 [i915]
 [<f87b8eaf>] ? drm_get_dev+0x29f/0x470 [drm]
 [<c10db051>] ? sysfs_do_create_link+0xa1/0x140
 [<f89cdc15>] ? i915_pci_probe+0x0/0x130 [i915]
 [<c112d6db>] ? local_pci_probe+0xb/0x10
 [<c112df29>] ? pci_device_probe+0x69/0x90
 [<c118ffeb>] ? driver_probe_device+0x7b/0x170
 [<c112d848>] ? pci_match_device+0xa8/0xc0
 [<c1190159>] ? __driver_attach+0x79/0x80
 [<c11900e0>] ? __driver_attach+0x0/0x80
 [<c118f8b2>] ? bus_for_each_dev+0x52/0x80
 [<c118fe86>] ? driver_attach+0x16/0x20
 [<c11900e0>] ? __driver_attach+0x0/0x80
 [<c118f1d1>] ? bus_add_driver+0xa1/0x250
 [<c112de60>] ? pci_device_remove+0x0/0x40
 [<c11903f3>] ? driver_register+0x63/0x110
 [<f87b434d>] ? drm_init+0x2d/0xf0 [drm]
 [<f89df000>] ? i915_init+0x0/0x48 [i915]
 [<c112e16d>] ? __pci_register_driver+0x3d/0xb0
 [<c100112f>] ? do_one_initcall+0x2f/0x190
 [<c105c002>] ? sys_init_module+0xb2/0x220
 [<c10961b1>] ? sys_read+0x41/0x70
 [<c1002ed0>] ? sysenter_do_call+0x12/0x26
---[ end trace 03d4bb0d67069a6a ]---
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


