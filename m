Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYJ3LEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYJ3LEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYJ3LEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:04:41 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46703 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbYJ3LEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:04:39 -0400
Date: Thu, 30 Oct 2008 13:04:29 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] w35und: #include cleanup
Message-ID: <Pine.LNX.4.64.0810301303580.6842@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch moves #includes from sysdef.h and common.h to the files which
actually need them. This makes the dependencies less complex and allows us to
move code around much easily.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/adapter.h         |   11 +++++++++++
 drivers/staging/winbond/bss_f.h           |   12 ++++++++----
 drivers/staging/winbond/bssdscpt.h        |   10 +++++++++-
 drivers/staging/winbond/ds_tkip.h         |    8 ++++++--
 drivers/staging/winbond/gl_80211.h        |    3 ++-
 drivers/staging/winbond/linux/common.h    |   21 ---------------------
 drivers/staging/winbond/linux/sysdef.h    |   29 -----------------------------
 drivers/staging/winbond/linux/wb35reg.c   |    3 +++
 drivers/staging/winbond/linux/wb35reg_f.h |    7 ++++++-
 drivers/staging/winbond/linux/wb35reg_s.h |    9 ++++++++-
 drivers/staging/winbond/linux/wb35rx.c    |    3 +++
 drivers/staging/winbond/linux/wb35rx_f.h  |    9 ++++++---
 drivers/staging/winbond/linux/wb35tx.c    |    5 ++++-
 drivers/staging/winbond/linux/wb35tx_f.h  |    7 ++++++-
 drivers/staging/winbond/linux/wb35tx_s.h  |   10 ++++++----
 drivers/staging/winbond/linux/wbusb.c     |    6 +++++-
 drivers/staging/winbond/linux/wbusb_s.h   |   12 +++++++-----
 drivers/staging/winbond/localpara.h       |    8 +++++++-
 drivers/staging/winbond/mac_structures.h  |    7 ++-----
 drivers/staging/winbond/mds.c             |    7 +++++++
 drivers/staging/winbond/mds_f.h           |    8 +++++++-
 drivers/staging/winbond/mds_s.h           |   13 ++++++++++++-
 drivers/staging/winbond/mlme_s.h          |   11 ++++++++++-
 drivers/staging/winbond/mlmetxrx.c        |    2 ++
 drivers/staging/winbond/mlmetxrx_f.h      |    2 ++
 drivers/staging/winbond/mto.c             |    3 +++
 drivers/staging/winbond/mto.h             |    2 ++
 drivers/staging/winbond/mto_f.h           |    6 ++++++
 drivers/staging/winbond/phy_calibration.c |    1 +
 drivers/staging/winbond/phy_calibration.h |    6 ++++++
 drivers/staging/winbond/reg.c             |    1 +
 drivers/staging/winbond/rxisr.c           |    1 +
 drivers/staging/winbond/scan_s.h          |    7 +++++++
 drivers/staging/winbond/sme_api.c         |    1 +
 drivers/staging/winbond/sme_api.h         |    4 ++++
 drivers/staging/winbond/sme_s.h           |    9 +++++++++
 drivers/staging/winbond/wbhal.c           |    2 ++
 drivers/staging/winbond/wbhal_f.h         |   14 +++++---------
 drivers/staging/winbond/wbhal_s.h         |    9 ++++++++-
 drivers/staging/winbond/wblinux.c         |    6 ++++++
 drivers/staging/winbond/wblinux_f.h       |    7 +++++++
 41 files changed, 208 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/winbond/adapter.h b/drivers/staging/winbond/adapter.h
index fb07c7b..e67e034 100644
--- a/drivers/staging/winbond/adapter.h
+++ b/drivers/staging/winbond/adapter.h
@@ -1,3 +1,12 @@
+#ifndef __WINBOND_ADAPTER_H
+#define __WINBOND_ADAPTER_H
+
+#include <linux/wireless.h>
+
+#include "bssdscpt.h"
+#include "mto.h"
+#include "wbhal_s.h"
+
 #define OS_SET_SHUTDOWN( _A )		_A->shutdown=1
 #define OS_SET_RESUME( _A )		_A->shutdown=0
 #define OS_STOP( _A )	WBLINUX_stop( _A )
