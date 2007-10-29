Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbXJ2SXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbXJ2SXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760107AbXJ2SXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:23:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27991 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760097AbXJ2SXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:23:42 -0400
Date: Mon, 29 Oct 2007 11:19:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] media drivers use input functions, should depend on INPUT
Message-Id: <20071029111955.2e129665.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

All of these drivers select VIDEO_IR, which uses the input subsystem,
so they should also depend on INPUT.

Problem examples:

drivers/built-in.o: In function `ir_input_key_event':
ir-functions.c:(.text+0x10849a): undefined reference to `input_event'
ir-functions.c:(.text+0x1084ac): undefined reference to `input_event'
drivers/built-in.o: In function `saa7134_set_i2c_ir':
(.text+0x11cc0a): undefined reference to `get_key_pinnacle_color'
drivers/built-in.o: In function `saa7134_set_i2c_ir':
(.text+0x11cc4f): undefined reference to `get_key_pinnacle_grey'
drivers/built-in.o: In function `saa7134_input_fini':
(.text+0x11cd8b): undefined reference to `input_unregister_device'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11d1fa): undefined reference to `input_allocate_device'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11d317): undefined reference to `input_register_device'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11d6ca): undefined reference to `input_free_device'

drivers/built-in.o: In function `saa7134_set_i2c_ir':
(.text+0x11c3f3): undefined reference to `ir_codes_hauppauge_new'
drivers/built-in.o: In function `saa7134_set_i2c_ir':
(.text+0x11c450): undefined reference to `ir_codes_pinnacle_color'
drivers/built-in.o: In function `saa7134_set_i2c_ir':
(.text+0x11c480): undefined reference to `ir_codes_purpletv'
drivers/built-in.o: In function `saa7134_set_i2c_ir':
(.text+0x11c495): undefined reference to `ir_codes_pinnacle_grey'
drivers/built-in.o: In function `saa7134_ir_start':
(.text+0x11c622): undefined reference to `ir_rc5_timer_end'
drivers/built-in.o: In function `saa7134_ir_start':
(.text+0x11c637): undefined reference to `ir_rc5_timer_keyup'
drivers/built-in.o: In function `build_key':
saa7134-input.c:(.text+0x11c769): undefined reference to `ir_extract_bits'
saa7134-input.c:(.text+0x11c7ad): undefined reference to `ir_input_keydown'
saa7134-input.c:(.text+0x11c7f0): undefined reference to `ir_input_keydown'
saa7134-input.c:(.text+0x11c7f9): undefined reference to `ir_input_nokey'
saa7134-input.c:(.text+0x11c806): undefined reference to `ir_input_nokey'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11ca07): undefined reference to `ir_codes_encore_enltv'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11caf6): undefined reference to `ir_input_init'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11cbf2): undefined reference to `ir_codes_avermedia'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11cc24): undefined reference to `ir_codes_pctv_sedna'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11cc53): undefined reference to `ir_codes_flydvb'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11cc85): undefined reference to `ir_codes_videomate_tv_pvr'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11ccb7): undefined reference to `ir_codes_pixelview'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11cce9): undefined reference to `ir_codes_eztv'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11cd1b): undefined reference to `ir_codes_manli'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11cda8): undefined reference to `ir_codes_cinergy'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11cdd7): undefined reference to `ir_codes_flyvideo'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11ce06): undefined reference to `ir_codes_asus_pc39'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11ce7d): undefined reference to `ir_codes_gotview7135'
drivers/built-in.o: In function `saa7134_input_init1':
(.text+0x11cee1): undefined reference to `ir_codes_proteus_2309'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/dvb/ttpci/Kconfig     |    2 +-
 drivers/media/video/cx23885/Kconfig |    2 +-
 drivers/media/video/cx88/Kconfig    |    2 +-
 drivers/media/video/em28xx/Kconfig  |    2 +-
 drivers/media/video/saa7134/Kconfig |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- linux-2624-rc1g4-v1.orig/drivers/media/video/cx23885/Kconfig
+++ linux-2624-rc1g4-v1/drivers/media/video/cx23885/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX23885
 	tristate "Conexant cx23885 (2388x successor) support"
-	depends on DVB_CORE && VIDEO_DEV && PCI && I2C
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
 	select I2C_ALGOBIT
 	select FW_LOADER
 	select VIDEO_BTCX
--- linux-2624-rc1g4-v1.orig/drivers/media/video/cx88/Kconfig
+++ linux-2624-rc1g4-v1/drivers/media/video/cx88/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX88
 	tristate "Conexant 2388x (bt878 successor) support"
-	depends on VIDEO_DEV && PCI && I2C
+	depends on VIDEO_DEV && PCI && I2C && INPUT
 	select I2C_ALGOBIT
 	select FW_LOADER
 	select VIDEO_BTCX
--- linux-2624-rc1g4-v1.orig/drivers/media/video/em28xx/Kconfig
+++ linux-2624-rc1g4-v1/drivers/media/video/em28xx/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_EM28XX
 	tristate "Empia EM2800/2820/2840 USB video capture support"
-	depends on VIDEO_V4L1 && I2C
+	depends on VIDEO_V4L1 && I2C && INPUT
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_IR
--- linux-2624-rc1g4-v1.orig/drivers/media/video/saa7134/Kconfig
+++ linux-2624-rc1g4-v1/drivers/media/video/saa7134/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_SAA7134
 	tristate "Philips SAA7134 support"
-	depends on VIDEO_DEV && PCI && I2C
+	depends on VIDEO_DEV && PCI && I2C && INPUT
 	select VIDEOBUF_DMA_SG
 	select VIDEO_IR
 	select VIDEO_TUNER
--- linux-2624-rc1g4-v1.orig/drivers/media/dvb/ttpci/Kconfig
+++ linux-2624-rc1g4-v1/drivers/media/dvb/ttpci/Kconfig
@@ -84,7 +84,7 @@ config DVB_BUDGET
 
 config DVB_BUDGET_CI
 	tristate "Budget cards with onboard CI connector"
-	depends on DVB_CORE && PCI && I2C && VIDEO_V4L1
+	depends on DVB_CORE && PCI && I2C && VIDEO_V4L1 && INPUT
 	select VIDEO_SAA7146
 	select DVB_STV0297 if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
