Return-Path: <linux-kernel-owner+w=401wt.eu-S1764796AbYEUAcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764796AbYEUAcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764192AbYEUAbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:31:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45302 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764070AbYEUAbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:31:22 -0400
To: mchehab@infradead.org
Subject: [PATCH] fix endianness bug in dib0700_devices.c
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycEj-0004nj-Qf@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:31:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 3462238..c4d40fe 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -111,8 +111,8 @@ static int bristol_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe, 1);
 	s8 a;
 	int if1=1220;
-	if (adap->dev->udev->descriptor.idVendor  == USB_VID_HAUPPAUGE &&
-		adap->dev->udev->descriptor.idProduct == USB_PID_HAUPPAUGE_NOVA_T_500_2) {
+	if (adap->dev->udev->descriptor.idVendor  == cpu_to_le16(USB_VID_HAUPPAUGE) &&
+		adap->dev->udev->descriptor.idProduct == cpu_to_le16(USB_PID_HAUPPAUGE_NOVA_T_500_2)) {
 		if (!eeprom_read(prim_i2c,0x59 + adap->id,&a)) if1=1220+a;
 	}
 	return dvb_attach(mt2060_attach,adap->fe, tun_i2c,&bristol_mt2060_config[adap->id],
@@ -402,8 +402,8 @@ static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct usb_device_descriptor *desc = &adap->dev->udev->descriptor;
 
-	if (desc->idVendor  == USB_VID_PINNACLE &&
-	    desc->idProduct == USB_PID_PINNACLE_EXPRESSCARD_320CX)
+	if (desc->idVendor  == cpu_to_le16(USB_VID_PINNACLE) &&
+	    desc->idProduct == cpu_to_le16(USB_PID_PINNACLE_EXPRESSCARD_320CX))
 	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
 	else
 	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
@@ -845,8 +845,8 @@ static int stk7700p_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *tun_i2c;
 	s8 a;
 	int if1=1220;
-	if (adap->dev->udev->descriptor.idVendor  == USB_VID_HAUPPAUGE &&
-		adap->dev->udev->descriptor.idProduct == USB_PID_HAUPPAUGE_NOVA_T_STICK) {
+	if (adap->dev->udev->descriptor.idVendor  == cpu_to_le16(USB_VID_HAUPPAUGE) &&
+		adap->dev->udev->descriptor.idProduct == cpu_to_le16(USB_PID_HAUPPAUGE_NOVA_T_STICK)) {
 		if (!eeprom_read(prim_i2c,0x58,&a)) if1=1220+a;
 	}
 	if (st->is_dib7000pc)
@@ -990,11 +990,12 @@ static struct dib7000p_config dib7070p_dib7000p_config = {
 /* STK7070P */
 static int stk7070p_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	if (adap->dev->udev->descriptor.idVendor  == USB_VID_PINNACLE &&
-	adap->dev->udev->descriptor.idProduct == USB_PID_PINNACLE_PCTV72E)
-	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
+	struct usb_device_descriptor *p = &adap->dev->udev->descriptor;
+	if (p->idVendor  == cpu_to_le16(USB_VID_PINNACLE) &&
+	    p->idProduct == cpu_to_le16(USB_PID_PINNACLE_PCTV72E))
+		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
 	else
-	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
+		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
 	msleep(10);
 	dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
 	dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
-- 
1.5.3.GIT


