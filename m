Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYJVQG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYJVQG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbYJVQGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:06:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40872 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYJVQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:06:14 -0400
Date: Wed, 22 Oct 2008 19:06:13 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] w35und: remove unused wb35_open() and wb35_close()
 functions
Message-ID: <Pine.LNX.4.64.0810221905550.1679@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The functions are not used anywhere so remove them.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/linux/wbusb.c   |   19 -------------------
 drivers/staging/winbond/linux/wbusb_f.h |    2 --
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index 4b989c5..c3394bf 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -308,25 +308,6 @@ WbUsb_destroy(phw_data_t pHwData)
 {
 }
 
-int wb35_open(struct net_device *netdev)
-{
-	struct wb35_adapter * adapter = (struct wb35_adapter *)netdev->priv;
-	phw_data_t pHwData = &adapter->sHwData;
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
 	struct wb35_adapter * adapter = usb_get_intfdata(intf);
diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
index 0402f66..a1d5946 100644
--- a/drivers/staging/winbond/linux/wbusb_f.h
+++ b/drivers/staging/winbond/linux/wbusb_f.h
@@ -11,8 +11,6 @@
 //
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
-int wb35_open(struct net_device *netdev);
-int wb35_close(struct net_device *netdev);
 unsigned char WbUsb_initial(phw_data_t pHwData);
 void WbUsb_destroy(phw_data_t pHwData);
 unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
-- 
1.5.3.7