@@ -45,3 +54,5 @@ struct wb35_adapter {
 
 	u8 LinkName[MAX_ANSI_STRING];
 };
+
+#endif
diff --git a/drivers/staging/winbond/bss_f.h b/drivers/staging/winbond/bss_f.h
index a7ef3de..feffe5f 100644
--- a/drivers/staging/winbond/bss_f.h
+++ b/drivers/staging/winbond/bss_f.h
@@ -1,3 +1,10 @@
+#ifndef __WINBOND_BSS_F_H
+#define __WINBOND_BSS_F_H
+
+#include "adapter.h"
+
+struct PMKID_Information_Element;
+
 //
 // BSS descriptor DataBase management global function
 //
@@ -53,7 +60,4 @@ u16 SearchPmkid(struct wb35_adapter * adapter, struct  Management_Frame* msgHead
 				   struct PMKID_Information_Element * AssoReq_PMKID );
 #endif
 
-
-
-
-
+#endif
diff --git a/drivers/staging/winbond/bssdscpt.h b/drivers/staging/winbond/bssdscpt.h
index 90b5682..3a71d4e 100644
--- a/drivers/staging/winbond/bssdscpt.h
+++ b/drivers/staging/winbond/bssdscpt.h
@@ -1,3 +1,11 @@
+#ifndef __WINBOND_BSSDSCPT_H
+#define __WINBOND_BSSDSCPT_H
+
+#include <linux/types.h>
+
+#include "mds_s.h"
+#include "mlme_s.h"
+
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 //	bssdscpt.c
 //		BSS descriptor data base
@@ -153,4 +161,4 @@ typedef struct BSSDescriptionElement
 
 #define psBSS(i)			(&(adapter->asBSSDescriptElement[(i)]))
 
-
+#endif
diff --git a/drivers/staging/winbond/ds_tkip.h b/drivers/staging/winbond/ds_tkip.h
index 6cfe3de..9c5c4e7 100644
--- a/drivers/staging/winbond/ds_tkip.h
+++ b/drivers/staging/winbond/ds_tkip.h
@@ -1,3 +1,8 @@
+#ifndef __WINBOND_DS_TKIP_H
+#define __WINBOND_DS_TKIP_H
+
+#include <linux/types.h>
+
 // Rotation functions on 32 bit values
 #define ROL32( A, n ) \
     ( ((A) << (n)) | ( ((A)>>(32-(n)))  & ( (1UL << (n)) - 1 ) ) )
@@ -29,5 +34,4 @@ typedef struct tkip
 void Mds_MicGet(  void* adapter,  void* pRxLayer1,  u8 *pKey,  u8 *pMic );
 void Mds_MicFill(  void* adapter,  void* pDes,  u8 *XmitBufAddress );
 
-
-
+#endif
diff --git a/drivers/staging/winbond/gl_80211.h b/drivers/staging/winbond/gl_80211.h
index 1806d81..5a244c4 100644
--- a/drivers/staging/winbond/gl_80211.h
+++ b/drivers/staging/winbond/gl_80211.h
@@ -1,7 +1,8 @@
-
 #ifndef __GL_80211_H__
 #define __GL_80211_H__
 
+#include <linux/types.h>
+
 /****************** CONSTANT AND MACRO SECTION ******************************/
 
 /* BSS Type */
diff --git a/drivers/staging/winbond/linux/common.h b/drivers/staging/winbond/linux/common.h
index 23853da..2badc29 100644
--- a/drivers/staging/winbond/linux/common.h
+++ b/drivers/staging/winbond/linux/common.h
@@ -10,27 +10,6 @@
 #ifndef COMMON_DEF
 #define COMMON_DEF
 
