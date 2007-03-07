Return-Path: <linux-kernel-owner+w=401wt.eu-S1422791AbXCGRvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422791AbXCGRvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422786AbXCGROo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:44 -0500
Received: from ns.suse.de ([195.135.220.2]:43656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422787AbXCGROb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:31 -0500
Message-Id: <20070307171244.080136521@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Julien BLACHE <jb@jblache.org>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 026/101] USB HID: Fix USB vendor and product IDs endianness for USB HID devices
Content-Disposition: inline; filename=usb-hid-fix-usb-vendor-and-product-ids-endianness-for-usb-hid-devices.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien BLACHE <jb@jblache.org>

[PATCH] USB HID: Fix USB vendor and product IDs endianness for USB HID devices

The USB vendor and product IDs are not byteswapped appropriately, and
thus come out in the wrong endianness when fetched through the evdev
using ioctl() on big endian platforms.

Signed-off-by: Julien BLACHE <jb@jblache.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/usb/input/hid-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/drivers/usb/input/hid-core.c
+++ linux-2.6.20.1/drivers/usb/input/hid-core.c
@@ -1212,8 +1212,8 @@ static struct hid_device *usb_hid_config
 			 le16_to_cpu(dev->descriptor.idProduct));
 
 	hid->bus = BUS_USB;
-	hid->vendor = dev->descriptor.idVendor;
-	hid->product = dev->descriptor.idProduct;
+	hid->vendor = le16_to_cpu(dev->descriptor.idVendor);
+	hid->product = le16_to_cpu(dev->descriptor.idProduct);
 
 	usb_make_path(dev, hid->phys, sizeof(hid->phys));
 	strlcat(hid->phys, "/input", sizeof(hid->phys));

--
