Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbYBFVXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbYBFVXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbYBFVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:23:43 -0500
Received: from relay2.netbox.cz ([83.240.0.204]:59695 "EHLO relay.netbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754638AbYBFVXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:23:42 -0500
Date: Thu, 7 Feb 2008 00:22:24 +0100
From: Zbynek Hrabovsky <hrabosh@t-email.cz>
To: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH][RESEND] New type of DTV2000H TV Card
Message-Id: <20080207002224.e26d6bb1.hrabosh@t-email.cz>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__7_Feb_2008_00_22_24_+0100_yf3f3JEE_7iANlHr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__7_Feb_2008_00_22_24_+0100_yf3f3JEE_7iANlHr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

		Hello all,

I bought Leadtek WinFast DTV2000H, but it didn't work. I found, that there are two types of this card. Type I (older), and type J (latest) ... and only type I is supported by the module.

Type J is not autodetected, and if you force card type (card = 51), DVB-T works, but there is no sound in analogue television. I know why (multiplexer, which is switching between the radio, TV, and external sound is driven by GPIO pins ... and setting of this pins is wrong), and I wrote a patch, which makes this card (DTV2000H type J) works. 

With this patch, card is autodetected, I'm having sound in analogue television, I can switch between antenna, and cable signal input, and I can see video from external S-video and composite video input.

So ... I'm sending this patch to you. I think it will be good to add support for this card to the cx88xx module.

Bye,
	Zbynek Hrabovsky, Brno, Czech Republic

PS .. sorry for my English.

--Multipart=_Thu__7_Feb_2008_00_22_24_+0100_yf3f3JEE_7iANlHr
Content-Type: text/x-patch;
 name="DTV2000H_Patch.diff"
Content-Disposition: attachment;
 filename="DTV2000H_Patch.diff"
Content-Transfer-Encoding: 7bit

diff -Naur /usr/src/linux/drivers/media/video/cx88/cx88-cards.c /usr/src/linux/drivers/media/video/cx88-patched/cx88-cards.c
--- /usr/src/linux/drivers/media/video/cx88/cx88-cards.c	2007-10-09 22:31:38.000000000 +0200
+++ /usr/src/linux/drivers/media/video/cx88-patched/cx88-cards.c	2008-01-10 19:24:06.000000000 +0100
@@ -1205,7 +1205,7 @@
 	},
 	[CX88_BOARD_WINFAST_DTV2000H] = {
 		/* video inputs and radio still in testing */
-		.name           = "WinFast DTV2000 H",
+		.name           = "WinFast DTV2000 H ver. I (old)",
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
@@ -1220,6 +1220,47 @@
 			.gpio3  = 0x02000000,
 		}},
 		.mpeg           = CX88_MPEG_DVB,
+
+	},
+    	[CX88_BOARD_WINFAST_DTV2000H_2] = {
+		/* this is just a try */
+		.name           = "WinFast DTV2000 H ver. J (new)",
+		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.input          = {{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00017300,
+			.gpio1  = 0x00008207,
+			.gpio2	= 0x00000000,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00018300,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		}},
+		.mpeg           = CX88_MPEG_DVB,
+
 	},
 	[CX88_BOARD_GENIATECH_DVBS] = {
 		.name          = "Geniatech DVB-S",
@@ -1601,6 +1642,10 @@
 		.subdevice = 0x665e,
 		.card      = CX88_BOARD_WINFAST_DTV2000H,
 	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6f2b,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_2,
+	},{
 		.subvendor = 0x18ac,
 		.subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
diff -Naur /usr/src/linux/drivers/media/video/cx88/cx88-core.c /usr/src/linux/drivers/media/video/cx88-patched/cx88-core.c
--- /usr/src/linux/drivers/media/video/cx88/cx88-core.c	2007-10-09 22:31:38.000000000 +0200
+++ /usr/src/linux/drivers/media/video/cx88-patched/cx88-core.c	2008-01-07 22:55:16.000000000 +0100
@@ -631,6 +631,8 @@
 	msleep(10);
 	cx_write(MO_SRST_IO, 1);
 
+	printk("RESEEEEEEEEEEEEEEEEET !");
+
 	return 0;
 }
 
diff -Naur /usr/src/linux/drivers/media/video/cx88/cx88-dvb.c /usr/src/linux/drivers/media/video/cx88-patched/cx88-dvb.c
--- /usr/src/linux/drivers/media/video/cx88/cx88-dvb.c	2007-10-09 22:31:38.000000000 +0200
+++ /usr/src/linux/drivers/media/video/cx88-patched/cx88-dvb.c	2008-01-06 22:08:53.000000000 +0100
@@ -403,6 +403,7 @@
 		}
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_2:
 	case CX88_BOARD_HAUPPAUGE_HVR1100:
 	case CX88_BOARD_HAUPPAUGE_HVR1100LP:
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
diff -Naur /usr/src/linux/drivers/media/video/cx88/cx88-input.c /usr/src/linux/drivers/media/video/cx88-patched/cx88-input.c
--- /usr/src/linux/drivers/media/video/cx88/cx88-input.c	2007-10-09 22:31:38.000000000 +0200
+++ /usr/src/linux/drivers/media/video/cx88-patched/cx88-input.c	2008-01-06 22:10:13.000000000 +0100
@@ -230,6 +230,7 @@
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_2:
 		ir_codes = ir_codes_winfast;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
diff -Naur /usr/src/linux/drivers/media/video/cx88/cx88-mpeg.c /usr/src/linux/drivers/media/video/cx88-patched/cx88-mpeg.c
--- /usr/src/linux/drivers/media/video/cx88/cx88-mpeg.c	2007-10-09 22:31:38.000000000 +0200
+++ /usr/src/linux/drivers/media/video/cx88-patched/cx88-mpeg.c	2008-01-07 23:28:29.000000000 +0100
@@ -93,6 +93,7 @@
 	/* FIXME: this needs a review.
 	 * also: move to cx88-blackbird + cx88-dvb source files? */
 
+	if ((core->board) == CX88_BOARD_WINFAST_DTV2000H_2) cx_write(MO_GP0_IO, 0x00017300);/*switch signal input to antena*/
 	dprintk( 1, "core->active_type_id = 0x%08x\n", core->active_type_id);
 
 	if ( (core->active_type_id == CX88_MPEG_DVB) &&
diff -Naur /usr/src/linux/drivers/media/video/cx88/cx88.h /usr/src/linux/drivers/media/video/cx88-patched/cx88.h
--- /usr/src/linux/drivers/media/video/cx88/cx88.h	2007-10-09 22:31:38.000000000 +0200
+++ /usr/src/linux/drivers/media/video/cx88-patched/cx88.h	2008-01-03 23:00:39.000000000 +0100
@@ -210,6 +210,8 @@
 #define CX88_BOARD_TE_DTV_250_OEM_SWANN    55
 #define CX88_BOARD_HAUPPAUGE_HVR1300       56
 #define CX88_BOARD_ADSTECH_PTV_390         57
+#define CX88_BOARD_WINFAST_DTV2000H_2      58
+
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

--Multipart=_Thu__7_Feb_2008_00_22_24_+0100_yf3f3JEE_7iANlHr--
