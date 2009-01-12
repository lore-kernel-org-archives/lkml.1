Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZALQD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZALQD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZALQDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:03:17 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41751 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZALQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:03:16 -0500
Date: Mon, 12 Jan 2009 18:03:13 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] w35und: merge wbhal_s.h and wbhal_f.h header files
Message-ID: <Pine.LNX.4.64.0901121802480.16815@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

No need to keep function definitions separate from the rest so unify wbhal_s.h
and wbhal_f.h header files.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/core.h                 |    2 +-
 drivers/staging/winbond/mds.c                  |    3 +-
 drivers/staging/winbond/mds_f.h                |    2 +-
 drivers/staging/winbond/mto.c                  |    4 +-
 drivers/staging/winbond/phy_calibration.c      |    3 +-
 drivers/staging/winbond/phy_calibration.h      |    2 +-
 drivers/staging/winbond/reg.c                  |    3 +-
 drivers/staging/winbond/wb35reg_f.h            |    2 +-
 drivers/staging/winbond/wb35rx_f.h             |    2 +-
 drivers/staging/winbond/wb35tx_f.h             |    2 +-
 drivers/staging/winbond/wbhal.c                |    5 +-
 drivers/staging/winbond/{wbhal_s.h => wbhal.h} |   82 +++++++++++++++++++++
 drivers/staging/winbond/wbhal_f.h              |   91 ------------------------
 drivers/staging/winbond/wbusb.c                |    2 +-
 14 files changed, 102 insertions(+), 103 deletions(-)
 rename drivers/staging/winbond/{wbhal_s.h => wbhal.h} (75%)
 delete mode 100644 drivers/staging/winbond/wbhal_f.h

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index cd6a419..2eef587 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -4,7 +4,7 @@
 #include <linux/wireless.h>
 
 #include "bssdscpt.h"
-#include "wbhal_s.h"
+#include "wbhal.h"
 #include "mto.h"
 
 #define WBLINUX_PACKET_ARRAY_SIZE (ETHERNET_TX_DESCRIPTORS*4)
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 59cdba8..65dcaed 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -4,8 +4,9 @@
 #include "mlmetxrx_f.h"
 #include "mto.h"
 #include "sysdef.h"
-#include "wbhal_f.h"
+#include "wbhal.h"
 #include "wblinux_f.h"
+#include "wb35tx_f.h"
 
 unsigned char
 Mds_initial(struct wbsoft_priv * adapter)
diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index ee0f120..cf582c8 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -1,7 +1,7 @@
 #ifndef __WINBOND_MDS_F_H
 #define __WINBOND_MDS_F_H
 
-#include "wbhal_s.h"
+#include "wbhal.h"
 #include "core.h"
 
 unsigned char Mds_initial(  struct wbsoft_priv *adapter );
diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index a962fdd..d77e330 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -25,7 +25,9 @@
 #include "sysdef.h"
 #include "sme_api.h"
 #include "gl_80211.h"
-#include "wbhal_f.h"
+#include "wbhal.h"
+#include "mto.h"
+#include "core.h"
 
 // Declare SQ3 to rate and fragmentation threshold table
 // Declare fragmentation thresholds table
diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index af8c01e..8410f96 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -12,7 +12,8 @@
 /****************** INCLUDE FILES SECTION ***********************************/
 #include "sysdef.h"
 #include "phy_calibration.h"
-#include "wbhal_f.h"
+#include "wbhal.h"
+#include "wb35reg_f.h"
 
 
 /****************** DEBUG CONSTANT AND MACRO SECTION ************************/
diff --git a/drivers/staging/winbond/phy_calibration.h b/drivers/staging/winbond/phy_calibration.h
index 51c8fde..e7fbfc8 100644
--- a/drivers/staging/winbond/phy_calibration.h
+++ b/drivers/staging/winbond/phy_calibration.h
@@ -1,7 +1,7 @@
 #ifndef __WINBOND_PHY_CALIBRATION_H
 #define __WINBOND_PHY_CALIBRATION_H
 
-#include "wbhal_f.h"
+#include "wbhal.h"
 
 // 20031229 Turbo add
 #define REG_AGC_CTRL1               0x1000
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index d915cbd..444599f 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1,5 +1,6 @@
 #include "sysdef.h"
