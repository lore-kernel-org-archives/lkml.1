Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYJ0Uob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYJ0Uob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYJ0UoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:44:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54650 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYJ0UoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:44:21 -0400
Date: Mon, 27 Oct 2008 22:44:19 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] w35und: remove dead code from wbusb_f.h
In-Reply-To: <20081027183707.GA13737@kroah.com>
Message-ID: <Pine.LNX.4.64.0810272241520.7338@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0810221906140.1679@melkki.cs.Helsinki.FI>
 <20081027183707.GA13737@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Oct 22, 2008 at 07:06:41PM +0300, Pekka J Enberg wrote:
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > Remove dead code from wbusb_f.h and move the WbWLanInitialize() definition to
> > wblinux_f.h where it arguably belongs to. As the wbusb_f.h is now empty, we can
> > remove it completely.
> > 
> > Cc: Pavel Machek <pavel@suse.cz>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

On Mon, 27 Oct 2008, Greg KH wrote:
> This patch gives me a bunch of build errors as I don't think you are in
> sync with the other changes in these files.
> 
> Care to respin it against 2.6.28-rc2?

That's strange. I rebased against 2.6.28-rc2 but didn't get any conficts 
and everything seems to build just fine. What kind of errors are you 
seeing?

I've included the rediffed patch here in case it helps. Not sure why it 
would...

		Pekka

>From cc8c4e3686389a46e552c016722e3983ef72ac00 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 22 Oct 2008 18:46:33 +0300
Subject: [PATCH] w35und: remove dead code from wbusb_f.h

Remove dead code from wbusb_f.h and move the WbWLanInitialize() definition to
wblinux_f.h where it arguably belongs to. As the wbusb_f.h is now empty, we can
remove it completely.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/linux/wbusb.c   |   12 ------
 drivers/staging/winbond/linux/wbusb_f.h |   25 -------------
 drivers/staging/winbond/wbhal.c         |   57 ++++++++++++++-----------------
 drivers/staging/winbond/wbhal_f.h       |    2 -
 drivers/staging/winbond/wblinux_f.h     |    3 +-
 5 files changed, 27 insertions(+), 72 deletions(-)
 delete mode 100644 drivers/staging/winbond/linux/wbusb_f.h

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index 3519e5b..a4403d2 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -307,18 +307,6 @@ void packet_came(char *pRxBufferAddress, int PacketSize)
 	ieee80211_rx_irqsafe(my_dev, skb, &rx_status);
 }
 
