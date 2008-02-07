Return-Path: <linux-kernel-owner+w=401wt.eu-S934360AbYBGU7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360AbYBGU7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762663AbYBGUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:40 -0500
Received: from ns.suse.de ([195.135.220.2]:45461 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761973AbYBGUvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:37 -0500
Date: Thu, 7 Feb 2008 12:47:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 18/45] USB: Variant of the Dell Wireless 5520 driver
Message-ID: <20080207204720.GS16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-variant-of-the-dell-wireless-5520-driver.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Nate Carlson <natecars@natecarlson.com>

I've got a Dell wireless 5520 card with a different USB ID - specifically, 8136
instead of 8137. Attached a small patch to add support, and the output of an
'ati3'.

If we could get this in, that'd be sweet.  ;)  Thanks!

nc@knight:~/tmp/linux-2.6.24-rc8/drivers/usb/serial$ lsusb | grep 8136
	Bus 001 Device 005: ID 413c:8136 Dell Computer Corp.
nc@knight:~/tmp/linux-source-2.6.23/drivers/usb/serial$ cu -l ttyUSB0 -s 115200
	Connected.
	ati3
	Manufacturer: Novatel Wireless Incorporated
	Model: Expedite EU860D MiniCard
	Revision: 10.10.04.01-01  [2007-04-11 14:07:19]
	IMEI: 011186000228043
	+GCAP: +CGSM,+DS,+ES

From: Nate Carlson <natecars@natecarlson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -180,6 +180,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8117) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO ExpressCard == Novatel Merlin XV620 CDMA/EV-DO */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8118) },	/* Dell Wireless 5510 Mobile Broadband HSDPA ExpressCard == Novatel Merlin XU870 HSDPA/3G */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8128) },	/* Dell Wireless 5700 Mobile Broadband CDMA/EVDO Mini-Card == Novatel Expedite E720 CDMA/EV-DO */
+	{ USB_DEVICE(DELL_VENDOR_ID, 0x8136) },	/* Dell Wireless HSDPA 5520 == Novatel Expedite EU860D */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8137) },	/* Dell Wireless HSDPA 5520 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },

-- 
