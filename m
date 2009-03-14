Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbZCNCAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbZCNCAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZCNBV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:58 -0400
Received: from kroah.org ([198.145.64.141]:35870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755146AbZCNBV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:46 2009
Message-Id: <20090314011046.806586365@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:21 -0700
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
       alan@lxorguk.ukuu.org.uk, Anssi Hannula <anssi.hannula@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 104/114] HID: move tmff and zpff devices from ignore_list to blacklist
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=hid-move-tmff-and-zpff-devices-from-ignore_list-to-blacklist.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anssi Hannula <anssi.hannula@gmail.com>

[ upstream commit daedb3d6a91f9626ab4c921378ac52e44de833d5 ]

Subject: [patch 104/114] HID: move tmff and zpff devices from ignore_list to blacklist

The devices handled by hid-tmff and hid-zpff were added in the
hid_ignore_list[] instead of hid_blacklist[] in hid-core.c, thus
disabling them completely.

hid_ignore_list[] causes hid layer to skip the device, while
hid_blacklist[] indicates there is a specific driver in hid bus.

Re-enable the devices by moving them to the correct list.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1302,6 +1302,12 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
 
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 0x030c) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
@@ -1529,10 +1535,6 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TENX, USB_DEVICE_ID_TENX_IBUDDY1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TENX, USB_DEVICE_ID_TENX_IBUDDY2) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_LABPRO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_GOTEMP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_SKIP) },
@@ -1543,8 +1545,6 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_1_PHIDGETSERVO_20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_8_8_4_IF_KIT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
 	{ }
 };
 


