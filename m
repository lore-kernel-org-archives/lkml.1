Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYJ2Woy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYJ2Woy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYJ2Wno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:43:44 -0400
Received: from kroah.org ([198.145.64.141]:43735 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755355AbYJ2Wnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:43:43 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/49] Staging: w35und: remove unused wb35_open() and wb35_close() functions
Date: Wed, 29 Oct 2008 15:39:31 -0700
Message-Id: <1225320016-21803-4-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The functions are not used anywhere so remove them.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/linux/wbusb.c   |   19 -------------------
 drivers/staging/winbond/linux/wbusb_f.h |    2 --
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index ad0187a..c1e2562 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -332,25 +332,6 @@ WbUsb_destroy(phw_data_t pHwData)
 {
 }
 
-int wb35_open(struct net_device *netdev)
-{
-	PADAPTER Adapter = (PADAPTER)netdev->priv;
-	phw_data_t pHwData = &Adapter->sHwData;
-
-        netif_start_queue(netdev);
-
-	//TODO : put here temporarily
-	hal_set_accept_broadcast(pHwData, 1); // open accept broadcast
-
-	return 0;
-}
-
-int wb35_close(struct net_device *netdev)
-{
-	netif_stop_queue(netdev);
-	return 0;
-}
-
 static void wb35_disconnect(struct usb_interface *intf)
 {
 	PWBLINUX pWbLinux;
diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
index 9a69008..d08fbc2 100644
--- a/drivers/staging/winbond/linux/wbusb_f.h
+++ b/drivers/staging/winbond/linux/wbusb_f.h
@@ -11,8 +11,6 @@
 //
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
-int wb35_open(struct net_device *netdev);
-int wb35_close(struct net_device *netdev);
 unsigned char WbUsb_initial(phw_data_t pHwData);
 void WbUsb_destroy(phw_data_t pHwData);
 unsigned char WbWLanInitialize(PADAPTER Adapter);
-- 
1.6.0.2

