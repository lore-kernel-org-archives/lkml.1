Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495Ab0AGSl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0AGSl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442Ab0AGSlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:41:24 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:56851 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0AGSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:40:54 -0500
Date: Thu, 7 Jan 2010 19:29:53 +0100
From: Bastian Blank <waldi@debian.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
Subject: [PATCH 5/7] Input: wacom - Convert remaining ids, part two
Message-ID: <20100107182953.GA12985@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ping Cheng <pingc@wacom.com>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100107182553.GA11236@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/input/tablet/wacom_sys.c |  183 ++++++++++++++++++++++----------------
 1 files changed, 107 insertions(+), 76 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 26ed62e..3a7e8db 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -665,49 +665,80 @@ static int wacom_reset_resume(struct usb_interface *intf)
 	return wacom_resume(intf);
 }
 
+static struct wacom_features wacom_features[] = {};
+
 static struct wacom_features wacom_features_0x00 =
 	{ "Wacom Penpartner",     WACOM_PKGLEN_PENPRTN,    5040,  3780,  255,  0, PENPARTNER };
-
-static struct wacom_features wacom_features[] = {
-	{ },
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
-	{ }
-};
-
+static struct wacom_features wacom_features_0x10 =
+	{ "Wacom Graphire",       WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x11 =
+	{ "Wacom Graphire2 4x5",  WACOM_PKGLEN_GRAPHIRE,  10206,  7422,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x12 =
+	{ "Wacom Graphire2 5x7",  WACOM_PKGLEN_GRAPHIRE,  13918, 10206,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x13 =
+	{ "Wacom Graphire3",      WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x14 =
+	{ "Wacom Graphire3 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x15 =
+	{ "Wacom Graphire4 4x5",  WACOM_PKGLEN_GRAPHIRE,  10208,  7424,  511, 63, WACOM_G4 };
+static struct wacom_features wacom_features_0x16 =
+	{ "Wacom Graphire4 6x8",  WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, WACOM_G4 };
+static struct wacom_features wacom_features_0x17 =
+	{ "Wacom BambooFun 4x5",  WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO };
+static struct wacom_features wacom_features_0x18 =
+	{ "Wacom BambooFun 6x8",  WACOM_PKGLEN_BBFUN,     21648, 13530,  511, 63, WACOM_MO };
+static struct wacom_features wacom_features_0x19 =
+	{ "Wacom Bamboo1 Medium", WACOM_PKGLEN_GRAPHIRE,  16704, 12064,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x60 =
+	{ "Wacom Volito",         WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x61 =
+	{ "Wacom PenStation2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  255, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x62 =
+	{ "Wacom Volito2 4x5",    WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x63 =
+	{ "Wacom Volito2 2x3",    WACOM_PKGLEN_GRAPHIRE,   3248,  2320,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x64 =
+	{ "Wacom PenPartner2",    WACOM_PKGLEN_GRAPHIRE,   3250,  2320,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x65 =
+	{ "Wacom Bamboo",         WACOM_PKGLEN_BBFUN,     14760,  9225,  511, 63, WACOM_MO };
+static struct wacom_features wacom_features_0x69 =
+	{ "Wacom Bamboo1",        WACOM_PKGLEN_GRAPHIRE,   5104,  3712,  511, 63, GRAPHIRE };
+static struct wacom_features wacom_features_0x20 =
+	{ "Wacom Intuos 4x5",     WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x21 =
+	{ "Wacom Intuos 6x8",     WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x22 =
+	{ "Wacom Intuos 9x12",    WACOM_PKGLEN_INTUOS,    30480, 24060, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x23 =
+	{ "Wacom Intuos 12x12",   WACOM_PKGLEN_INTUOS,    30480, 31680, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x24 =
+	{ "Wacom Intuos 12x18",   WACOM_PKGLEN_INTUOS,    45720, 31680, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0x30 =
+	{ "Wacom PL400",          WACOM_PKGLEN_GRAPHIRE,   5408,  4056,  255,  0, PL };
+static struct wacom_features wacom_features_0x31 =
+	{ "Wacom PL500",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  255,  0, PL };
+static struct wacom_features wacom_features_0x32 =
+	{ "Wacom PL600",          WACOM_PKGLEN_GRAPHIRE,   6126,  4604,  255,  0, PL };
+static struct wacom_features wacom_features_0x33 =
+	{ "Wacom PL600SX",        WACOM_PKGLEN_GRAPHIRE,   6260,  5016,  255,  0, PL };
+static struct wacom_features wacom_features_0x34 =
+	{ "Wacom PL550",          WACOM_PKGLEN_GRAPHIRE,   6144,  4608,  511,  0, PL };
+static struct wacom_features wacom_features_0x35 =
+	{ "Wacom PL800",          WACOM_PKGLEN_GRAPHIRE,   7220,  5780,  511,  0, PL };
+static struct wacom_features wacom_features_0x37 =
+	{ "Wacom PL700",          WACOM_PKGLEN_GRAPHIRE,   6758,  5406,  511,  0, PL };
+static struct wacom_features wacom_features_0x38 =
+	{ "Wacom PL510",          WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL };
+static struct wacom_features wacom_features_0x39 =
+	{ "Wacom DTU710",         WACOM_PKGLEN_GRAPHIRE,  34080, 27660,  511,  0, PL };
+static struct wacom_features wacom_features_0xC4 =
+	{ "Wacom DTF521",         WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,  0, PL };
+static struct wacom_features wacom_features_0xC0 =
+	{ "Wacom DTF720",         WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL };
+static struct wacom_features wacom_features_0xC2 =
+	{ "Wacom DTF720a",        WACOM_PKGLEN_GRAPHIRE,   6858,  5506,  511,  0, PL };
+static struct wacom_features wacom_features_0x03 =
+	{ "Wacom Cintiq Partner", WACOM_PKGLEN_GRAPHIRE,  20480, 15360,  511,  0, PTU };
 static struct wacom_features wacom_features_0x41 =
 	{ "Wacom Intuos2 4x5",    WACOM_PKGLEN_INTUOS,    12700, 10600, 1023, 31, INTUOS };
 static struct wacom_features wacom_features_0x42 =
@@ -769,41 +800,41 @@ static struct wacom_features wacom_features_0x47 =
 
 static struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x00) },
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
+	{ USB_DEVICE_WACOM(0x10) },
+	{ USB_DEVICE_WACOM(0x11) },
+	{ USB_DEVICE_WACOM(0x12) },
+	{ USB_DEVICE_WACOM(0x13) },
+	{ USB_DEVICE_WACOM(0x14) },
+	{ USB_DEVICE_WACOM(0x15) },
+	{ USB_DEVICE_WACOM(0x16) },
+	{ USB_DEVICE_WACOM(0x17) },
+	{ USB_DEVICE_WACOM(0x18) },
+	{ USB_DEVICE_WACOM(0x19) },
+	{ USB_DEVICE_WACOM(0x60) },
+	{ USB_DEVICE_WACOM(0x61) },
+	{ USB_DEVICE_WACOM(0x62) },
+	{ USB_DEVICE_WACOM(0x63) },
+	{ USB_DEVICE_WACOM(0x64) },
+	{ USB_DEVICE_WACOM(0x65) },
+	{ USB_DEVICE_WACOM(0x69) },
+	{ USB_DEVICE_WACOM(0x20) },
+	{ USB_DEVICE_WACOM(0x21) },
+	{ USB_DEVICE_WACOM(0x22) },
+	{ USB_DEVICE_WACOM(0x23) },
+	{ USB_DEVICE_WACOM(0x24) },
+	{ USB_DEVICE_WACOM(0x30) },
+	{ USB_DEVICE_WACOM(0x31) },
+	{ USB_DEVICE_WACOM(0x32) },
+	{ USB_DEVICE_WACOM(0x33) },
+	{ USB_DEVICE_WACOM(0x34) },
+	{ USB_DEVICE_WACOM(0x35) },
+	{ USB_DEVICE_WACOM(0x37) },
+	{ USB_DEVICE_WACOM(0x38) },
+	{ USB_DEVICE_WACOM(0x39) },
+	{ USB_DEVICE_WACOM(0xC4) },
+	{ USB_DEVICE_WACOM(0xC0) },
+	{ USB_DEVICE_WACOM(0xC2) },
+	{ USB_DEVICE_WACOM(0x03) },
 	{ USB_DEVICE_WACOM(0x41) },
 	{ USB_DEVICE_WACOM(0x42) },
 	{ USB_DEVICE_WACOM(0x43) },
-- 
1.6.5.7


-- 
We Klingons believe as you do -- the sick should die.  Only the strong
should live.
		-- Kras, "Friday's Child", stardate 3497.2
