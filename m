Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZDPJx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZDPJx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZDPJxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:53:18 -0400
Received: from mail3.ks.pochta.ru ([82.204.219.182]:60864 "EHLO
	mail3.ks.pochta.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZDPJxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:53:17 -0400
X-Greylist: delayed 1686 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Apr 2009 05:53:16 EDT
Date: Thu, 16 Apr 2009 13:25:11 +0400
To: linux-kernel@vger.kernel.org
Subject: Include in a kernel a patch for tuner support AverMedia Studio 505
From: vaka@newmail.ru
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.usg239qgd7v8y6@vaka>
User-Agent: Opera Mail/9.64 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have written a patch for the tuner AverMedia Studio 505 that it was  
correctly defined.
I hope that you include this patch in a kernel
This patch for a kernel 2.6.29.1

Thanks that have paid attention!
Have a nice day!

Thanks,
	Vasiliy Temnikov <vaka@newmail.ru>




/* Adds tuner support AverMedia AverTV Studio 505 for kernel version  
2.6.29.1 */
/* Vasiliy Temnikov <vaka@newmail.ru> */

diff --git a/drivers/media/video/saa7134/saa7134-cards.c  
b/drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -1359,6 +1359,42 @@
  			.amux = LINE1,
  		},
  	},
+	[SAA7134_BOARD_AVERMEDIA_STUDIO_505] = {
+		/* Vasiliy Temnikov <vaka@newmail.ru> */
+		.name           = "AverMedia AverTV Studio 505",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = LINE2,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+		},{
+			.name = name_comp2,
+			.vmux = 3,
+			.amux = LINE2,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+	},
  	[SAA7134_BOARD_UPMOST_PURPLE_TV] = {
  		.name           = "UPMOST PURPLE TV",
  		.audio_clock    = 0x00187de7,
@@ -4932,6 +4968,12 @@
  		.vendor       = PCI_VENDOR_ID_PHILIPS,
  		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
  		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xa115,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_STUDIO_505,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
  		.subdevice    = 0x2108,
  		.driver_data  = SAA7134_BOARD_AVERMEDIA_305,
  	},{
@@ -5922,6 +5964,7 @@
  	case SAA7134_BOARD_KWORLD_VSTREAM_XPERT:
  	case SAA7134_BOARD_KWORLD_XPERT:
  	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
  	case SAA7134_BOARD_AVERMEDIA_305:
  	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
  	case SAA7134_BOARD_AVERMEDIA_307:


diff --git a/drivers/media/video/saa7134/saa7134-input.c  
b/drivers/media/video/saa7134/saa7134-input.c
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -445,6 +445,7 @@
  	case SAA7134_BOARD_AVERMEDIA_305:
  	case SAA7134_BOARD_AVERMEDIA_307:
  	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
+	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
  	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
  	case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
  	case SAA7134_BOARD_AVERMEDIA_GO_007_FM:


diff --git a/drivers/media/video/saa7134/saa7134.h  
b/drivers/media/video/saa7134/saa7134.h
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -158,6 +158,7 @@
  #define SAA7134_BOARD_AVERMEDIA_DVD_EZMAKER 33
  #define SAA7134_BOARD_NOVAC_PRIMETV7133 34
  #define SAA7134_BOARD_AVERMEDIA_STUDIO_305 35
+#define SAA7134_BOARD_AVERMEDIA_STUDIO_505 155
  #define SAA7134_BOARD_UPMOST_PURPLE_TV 36
  #define SAA7134_BOARD_ITEMS_MTV005     37
  #define SAA7134_BOARD_CINERGY200       38


diff --git a/drivers/media/video/saa7134/saa7134-video.c  
b/drivers/media/video/saa7134/saa7134-video.c
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -43,7 +43,7 @@
  static unsigned int noninterlaced; /* 0 */
  static unsigned int gbufsize      = 720*576*4;
  static unsigned int gbufsize_max  = 720*576*4;
-static char secam[] = "--";
+static char secam[] = "dk";
  module_param(video_debug, int, 0644);
  MODULE_PARM_DESC(video_debug,"enable debug messages [video]");
  module_param(gbuffers, int, 0444);

diff --git a/Documentation/video4linux/CARDLIST.saa7134  
b/Documentation/video4linux/CARDLIST.saa7134
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -153,3 +153,4 @@
  152 -> Asus Tiger Rev:1.00                      [1043:4857]
  153 -> Kworld Plus TV Analog Lite PCI           [17de:7128]
  154 -> Avermedia AVerTV GO 007 FM Plus          [1461:f31d]
+155 -> AverMedia AverTV Studio 505              [1461:a115]
