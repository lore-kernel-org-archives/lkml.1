Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631Ab0AMXgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0AMXgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577Ab0AMXgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:36:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35820 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756572Ab0AMXgP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:36:15 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jan 2010 23:36:09 +0000
Message-ID: <1263425769.3852.119.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 03/11] staging: declare MODULE_FIRMWARE in various drivers
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/jr3_pci.c    |    2 ++
 drivers/staging/go7007/go7007-driver.c      |    2 ++
 drivers/staging/go7007/go7007-usb.c         |    2 ++
 drivers/staging/go7007/saa7134-go7007.c     |    1 +
 drivers/staging/rtl8192e/r819xE_firmware.c  |    4 ++++
 drivers/staging/rtl8192su/r8192S_firmware.c |    1 +
 drivers/staging/slicoss/slicoss.c           |    6 ++++++
 drivers/staging/wlan-ng/prism2fw.c          |    1 +
 8 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index bd39784..fe5b495 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -954,6 +954,8 @@ out:
 	return result;
 }
 
+MODULE_FIRMWARE("comedi/jr3pci.idm");
+
 static int jr3_pci_detach(struct comedi_device *dev)
 {
 	int i;
diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index fb1345f..d42ba16 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -128,6 +128,8 @@ static int go7007_load_encoder(struct go7007 *go)
 	return rv;
 }
 
+MODULE_FIRMWARE("go7007fw.bin");
+
 /*
  * Boot the encoder and register the I2C adapter if requested.  Do the
  * minimum initialization necessary, since the board-specific code may
diff --git a/drivers/staging/go7007/go7007-usb.c b/drivers/staging/go7007/go7007-usb.c
index 1e89dc0..c57f8ef 100644
--- a/drivers/staging/go7007/go7007-usb.c
+++ b/drivers/staging/go7007/go7007-usb.c
@@ -444,6 +444,8 @@ static struct go7007_usb_board board_sensoray_2250 = {
 	},
 };
 
+MODULE_FIRMWARE("go7007tv.bin");
+
 static struct usb_device_id go7007_usb_id_table[] = {
 	{
 		.match_flags	= USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION |
diff --git a/drivers/staging/go7007/saa7134-go7007.c b/drivers/staging/go7007/saa7134-go7007.c
index 665bbf5..b25d7d2 100644
--- a/drivers/staging/go7007/saa7134-go7007.c
+++ b/drivers/staging/go7007/saa7134-go7007.c
@@ -84,6 +84,7 @@ static struct go7007_board_info board_voyager = {
 		},
 	},
 };
+MODULE_FIRMWARE("go7007tv.bin");
 
 /********************* Driver for GPIO HPI interface *********************/
 
diff --git a/drivers/staging/rtl8192e/r819xE_firmware.c b/drivers/staging/rtl8192e/r819xE_firmware.c
index e05ba17..793a175 100644
--- a/drivers/staging/rtl8192e/r819xE_firmware.c
+++ b/drivers/staging/rtl8192e/r819xE_firmware.c
@@ -365,3 +365,7 @@ download_firmware_fail:
 	rt_status = false;
 	return rt_status;
 }
+
+MODULE_FIRMWARE("RTL8192E/boot.img");
+MODULE_FIRMWARE("RTL8192E/main.img");
+MODULE_FIRMWARE("RTL8192E/data.img");
diff --git a/drivers/staging/rtl8192su/r8192S_firmware.c b/drivers/staging/rtl8192su/r8192S_firmware.c
index 3561adf..ff65bd1 100644
--- a/drivers/staging/rtl8192su/r8192S_firmware.c
+++ b/drivers/staging/rtl8192su/r8192S_firmware.c
@@ -538,3 +538,4 @@ bool FirmwareDownload92S(struct net_device *dev)
 	return rtStatus;
 }
 
+MODULE_FIRMWARE("RTL8192SU/rtl8192sfw.bin");
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 09a9d75..87d98e3 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1866,6 +1866,9 @@ static int slic_card_download_gbrcv(struct adapter *adapter)
 	return 0;
 }
 
+MODULE_FIRMWARE("slicoss/oasisrcvucode.sys");
+MODULE_FIRMWARE("slicoss/gbrcvucode.sys");
+
 static int slic_card_download(struct adapter *adapter)
 {
 	const struct firmware *fw;
@@ -1977,6 +1980,9 @@ static int slic_card_download(struct adapter *adapter)
 	return STATUS_SUCCESS;
 }
 
+MODULE_FIRMWARE("slicoss/oasisdownload.sys");
+MODULE_FIRMWARE("slicoss/gbdownload.sys");
+
 static void slic_adapter_set_hwaddr(struct adapter *adapter)
 {
 	struct sliccard *card = adapter->card;
diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index aaa70ed..5e95c48 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -53,6 +53,7 @@
 /* Local Constants */
 
 #define PRISM2_USB_FWFILE	"prism2_ru.fw"
+MODULE_FIRMWARE(PRISM2_USB_FWFILE);
 
 #define S3DATA_MAX		5000
 #define S3PLUG_MAX		200
-- 
1.6.5.7



