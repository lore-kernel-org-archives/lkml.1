Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbYBGU4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbYBGU4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933192AbYBGUvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:45125 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762449AbYBGUvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:04 -0500
Date: Thu, 7 Feb 2008 12:47:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kevin Lloyd <linux@sierrawireless.com>
Subject: [patch 10/45] USB: sierra driver - add devices
Message-ID: <20080207204700.GK16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-sierra-driver-add-devices.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kevin Lloyd <linux@sierrawireless.com>

The following improvements were made:
 - Added new product support: MC5725, AC 880 U, MP 3G (UMTS & CDMA)

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -104,6 +104,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U */
+	{ USB_DEVICE(0x1199, 0x0023) },	/* Sierra Wireless AirCard */
 
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
@@ -117,8 +118,12 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E */
 	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881 E */
+	{ USB_DEVICE(0x1199, 0x6855) },	/* Sierra Wireless AirCard 880 U */
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U */
 
+	{ USB_DEVICE(0x1199, 0x6468) }, /* Sierra Wireless MP3G - EVDO */
+	{ USB_DEVICE(0x1199, 0x6469) }, /* Sierra Wireless MP3G - UMTS/HSPA */
+
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
 
@@ -143,6 +148,7 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U*/
+	{ USB_DEVICE(0x1199, 0x0023) },	/* Sierra Wireless AirCard */
 
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
@@ -156,7 +162,10 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880E */
 	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881E */
+	{ USB_DEVICE(0x1199, 0x6855) },	/* Sierra Wireless AirCard 880 U */
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881U */
+	{ USB_DEVICE(0x1199, 0x6468) }, /* Sierra Wireless MP3G - EVDO */
+	{ USB_DEVICE(0x1199, 0x6469) }, /* Sierra Wireless MP3G - UMTS/HSPA */
 	{ }
 };
 

-- 
