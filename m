Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500Ab0AGSmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0AGSmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612Ab0AGSmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:42:09 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:56852 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab0AGSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:40:53 -0500
Date: Thu, 7 Jan 2010 19:30:00 +0100
From: Bastian Blank <waldi@debian.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
Subject: [PATCH 6/7] Imput: wacom - Remove old feature struct setup
Message-ID: <20100107183000.GA13008@wavehammer.waldi.eu.org>
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

The old feature setup is not longer needed, remove it.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/input/tablet/wacom_sys.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 3a7e8db..41a631b 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -524,8 +524,6 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 	return error;
 }
 
-static struct wacom_features *get_wacom_feature(const struct usb_device_id *id);
-
 static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
@@ -557,8 +555,6 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	usb_make_path(dev, wacom->phys, sizeof(wacom->phys));
 	strlcat(wacom->phys, "/input0", sizeof(wacom->phys));
 
-	if (!features)
-		features = get_wacom_feature(id);
 	wacom_wac->features = features;
 	BUG_ON(features->pktlen > WACOM_PKGLEN_MAX);
 
@@ -665,8 +661,6 @@ static int wacom_reset_resume(struct usb_interface *intf)
 	return wacom_resume(intf);
 }
 
-static struct wacom_features wacom_features[] = {};
-
 static struct wacom_features wacom_features_0x00 =
 	{ "Wacom Penpartner",     WACOM_PKGLEN_PENPRTN,    5040,  3780,  255,  0, PENPARTNER };
 static struct wacom_features wacom_features_0x10 =
@@ -865,14 +859,6 @@ static struct usb_device_id wacom_ids[] = {
 	{ }
 };
 
-static struct wacom_features * get_wacom_feature(const struct usb_device_id *id)
-{
-        int index = id - wacom_ids;
-        struct wacom_features *wf = &wacom_features[index];
-
-        return wf;
-}
-
 static struct usb_driver wacom_driver = {
 	.name =		"wacom",
 	.id_table =	wacom_ids,
-- 
1.6.5.7


-- 
	"... freedom ... is a worship word..."
	"It is our worship word too."
		-- Cloud William and Kirk, "The Omega Glory", stardate unknown
