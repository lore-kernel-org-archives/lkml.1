Return-Path: <linux-kernel-owner+w=401wt.eu-S1762489AbYA3Qjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762489AbYA3Qjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYA3Qjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:39:44 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:33258 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbYA3Qjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:39:42 -0500
Date: Wed, 30 Jan 2008 08:38:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Bryan Wu <bryan.wu@analog.com>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [Linux-fbdev-devel] [PATCH 1/1] [VIDEO/FRAMEBUFFER]: add BF52x
 EZkit Display driver
Message-Id: <20080130083820.c1bcbc14.randy.dunlap@oracle.com>
In-Reply-To: <1201686800-31739-1-git-send-email-bryan.wu@analog.com>
References: <1201686800-31739-1-git-send-email-bryan.wu@analog.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 17:53:20 +0800 Bryan Wu wrote:

> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/video/Kconfig            |   53 ++--

All of these non-bfin changes to Kconfig shouldn't be part of
this patch.


>  drivers/video/Makefile           |    1 +
>  drivers/video/bfin-t350mcqb-fb.c |  685 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 719 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/video/bfin-t350mcqb-fb.c
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 758435f..6e3bb9d 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -553,6 +553,19 @@ config FB_BF54X_LQ043
>  	help
>  	 This is the framebuffer device driver for a SHARP LQ043T1DG01 TFT LCD
>  
> +config FB_BFIN_T350MCQB
> +	tristate "Varitronix COG-T350MCQB TFT LCD display (BF527 EZKIT)"
> +	depends on FB && BLACKFIN
> +	select BFIN_GPTIMERS
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	help
> +	 This is the framebuffer device driver for a Varitronix VL-PS-COG-T350MCQB-01 display TFT LCD
> +	 This display is a QVGA 320x240 24-bit RGB display interfaced by an 8-bit wide PPI
> +	 It uses PPI[0..7] PPI_FS1, PPI_FS2 and PPI_CLK. 
> +
> +
>  config FB_STI
>  	tristate "HP STI frame buffer device support"
>  	depends on FB && PARISC
> @@ -565,7 +578,7 @@ config FB_STI
>  	  BIOS routines contained in a ROM chip in HP PA-RISC based machines.
>  	  Enabling this option will implement the linux framebuffer device
>  	  using calls to the STI BIOS routines for initialisation.
> -	
> +
>  	  If you enable this option, you will get a planar framebuffer device
>  	  /dev/fb which will work on the most common HP graphic cards of the
>  	  NGLE family, including the artist chips (in the 7xx and Bxxx series),
> @@ -1019,36 +1032,36 @@ config FB_I810
>  	select FB_CFB_IMAGEBLIT
>  	select VGASTATE
>  	help
> -	  This driver supports the on-board graphics built in to the Intel 810 
> +	  This driver supports the on-board graphics built in to the Intel 810
>            and 815 chipsets.  Say Y if you have and plan to use such a board.
>  
>            To compile this driver as a module, choose M here: the
>  	  module will be called i810fb.
>  
> -          For more information, please read 
> +          For more information, please read
>  	  <file:Documentation/fb/intel810.txt>
>  
>  config FB_I810_GTF
>  	bool "use VESA Generalized Timing Formula"
>  	depends on FB_I810
>  	help
> -	  If you say Y, then the VESA standard, Generalized Timing Formula 
> +	  If you say Y, then the VESA standard, Generalized Timing Formula
>            or GTF, will be used to calculate the required video timing values
> -	  per video mode.  Since the GTF allows nondiscrete timings 
> +	  per video mode.  Since the GTF allows nondiscrete timings
>            (nondiscrete being a range of values as opposed to discrete being a
> -          set of values), you'll be able to use any combination of horizontal 
> +          set of values), you'll be able to use any combination of horizontal
>  	  and vertical resolutions, and vertical refresh rates without having
>  	  to specify your own timing parameters.  This is especially useful
> -	  to maximize the performance of an aging display, or if you just 
> -          have a display with nonstandard dimensions. A VESA compliant 
> +	  to maximize the performance of an aging display, or if you just
> +          have a display with nonstandard dimensions. A VESA compliant
>  	  monitor is recommended, but can still work with non-compliant ones.
> -	  If you need or want this, then select this option. The timings may 
> -	  not be compliant with Intel's recommended values. Use at your own 
> +	  If you need or want this, then select this option. The timings may
> +	  not be compliant with Intel's recommended values. Use at your own
>  	  risk.
>  
> -          If you say N, the driver will revert to discrete video timings 
> +          If you say N, the driver will revert to discrete video timings
>  	  using a set recommended by Intel in their documentation.
> -  
> +
>            If unsure, say N.
>  
>  config FB_I810_I2C
> @@ -1172,10 +1185,10 @@ config FB_MATROX_G
>  	  framebuffer section. G450/G550 secondary head and digital output
>  	  are supported without additional modules.
>  
> -	  The driver starts in monitor mode. You must use the matroxset tool 
> -	  (available at <ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/>) to 
> -	  swap primary and secondary head outputs, or to change output mode.  
> -	  Secondary head driver always start in 640x480 resolution and you 
> +	  The driver starts in monitor mode. You must use the matroxset tool
> +	  (available at <ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/>) to
> +	  swap primary and secondary head outputs, or to change output mode.
> +	  Secondary head driver always start in 640x480 resolution and you
>  	  must use fbset to change it.
>  
>  	  Do not forget that second head supports only 16 and 32 bpp
> @@ -1273,7 +1286,7 @@ config FB_RADEON
>  	  "I2C support" and "I2C bit-banging support" in the character devices
>  	  section.
>  
> -	  If you say M here then "I2C support" and "I2C bit-banging support" 
> +	  If you say M here then "I2C support" and "I2C bit-banging support"
>  	  can be build either as modules or built-in.
>  
>  	  There is a product page at
> @@ -1285,7 +1298,7 @@ config FB_RADEON_I2C
>  	select FB_DDC
>  	default y
>  	help
> -	  Say Y here if you want DDC/I2C support for your Radeon board. 
> +	  Say Y here if you want DDC/I2C support for your Radeon board.
>  
>  config FB_RADEON_BACKLIGHT
>  	bool "Support for backlight control"
> @@ -1466,7 +1479,7 @@ config FB_NEOMAGIC
>  	select VGASTATE
>  	help
>  	  This driver supports notebooks with NeoMagic PCI chips.
> -	  Say Y if you have such a graphics card. 
> +	  Say Y if you have such a graphics card.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called neofb.
> @@ -1512,7 +1525,7 @@ config FB_VOODOO1
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
>  	---help---
> -	  Say Y here if you have a 3Dfx Voodoo Graphics (Voodoo1/sst1) or 
> +	  Say Y here if you have a 3Dfx Voodoo Graphics (Voodoo1/sst1) or
>  	  Voodoo2 (cvg) based graphics card.
>  
>  	  To compile this driver as a module, choose M here: the


---
~Randy