-#include <linux/version.h>
-#include <linux/usb.h>
-#include <linux/kernel.h> //need for kernel alert
-#include <linux/autoconf.h>
-#include <linux/sched.h>
-#include <linux/signal.h>
-#include <linux/slab.h> //memory allocate
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/init.h>//need for init and exit modules marco
-#include <linux/ctype.h>
-#include <linux/wait.h>
-#include <linux/list.h>
-#include <linux/wireless.h>
-#include <linux/if_arp.h>
-#include <asm/uaccess.h>
-#include <net/iw_handler.h>
-#include <linux/skbuff.h>
-
-
 //#define DEBUG_ENABLED  1
 
 //==================================================================================================
diff --git a/drivers/staging/winbond/linux/sysdef.h b/drivers/staging/winbond/linux/sysdef.h
index 4b35a97..60e4c04 100644
--- a/drivers/staging/winbond/linux/sysdef.h
+++ b/drivers/staging/winbond/linux/sysdef.h
@@ -37,36 +37,7 @@
 #define _PE_USB_INI_DUMP_
 #endif
 
-
-
-#include "common.h"	// Individual file depends on OS
-
-#include "../wb35_ver.h"
-#include "../mac_structures.h"
-#include "../ds_tkip.h"
-#include "../localpara.h"
-#include "../sme_s.h"
-#include "../scan_s.h"
-#include "../mds_s.h"
-#include "../mlme_s.h"
-#include "../bssdscpt.h"
-#include "../sme_api.h"
-#include "../gl_80211.h"
-#include "../mto.h"
-#include "../wbhal_s.h"
-
-
-#include "../adapter.h"
-
-#include "../mlme_mib.h"
-#include "../mds_f.h"
-#include "../bss_f.h"
-#include "../mlmetxrx_f.h"
-#include "../mto_f.h"
-#include "../wbhal_f.h"
-#include "../wblinux_f.h"
 // Kernel Timer resolution, NDIS is 10ms, 10000us
 #define MIN_TIMEOUT_VAL	(10) //ms
 
-
 #endif
diff --git a/drivers/staging/winbond/linux/wb35reg.c b/drivers/staging/winbond/linux/wb35reg.c
index cc856a8..c74b3fd 100644
--- a/drivers/staging/winbond/linux/wb35reg.c
+++ b/drivers/staging/winbond/linux/wb35reg.c
@@ -1,4 +1,7 @@
 #include "sysdef.h"
+#include "wb35reg_f.h"
+
+#include <linux/usb.h>
 
 extern void phy_calibration_winbond(hw_data_t *phw_data, u32 frequency);
 
diff --git a/drivers/staging/winbond/linux/wb35reg_f.h b/drivers/staging/winbond/linux/wb35reg_f.h
index fc94091..9a178b9 100644
--- a/drivers/staging/winbond/linux/wb35reg_f.h
+++ b/drivers/staging/winbond/linux/wb35reg_f.h
@@ -1,3 +1,8 @@
+#ifndef __WINBOND_WB35REG_F_H
+#define __WINBOND_WB35REG_F_H
+
+#include "../wbhal_s.h"
+
 //====================================
 // Interface function declare
 //====================================
@@ -53,4 +58,4 @@ void Wb35Reg_phy_calibration(  phw_data_t pHwData );
 void Wb35Reg_Update(  phw_data_t pHwData,  u16 RegisterNo,  u32 RegisterValue );
 unsigned char adjust_TXVGA_for_iq_mag(  phw_data_t pHwData );
 