-#include "wbhal_f.h"
+#include "wbhal.h"
+#include "wb35reg_f.h"
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 // Original Phy.h
diff --git a/drivers/staging/winbond/wb35reg_f.h b/drivers/staging/winbond/wb35reg_f.h
index 30f5b5a..f57c2fc 100644
--- a/drivers/staging/winbond/wb35reg_f.h
+++ b/drivers/staging/winbond/wb35reg_f.h
@@ -1,7 +1,7 @@
 #ifndef __WINBOND_WB35REG_F_H
 #define __WINBOND_WB35REG_F_H
 
-#include "wbhal_s.h"
+#include "wbhal.h"
 
 //====================================
 // Interface function declare
diff --git a/drivers/staging/winbond/wb35rx_f.h b/drivers/staging/winbond/wb35rx_f.h
index 98acce5..1fdf65e 100644
--- a/drivers/staging/winbond/wb35rx_f.h
+++ b/drivers/staging/winbond/wb35rx_f.h
@@ -2,7 +2,7 @@
 #define __WINBOND_WB35RX_F_H
 
 #include <net/mac80211.h>
-#include "wbhal_s.h"
+#include "wbhal.h"
 
 //====================================
 // Interface function declare
diff --git a/drivers/staging/winbond/wb35tx_f.h b/drivers/staging/winbond/wb35tx_f.h
index a7af9cb..2be3fa2 100644
--- a/drivers/staging/winbond/wb35tx_f.h
+++ b/drivers/staging/winbond/wb35tx_f.h
@@ -2,7 +2,7 @@
 #define __WINBOND_WB35TX_F_H
 
 #include "core.h"
-#include "wbhal_f.h"
+#include "wbhal.h"
 
 //====================================
 // Interface function declare
diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index c985ad0..eef4951 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -1,6 +1,9 @@
 #include "sysdef.h"
-#include "wbhal_f.h"
+#include "wbhal.h"
 #include "wblinux_f.h"
