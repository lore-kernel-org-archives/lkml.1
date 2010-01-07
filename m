Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492Ab0AGSlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0AGSlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442Ab0AGSky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:40:54 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:56843 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0AGSkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:40:52 -0500
X-Greylist: delayed 682 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 13:40:50 EST
Date: Thu, 7 Jan 2010 19:29:27 +0100
From: Bastian Blank <waldi@debian.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
Subject: [PATCH 1/7] Input: wacom - Move device ids to the initialisation
Message-ID: <20100107182926.GA12843@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ping Cheng <pingc@wacom.com>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100107182553.GA11236@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the device ids and features structs near the driver initialisation
where they are used.

Signed-of-by: Bastian Blank <waldi@debian.org>
---
 drivers/input/tablet/wacom.h     |    2 -
 drivers/input/tablet/wacom_sys.c |  147 +++++++++++++++++++++++++++++++++++++-
 drivers/input/tablet/wacom_wac.c |  150 --------------------------------------
 3 files changed, 146 insertions(+), 153 deletions(-)

diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index 16310f3..c339560 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -142,7 +142,5 @@ extern void input_dev_mo(struct input_dev *input_dev, struct wacom_wac *wacom_wa
 extern void input_dev_bee(struct input_dev *input_dev, struct wacom_wac *wacom_wac);
 extern __u16 wacom_le16_to_cpu(unsigned char *data);
 extern __u16 wacom_be16_to_cpu(unsigned char *data);
-extern struct wacom_features *get_wacom_feature(const struct usb_device_id *id);
-extern const struct usb_device_id *get_device_table(void);
 
 #endif
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 072f33b..ab42c25 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -524,6 +524,8 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 	return error;
 }
 
+static struct wacom_features *get_wacom_feature(const struct usb_device_id *id);
+
 static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
@@ -661,8 +663,151 @@ static int wacom_reset_resume(struct usb_interface *intf)
 	return wacom_resume(intf);
 }
 
