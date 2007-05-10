Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbXEJDGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbXEJDGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 23:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbXEJDGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 23:06:31 -0400
Received: from mail.sjtu.org ([202.120.5.34]:7562 "ehlo appsrv1.sjtu.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753903AbXEJDGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 23:06:30 -0400
Subject: [PATCH 1/3] v4l: saa7134: add support for 10moons TM300 card
From: Tony Wan <wankai@sjtu.org>
To: mchehab@infradead.org, michael@mihu.de
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 10 May 2007 11:02:52 +0800
Message-Id: <1178766173.29993.40.camel@wankai.sjtu.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Support the 10moons TM300 TV card (so called TV Master 3), which is a
10moons saa7130 based board.
Here not include features for the IR-remote.

It has been tested using TVTIME. The card was auto-detected and all the
input sources worked correct with sound.

Signed-off-by: Tony Wan <wankai@sjtu.org>
---
 drivers/media/video/saa7134/saa7134-cards.c |   38
+++++++++++++++++++++++++++
 drivers/media/video/saa7134/saa7134.h       |    1 +
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-cards.c
b/drivers/media/video/saa7134/saa7134-cards.c
index 50f15ad..44f2077 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -3502,6 +3502,38 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = TV,
 		},
 	},
+	[SAA7134_BOARD_10MOONSTVMASTER3] = {
+		/* Tony Wan <aloha_cn@hotmail.com> */
+		.name           = "10MOONS TM300 TV Card",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.gpiomask       = 0x7000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = LINE2,
+			.gpio = 0x0000,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+			.gpio = 0x2000,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+			.gpio = 0x2000,
+		}},
+		.mute = {
+			.name = name_mute,
+			.amux = LINE2,
+			.gpio = 0x3000,
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -4219,6 +4251,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0x2003, /* OEM cardbus */
 		.driver_data  = SAA7134_BOARD_SABRENT_TV_PCB05,
 	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = PCI_VENDOR_ID_PHILIPS,
+		.subdevice    = 0x2304,
+		.driver_data  = SAA7134_BOARD_10MOONSTVMASTER3,
+	},{
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff --git a/drivers/media/video/saa7134/saa7134.h
b/drivers/media/video/saa7134/saa7134.h
index 15623b2..6389c0e 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -238,6 +238,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_ECS_TVP3XP_4CB6  113
 #define SAA7134_BOARD_KWORLD_DVBT_210 114
 #define SAA7134_BOARD_SABRENT_TV_PCB05     115
+#define SAA7134_BOARD_10MOONSTVMASTER3     116
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8


