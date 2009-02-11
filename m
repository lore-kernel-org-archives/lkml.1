Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbZBKArA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbZBKArA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbZBKA24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:56 -0500
Received: from kroah.org ([198.145.64.141]:51652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757903AbZBKA2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:54 -0500
Date: Tue, 10 Feb 2009 16:26:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dirk De Schepper <ddeschepper@nvtl.com>,
       Matthias Urlichs <matthias@urlichs.de>
Subject: [patch 52/56] USB: option: New mobile broadband modems to be
	supported
Message-ID: <20090211002602.GA14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-option-new-mobile-broadband-modems-to-be-supported.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Dirk De Schepper <ddeschepper@nvtl.com>

commit c200b9c9e8ec93cdd262cfa1699ad92e883d4876 upstream.

- New Novatel and Dell mobile broadband modem products added
 - Dell pid variables used in stead of numerical PIDs for known
   products

Signed-off-by: Dirk De Schepper <ddeschepper@nvtl.com>
Signed-off-by: Matthias Urlichs <matthias@urlichs.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   84 +++++++++++++++++++++++++++++---------------
 1 file changed, 56 insertions(+), 28 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -192,14 +192,15 @@ static int  option_send_setup(struct tty
 #define NOVATELWIRELESS_PRODUCT_MC950D		0x4400
 
 /* FUTURE NOVATEL PRODUCTS */
-#define NOVATELWIRELESS_PRODUCT_EVDO_1		0x6000
-#define NOVATELWIRELESS_PRODUCT_HSPA_1		0x7000
-#define NOVATELWIRELESS_PRODUCT_EMBEDDED_1	0x8000
-#define NOVATELWIRELESS_PRODUCT_GLOBAL_1	0x9000
-#define NOVATELWIRELESS_PRODUCT_EVDO_2		0x6001
-#define NOVATELWIRELESS_PRODUCT_HSPA_2		0x7001
-#define NOVATELWIRELESS_PRODUCT_EMBEDDED_2	0x8001
-#define NOVATELWIRELESS_PRODUCT_GLOBAL_2	0x9001
+#define NOVATELWIRELESS_PRODUCT_EVDO_FULLSPEED	0X6000
+#define NOVATELWIRELESS_PRODUCT_EVDO_HIGHSPEED	0X6001
+#define NOVATELWIRELESS_PRODUCT_HSPA_FULLSPEED	0X7000
+#define NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED	0X7001
+#define NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED	0X8000
+#define NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED	0X8001
+#define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED	0X9000
+#define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED	0X9001
+#define NOVATELWIRELESS_PRODUCT_GLOBAL		0XA001
 
 /* AMOI PRODUCTS */
 #define AMOI_VENDOR_ID				0x1614
@@ -209,6 +210,27 @@ static int  option_send_setup(struct tty
 
 #define DELL_VENDOR_ID				0x413C
 
+/* Dell modems */
+#define DELL_PRODUCT_5700_MINICARD		0x8114
+#define DELL_PRODUCT_5500_MINICARD		0x8115
+#define DELL_PRODUCT_5505_MINICARD		0x8116
+#define DELL_PRODUCT_5700_EXPRESSCARD		0x8117
+#define DELL_PRODUCT_5510_EXPRESSCARD		0x8118
+
+#define DELL_PRODUCT_5700_MINICARD_SPRINT	0x8128
+#define DELL_PRODUCT_5700_MINICARD_TELUS	0x8129
+
+#define DELL_PRODUCT_5720_MINICARD_VZW		0x8133
+#define DELL_PRODUCT_5720_MINICARD_SPRINT	0x8134
+#define DELL_PRODUCT_5720_MINICARD_TELUS	0x8135
+#define DELL_PRODUCT_5520_MINICARD_CINGULAR	0x8136
+#define DELL_PRODUCT_5520_MINICARD_GENERIC_L	0x8137
+#define DELL_PRODUCT_5520_MINICARD_GENERIC_I	0x8138
+
+#define DELL_PRODUCT_5730_MINICARD_SPRINT	0x8180
+#define DELL_PRODUCT_5730_MINICARD_TELUS	0x8181
+#define DELL_PRODUCT_5730_MINICARD_VZW		0x8182
+
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
 #define KYOCERA_PRODUCT_KPC680			0x180a
@@ -377,31 +399,37 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EU870D) }, /* Novatel EU850D/EU860D/EU870D */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC950D) }, /* Novatel MC930D/MC950D */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC727) }, /* Novatel MC727/U727/USB727 */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_1) }, /* Novatel EVDO product */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_1) }, /* Novatel HSPA product */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EMBEDDED_1) }, /* Novatel Embedded product */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_GLOBAL_1) }, /* Novatel Global product */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_2) }, /* Novatel EVDO product */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_2) }, /* Novatel HSPA product */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EMBEDDED_2) }, /* Novatel Embedded product */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_GLOBAL_2) }, /* Novatel Global product */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_FULLSPEED) }, /* Novatel EVDO product */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_FULLSPEED) }, /* Novatel HSPA product */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED) }, /* Novatel EVDO Embedded product */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED) }, /* Novatel HSPA Embedded product */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_HIGHSPEED) }, /* Novatel EVDO product */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED) }, /* Novatel HSPA product */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED) }, /* Novatel EVDO Embedded product */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED) }, /* Novatel HSPA Embedded product */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_GLOBAL) }, /* Novatel Global product */
 
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01A) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H02) },
 
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8114) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite EV620 CDMA/EV-DO */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8115) },	/* Dell Wireless 5500 Mobile Broadband HSDPA Mini-Card == Novatel Expedite EU740 HSDPA/3G */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8116) },	/* Dell Wireless 5505 Mobile Broadband HSDPA Mini-Card == Novatel Expedite EU740 HSDPA/3G */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8117) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO ExpressCard == Novatel Merlin XV620 CDMA/EV-DO */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8118) },	/* Dell Wireless 5510 Mobile Broadband HSDPA ExpressCard == Novatel Merlin XU870 HSDPA/3G */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8128) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite E720 CDMA/EV-DO */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8129) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite ET620 CDMA/EV-DO */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8133) }, /* Dell Wireless 5720 == Novatel EV620 CDMA/EV-DO */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8136) },	/* Dell Wireless HSDPA 5520 == Novatel Expedite EU860D */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8137) },	/* Dell Wireless HSDPA 5520 */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8138) },	/* Dell Wireless 5520 Voda I Mobile Broadband (3G HSDPA) Minicard */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8147) },	/* Dell Wireless 5530 Mobile Broadband (3G HSPA) Mini-Card */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5700_MINICARD) },		/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite EV620 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5500_MINICARD) },		/* Dell Wireless 5500 Mobile Broadband HSDPA Mini-Card == Novatel Expedite EU740 HSDPA/3G */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5505_MINICARD) },		/* Dell Wireless 5505 Mobile Broadband HSDPA Mini-Card == Novatel Expedite EU740 HSDPA/3G */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5700_EXPRESSCARD) },		/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO ExpressCard == Novatel Merlin XV620 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5510_EXPRESSCARD) },		/* Dell Wireless 5510 Mobile Broadband HSDPA ExpressCard == Novatel Merlin XU870 HSDPA/3G */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5700_MINICARD_SPRINT) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite E720 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5700_MINICARD_TELUS) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite ET620 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5720_MINICARD_VZW) }, 	/* Dell Wireless 5720 == Novatel EV620 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5720_MINICARD_SPRINT) }, 	/* Dell Wireless 5720 == Novatel EV620 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5720_MINICARD_TELUS) }, 	/* Dell Wireless 5720 == Novatel EV620 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5520_MINICARD_CINGULAR) },	/* Dell Wireless HSDPA 5520 == Novatel Expedite EU860D */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5520_MINICARD_GENERIC_L) },	/* Dell Wireless HSDPA 5520 */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5520_MINICARD_GENERIC_I) },	/* Dell Wireless 5520 Voda I Mobile Broadband (3G HSDPA) Minicard */
+	{ USB_DEVICE(DELL_VENDOR_ID, 0x8147) },					/* Dell Wireless 5530 Mobile Broadband (3G HSPA) Mini-Card */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_SPRINT) },	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_TELUS) },	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_VZW) }, 	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },

