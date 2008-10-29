Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYJ2Woi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYJ2Woi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYJ2Wnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:43:43 -0400
Received: from kroah.org ([198.145.64.141]:43731 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754894AbYJ2Wnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:43:42 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/49] Staging: w35und: make wb35_probe() and wb35_disconnect() funtions static
Date: Wed, 29 Oct 2008 15:39:30 -0700
Message-Id: <1225320016-21803-3-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The wb35_probe() and wb35_disconnect() functions are only used in wbusb.c so
make them static and remove them from a header file.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/linux/wbusb.c   |    6 ++----
 drivers/staging/winbond/linux/wbusb_f.h |    4 ----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index f4a7875..ad0187a 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -185,9 +185,7 @@ static const struct ieee80211_ops wbsoft_ops = {
 struct wbsoft_priv {
 };
 
-
-// Usb kernel subsystem will call this function when a new device is plugged into.
-int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
+static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
 {
 	PADAPTER	Adapter;
 	PWBLINUX	pWbLinux;
@@ -353,7 +351,7 @@ int wb35_close(struct net_device *netdev)
 	return 0;
 }
 
-void wb35_disconnect(struct usb_interface *intf)
+static void wb35_disconnect(struct usb_interface *intf)
 {
 	PWBLINUX pWbLinux;
 	PADAPTER Adapter = usb_get_intfdata(intf);
diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
index cae29e1..9a69008 100644
--- a/drivers/staging/winbond/linux/wbusb_f.h
+++ b/drivers/staging/winbond/linux/wbusb_f.h
@@ -18,10 +18,6 @@ void WbUsb_destroy(phw_data_t pHwData);
 unsigned char WbWLanInitialize(PADAPTER Adapter);
 #define	WbUsb_Stop( _A )
 
-int wb35_probe(struct usb_interface *intf,const struct usb_device_id *id_table);
-void wb35_disconnect(struct usb_interface *intf);
-
-
 #define wb_usb_submit_urb(_A) usb_submit_urb(_A, GFP_ATOMIC)
 #define wb_usb_alloc_urb(_A) usb_alloc_urb(_A, GFP_ATOMIC)
 
-- 
1.6.0.2

