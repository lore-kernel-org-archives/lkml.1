Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab0APA7N (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412Ab0APA7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:59:12 -0500
Received: from pima.mpagano.com ([67.228.218.97]:48725 "EHLO pima.mpagano.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758384Ab0APA7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:59:12 -0500
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2010 19:59:11 EST
From: Mike Pagano <mpagano@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] video: Add VIDEO_DEV dependency as needed in drivers/media/video/Kconfig
Date: Fri, 15 Jan 2010 19:49:08 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32-gentoo; KDE/4.3.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001151949.08751.mpagano@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add VIDEO_DEV as dependency of VIDEO_CAPTURE_DRIVERS and all of the devices listed under this setting.  

Signed-off-by: Mike Pagano <mpagano@gentoo.org>
---
 media/video/Kconfig |   20 ++++++++++----------
  1 file changed, 10 insertions(+), 10 deletions(-)

--- drivers/media/video/Kconfig.orig	2010-01-15 15:54:11.000000000 -0500
+++ drivers/media/video/Kconfig	2010-01-15 19:20:24.000000000 -0500
@@ -51,14 +51,14 @@ config VIDEO_TUNER
 
 menuconfig VIDEO_CAPTURE_DRIVERS
 	bool "Video capture adapters"
-	depends on VIDEO_V4L2
+	depends on VIDEO_V4L2 && VIDEO_DEV
 	default y
 	---help---
 	  Say Y here to enable selecting the video adapters for
 	  webcams, analog TV, and hybrid analog/digital TV.
 	  Some of those devices also supports FM radio.
 
-if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
+if VIDEO_DEV && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
 
 config VIDEO_ADV_DEBUG
 	bool "Enable advanced debug functionality"
@@ -500,7 +500,7 @@ endmenu # encoder / decoder chips
 
 config DISPLAY_DAVINCI_DM646X_EVM
 	tristate "DM646x EVM Video Display"
-	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
+	depends on MACH_DAVINCI_DM6467_EVM
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEO_DAVINCI_VPIF
 	select VIDEO_ADV7343
@@ -513,7 +513,7 @@ config DISPLAY_DAVINCI_DM646X_EVM
 
 config CAPTURE_DAVINCI_DM646X_EVM
 	tristate "DM646x EVM Video Capture"
-	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
+	depends on MACH_DAVINCI_DM6467_EVM
 	select VIDEOBUF_DMA_CONTIG
 	select VIDEO_DAVINCI_VPIF
 	help
@@ -533,7 +533,7 @@ config VIDEO_DAVINCI_VPIF
 
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
+	depends on VIDEO_V4L2 && !SPARC32 && !SPARC64
 	select VIDEOBUF_VMALLOC
 	default n
 	---help---
@@ -884,7 +884,7 @@ config MX1_VIDEO
 
 config VIDEO_MX1
 	tristate "i.MX1/i.MXL CMOS Sensor Interface driver"
-	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
+	depends on ARCH_MX1 && SOC_CAMERA
 	select FIQ
 	select VIDEOBUF_DMA_CONTIG
 	select MX1_VIDEO
@@ -896,7 +896,7 @@ config MX3_VIDEO
 
 config VIDEO_MX3
 	tristate "i.MX3x Camera Sensor Interface driver"
-	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
+	depends on MX3_IPU && SOC_CAMERA
 	select VIDEOBUF_DMA_CONTIG
 	select MX3_VIDEO
 	---help---
@@ -904,21 +904,21 @@ config VIDEO_MX3
 
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && PXA27x && SOC_CAMERA
+	depends on PXA27x && SOC_CAMERA
 	select VIDEOBUF_DMA_SG
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
-	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
+	depends on SOC_CAMERA && HAS_DMA && HAVE_CLK
 	select VIDEOBUF_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for the SuperH Mobile CEU Interface
 
 config VIDEO_OMAP2
 	tristate "OMAP2 Camera Capture Interface driver"
-	depends on VIDEO_DEV && ARCH_OMAP2
+	depends on ARCH_OMAP2
 	select VIDEOBUF_DMA_SG
 	---help---
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