+static struct wacom_features wacom_features[] = {
+	{ "Wacom Penpartner",     WACOM_PKGLEN_PENPRTN,    5040,  3780,  255,  0, PENPARTNER },
+	{ "Wacom Graphire",       WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE },
+	{ "Wacom Graphire2 4x5",  WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE },
+	{ "Wacom Graphire2 5x7",  WACOM_PKGLEN_GRAPHIRE,  13918, 10206,  511, 63, GRAPHIRE },
+	{ "Wacom Graphire3",      WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, GRAPHIRE },
+	{ "Wacom Graphire3 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE },
+	{ "Wacom Graphire4 4x5",  WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, WACOM_G4 },
+	{ "Wacom Graphire4 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, WACOM_G4 },
+	{ "Wacom BambooFun 4x5",  WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO },
+	{ "Wacom BambooFun 6x8",  WACOM_PKGLEN_BBFUN,     21648, 13530,  511, 63, WACOM_MO },
+	{ "Wacom Bamboo1 Medium", WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE },
+	{ "Wacom Volito",         WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE },
+	{ "Wacom PenStation2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  255, 63, GRAPHIRE },
+	{ "Wacom Volito2 4x5",    WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE },
+	{ "Wacom Volito2 2x3",    WACOM_PKGLEN_GRAPHIRE,   3248,  2320,  511, 63, GRAPHIRE },
+	{ "Wacom PenPartner2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  511, 63, GRAPHIRE },
+	{ "Wacom Bamboo",         WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO },
+	{ "Wacom Bamboo1",        WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE },
+	{ "Wacom Intuos 4x5",     WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS },
+	{ "Wacom Intuos 6x8",     WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
+	{ "Wacom Intuos 9x12",    WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS },
+	{ "Wacom Intuos 12x12",   WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS },
+	{ "Wacom Intuos 12x18",   WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS },
+	{ "Wacom PL400",          WACOM_PKGLEN_GRAPHIRE,   5408,  4056,  255,  0, PL },
+	{ "Wacom PL500",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  255,  0, PL },
+	{ "Wacom PL600",          WACOM_PKGLEN_GRAPHIRE,   6126,  4604,  255,  0, PL },
+	{ "Wacom PL600SX",        WACOM_PKGLEN_GRAPHIRE,   6260,  5016,  255,  0, PL },
+	{ "Wacom PL550",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  511,  0, PL },
+	{ "Wacom PL800",          WACOM_PKGLEN_GRAPHIRE,   7220,  5780,  511,  0, PL },
+	{ "Wacom PL700",          WACOM_PKGLEN_GRAPHIRE,   6758,  5406,  511,  0, PL },
+	{ "Wacom PL510",          WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL },
+	{ "Wacom DTU710",         WACOM_PKGLEN_GRAPHIRE,  34080, 27660,  511,  0, PL },
+	{ "Wacom DTF521",         WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL },
+	{ "Wacom DTF720",         WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL },
+	{ "Wacom DTF720a",        WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL },
+	{ "Wacom Cintiq Partner", WACOM_PKGLEN_GRAPHIRE,  20480, 15360,  511,  0, PTU },
+	{ "Wacom Intuos2 4x5",    WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS },
+	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
+	{ "Wacom Intuos2 9x12",   WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS },
+	{ "Wacom Intuos2 12x12",  WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS },
+	{ "Wacom Intuos2 12x18",  WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS },
+	{ "Wacom Intuos3 4x5",    WACOM_PKGLEN_INTUOS,    25400, 20320, 1023, 63, INTUOS3S },
+	{ "Wacom Intuos3 6x8",    WACOM_PKGLEN_INTUOS,    40640, 30480, 1023, 63, INTUOS3 },
+	{ "Wacom Intuos3 9x12",   WACOM_PKGLEN_INTUOS,    60960, 45720, 1023, 63, INTUOS3 },
+	{ "Wacom Intuos3 12x12",  WACOM_PKGLEN_INTUOS,    60960, 60960, 1023, 63, INTUOS3L },
+	{ "Wacom Intuos3 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 1023, 63, INTUOS3L },
+	{ "Wacom Intuos3 6x11",   WACOM_PKGLEN_INTUOS,    54204, 31750, 1023, 63, INTUOS3 },
+	{ "Wacom Intuos3 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 1023, 63, INTUOS3S },
+	{ "Wacom Intuos4 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 2047, 63, INTUOS4S },
+	{ "Wacom Intuos4 6x9",    WACOM_PKGLEN_INTUOS,    44704, 27940, 2047, 63, INTUOS4 },
+	{ "Wacom Intuos4 8x13",   WACOM_PKGLEN_INTUOS,    65024, 40640, 2047, 63, INTUOS4L },
+	{ "Wacom Intuos4 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 2047, 63, INTUOS4L },
+	{ "Wacom Cintiq 21UX",    WACOM_PKGLEN_INTUOS,    87200, 65600, 1023, 63, CINTIQ },
+	{ "Wacom Cintiq 20WSX",   WACOM_PKGLEN_INTUOS,    86680, 54180, 1023, 63, WACOM_BEE },
+	{ "Wacom Cintiq 12WX",    WACOM_PKGLEN_INTUOS,    53020, 33440, 1023, 63, WACOM_BEE },
+	{ "Wacom DTU1931",        WACOM_PKGLEN_GRAPHIRE,  37832, 30305,  511,  0, PL },
+	{ "Wacom ISDv4 90",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
+	{ "Wacom ISDv4 93",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
+	{ "Wacom ISDv4 9A",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
+	{ "Wacom ISDv4 9F",       WACOM_PKGLEN_PENABLED,  26202, 16325,  255,  0, TABLETPC },
+	{ "Wacom ISDv4 E2",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG },
+	{ "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG },
+	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
+	{ }
+};
+
+static struct usb_device_id wacom_ids[] = {
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x00) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x10) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x11) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x12) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x13) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x14) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x15) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x16) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x17) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x18) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x19) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x60) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x61) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x62) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x63) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x64) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x65) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x69) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x20) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x21) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x22) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x23) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x24) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x30) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x31) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x32) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x33) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x34) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x35) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x37) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x38) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x39) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC4) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC0) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC2) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x03) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x41) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x42) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x43) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x44) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x45) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB0) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB1) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB2) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB3) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB4) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB5) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB7) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB8) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB9) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xBA) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xBB) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x3F) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC5) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC6) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC7) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x90) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x93) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x9A) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x9F) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xE2) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xE3) },
+	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x47) },
+	{ }
+};
+
+static struct wacom_features * get_wacom_feature(const struct usb_device_id *id)
+{
+        int index = id - wacom_ids;
+        struct wacom_features *wf = &wacom_features[index];
+
+        return wf;
+}
+
 static struct usb_driver wacom_driver = {
 	.name =		"wacom",
+	.id_table =	wacom_ids,
 	.probe =	wacom_probe,
 	.disconnect =	wacom_disconnect,
 	.suspend =	wacom_suspend,
@@ -674,7 +819,6 @@ static struct usb_driver wacom_driver = {
 static int __init wacom_init(void)
 {
 	int result;
-	wacom_driver.id_table = get_device_table();
 	result = usb_register(&wacom_driver);
 	if (result == 0)
 		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
@@ -689,3 +833,4 @@ static void __exit wacom_exit(void)
 
 module_init(wacom_init);
 module_exit(wacom_exit);
+MODULE_DEVICE_TABLE(usb, wacom_ids);
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 1056f14..410802c 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -903,153 +903,3 @@ void wacom_init_input_dev(struct input_dev *input_dev, struct wacom_wac *wacom_w
 	return;
 }
 
-static struct wacom_features wacom_features[] = {
-	{ "Wacom Penpartner",     WACOM_PKGLEN_PENPRTN,    5040,  3780,  255,  0, PENPARTNER },
-	{ "Wacom Graphire",       WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire2 4x5",  WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire2 5x7",  WACOM_PKGLEN_GRAPHIRE,  13918, 10206,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire3",      WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire3 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE },
-	{ "Wacom Graphire4 4x5",  WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, WACOM_G4 },
-	{ "Wacom Graphire4 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, WACOM_G4 },
-	{ "Wacom BambooFun 4x5",  WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO },
-	{ "Wacom BambooFun 6x8",  WACOM_PKGLEN_BBFUN,     21648, 13530,  511, 63, WACOM_MO },
-	{ "Wacom Bamboo1 Medium", WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE },
-	{ "Wacom Volito",         WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE },
-	{ "Wacom PenStation2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  255, 63, GRAPHIRE },
-	{ "Wacom Volito2 4x5",    WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE },
-	{ "Wacom Volito2 2x3",    WACOM_PKGLEN_GRAPHIRE,   3248,  2320,  511, 63, GRAPHIRE },
-	{ "Wacom PenPartner2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  511, 63, GRAPHIRE },
-	{ "Wacom Bamboo",         WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO },
-	{ "Wacom Bamboo1",        WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE },
-	{ "Wacom Intuos 4x5",     WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS },
-	{ "Wacom Intuos 6x8",     WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
-	{ "Wacom Intuos 9x12",    WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS },
-	{ "Wacom Intuos 12x12",   WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS },
-	{ "Wacom Intuos 12x18",   WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS },
-	{ "Wacom PL400",          WACOM_PKGLEN_GRAPHIRE,   5408,  4056,  255,  0, PL },
-	{ "Wacom PL500",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  255,  0, PL },
-	{ "Wacom PL600",          WACOM_PKGLEN_GRAPHIRE,   6126,  4604,  255,  0, PL },
-	{ "Wacom PL600SX",        WACOM_PKGLEN_GRAPHIRE,   6260,  5016,  255,  0, PL },
-	{ "Wacom PL550",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  511,  0, PL },
-	{ "Wacom PL800",          WACOM_PKGLEN_GRAPHIRE,   7220,  5780,  511,  0, PL },
-	{ "Wacom PL700",          WACOM_PKGLEN_GRAPHIRE,   6758,  5406,  511,  0, PL },
-	{ "Wacom PL510",          WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL },
-	{ "Wacom DTU710",         WACOM_PKGLEN_GRAPHIRE,  34080, 27660,  511,  0, PL },
-	{ "Wacom DTF521",         WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL },
-	{ "Wacom DTF720",         WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL },
-	{ "Wacom DTF720a",        WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL },
-	{ "Wacom Cintiq Partner", WACOM_PKGLEN_GRAPHIRE,  20480, 15360,  511,  0, PTU },
-	{ "Wacom Intuos2 4x5",    WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 9x12",   WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 12x12",  WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS },
-	{ "Wacom Intuos2 12x18",  WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS },
-	{ "Wacom Intuos3 4x5",    WACOM_PKGLEN_INTUOS,    25400, 20320, 1023, 63, INTUOS3S },
-	{ "Wacom Intuos3 6x8",    WACOM_PKGLEN_INTUOS,    40640, 30480, 1023, 63, INTUOS3 },
-	{ "Wacom Intuos3 9x12",   WACOM_PKGLEN_INTUOS,    60960, 45720, 1023, 63, INTUOS3 },
-	{ "Wacom Intuos3 12x12",  WACOM_PKGLEN_INTUOS,    60960, 60960, 1023, 63, INTUOS3L },
-	{ "Wacom Intuos3 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 1023, 63, INTUOS3L },
-	{ "Wacom Intuos3 6x11",   WACOM_PKGLEN_INTUOS,    54204, 31750, 1023, 63, INTUOS3 },
-	{ "Wacom Intuos3 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 1023, 63, INTUOS3S },
-	{ "Wacom Intuos4 4x6",    WACOM_PKGLEN_INTUOS,    31496, 19685, 2047, 63, INTUOS4S },
-	{ "Wacom Intuos4 6x9",    WACOM_PKGLEN_INTUOS,    44704, 27940, 2047, 63, INTUOS4 },
-	{ "Wacom Intuos4 8x13",   WACOM_PKGLEN_INTUOS,    65024, 40640, 2047, 63, INTUOS4L },
-	{ "Wacom Intuos4 12x19",  WACOM_PKGLEN_INTUOS,    97536, 60960, 2047, 63, INTUOS4L },
-	{ "Wacom Cintiq 21UX",    WACOM_PKGLEN_INTUOS,    87200, 65600, 1023, 63, CINTIQ },
-	{ "Wacom Cintiq 20WSX",   WACOM_PKGLEN_INTUOS,    86680, 54180, 1023, 63, WACOM_BEE },
-	{ "Wacom Cintiq 12WX",    WACOM_PKGLEN_INTUOS,    53020, 33440, 1023, 63, WACOM_BEE },
-	{ "Wacom DTU1931",        WACOM_PKGLEN_GRAPHIRE,  37832, 30305,  511,  0, PL },
-	{ "Wacom ISDv4 90",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 93",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 9A",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 9F",       WACOM_PKGLEN_PENABLED,  26202, 16325,  255,  0, TABLETPC },
-	{ "Wacom ISDv4 E2",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG },
-	{ "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG },
-	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS },
-	{ }
-};
-
-static struct usb_device_id wacom_ids[] = {
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x00) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x10) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x11) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x12) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x13) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x14) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x15) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x16) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x17) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x18) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x19) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x60) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x61) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x62) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x63) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x64) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x65) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x69) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x20) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x21) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x22) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x23) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x24) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x30) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x31) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x32) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x33) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x34) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x35) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x37) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x38) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x39) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC4) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC0) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC2) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x03) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x41) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x42) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x43) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x44) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x45) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB0) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB1) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB2) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB3) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB4) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB5) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB7) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB8) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xB9) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xBA) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xBB) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x3F) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC5) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC6) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xC7) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x90) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x93) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x9A) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x9F) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xE2) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0xE3) },
-	{ USB_DEVICE(USB_VENDOR_ID_WACOM, 0x47) },
-	{ }
-};
-
-const struct usb_device_id *get_device_table(void)
-{
-        const struct usb_device_id *id_table = wacom_ids;
-
-        return id_table;
-}
-
-struct wacom_features * get_wacom_feature(const struct usb_device_id *id)
-{
-        int index = id - wacom_ids;
-        struct wacom_features *wf = &wacom_features[index];
-
-        return wf;
-}
-
-MODULE_DEVICE_TABLE(usb, wacom_ids);
-- 
1.6.5.7


-- 
Oh, that sound of male ego.  You travel halfway across the galaxy and
it's still the same song.
		-- Eve McHuron, "Mudd's Women", stardate 1330.1