-
+#endif
diff --git a/drivers/staging/winbond/linux/wb35reg_s.h b/drivers/staging/winbond/linux/wb35reg_s.h
index 2f665d1..32ef4b8 100644
--- a/drivers/staging/winbond/linux/wb35reg_s.h
+++ b/drivers/staging/winbond/linux/wb35reg_s.h
@@ -1,3 +1,10 @@
+#ifndef __WINBOND_WB35REG_S_H
+#define __WINBOND_WB35REG_S_H
+
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <asm/atomic.h>
+
 //=======================================================================================
 /*
 				HAL setting function
@@ -162,4 +169,4 @@ struct wb35_reg {
 
 };
 
-
+#endif
diff --git a/drivers/staging/winbond/linux/wb35rx.c b/drivers/staging/winbond/linux/wb35rx.c
index f690298..15a0650 100644
--- a/drivers/staging/winbond/linux/wb35rx.c
+++ b/drivers/staging/winbond/linux/wb35rx.c
@@ -8,7 +8,10 @@
 //    Processing the Rx message from down layer
 //
 //============================================================================
+#include <linux/usb.h>
+
 #include "sysdef.h"
+#include "wb35rx_f.h"
 
 void Wb35Rx_start(phw_data_t pHwData)
 {
diff --git a/drivers/staging/winbond/linux/wb35rx_f.h b/drivers/staging/winbond/linux/wb35rx_f.h
index 565280e..752eec7 100644
--- a/drivers/staging/winbond/linux/wb35rx_f.h
+++ b/drivers/staging/winbond/linux/wb35rx_f.h
@@ -1,3 +1,8 @@
+#ifndef __WINBOND_WB35RX_F_H
+#define __WINBOND_WB35RX_F_H
+
+#include "../wbhal_s.h"
+
 //====================================
 // Interface function declare
 //====================================
@@ -12,6 +17,4 @@ void		Wb35Rx_start(  phw_data_t pHwData );
 void		Wb35Rx(  phw_data_t pHwData );
 void		Wb35Rx_Complete(struct urb *urb);
 
-
-
-
+#endif
diff --git a/drivers/staging/winbond/linux/wb35tx.c b/drivers/staging/winbond/linux/wb35tx.c
index a58a193..ec0e7b9 100644
--- a/drivers/staging/winbond/linux/wb35tx.c
+++ b/drivers/staging/winbond/linux/wb35tx.c
@@ -8,8 +8,11 @@
 //    Processing the Tx message and put into down layer
 //
 //============================================================================
-#include "sysdef.h"
+#include <linux/usb.h>
 
+#include "wb35tx_f.h"
+#include "../mds_f.h"
+#include "sysdef.h"
 
 unsigned char
 Wb35Tx_get_tx_buffer(phw_data_t pHwData, u8 **pBuffer)
diff --git a/drivers/staging/winbond/linux/wb35tx_f.h b/drivers/staging/winbond/linux/wb35tx_f.h
index 1815c10..64b11a1 100644
--- a/drivers/staging/winbond/linux/wb35tx_f.h
+++ b/drivers/staging/winbond/linux/wb35tx_f.h
@@ -1,3 +1,8 @@
+#ifndef __WINBOND_WB35TX_F_H
+#define __WINBOND_WB35TX_F_H
+
+#include "../wbhal_f.h"
+
 //====================================
 // Interface function declare
 //====================================
@@ -17,4 +22,4 @@ void Wb35Tx_reset_descriptor(  phw_data_t pHwData );
 
 void Wb35Tx_CurrentTime(  phw_data_t pHwData,  u32 TimeCount );
 
-
+#endif
diff --git a/drivers/staging/winbond/linux/wb35tx_s.h b/drivers/staging/winbond/linux/wb35tx_s.h
index 8cb449f..b6ff6fd 100644
--- a/drivers/staging/winbond/linux/wb35tx_s.h
+++ b/drivers/staging/winbond/linux/wb35tx_s.h
@@ -1,3 +1,8 @@
+#ifndef __WINBOND_WB35_TX_S_H
+#define __WINBOND_WB35_TX_S_H
+
+#include "../mds_s.h"
+
 //====================================
 // IS89C35 Tx related definition
 //====================================
@@ -41,7 +46,4 @@ typedef struct _WB35TX
 
 } WB35TX, *PWB35TX;
 
-
-
-
-
+#endif
diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index 8957634..40c96ca 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -3,8 +3,12 @@
  *
  * Distribute under GPLv2.
  */
