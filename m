Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYJ2SNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYJ2SNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbYJ2SMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:12:41 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52523 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYJ2SMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:12:40 -0400
Date: Wed, 29 Oct 2008 20:12:08 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] w35und: remove unused link status code
Message-ID: <Pine.LNX.4.64.0810292011500.16596@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The WBLINUX_ConnectStatus() and related code is not used anywhere so remove
them from the driver.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/adapter.h      |    6 ------
 drivers/staging/winbond/linux/common.h |    4 ----
 drivers/staging/winbond/mds_s.h        |    1 -
 drivers/staging/winbond/wblinux.c      |    6 ------
 drivers/staging/winbond/wblinux_f.h    |    1 -
 5 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/winbond/adapter.h b/drivers/staging/winbond/adapter.h
index bc09e41..fb07c7b 100644
--- a/drivers/staging/winbond/adapter.h
+++ b/drivers/staging/winbond/adapter.h
@@ -1,9 +1,5 @@
-#define OS_LINK_STATUS			(adapter->LinkStatus == OS_CONNECTED)
 #define OS_SET_SHUTDOWN( _A )		_A->shutdown=1
 #define OS_SET_RESUME( _A )		_A->shutdown=0
-#define OS_CONNECT_STATUS_INDICATE( _A, _F )		WBLINUX_ConnectStatus( _A, _F )
-#define OS_DISCONNECTED	0
-#define OS_CONNECTED	1
 #define OS_STOP( _A )	WBLINUX_stop( _A )
 
 #define OS_CURRENT_RX_BYTE( _A )		_A->RxByteCount
@@ -37,8 +33,6 @@ struct wb35_adapter {
 
 	atomic_t ThreadCount;
 
-	u32 LinkStatus;		// OS_DISCONNECTED or OS_CONNECTED
-
 	u32 RxByteCount;
 	u32 TxByteCount;
 
diff --git a/drivers/staging/winbond/linux/common.h b/drivers/staging/winbond/linux/common.h
index 8290779..23853da 100644
--- a/drivers/staging/winbond/linux/common.h
+++ b/drivers/staging/winbond/linux/common.h
@@ -44,10 +44,6 @@
 #define WBDEBUG( _M )	0
 #endif
 
-#define OS_DISCONNECTED	0
-#define OS_CONNECTED	1
-
-
 #define OS_EVENT_INDICATE( _A, _B, _F )
 #define OS_PMKID_STATUS_EVENT( _A )
 
diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index e1d373e..04030b9 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -25,7 +25,6 @@
 #define CURRENT_CONTROL_PORT_BLOCK		( psSME->wpa_ok!=1 || (adapter->Mds.boCounterMeasureBlock==1 && (CURRENT_ENCRYPT_STATUS==ENCRYPT_TKIP)) )
 #define CURRENT_FRAGMENT_THRESHOLD		(adapter->Mds.TxFragmentThreshold & ~0x1)
 #define CURRENT_PREAMBLE_MODE			psLOCAL->boShortPreamble?WLAN_PREAMBLE_TYPE_SHORT:WLAN_PREAMBLE_TYPE_LONG
-#define CURRENT_LINK_ON					OS_LINK_STATUS
 #define CURRENT_TX_RATE					adapter->sLocalPara.CurrentTxRate
 #define CURRENT_FALL_BACK_TX_RATE		adapter->sLocalPara.CurrentTxFallbackRate
 #define CURRENT_TX_RATE_FOR_MNG			adapter->sLocalPara.CurrentTxRateForMng
diff --git a/drivers/staging/winbond/wblinux.c b/drivers/staging/winbond/wblinux.c
index e43070e..ec4c233 100644
--- a/drivers/staging/winbond/wblinux.c
+++ b/drivers/staging/winbond/wblinux.c
@@ -224,9 +224,3 @@ error:
 
 	return false;
 }
-
-void WBLINUX_ConnectStatus(struct wb35_adapter * adapter, u32 flag)
-{
-	adapter->LinkStatus = flag; // OS_DISCONNECTED	or  OS_CONNECTED
-}
-
diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
index d763820..bfa69d7 100644
--- a/drivers/staging/winbond/wblinux_f.h
+++ b/drivers/staging/winbond/wblinux_f.h
@@ -14,6 +14,5 @@ void wb35_set_multicast( struct net_device *netdev );
 struct net_device_stats * wb35_netdev_stats( struct net_device *netdev );
 void WBLINUX_stop(  struct wb35_adapter *adapter );
 void WbWlanHalt(  struct wb35_adapter *adapter );
-void WBLINUX_ConnectStatus(  struct wb35_adapter *adapter,  u32 flag );
 unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
 
-- 
1.5.3.7

