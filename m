Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbZCWQIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbZCWQIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZCWQIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:08:11 -0400
Received: from epiphany.epiphan.com ([217.160.251.166]:57004 "EHLO
	epiphany.epiphan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbZCWQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:08:09 -0400
Subject: Re: [PATCH] V4L: em28xx: add support for Digitus/Plextor PX-AV200U
	 grabbers
From: Mikhail Jiline <misha@epiphan.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
In-Reply-To: <412bdbff0903230747i1ebc4487x2636369e6b20ce8f@mail.gmail.com>
References: <1237575285.26159.2.camel@T60p>
	 <412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
	 <1237578912.26159.13.camel@T60p>
	 <412bdbff0903201302ib6758a8ue76a8dd235cfa4cb@mail.gmail.com>
	 <1237579738.26159.16.camel@T60p>
	 <412bdbff0903201314r5105d373ofe6614ee08431d4b@mail.gmail.com>
	 <1237816050.3833.20.camel@T60p>
	 <412bdbff0903230747i1ebc4487x2636369e6b20ce8f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 12:08:04 -0400
Message-Id: <1237824485.3833.26.camel@T60p>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Did you verify that both video inputs were working as expected?  Also,
> did you confirm the audio support works?  

Yes, audio, composite and s-video are functional.


From: Misha Zhilin <misha@epiphan.com>

Adds support for Digitus/Plextor PX-AV200U grabbers
Signed-off-by: Misha Zhilin <misha@epiphan.com>
---

diff -urN linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx-cards.c linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx-cards.c
--- linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx-cards.c	2008-10-09 18:13:53.000000000 -0400
+++ linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx-cards.c	2009-03-23 12:05:22.000000000 -0400
@@ -1087,6 +1087,21 @@
 			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
 	},
+	[EM2820_BOARD_PLEXTOR_PX_AV200U] = {
+		.name         = "Plextor PX-AV200U",
+		.vchannels    = 2,
+		.tuner_type   = TUNER_ABSENT,
+		.decoder      = EM28XX_SAA7113,
+		.input          = { {
+			.type     = EM28XX_VMUX_COMPOSITE1,
+			.vmux     = SAA7115_COMPOSITE0,
+			.amux     = EM28XX_AMUX_AC97_LINE_IN,
+		}, {
+			.type     = EM28XX_VMUX_SVIDEO,
+			.vmux     = SAA7115_SVIDEO3,
+			.amux     = EM28XX_AMUX_AC97_LINE_IN,
+		} },
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -1269,6 +1284,7 @@
 	{0xb06a32c3, EM2800_BOARD_TERRATEC_CINERGY_200, TUNER_LG_PAL_NEW_TAPC},
 	{0xf51200e3, EM2800_BOARD_VGEAR_POCKETTV, TUNER_LG_PAL_NEW_TAPC},
 	{0x1ba50080, EM2860_BOARD_POINTNIX_INTRAORAL_CAMERA, TUNER_ABSENT},
+	{0x6ba50080, EM2820_BOARD_PLEXTOR_PX_AV200U, TUNER_ABSENT},
 };
 
 int em28xx_tuner_callback(void *ptr, int command, int arg)
diff -urN linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx.h linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx.h
--- linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx.h	2008-10-09 18:13:53.000000000 -0400
+++ linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx.h	2009-03-23 11:11:40.000000000 -0400
@@ -97,6 +97,7 @@
 #define EM2882_BOARD_PINNACLE_HYBRID_PRO	  56
 #define EM2883_BOARD_KWORLD_HYBRID_A316		  57
 #define EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU	  58
+#define EM2820_BOARD_PLEXTOR_PX_AV200U            59
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
diff -urN linux-2.6.27.x86_64.orig/Documentation/video4linux/CARDLIST.em28xx linux-2.6.27.x86_64.new/Documentation/video4linux/CARDLIST.em28xx
--- linux-2.6.27.x86_64.orig/Documentation/video4linux/CARDLIST.em28xx	2008-10-09 18:13:53.000000000 -0400
+++ linux-2.6.27.x86_64.new/Documentation/video4linux/CARDLIST.em28xx	2009-03-18 11:15:00.000000000 -0400
@@ -57,3 +57,4 @@
  56 -> Pinnacle Hybrid Pro (2)                  (em2882)        [2304:0226]
  57 -> Kworld PlusTV HD Hybrid 330              (em2883)        [eb1a:a316]
  58 -> Compro VideoMate ForYou/Stereo           (em2820/em2840) [185b:2041]
+ 59 -> Plextor PX-AV200U                        (em2880)

