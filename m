Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYJ0WUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYJ0WUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYJ0WUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:20:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36795 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYJ0WUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:20:04 -0400
Date: Tue, 28 Oct 2008 00:20:03 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
cc: pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] w35und: move supported band initialization out of wb35_probe()
Message-ID: <Pine.LNX.4.64.0810280019330.9949@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch moves the static struct ieee80211_supported_band initialization out
of w35_probe() because it's really global read-only configuration data.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/linux/wbusb.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index a4403d2..582ede4 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -32,6 +32,13 @@ static struct ieee80211_channel wbsoft_channels[] = {
 	{ .center_freq = 2412},
 };
 
+static struct ieee80211_supported_band wbsoft_band_2GHz = {
+	.channels	= wbsoft_channels,
+	.n_channels	= ARRAY_SIZE(wbsoft_channels),
+	.bitrates	= wbsoft_rates,
+	.n_bitrates	= ARRAY_SIZE(wbsoft_rates),
+};
+
 int wbsoft_enabled;
 struct ieee80211_hw *my_dev;
 struct wb35_adapter * my_adapter;
@@ -195,7 +202,6 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct wbsoft_priv *priv;
 	struct ieee80211_hw *dev;
-	static struct ieee80211_supported_band band;
 	int err;
 
 	usb_get_dev(udev);
@@ -256,12 +262,7 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	dev->channel_change_time = 1000;
 	dev->queues = 1;
 
-	band.channels = wbsoft_channels;
-	band.n_channels = ARRAY_SIZE(wbsoft_channels);
-	band.bitrates = wbsoft_rates;
-	band.n_bitrates = ARRAY_SIZE(wbsoft_rates);
-
-	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band;
+	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &wbsoft_band_2GHz;
 
 	err = ieee80211_register_hw(dev);
 	if (err)
-- 
1.5.3.7

