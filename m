Return-Path: <linux-kernel-owner+w=401wt.eu-S1762368AbXEXFhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762368AbXEXFhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 01:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbXEXFhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 01:37:38 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:45027 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbXEXFhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 01:37:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoUANXBVEZKhRO4WGdsb2JhbACHP4hGARwNBREB
From: Dmitry Torokhov <dtor@insightbb.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Nvidiafb issues on Inspiron 8100
Date: Thu, 24 May 2007 01:37:35 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705240137.35955.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonino,

I am having the following issues on my Dell Inspiron 8100. They are not
new but I just got around to report them.

With CONFIG_FB_NVIDIA_I2C I get 1600x1200 resolution but pixels
"swarming" and it is unuseable. There are following messages in
dmesg (note complaints from i2c):

May 24 00:53:29 core kernel: [    0.000000] Kernel command line: ro root=LABEL=/ video=nvidiafb:
1600x1200MR atkbd.softrepeat selinux=0
May 24 00:53:29 core kernel: [   12.876534] nvidiafb_setup START
May 24 00:53:29 core kernel: [   12.876608] nvidiafb_setup END
May 24 00:53:29 core kernel: [   12.877920] nvidiafb_probe START
May 24 00:53:29 core kernel: [   12.880624] nvidiafb: Device ID: 10de0112
May 24 00:53:29 core kernel: [   13.105685] nvidiafb: EDID found from BUS1
May 24 00:53:29 core kernel: [   13.182737] i2c-adapter i2c-1: unable to read EDID block.
May 24 00:53:29 core kernel: [   13.262611] Switched to high resolution mode on CPU 0
May 24 00:53:29 core kernel: [   13.302898] i2c-adapter i2c-1: unable to read EDID block.
May 24 00:53:29 core kernel: [   13.422871] i2c-adapter i2c-1: unable to read EDID block.
May 24 00:53:29 core kernel: [   13.465822] nvidiafb: CRTC 1 is currently programmed for DFP
May 24 00:53:29 core kernel: [   13.465892] nvidiafb: Using DFP on CRTC 1
May 24 00:53:29 core kernel: [   13.465960] nvidiafb: Panel size is 1600 x 1200
May 24 00:53:29 core kernel: [   13.466025] nvidiafb: Panel is LVDS
May 24 00:53:29 core kernel: [   13.466982] nvidiafb: MTRR set to ON
May 24 00:53:29 core kernel: [   13.467060] nvidia_set_fbinfo START
May 24 00:53:29 core kernel: [   13.467135] fbcvt: 1600x1200@60: CVT Name - 1.920M3-R
May 24 00:53:29 core kernel: [   13.467204] nvidiafb_check_var START
May 24 00:53:29 core kernel: [   13.467266] nvidiafb_check_var END
May 24 00:53:29 core kernel: [   13.467332] nvidia_set_fbinfo END
May 24 00:53:29 core kernel: [   13.467391] nvidiafb_check_var START
May 24 00:53:29 core kernel: [   13.467452] nvidiafb_check_var END
May 24 00:53:29 core kernel: [   13.467513] nvidia_save_vga START
May 24 00:53:29 core kernel: [   13.467846] nvidia_save_vga END
May 24 00:53:29 core kernel: [   13.613205] nvidia_save_vga START
May 24 00:53:29 core kernel: [   13.613459] nvidia_save_vga END
May 24 00:53:29 core kernel: [   13.630281] nvidiafb_set_par START
May 24 00:53:29 core kernel: [   13.630293] nvidiafb: Flat panel dithering disabled
May 24 00:53:29 core kernel: [   13.630335] nvidia_write_regs START
May 24 00:53:29 core kernel: [   13.630523] nvidia_write_regs END
May 24 00:53:29 core kernel: [   13.630540] nvidiafb_set_par END
May 24 00:53:29 core kernel: [   13.630593] nvidiafb_setcolreg START
May 24 00:53:29 core kernel: [   13.630599] nvidiafb_setcolreg END
....
May 24 00:53:29 core kernel: [   13.636561] Console: switching to colour frame buffer device 200x75
....
May 24 00:53:29 core kernel: [   13.728536] nvidiafb: PCI nVidia NV11 framebuffer (32MB @ 0xE0000000)
May 24 00:53:29 core kernel: [   13.729568] nvidiafb_probe END

If I disable CONFIG_FB_NVIDIA_I2C and enable CONFIG_FIRMWARE_EDID then
it looks like I have a virtual screen with large font extending past
physical. If I do:

	fbset 1024x768-60
	fbset 1600x1200-60

everything is back to normal.

And below a cosmetic patch for you...

Thank you.

-- 
Dmitry

nvidiafb: tweak wording on module parameters descriptions

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/video/nvidia/nvidia.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

Index: work/drivers/video/nvidia/nvidia.c
===================================================================
--- work.orig/drivers/video/nvidia/nvidia.c
+++ work/drivers/video/nvidia/nvidia.c
@@ -1562,11 +1562,11 @@ MODULE_PARM_DESC(noaccel,
 		 "(default=0)");
 module_param(noscale, int, 0);
 MODULE_PARM_DESC(noscale,
-		 "Disables screen scaleing. (0 or 1=disable) "
+		 "Disables screen scaling. (0 or 1=disable) "
 		 "(default=0, do scaling)");
 module_param(paneltweak, int, 0);
 MODULE_PARM_DESC(paneltweak,
-		 "Tweak display settings for flatpanels. "
+		 "Tweak display settings for flat panels. "
 		 "(default=0, no tweaks)");
 module_param(forceCRTC, int, 0);
 MODULE_PARM_DESC(forceCRTC,
@@ -1574,13 +1574,12 @@ MODULE_PARM_DESC(forceCRTC,
 		 "fails. (0 or 1) (default=autodetect)");
 module_param(vram, int, 0);
 MODULE_PARM_DESC(vram,
-		 "amount of framebuffer memory to remap in MiB"
+		 "Amount of framebuffer memory to remap in MiB"
 		 "(default=0 - remap entire memory)");
 module_param(mode_option, charp, 0);
 MODULE_PARM_DESC(mode_option, "Specify initial video mode");
 module_param(bpp, int, 0);
-MODULE_PARM_DESC(bpp, "pixel width in bits"
-		 "(default=8)");
+MODULE_PARM_DESC(bpp, "Pixel width in bits (default=8)");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "Disables MTRR support (0 or 1=disabled) "
