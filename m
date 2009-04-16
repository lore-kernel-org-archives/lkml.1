Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZDPBfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZDPBfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZDPBey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:34:54 -0400
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:36666 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751294AbZDPBex convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:34:53 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] usb/core/sysfs: fix sparse warnings
Date: Wed, 15 Apr 2009 21:34:40 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F8DF8@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] usb/core/sysfs: fix sparse warnings
Thread-Index: Acm+M4MAS6CrU1DeRZemqv3pdHiHJA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2009 01:34:51.0266 (UTC) FILETIME=[89494620:01C9BE33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 3 sparse warning in drivers/usb/core/sysfs.c.

	warning: symbol '__mptr' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index c667891..b5c72e4 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -552,8 +552,8 @@ static struct attribute *dev_string_attrs[] = {
 static mode_t dev_string_attrs_are_visible(struct kobject *kobj,
 		struct attribute *a, int n)
 {
-	struct usb_device *udev = to_usb_device(
-			container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct usb_device *udev = to_usb_device(dev);
 
 	if (a == &dev_attr_manufacturer.attr) {
 		if (udev->manufacturer == NULL)
@@ -585,8 +585,8 @@ static ssize_t
 read_descriptors(struct kobject *kobj, struct bin_attribute *attr,
 		char *buf, loff_t off, size_t count)
 {
-	struct usb_device *udev = to_usb_device(
-			container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct usb_device *udev = to_usb_device(dev);
 	size_t nleft = count;
 	size_t srclen, n;
 	int cfgno;
@@ -786,8 +786,8 @@ static struct attribute *intf_assoc_attrs[] = {
 static mode_t intf_assoc_attrs_are_visible(struct kobject *kobj,
 		struct attribute *a, int n)
 {
-	struct usb_interface *intf = to_usb_interface(
-			container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct usb_interface *intf = to_usb_interface(dev);
 
 	if (intf->intf_assoc == NULL)
 		return 0; 
