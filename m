Return-Path: <linux-kernel-owner+w=401wt.eu-S935472AbZLPTI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935472AbZLPTI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935457AbZLPTIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:08:24 -0500
Received: from khc.piap.pl ([195.187.100.11]:49745 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935381AbZLPTIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:08:19 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       Nanhai Zou <nanhai.zou@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: 2.6.32.1 i915 KMS rmmod failure
Date: Wed, 16 Dec 2009 20:08:16 +0100
Message-ID: <m3d42e20v3.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following sequence causes the machine to hang hard:
modprobe drm debug=65535
modprobe i915 modeset=1
rmmod i915

Linux 2.6.32.1 x86-64, i915 (the machine is a slimline MSI Hetis 915
barebone), 2 GB RAM etc. Kernel messages captured with a serial console.
Only analog VGA output connected (no EDID, using a "pro" 5 * BNC cable
to connect to an old analog monitor). There is (unconnected) digital DVI
and a TV encoder. Other details available on request.

The IRQ happens in intel_pipe_set_base()

	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset, x, y);
	I915_WRITE(dspstride, crtc->fb->pitch);
	if (IS_I965G(dev)) {
        	...
	} else {
		I915_WRITE(dspbase, Start + Offset);
		I915_READ(dspbase);
  >>>>>>> IRQ seems to be triggered at this point <<<<<<<
	}

Any ideas?

modprobe:

