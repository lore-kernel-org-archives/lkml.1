Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468Ab0AGSm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0AGSm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451Ab0AGSkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:40:53 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:56848 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0AGSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:40:51 -0500
Date: Thu, 7 Jan 2010 19:29:36 +0100
From: Bastian Blank <waldi@debian.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
Subject: [PATCH 2/7] Input: wacom - Get features from driver info
Message-ID: <20100107182936.GA12913@wavehammer.waldi.eu.org>
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

Get the features information from the driver info of the usb device id
structure provided by the caller.  The device ids and feature structs
are strong coupled using indices.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/input/tablet/wacom_sys.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index ab42c25..b0f3fc3 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -532,7 +532,7 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	struct usb_endpoint_descriptor *endpoint;
 	struct wacom *wacom;
 	struct wacom_wac *wacom_wac;
-	struct wacom_features *features;
+	struct wacom_features *features = (void *)id->driver_info;
 	struct input_dev *input_dev;
 	int error = -ENOMEM;
 
@@ -557,7 +557,9 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	usb_make_path(dev, wacom->phys, sizeof(wacom->phys));
 	strlcat(wacom->phys, "/input0", sizeof(wacom->phys));
 
-	wacom_wac->features = features = get_wacom_feature(id);
+	if (!features)
+		features = get_wacom_feature(id);
+	wacom_wac->features = features;
 	BUG_ON(features->pktlen > WACOM_PKGLEN_MAX);
 
 	input_dev->name = wacom_wac->features->name;
-- 
1.6.5.7


-- 
You're dead, Jim.
		-- McCoy, "Amok Time", stardate 3372.7