+#include "wb35reg_f.h"
+#include "wb35rx_f.h"
+#include "wb35tx_f.h"
 
 void hal_set_ethernet_address( struct hw_data * pHwData, u8 *current_address )
 {
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal.h
similarity index 75%
rename from drivers/staging/winbond/wbhal_s.h
rename to drivers/staging/winbond/wbhal.h
index acfebf0..a6d9e73 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/if_ether.h> /* for ETH_ALEN */
+#include <net/mac80211.h>
 
 //[20040722 WK]
 #define HAL_LED_SET_MASK		0x001c	//20060901 Extend
@@ -542,4 +543,85 @@ struct hw_data {
 
 };
 
+//====================================================================================
+// Function declaration
+//====================================================================================
+void hal_remove_mapping_key(  struct hw_data * pHwData,  u8 *pmac_addr );
+void hal_remove_default_key(  struct hw_data * pHwData,  u32 index );
+unsigned char hal_set_mapping_key(  struct hw_data * adapter,  u8 *pmac_addr,  u8 null_key,  u8 wep_on,  u8 *ptx_tsc,  u8 *prx_tsc,  u8 key_type,  u8 key_len,  u8 *pkey_data );
+unsigned char hal_set_default_key(  struct hw_data * adapter,  u8 index,  u8 null_key,  u8 wep_on,  u8 *ptx_tsc,  u8 *prx_tsc,  u8 key_type,  u8 key_len,  u8 *pkey_data );
+void hal_clear_all_default_key(  struct hw_data * pHwData );
+void hal_clear_all_group_key(  struct hw_data * pHwData );
+void hal_clear_all_mapping_key(  struct hw_data * pHwData );
+void hal_clear_all_key(  struct hw_data * pHwData );
+void hal_get_ethernet_address(  struct hw_data * pHwData,  u8 *current_address );
+void hal_set_ethernet_address(  struct hw_data * pHwData,  u8 *current_address );
+void hal_get_permanent_address(  struct hw_data * pHwData,  u8 *pethernet_address );
+u8 hal_init_hardware(struct ieee80211_hw *hw);
+void hal_set_power_save_mode(  struct hw_data * pHwData,  unsigned char power_save,  unsigned char wakeup,  unsigned char dtim );
+void hal_get_power_save_mode(  struct hw_data * pHwData,   u8 *pin_pwr_save );
+void hal_set_slot_time(  struct hw_data * pHwData,  u8 type );
+#define hal_set_atim_window( _A, _ATM )
+void hal_start_bss(  struct hw_data * pHwData,  u8 mac_op_mode );
+void hal_join_request(  struct hw_data * pHwData,  u8 bss_type ); // 0:BSS STA 1:IBSS STA//
+void hal_stop_sync_bss(  struct hw_data * pHwData );
+void hal_resume_sync_bss(  struct hw_data * pHwData);
+void hal_set_aid(  struct hw_data * pHwData,  u16 aid );
+void hal_set_bssid(  struct hw_data * pHwData,  u8 *pbssid );
+void hal_get_bssid(  struct hw_data * pHwData,  u8 *pbssid );
+void hal_set_beacon_period(  struct hw_data * pHwData,  u16 beacon_period );
+void hal_set_listen_interval(  struct hw_data * pHwData,  u16 listen_interval );
+void hal_set_cap_info(  struct hw_data * pHwData,  u16 capability_info );
+void hal_set_ssid(  struct hw_data * pHwData,  u8 *pssid,  u8 ssid_len );
+void hal_set_current_channel(  struct hw_data * pHwData,  ChanInfo channel );
+void hal_set_accept_broadcast(  struct hw_data * pHwData,  u8 enable );
+void hal_set_accept_multicast(  struct hw_data * pHwData,  u8 enable );
+void hal_set_accept_beacon(  struct hw_data * pHwData,  u8 enable );
+void hal_stop(  struct hw_data * pHwData );
+void hal_halt(  struct hw_data * pHwData, void *ppa_data );
+void hal_start_tx0(  struct hw_data * pHwData );
+void hal_set_phy_type(  struct hw_data * pHwData,  u8 PhyType );
+#define hal_get_cwmin( _A ) ( (_A)->cwmin )
+void hal_set_cwmax(  struct hw_data * pHwData,  u16 cwin_max );
+#define hal_get_cwmax( _A ) ( (_A)->cwmax )
+void hal_set_rsn_wpa(  struct hw_data * pHwData,  u32 * RSN_IE_Bitmap , u32 * RSN_OUI_type , unsigned char bDesiredAuthMode);
+void hal_set_connect_info(  struct hw_data * pHwData,  unsigned char boConnect );
+u8 hal_get_est_sq3(  struct hw_data * pHwData,  u8 Count );
+void hal_set_rf_power(  struct hw_data * pHwData,  u8 PowerIndex ); // 20060621 Modify
+void hal_set_radio_mode(  struct hw_data * pHwData,  unsigned char boValue);
+void hal_descriptor_indicate(  struct hw_data * pHwData,  PDESCRIPTOR pDes );
+u8 hal_get_antenna_number(  struct hw_data * pHwData );
+u32 hal_get_bss_pk_cnt(  struct hw_data * pHwData );
+#define hal_get_region_from_EEPROM( _A ) ( (_A)->reg.EEPROMRegion )
+void hal_set_accept_promiscuous		(  struct hw_data * pHwData,  u8 enable);
+#define hal_get_tx_buffer( _A, _B ) Wb35Tx_get_tx_buffer( _A, _B )
+u8 hal_get_hw_radio_off			(  struct hw_data * pHwData );
+#define hal_software_set( _A )		(_A->SoftwareSet)
+#define hal_driver_init_OK( _A )	(_A->IsInitOK)
+#define hal_rssi_boundary_high( _A ) (_A->RSSI_high)
+#define hal_rssi_boundary_low( _A ) (_A->RSSI_low)
+#define hal_scan_interval( _A )		(_A->Scan_Interval)
+
+#define PHY_DEBUG( msg, args... )
+
+unsigned char hal_get_dxx_reg(  struct hw_data * pHwData,  u16 number,  u32 * pValue );
+unsigned char hal_set_dxx_reg(  struct hw_data * pHwData,  u16 number,  u32 value );
+#define hal_get_time_count( _P )	(_P->time_count/10)	// return 100ms count
+#define hal_detect_error( _P )		(_P->WbUsb.DetectCount)
+
+//-------------------------------------------------------------------------
+// The follow function is unused for IS89C35
+//-------------------------------------------------------------------------
+#define hal_disable_interrupt(_A)
+#define hal_enable_interrupt(_A)
+#define hal_get_interrupt_type( _A)
+#define hal_get_clear_interrupt(_A)
+#define hal_ibss_disconnect(_A) hal_stop_sync_bss(_A)
+#define hal_join_request_stop(_A)
+unsigned char	hal_idle(  struct hw_data * pHwData );
+#define hw_get_cxx_reg( _A, _B, _C )
+#define hw_set_cxx_reg( _A, _B, _C )
+#define hw_get_dxx_reg( _A, _B, _C )	hal_get_dxx_reg( _A, _B, (u32 *)_C )
+#define hw_set_dxx_reg( _A, _B, _C )	hal_set_dxx_reg( _A, _B, (u32)_C )
+
 #endif
diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
deleted file mode 100644
index efcaefb..0000000
--- a/drivers/staging/winbond/wbhal_f.h
+++ /dev/null
@@ -1,91 +0,0 @@
-//=====================================================================
-// Device related include
-//=====================================================================
-#include "wb35reg_f.h"
-#include "wb35tx_f.h"
-#include "wb35rx_f.h"
-
-#include "core.h"
-
-//====================================================================================
-// Function declaration
-//====================================================================================
-void hal_remove_mapping_key(  struct hw_data * pHwData,  u8 *pmac_addr );
-void hal_remove_default_key(  struct hw_data * pHwData,  u32 index );
-unsigned char hal_set_mapping_key(  struct hw_data * adapter,  u8 *pmac_addr,  u8 null_key,  u8 wep_on,  u8 *ptx_tsc,  u8 *prx_tsc,  u8 key_type,  u8 key_len,  u8 *pkey_data );
-unsigned char hal_set_default_key(  struct hw_data * adapter,  u8 index,  u8 null_key,  u8 wep_on,  u8 *ptx_tsc,  u8 *prx_tsc,  u8 key_type,  u8 key_len,  u8 *pkey_data );
-void hal_clear_all_default_key(  struct hw_data * pHwData );
-void hal_clear_all_group_key(  struct hw_data * pHwData );
-void hal_clear_all_mapping_key(  struct hw_data * pHwData );
-void hal_clear_all_key(  struct hw_data * pHwData );
-void hal_get_ethernet_address(  struct hw_data * pHwData,  u8 *current_address );
-void hal_set_ethernet_address(  struct hw_data * pHwData,  u8 *current_address );
-void hal_get_permanent_address(  struct hw_data * pHwData,  u8 *pethernet_address );
-u8 hal_init_hardware(struct ieee80211_hw *hw);
-void hal_set_power_save_mode(  struct hw_data * pHwData,  unsigned char power_save,  unsigned char wakeup,  unsigned char dtim );
-void hal_get_power_save_mode(  struct hw_data * pHwData,   u8 *pin_pwr_save );
-void hal_set_slot_time(  struct hw_data * pHwData,  u8 type );
-#define hal_set_atim_window( _A, _ATM )
-void hal_start_bss(  struct hw_data * pHwData,  u8 mac_op_mode );
-void hal_join_request(  struct hw_data * pHwData,  u8 bss_type ); // 0:BSS STA 1:IBSS STA//
-void hal_stop_sync_bss(  struct hw_data * pHwData );
-void hal_resume_sync_bss(  struct hw_data * pHwData);
-void hal_set_aid(  struct hw_data * pHwData,  u16 aid );
-void hal_set_bssid(  struct hw_data * pHwData,  u8 *pbssid );
-void hal_get_bssid(  struct hw_data * pHwData,  u8 *pbssid );
-void hal_set_beacon_period(  struct hw_data * pHwData,  u16 beacon_period );
-void hal_set_listen_interval(  struct hw_data * pHwData,  u16 listen_interval );
-void hal_set_cap_info(  struct hw_data * pHwData,  u16 capability_info );
-void hal_set_ssid(  struct hw_data * pHwData,  u8 *pssid,  u8 ssid_len );
-void hal_set_current_channel(  struct hw_data * pHwData,  ChanInfo channel );
-void hal_set_accept_broadcast(  struct hw_data * pHwData,  u8 enable );
-void hal_set_accept_multicast(  struct hw_data * pHwData,  u8 enable );
-void hal_set_accept_beacon(  struct hw_data * pHwData,  u8 enable );
-void hal_stop(  struct hw_data * pHwData );
-void hal_halt(  struct hw_data * pHwData, void *ppa_data );
-void hal_start_tx0(  struct hw_data * pHwData );
-void hal_set_phy_type(  struct hw_data * pHwData,  u8 PhyType );
-#define hal_get_cwmin( _A ) ( (_A)->cwmin )
-void hal_set_cwmax(  struct hw_data * pHwData,  u16 cwin_max );
-#define hal_get_cwmax( _A ) ( (_A)->cwmax )
-void hal_set_rsn_wpa(  struct hw_data * pHwData,  u32 * RSN_IE_Bitmap , u32 * RSN_OUI_type , unsigned char bDesiredAuthMode);
-void hal_set_connect_info(  struct hw_data * pHwData,  unsigned char boConnect );
-u8 hal_get_est_sq3(  struct hw_data * pHwData,  u8 Count );
-void hal_set_rf_power(  struct hw_data * pHwData,  u8 PowerIndex ); // 20060621 Modify
-void hal_set_radio_mode(  struct hw_data * pHwData,  unsigned char boValue);
-void hal_descriptor_indicate(  struct hw_data * pHwData,  PDESCRIPTOR pDes );
-u8 hal_get_antenna_number(  struct hw_data * pHwData );
-u32 hal_get_bss_pk_cnt(  struct hw_data * pHwData );
-#define hal_get_region_from_EEPROM( _A ) ( (_A)->reg.EEPROMRegion )
-void hal_set_accept_promiscuous		(  struct hw_data * pHwData,  u8 enable);
-#define hal_get_tx_buffer( _A, _B ) Wb35Tx_get_tx_buffer( _A, _B )
-u8 hal_get_hw_radio_off			(  struct hw_data * pHwData );
-#define hal_software_set( _A )		(_A->SoftwareSet)
-#define hal_driver_init_OK( _A )	(_A->IsInitOK)
-#define hal_rssi_boundary_high( _A ) (_A->RSSI_high)
-#define hal_rssi_boundary_low( _A ) (_A->RSSI_low)
-#define hal_scan_interval( _A )		(_A->Scan_Interval)
-
-#define PHY_DEBUG( msg, args... )
-
-unsigned char hal_get_dxx_reg(  struct hw_data * pHwData,  u16 number,  u32 * pValue );
-unsigned char hal_set_dxx_reg(  struct hw_data * pHwData,  u16 number,  u32 value );
-#define hal_get_time_count( _P )	(_P->time_count/10)	// return 100ms count
-#define hal_detect_error( _P )		(_P->WbUsb.DetectCount)
-
-//-------------------------------------------------------------------------
-// The follow function is unused for IS89C35
-//-------------------------------------------------------------------------
-#define hal_disable_interrupt(_A)
-#define hal_enable_interrupt(_A)
-#define hal_get_interrupt_type( _A)
-#define hal_get_clear_interrupt(_A)
-#define hal_ibss_disconnect(_A) hal_stop_sync_bss(_A)
-#define hal_join_request_stop(_A)
-unsigned char	hal_idle(  struct hw_data * pHwData );
-#define hw_get_cxx_reg( _A, _B, _C )
-#define hw_set_cxx_reg( _A, _B, _C )
-#define hw_get_dxx_reg( _A, _B, _C )	hal_get_dxx_reg( _A, _B, (u32 *)_C )
-#define hw_set_dxx_reg( _A, _B, _C )	hal_set_dxx_reg( _A, _B, (u32)_C )
-
-
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 3f7d4e5..d72e066 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -10,7 +10,7 @@
 #include "mds_f.h"
 #include "mlmetxrx_f.h"
 #include "mto.h"
-#include "wbhal_f.h"
+#include "wbhal.h"
 #include "wblinux_f.h"
 
 MODULE_AUTHOR("Original by: Jeff Lee<YY_Lee@issc.com.tw> Adapted to 2.6.x by Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>");
-- 
1.5.4.3

