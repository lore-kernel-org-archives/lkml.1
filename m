Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbZB0WwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbZB0WwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbZB0WvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:51:23 -0500
Received: from kroah.org ([198.145.64.141]:53523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758776AbZB0WvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:51:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/5] Staging: w35und: fix registration with wlan stack
Date: Fri, 27 Feb 2009 14:49:21 -0800
Message-Id: <1235774963-19732-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20090227224555.GB19545@kroah.com>
References: <20090227224555.GB19545@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@suse.cz>

Initialize few more fields in wireless device structure so that
wireless core actually accepts our registration.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/wbusb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index b003f9a..49f1bf0 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -369,9 +369,11 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	}
 
 	dev->extra_tx_headroom = 12;	/* FIXME */
-	dev->flags = 0;
+	dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	dev->channel_change_time = 1000;
+	dev->max_signal = 100;
 	dev->queues = 1;
 
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &wbsoft_band_2GHz;
-- 
1.6.0.2