-#include "sysdef.h"
 #include <net/mac80211.h>
+#include <linux/usb.h>
+
+#include "../mlmetxrx_f.h"
+#include "../wbhal_f.h"
+#include "../wblinux_f.h"
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/staging/winbond/linux/wbusb_s.h b/drivers/staging/winbond/linux/wbusb_s.h
index 45e41b3..1aa8ab1 100644
--- a/drivers/staging/winbond/linux/wbusb_s.h
+++ b/drivers/staging/winbond/linux/wbusb_s.h
@@ -11,6 +11,11 @@
 //
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
+#ifndef __WINBOND_WBUSB_S_H
+#define __WINBOND_WBUSB_S_H
+
+#include <linux/types.h>
+
 //---------------------------------------------------------------------------
 //  RW_CONTEXT --
 //
@@ -23,16 +28,13 @@ typedef struct _RW_CONTEXT
 	void*			pCallBackFunctionParameter;
 } RW_CONTEXT, *PRW_CONTEXT;
 
-
-
-
 #define DRIVER_AUTHOR "Original by: Jeff Lee<YY_Lee@issc.com.tw> Adapted to 2.6.x by Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>"
 #define DRIVER_DESC   "IS89C35 802.11bg WLAN USB Driver"
 
-
-
 typedef struct _WBUSB {
 	u32	IsUsb20;
 	struct usb_device *udev;
 	u32	DetectCount;
 } WBUSB, *PWBUSB;
+
+#endif
diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index 087f486..a308ac2 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -1,6 +1,12 @@
+#ifndef __WINBOND_LOCALPARA_H
+#define __WINBOND_LOCALPARA_H
+
 //=============================================================
 // LocalPara.h -
 //=============================================================
+
+#include "mac_structures.h"
+
 //Define the local ability
 
 #define LOCAL_DEFAULT_BEACON_PERIOD			100		//ms
@@ -272,4 +278,4 @@ typedef struct LOCAL_PARA
 
 } WB_LOCALDESCRIPT, *PWB_LOCALDESCRIPT;
 
-
+#endif
diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 031d2cb..0d16196 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -21,6 +21,7 @@
 #ifndef _MAC_Structures_H_
 #define _MAC_Structures_H_
 
+#include <linux/skbuff.h>
 
 //=========================================================
 // Some miscellaneous definitions
@@ -115,10 +116,6 @@
 #define WLAN_MAX_PAIRWISE_CIPHER_SUITE_COUNT    ((u16) 6)
 #define WLAN_MAX_AUTH_KEY_MGT_SUITE_LIST_COUNT  ((u16) 2)
 