-unsigned char
-WbUsb_initial(phw_data_t pHwData)
-{
-	return 1;
-}
-
-
-void
-WbUsb_destroy(phw_data_t pHwData)
-{
-}
-
 static void wb35_disconnect(struct usb_interface *intf)
 {
 	struct wb35_adapter * adapter = usb_get_intfdata(intf);
diff --git a/drivers/staging/winbond/linux/wbusb_f.h b/drivers/staging/winbond/linux/wbusb_f.h
deleted file mode 100644
index a1d5946..0000000
--- a/drivers/staging/winbond/linux/wbusb_f.h
+++ /dev/null
@@ -1,25 +0,0 @@
-//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-// Copyright (c) 1996-2004 Winbond Electronic Corporation
-//
-//  Module Name:
-//    wbusb_f.h
-//
-//  Abstract:
-//    Linux driver.
-//
-//  Author:
-//
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-
-unsigned char WbUsb_initial(phw_data_t pHwData);
-void WbUsb_destroy(phw_data_t pHwData);
-unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
-#define	WbUsb_Stop( _A )
-
-#define WbUsb_CheckForHang( _P )
-#define WbUsb_DetectStart( _P, _I )
-
-
-
-
-
diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index 8da441c..356bd91 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -37,34 +37,32 @@ u8 hal_init_hardware(phw_data_t pHwData, struct wb35_adapter * adapter)
 	pHwData->MaxReceiveLifeTime = DEFAULT_MSDU_LIFE_TIME; // Setting Rx maximum MSDU life time
 	pHwData->FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD; // Setting default fragment threshold
 
-	if (WbUsb_initial(pHwData)) {
-		pHwData->InitialResource = 1;
-		if( Wb35Reg_initial(pHwData)) {
-			pHwData->InitialResource = 2;
-			if (Wb35Tx_initial(pHwData)) {
-				pHwData->InitialResource = 3;
-				if (Wb35Rx_initial(pHwData)) {
-					pHwData->InitialResource = 4;
-					OS_TIMER_INITIAL( &pHwData->LEDTimer, hal_led_control, pHwData );
-					OS_TIMER_SET( &pHwData->LEDTimer, 1000 ); // 20060623
-
-					//
-					// For restrict to vendor's hardware
-					//
-					SoftwareSet = hal_software_set( pHwData );
-
-					#ifdef Vendor2
-					// Try to make sure the EEPROM contain
-					SoftwareSet >>= 8;
-					if( SoftwareSet != 0x82 )
-						return FALSE;
-					#endif
-
-					Wb35Rx_start( pHwData );
-					Wb35Tx_EP2VM_start( pHwData );
-
-					return TRUE;
-				}
+	pHwData->InitialResource = 1;
+	if( Wb35Reg_initial(pHwData)) {
+		pHwData->InitialResource = 2;
+		if (Wb35Tx_initial(pHwData)) {
+			pHwData->InitialResource = 3;
+			if (Wb35Rx_initial(pHwData)) {
+				pHwData->InitialResource = 4;
+				OS_TIMER_INITIAL( &pHwData->LEDTimer, hal_led_control, pHwData );
+				OS_TIMER_SET( &pHwData->LEDTimer, 1000 ); // 20060623
+
+				//
+				// For restrict to vendor's hardware
+				//
+				SoftwareSet = hal_software_set( pHwData );
+
+				#ifdef Vendor2
+				// Try to make sure the EEPROM contain
+				SoftwareSet >>= 8;
+				if( SoftwareSet != 0x82 )
+					return FALSE;
+				#endif
+
+				Wb35Rx_start( pHwData );
+				Wb35Tx_EP2VM_start( pHwData );
+
+				return TRUE;
 			}
 		}
 	}
@@ -84,7 +82,6 @@ void hal_halt(phw_data_t pHwData, void *ppa_data)
 			Wb35Rx_destroy( pHwData ); // Release the Rx
 		case 2: Wb35Tx_destroy( pHwData ); // Release the Tx
 		case 1: Wb35Reg_destroy( pHwData ); // Release the Wb35 Regisster resources
-				WbUsb_destroy( pHwData );// Release the WbUsb
 	}
 }
 
@@ -330,8 +327,6 @@ void hal_stop(  phw_data_t pHwData )
 
 	reg->D00_DmaControl &= ~0xc0000000;//Tx Off, Rx Off
 	Wb35Reg_Write( pHwData, 0x0400, reg->D00_DmaControl );
-
-	WbUsb_Stop( pHwData ); // 20051230 Add.4
 }
 
 unsigned char hal_idle(phw_data_t pHwData)
diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
index 4ecf191..9f0436b 100644
--- a/drivers/staging/winbond/wbhal_f.h
+++ b/drivers/staging/winbond/wbhal_f.h
@@ -2,12 +2,10 @@
 // Device related include
 //=====================================================================
 #ifdef WB_LINUX
-	#include "linux/wbusb_f.h"
 	#include "linux/wb35reg_f.h"
 	#include "linux/wb35tx_f.h"
 	#include "linux/wb35rx_f.h"
 #else
-	#include "wbusb_f.h"
 	#include "wb35reg_f.h"
 	#include "wb35tx_f.h"
 	#include "wb35rx_f.h"
diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
index 446ace9..1d09c65 100644
--- a/drivers/staging/winbond/wblinux_f.h
+++ b/drivers/staging/winbond/wblinux_f.h
@@ -18,6 +18,5 @@ struct net_device_stats * wb35_netdev_stats( struct net_device *netdev );
 void WBLINUX_stop(  struct wb35_adapter *adapter );
 void WbWlanHalt(  struct wb35_adapter *adapter );
 void WBLINUX_ConnectStatus(  struct wb35_adapter *adapter,  u32 flag );
-
-
+unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
 
-- 
1.5.3.7

