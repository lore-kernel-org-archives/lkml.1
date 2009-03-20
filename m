Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbZCTXf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbZCTXf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763004AbZCTXYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:45 -0400
Received: from kroah.org ([198.145.64.141]:48701 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762999AbZCTXYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:27 2009
Message-Id: <20090320222927.035552913@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:36 -0700
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
Subject: [patch 26/43] USB: Option: let cdc-acm handle Sony Ericsson F3507g / Dell 5530
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-option-let-cdc-acm-handle-sony-ericsson-f3507g-dell-5530.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 0cc6bfe901b946df125d8e37186d8e45f876457d upstream.

The generic cdc-acm driver is now the best one to handle Sony Ericsson
F3507g-based devices (which the Dell 5530 is a rebrand of), now that all
the pieces are in place (ie, cac477e8f1038c41b6f29d3161ce351462ef3df7).
Removing the IDs from option allows cdc-acm to handle the device.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -288,10 +288,6 @@ static int  option_send_setup(struct tty
 #define ZTE_PRODUCT_MF626			0x0031
 #define ZTE_PRODUCT_CDMA_TECH			0xfffe
 
-/* Ericsson products */
-#define ERICSSON_VENDOR_ID			0x0bdb
-#define ERICSSON_PRODUCT_F3507G			0x1900
-
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
 
@@ -434,7 +430,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5520_MINICARD_CINGULAR) },	/* Dell Wireless HSDPA 5520 == Novatel Expedite EU860D */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5520_MINICARD_GENERIC_L) },	/* Dell Wireless HSDPA 5520 */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5520_MINICARD_GENERIC_I) },	/* Dell Wireless 5520 Voda I Mobile Broadband (3G HSDPA) Minicard */
-	{ USB_DEVICE(DELL_VENDOR_ID, 0x8147) },					/* Dell Wireless 5530 Mobile Broadband (3G HSPA) Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_SPRINT) },	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_TELUS) },	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_VZW) }, 	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
@@ -506,7 +501,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
-	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(0x1da5, 0x4515) }, /* BenQ H20 */
 	{ } /* Terminating entry */


