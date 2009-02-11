Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbZBKAqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbZBKAqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbZBKA2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:54 -0500
Received: from kroah.org ([198.145.64.141]:51624 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757892AbZBKA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:52 -0500
Date: Tue, 10 Feb 2009 16:25:57 -0800
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
       alan@lxorguk.ukuu.org.uk, Dan Williams <dcbw@redhat.com>
Subject: [patch 50/56] Revert USB: option: add Pantech cards
Message-ID: <20090211002557.GY14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="revert-usb-option-add-pantech-cards.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 6b40c0057a7935bcf63a38a924094c7e61d4731f upstream.

Revert 8b6346ec899713a90890c9e832f7eff91ea73504 as these devices really
work just fine with the cdc-acm driver, as they follow the spec
properly.

Thanks to Chuck Ebbert for pointing out the problem here.

Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -267,12 +267,6 @@ static int  option_send_setup(struct tty
 #define ERICSSON_VENDOR_ID			0x0bdb
 #define ERICSSON_PRODUCT_F3507G			0x1900
 
-/* Pantech products */
-#define PANTECH_VENDOR_ID			0x106c
-#define PANTECH_PRODUCT_PC5740			0x3701
-#define PANTECH_PRODUCT_PC5750			0x3702  /* PX-500 */
-#define PANTECH_PRODUCT_UM150			0x3711
-
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -476,9 +470,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
 	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G) },
-	{ USB_DEVICE(PANTECH_VENDOR_ID, PANTECH_PRODUCT_PC5740) },
-	{ USB_DEVICE(PANTECH_VENDOR_ID, PANTECH_PRODUCT_PC5750) },
-	{ USB_DEVICE(PANTECH_VENDOR_ID, PANTECH_PRODUCT_UM150) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);