-#ifdef WB_LINUX
-#define UNALIGNED
-#endif
-
 //========================================================
 typedef enum enum_PowerManagementMode
 {
@@ -464,7 +461,7 @@ struct	RSN_Information_Element
 {
 	u8					Element_ID;
 	u8					Length;
-	UNALIGNED SUITE_SELECTOR	OuiWPAAdditional;//WPA version 2.0 additional field, and should be 00:50:F2:01
+	SUITE_SELECTOR	OuiWPAAdditional;//WPA version 2.0 additional field, and should be 00:50:F2:01
 	u16					Version;
 	SUITE_SELECTOR		GroupKeySuite;
 	u16					PairwiseKeySuiteCount;
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 20008e3..94f28ff 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -1,4 +1,11 @@
+#include "ds_tkip.h"
+#include "gl_80211.h"
+#include "mds_f.h"
+#include "mlmetxrx_f.h"
+#include "mto_f.h"
 #include "os_common.h"
+#include "wbhal_f.h"
+#include "wblinux_f.h"
 
 void
 Mds_reset_descriptor(struct wb35_adapter * adapter)
diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index 4258b32..f243d74 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -1,3 +1,9 @@
+#ifndef __WINBOND_MDS_F_H
+#define __WINBOND_MDS_F_H
+
+#include "wbhal_s.h"
+#include "adapter.h"
+
 unsigned char Mds_initial(  struct wb35_adapter *adapter );
 void Mds_Destroy(  struct wb35_adapter *adapter );
 void Mds_Tx(  struct wb35_adapter *adapter );
@@ -24,4 +30,4 @@ void MDS_GetNextPacketComplete(  struct wb35_adapter *adapter,  PDESCRIPTOR pDes
 void MDS_SendResult(  struct wb35_adapter *adapter,  u8 PacketId,  unsigned char SendOK );
 void MDS_EthernetPacketReceive(  struct wb35_adapter *adapter,  PRXLAYER1 pRxLayer1 );
 
-
+#endif
diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index 04030b9..02b1182 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -1,3 +1,14 @@
+#ifndef __WINBOND_MDS_H
+#define __WINBOND_MDS_H
+
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <asm/atomic.h>
+
+#include "localpara.h"
+#include "mac_structures.h"
+#include "scan_s.h"
+
 ////////////////////////////////////////////////////////////////////////////////////////////////////////
 #define MAX_USB_TX_DESCRIPTOR		15		// IS89C35 ability
 #define MAX_USB_TX_BUFFER_NUMBER	4		// Virtual pre-buffer number of MAX_USB_TX_BUFFER
@@ -178,4 +189,4 @@ typedef struct _RXLAYER1
 
 }RXLAYER1, * PRXLAYER1;
 
-
+#endif
diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index 039fd40..ea12684 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -1,3 +1,12 @@
+#ifndef __WINBOND_MLME_H
+#define __WINBOND_MLME_H
+
+#include <linux/types.h>
+#include <linux/spinlock.h>
+
+#include "mac_structures.h"
+#include "mds_s.h"
+
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 //	Mlme.h
 //		Define the related definitions of MLME module
@@ -192,4 +201,4 @@ typedef struct _RXDATA
 
 }__attribute__ ((packed)) RXDATA, *psRXDATA;
 
-
+#endif
diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index a071855..ee80aed 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -17,6 +17,8 @@
 //============================================================================
 #include "os_common.h"
 
+#include "mds_f.h"
+
 void MLMEResetTxRx(struct wb35_adapter * adapter)
 {
 	s32     i;
diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
index 5f108d8..0f264ed 100644
--- a/drivers/staging/winbond/mlmetxrx_f.h
+++ b/drivers/staging/winbond/mlmetxrx_f.h
@@ -8,6 +8,8 @@
 #ifndef _MLMETXRX_H
 #define _MLMETXRX_H
 
+#include "adapter.h"
+
 void
 MLMEProcThread(
      struct wb35_adapter *    adapter
diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index f53db93..c68c7f6 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -23,6 +23,9 @@
 
 // LA20040210_DTO kevin
 #include "os_common.h"
+#include "sme_api.h"
+#include "gl_80211.h"
+#include "wbhal_f.h"
 
 // Declare SQ3 to rate and fragmentation threshold table
 // Declare fragmentation thresholds table
diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
index 4ed15b0..9a17544 100644
--- a/drivers/staging/winbond/mto.h
+++ b/drivers/staging/winbond/mto.h
@@ -11,6 +11,8 @@
 #ifndef __MTO_H__
 #define __MTO_H__
 
+#include <linux/types.h>
+
 #define MTO_DEFAULT_TH_CNT              5
 #define MTO_DEFAULT_TH_SQ3              112  //OLD IS 13 reference JohnXu
 #define MTO_DEFAULT_TH_IDLE_SLOT        15
diff --git a/drivers/staging/winbond/mto_f.h b/drivers/staging/winbond/mto_f.h
index de3d8d4..ce4319d 100644
--- a/drivers/staging/winbond/mto_f.h
+++ b/drivers/staging/winbond/mto_f.h
@@ -1,3 +1,8 @@
+#ifndef __WINBOND_MTO_F_H
+#define __WINBOND_MTO_F_H
+
+#include "adapter.h"
+
 extern void MTO_Init(struct wb35_adapter *);
 extern void MTO_PeriodicTimerExpired(struct wb35_adapter *);
 extern void MTO_SetDTORateRange(struct wb35_adapter *, u8 *, u8);
@@ -5,3 +10,4 @@ extern u8 MTO_GetTxRate(MTO_FUNC_INPUT, u32 fpdu_len);
 extern u8 MTO_GetTxFallbackRate(MTO_FUNC_INPUT);
 extern void MTO_SetTxCount(MTO_FUNC_INPUT, u8 t0, u8 index);
 
+#endif
diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index b77c843..6782552 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -12,6 +12,7 @@
 /****************** INCLUDE FILES SECTION ***********************************/
 #include "os_common.h"
 #include "phy_calibration.h"
+#include "wbhal_f.h"
 
 
 /****************** DEBUG CONSTANT AND MACRO SECTION ************************/
diff --git a/drivers/staging/winbond/phy_calibration.h b/drivers/staging/winbond/phy_calibration.h
index b6a65d3..03b820c 100644
--- a/drivers/staging/winbond/phy_calibration.h
+++ b/drivers/staging/winbond/phy_calibration.h
@@ -1,3 +1,8 @@
+#ifndef __WINBOND_PHY_CALIBRATION_H
+#define __WINBOND_PHY_CALIBRATION_H
+
+#include "wbhal_f.h"
+
 // 20031229 Turbo add
 #define REG_AGC_CTRL1               0x1000
 #define REG_AGC_CTRL2               0x1004
@@ -99,3 +104,4 @@
 void phy_set_rf_data(  phw_data_t pHwData,  u32 index,  u32 value );
 #define phy_init_rf( _A )	//RFSynthesizer_initial( _A )
 
+#endif
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 9f305d7..d10d6f1 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1,4 +1,5 @@
 #include "os_common.h"
+#include "wbhal_f.h"
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 // Original Phy.h
diff --git a/drivers/staging/winbond/rxisr.c b/drivers/staging/winbond/rxisr.c
index de49a49..f5c98d9 100644
--- a/drivers/staging/winbond/rxisr.c
+++ b/drivers/staging/winbond/rxisr.c
@@ -1,4 +1,5 @@
 #include "os_common.h"
+#include "adapter.h"
 
 static void RxTimerHandler(unsigned long data)
 {
diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
index a952396..7269546 100644
--- a/drivers/staging/winbond/scan_s.h
+++ b/drivers/staging/winbond/scan_s.h
@@ -1,3 +1,9 @@
+#ifndef __WINBOND_SCAN_S_H
+#define __WINBOND_SCAN_S_H
+
+#include <linux/types.h>
+#include "localpara.h"
+
 //
 // SCAN task global CONSTANTS, STRUCTURES, variables
 //
@@ -112,3 +118,4 @@ typedef struct _SCAN_PARAMETERS
 //static void vScanTimerStart(struct wb35_adapter *	adapter, int timeout_value);
 //static void vScanTimerStop(struct wb35_adapter * adapter);
 
+#endif
diff --git a/drivers/staging/winbond/sme_api.c b/drivers/staging/winbond/sme_api.c
index 31c9673..6452d15 100644
--- a/drivers/staging/winbond/sme_api.c
+++ b/drivers/staging/winbond/sme_api.c
@@ -6,6 +6,7 @@
 //
 //------------------------------------------------------------------------------------
 #include "os_common.h"
+#include <linux/kernel.h>
 
 s8 sme_get_rssi(void *pcore_data, s32 *prssi)
 {
diff --git a/drivers/staging/winbond/sme_api.h b/drivers/staging/winbond/sme_api.h
index 745eb37..33183da 100644
--- a/drivers/staging/winbond/sme_api.h
+++ b/drivers/staging/winbond/sme_api.h
@@ -13,6 +13,10 @@
 #ifndef __SME_API_H__
 #define __SME_API_H__
 
+#include <linux/types.h>
+
+#include "localpara.h"
+
 /****************** INCLUDE FILES SECTION ***********************************/
 //#include "GL\gl_core.h"
 
diff --git a/drivers/staging/winbond/sme_s.h b/drivers/staging/winbond/sme_s.h
index 33f5d2a..1bd118f 100644
--- a/drivers/staging/winbond/sme_s.h
+++ b/drivers/staging/winbond/sme_s.h
@@ -1,3 +1,11 @@
+#ifndef __WINBOND_SME_S_H
+#define __WINBOND_SME_S_H
+
+#include <linux/types.h>
+
+#include "mac_structures.h"
+#include "localpara.h"
+
 //
 // SME_S.H -
 // SME task global CONSTANTS, STRUCTURES, variables
@@ -225,3 +233,4 @@ typedef struct _SME_PARAMETERS
 
 // Static function
 
+#endif
diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index 100a407..1ee706a 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -1,4 +1,6 @@
 #include "os_common.h"
+#include "wbhal_f.h"
+#include "wblinux_f.h"
 
 void hal_get_ethernet_address( phw_data_t pHwData, u8 *current_address )
 {
diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
index 7e6ebf2..ec66a99 100644
--- a/drivers/staging/winbond/wbhal_f.h
+++ b/drivers/staging/winbond/wbhal_f.h
@@ -1,15 +1,11 @@
 //=====================================================================
 // Device related include
 //=====================================================================
-#ifdef WB_LINUX
-	#include "linux/wb35reg_f.h"
-	#include "linux/wb35tx_f.h"
-	#include "linux/wb35rx_f.h"
-#else
-	#include "wb35reg_f.h"
-	#include "wb35tx_f.h"
-	#include "wb35rx_f.h"
-#endif
+#include "linux/wb35reg_f.h"
+#include "linux/wb35tx_f.h"
+#include "linux/wb35rx_f.h"
+
+#include "adapter.h"
 
 //====================================================================================
 // Function declaration
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 4eeb089..af99713 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -1,3 +1,10 @@
+#ifndef __WINBOND_WBHAL_S_H
+#define __WINBOND_WBHAL_S_H
+
+#include <linux/types.h>
+
+#include "linux/common.h"
+
 //[20040722 WK]
 #define HAL_LED_SET_MASK		0x001c	//20060901 Extend
 #define HAL_LED_SET_SHIFT		2
@@ -612,4 +619,4 @@ typedef struct _HAL_RATE
 	u32   NumRate54M;
 } HAL_RATE, *PHAL_RATE;
 
-
+#endif
diff --git a/drivers/staging/winbond/wblinux.c b/drivers/staging/winbond/wblinux.c
index ec4c233..450b277 100644
--- a/drivers/staging/winbond/wblinux.c
+++ b/drivers/staging/winbond/wblinux.c
@@ -8,7 +8,13 @@
 //    Linux releated routines
 //
 //============================================================================
+#include <linux/netdevice.h>
+
+#include "mds_f.h"
+#include "mto_f.h"
 #include "os_common.h"
+#include "wbhal_f.h"
+#include "wblinux_f.h"
 
 unsigned char
 WBLINUX_Initial(struct wb35_adapter * adapter)
diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
index bfa69d7..a2b7e4c 100644
--- a/drivers/staging/winbond/wblinux_f.h
+++ b/drivers/staging/winbond/wblinux_f.h
@@ -1,3 +1,9 @@
+#ifndef __WBLINUX_F_H
+#define __WBLINUX_F_H
+
+#include "adapter.h"
+#include "mds_s.h"
+
 //=========================================================================
 // Copyright (c) 1996-2004 Winbond Electronic Corporation
 //
@@ -16,3 +22,4 @@ void WBLINUX_stop(  struct wb35_adapter *adapter );
 void WbWlanHalt(  struct wb35_adapter *adapter );
 unsigned char WbWLanInitialize(struct wb35_adapter *adapter);
 
+#endif
-- 
1.5.3.7