[drm] Initialized drm 1.1.0 20060810
[drm:drm_init],
[drm:drm_get_dev],
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[drm:drm_get_minor],
[drm:drm_get_minor], new minor assigned 64
[drm:drm_get_minor],
[drm:drm_get_minor], new minor assigned 0
[drm:i915_init_phys_hws], Enabled hardware status page
[drm] set up 7M of stolen space
[drm:drm_agp_bind_pages],
[drm:parse_general_definitions], crt_ddc_bus_pin: 2
[drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
[drm:parse_sdvo_device_mapping], the SDVO device with slave addr 72 is found on SDVOC port
[drm:drm_irq_install], irq=16
[drm:intel_modeset_init], 2 display pipes available.
[drm:drm_sysfs_connector_add], adding "VGA-1" to sysfs
[drm:drm_sysfs_hotplug_event], generating hotplug event
[drm:drm_sysfs_connector_add], adding "DVI-D-1" to sysfs
[drm:drm_sysfs_hotplug_event], generating hotplug event
[drm:intel_sdvo_init], SDVOB device VID/DID: 02:3C.06, clock range 25MHz - 200MHz, input 1: Y, input 2: N, output 1:
Y, output 2: N
[drm:intel_sdvo_create_enhance_property], h_overscan: max 47, default 32, current 32
[drm:intel_sdvo_create_enhance_property], v_overscan: max 47, default 32, current 32
[drm:intel_sdvo_create_enhance_property], h_position: max 1023, default 512, current 512
[drm:intel_sdvo_create_enhance_property], v_position: max 1023, default 512, current 512
[drm:intel_sdvo_create_enhance_property], saturation: max 127, default 69, current 69
[drm:intel_sdvo_create_enhance_property], contrast: max 127, default 64, current 64
[drm:intel_sdvo_create_enhance_property], hue: max 127, default 64, current 64
[drm:intel_sdvo_create_enhance_property], brightness: max 255, default 128, current 128
[drm:drm_sysfs_connector_add], adding "SVIDEO-1" to sysfs
[drm:drm_sysfs_hotplug_event], generating hotplug event
[drm:intel_sdvo_init], SDVOC device VID/DID: 02:C2.02, clock range 25MHz - 160MHz, input 1: Y, input 2: N, output 1:
Y, output 2: N
[drm:drm_helper_probe_single_connector_modes], VGA-1
[drm:intel_update_watermarks], plane A (pipe 0) clock: 31500
[drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[drm:intel_calculate_wm], FIFO entries required for mode: 9
[drm:intel_calculate_wm], FIFO watermark level: 17
[drm:intel_calculate_wm], FIFO entries required for mode: 0
[drm:intel_calculate_wm], FIFO watermark level: 29
[drm:i9xx_update_wm], FIFO watermarks - A: 17, B: 29
[drm:i9xx_update_wm], self-refresh entries: 12
[drm:i9xx_update_wm], Setting FIFO watermarks - A: 17, B: 29, C: 2, SR 83
[drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[drm:intel_crtc_mode_set], Mode for pipe A:
[drm:drm_mode_debug_printmodeline], Modeline 0:"640x480" 0 31500 640 664 704 832 480 489 491 520 0x10 0xa
[drm:intel_pipe_set_base], No FB bound
[drm:intel_update_watermarks], plane A (pipe 0) clock: 31500
[drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[drm:intel_calculate_wm], FIFO entries required for mode: 9
[drm:intel_calculate_wm], FIFO watermark level: 17
[drm:intel_calculate_wm], FIFO entries required for mode: 0
[drm:intel_calculate_wm], FIFO watermark level: 29
[drm:i9xx_update_wm], FIFO watermarks - A: 17, B: 29
[drm:i9xx_update_wm], self-refresh entries: 12
[drm:i9xx_update_wm], Setting FIFO watermarks - A: 17, B: 29, C: 2, SR 83
[drm] DAC-6: set mode 640x480 0
[drm:intel_update_watermarks], plane A (pipe 0) clock: 31500
[drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[drm:intel_calculate_wm], FIFO entries required for mode: 9
[drm:intel_calculate_wm], FIFO watermark level: 17
[drm:intel_calculate_wm], FIFO entries required for mode: 0
[drm:intel_calculate_wm], FIFO watermark level: 29
[drm:i9xx_update_wm], FIFO watermarks - A: 17, B: 29
[drm:i9xx_update_wm], self-refresh entries: 12
[drm:i9xx_update_wm], Setting FIFO watermarks - A: 17, B: 29, C: 2, SR 83
[drm:drm_helper_probe_single_connector_modes], Probed modes for VGA-1
[drm:drm_mode_debug_printmodeline], Modeline 33:"800x600" 85 56250 800 832 896 1048 600 601 604 631 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 32:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 30:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 29:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 85 36000 640 696 752 832 480 481 484 509 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 27:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 26:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[drm:drm_mode_debug_printmodeline], Modeline 24:"720x400" 85 35500 720 756 828 936 400 401 404 446 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 23:"640x400" 85 31500 640 672 736 832 400 401 404 445 0x40 0x6
[drm:drm_mode_debug_printmodeline], Modeline 22:"640x350" 85 31500 640 672 736 832 350 382 385 445 0x40 0x9
[drm:drm_helper_probe_single_connector_modes], DVI-D-1
[drm:intel_sdvo_detect], SDVO response 0 0
[drm:drm_helper_probe_single_connector_modes], DVI-D-1 is disconnected
[drm:drm_helper_probe_single_connector_modes], SVIDEO-1
[drm:intel_sdvo_detect], SDVO response 0 0
[drm:drm_helper_probe_single_connector_modes], SVIDEO-1 is disconnected
[drm:drm_setup_crtcs],
[drm:drm_enable_connectors], connector 5 enabled? yes
[drm:drm_enable_connectors], connector 7 enabled? no
[drm:drm_enable_connectors], connector 9 enabled? no
[drm:drm_target_preferred], looking for cmdline mode on connector 5
[drm:drm_target_preferred], looking for preferred mode on connector 5
[drm:drm_target_preferred], found mode 800x600
[drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[drm:drm_setup_crtcs], desired mode 800x600 set on crtc 3
[drm:intelfb_probe],
[drm:drm_agp_bind_pages],
[drm:intelfb_create], allocated 800x600 fb: 0x007df000, bo ffff88007d363ec0
fb0: inteldrmfb frame buffer device
registered panic notifier
[drm:intel_opregion_init], graphic opregion physical addr: 0x0
[drm:intel_opregion_init], ACPI OpRegion not supported!
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

rmmod i915:

[drm:drm_exit],
[drm:drm_put_dev],
[drm:drm_lastclose],
[drm:drm_crtc_helper_set_config],
[drm:drm_crtc_helper_set_config], crtc: ffff88007c3fb800 3 fb: ffff88007d363cc0 connectors: ffff88007d02a280 num_conn
ectors: 1 (x, y) (0, 0)
[drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[drm:drm_crtc_helper_set_config], modes are different, full mode set
[drm:drm_mode_debug_printmodeline], Modeline 0:"640x480" 0 31500 640 664 704 832 480 489 491 520 0x10 0xa
[drm:drm_mode_debug_printmodeline], Modeline 35:"800x600" 85 56250 800 832 896 1048 600 601 604 631 0x40 0x5
[drm:drm_crtc_helper_set_config], setting connector 5 crtc to ffff88007c3fb800
[drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[drm:drm_mode_debug_printmodeline], Modeline 35:"800x600" 85 56250 800 832 896 1048 600 601 604 631 0x40 0x5
[drm:intel_update_watermarks], plane A (pipe 0) clock: 56250
[drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[drm:intel_calculate_wm], FIFO entries required for mode: 17
[drm:intel_calculate_wm], FIFO watermark level: 9
[drm:intel_calculate_wm], FIFO entries required for mode: 0
[drm:intel_calculate_wm], FIFO watermark level: 29
[drm:i9xx_update_wm], FIFO watermarks - A: 9, B: 29
[drm:i9xx_update_wm], self-refresh entries: 21
[drm:i9xx_update_wm], Setting FIFO watermarks - A: 9, B: 29, C: 2, SR 74
[drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[drm:intel_crtc_mode_set], Mode for pipe A:
[drm:drm_mode_debug_printmodeline], Modeline 35:"800x600" 85 56250 800 832 896 1048 600 601 604 631 0x40 0x5
[drm:intel_pipe_set_base], Writing base 007DF000 00000000 0 0
render error detected, EIR: 0x00000010
page table error
  PGTBL_ER: 0x00000010
[drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
--
Krzysztof Halasa
