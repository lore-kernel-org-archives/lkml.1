Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXJLNFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXJLNFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXJLNFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:05:34 -0400
Received: from verein.lst.de ([213.95.11.210]:52138 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbXJLNFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:05:13 -0400
Date: Fri, 12 Oct 2007 15:05:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwl3945: cleanup namespace
Message-ID: <20071012130500.GA22610@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

prefix all symbols with iwl3945_ and thus allow building the driver into
the kernel.  Also remove all the useless default statements in Kconfig
while we're at it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-debug.h	2007-10-12 14:38:43.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-debug.h	2007-10-12 14:38:45.000000000 +0200
@@ -26,18 +26,18 @@
  *
  *****************************************************************************/
 
-#ifndef __iwl_debug_h__
-#define __iwl_debug_h__
+#ifndef __iwl3945_debug_h__
+#define __iwl3945_debug_h__
 
 #ifdef CONFIG_IWL3945_DEBUG
-extern u32 iwl_debug_level;
+extern u32 iwl3945_debug_level;
 #define IWL_DEBUG(level, fmt, args...) \
-do { if (iwl_debug_level & (level)) \
+do { if (iwl3945_debug_level & (level)) \
   printk(KERN_ERR DRV_NAME": %c %s " fmt, \
 	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
 
 #define IWL_DEBUG_LIMIT(level, fmt, args...) \
-do { if ((iwl_debug_level & (level)) && net_ratelimit()) \
+do { if ((iwl3945_debug_level & (level)) && net_ratelimit()) \
   printk(KERN_ERR DRV_NAME": %c %s " fmt, \
 	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
 #else
@@ -68,7 +68,7 @@ static inline void IWL_DEBUG_LIMIT(int l
  *
  * % cat /proc/net/iwl/debug_level
  *
- * you simply need to add your entry to the iwl_debug_levels array.
+ * you simply need to add your entry to the iwl3945_debug_levels array.
  *
  * If you do not see debug_level in /proc/net/iwl then you do not have
  * CONFIG_IWL3945_DEBUG defined in your kernel configuration
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-hw.h	2007-10-12 14:38:47.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-hw.h	2007-10-12 14:38:49.000000000 +0200
@@ -61,8 +61,8 @@
  *
  *****************************************************************************/
 
-#ifndef __iwl_3945_hw__
-#define __iwl_3945_hw__
+#ifndef __iwl3945_3945_hw__
+#define __iwl3945_3945_hw__
 
 /* uCode queue management definitions */
 #define IWL_CMD_QUEUE_NUM       4
@@ -127,7 +127,7 @@ enum {
 #define EEPROM_SKU_CAP_OP_MODE_MRC                      (1 << 7)
 
 /* *regulatory* channel data from eeprom, one for each channel */
-struct iwl_eeprom_channel {
+struct iwl3945_eeprom_channel {
 	u8 flags;		/* flags copied from EEPROM */
 	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
 } __attribute__ ((packed));
@@ -142,7 +142,7 @@ struct iwl_eeprom_channel {
  *   level.
  * Data copied from EEPROM.
  */
-struct iwl_eeprom_txpower_sample {
+struct iwl3945_eeprom_txpower_sample {
 	u8 gain_index;		/* index into power (gain) setup table ... */
 	s8 power;		/* ... for this pwr level for this chnl group */
 	u16 v_det;		/* PA output voltage */
@@ -156,8 +156,8 @@ struct iwl_eeprom_txpower_sample {
  * Data copied from EEPROM.
  * DO NOT ALTER THIS STRUCTURE!!!
  */
-struct iwl_eeprom_txpower_group {
-	struct iwl_eeprom_txpower_sample samples[5];	/* 5 power levels */
+struct iwl3945_eeprom_txpower_group {
+	struct iwl3945_eeprom_txpower_sample samples[5];	/* 5 power levels */
 	s32 a, b, c, d, e;	/* coefficients for voltage->power
 				 * formula (signed) */
 	s32 Fa, Fb, Fc, Fd, Fe;	/* these modify coeffs based on
@@ -175,7 +175,7 @@ struct iwl_eeprom_txpower_group {
  *   difference between current temperature and factory calib temperature.
  * Data copied from EEPROM.
  */
-struct iwl_eeprom_temperature_corr {
+struct iwl3945_eeprom_temperature_corr {
 	u32 Ta;
 	u32 Tb;
 	u32 Tc;
@@ -183,7 +183,7 @@ struct iwl_eeprom_temperature_corr {
 	u32 Te;
 } __attribute__ ((packed));
 
-struct iwl_eeprom {
+struct iwl3945_eeprom {
 	u8 reserved0[16];
 #define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
 	u16 device_id;	/* abs.ofs: 16 */
@@ -226,23 +226,23 @@ struct iwl_eeprom {
 #define EEPROM_REGULATORY_BAND_1            (2*0x62)	/* 2  bytes */
 	u16 band_1_count;	/* abs.ofs: 196 */
 #define EEPROM_REGULATORY_BAND_1_CHANNELS   (2*0x63)	/* 28 bytes */
-	struct iwl_eeprom_channel band_1_channels[14];	/* abs.ofs: 196 */
+	struct iwl3945_eeprom_channel band_1_channels[14];	/* abs.ofs: 196 */
 #define EEPROM_REGULATORY_BAND_2            (2*0x71)	/* 2  bytes */
 	u16 band_2_count;	/* abs.ofs: 226 */
 #define EEPROM_REGULATORY_BAND_2_CHANNELS   (2*0x72)	/* 26 bytes */
-	struct iwl_eeprom_channel band_2_channels[13];	/* abs.ofs: 228 */
+	struct iwl3945_eeprom_channel band_2_channels[13];	/* abs.ofs: 228 */
 #define EEPROM_REGULATORY_BAND_3            (2*0x7F)	/* 2  bytes */
 	u16 band_3_count;	/* abs.ofs: 254 */
 #define EEPROM_REGULATORY_BAND_3_CHANNELS   (2*0x80)	/* 24 bytes */
-	struct iwl_eeprom_channel band_3_channels[12];	/* abs.ofs: 256 */
+	struct iwl3945_eeprom_channel band_3_channels[12];	/* abs.ofs: 256 */
 #define EEPROM_REGULATORY_BAND_4            (2*0x8C)	/* 2  bytes */
 	u16 band_4_count;	/* abs.ofs: 280 */
 #define EEPROM_REGULATORY_BAND_4_CHANNELS   (2*0x8D)	/* 22 bytes */
-	struct iwl_eeprom_channel band_4_channels[11];	/* abs.ofs: 282 */
+	struct iwl3945_eeprom_channel band_4_channels[11];	/* abs.ofs: 282 */
 #define EEPROM_REGULATORY_BAND_5            (2*0x98)	/* 2  bytes */
 	u16 band_5_count;	/* abs.ofs: 304 */
 #define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
-	struct iwl_eeprom_channel band_5_channels[6];	/* abs.ofs: 306 */
+	struct iwl3945_eeprom_channel band_5_channels[6];	/* abs.ofs: 306 */
 
 	u8 reserved9[194];
 
@@ -252,10 +252,10 @@ struct iwl_eeprom {
 #define EEPROM_TXPOWER_CALIB_GROUP3 0x2c0
 #define EEPROM_TXPOWER_CALIB_GROUP4 0x300
 #define IWL_NUM_TX_CALIB_GROUPS 5
-	struct iwl_eeprom_txpower_group groups[IWL_NUM_TX_CALIB_GROUPS];
+	struct iwl3945_eeprom_txpower_group groups[IWL_NUM_TX_CALIB_GROUPS];
 /* abs.ofs: 512 */
 #define EEPROM_CALIB_TEMPERATURE_CORRECT 0x340
-	struct iwl_eeprom_temperature_corr corrections;	/* abs.ofs: 832 */
+	struct iwl3945_eeprom_temperature_corr corrections;	/* abs.ofs: 832 */
 	u8 reserved16[172];	/* fill out to full 1024 byte block */
 } __attribute__ ((packed));
 
@@ -338,7 +338,7 @@ enum {
 
 #define IWL_CMD_FAILED_MSK 0x40
 
-struct iwl_cmd_header {
+struct iwl3945_cmd_header {
 	u8 cmd;
 	u8 flags;
 	/* We have 15 LSB to use as we please (MSB indicates
@@ -370,7 +370,7 @@ struct iwl_cmd_header {
 /*
  * REPLY_ALIVE = 0x1 (response only, not a command)
  */
-struct iwl_alive_resp {
+struct iwl3945_alive_resp {
 	u8 ucode_minor;
 	u8 ucode_major;
 	__le16 reserved1;
@@ -384,7 +384,7 @@ struct iwl_alive_resp {
 	__le32 is_valid;
 } __attribute__ ((packed));
 
-struct iwl_init_alive_resp {
+struct iwl3945_init_alive_resp {
 	u8 ucode_minor;
 	u8 ucode_major;
 	__le16 reserved1;
@@ -407,7 +407,7 @@ union tsf {
 /*
  * REPLY_ERROR = 0x2 (response only, not a command)
  */
-struct iwl_error_resp {
+struct iwl3945_error_resp {
 	__le32 error_type;
 	u8 cmd_id;
 	u8 reserved1;
@@ -476,7 +476,7 @@ enum {
 /*
  * REPLY_RXON = 0x10 (command, has simple generic response)
  */
-struct iwl_rxon_cmd {
+struct iwl3945_rxon_cmd {
 	u8 node_addr[6];
 	__le16 reserved1;
 	u8 bssid_addr[6];
@@ -498,7 +498,7 @@ struct iwl_rxon_cmd {
 /*
  * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
  */
-struct iwl_rxon_assoc_cmd {
+struct iwl3945_rxon_assoc_cmd {
 	__le32 flags;
 	__le32 filter_flags;
 	u8 ofdm_basic_rates;
@@ -509,7 +509,7 @@ struct iwl_rxon_assoc_cmd {
 /*
  * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
  */
-struct iwl_rxon_time_cmd {
+struct iwl3945_rxon_time_cmd {
 	union tsf timestamp;
 	__le16 beacon_interval;
 	__le16 atim_window;
@@ -518,34 +518,34 @@ struct iwl_rxon_time_cmd {
 	__le16 reserved;
 } __attribute__ ((packed));
 
-struct iwl_tx_power {
+struct iwl3945_tx_power {
 	u8 tx_gain;		/* gain for analog radio */
 	u8 dsp_atten;		/* gain for DSP */
 } __attribute__ ((packed));
 
-struct iwl_power_per_rate {
+struct iwl3945_power_per_rate {
 	u8 rate;		/* plcp */
-	struct iwl_tx_power tpc;
+	struct iwl3945_tx_power tpc;
 	u8 reserved;
 } __attribute__ ((packed));
 
 /*
  * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
  */
-struct iwl_channel_switch_cmd {
+struct iwl3945_channel_switch_cmd {
 	u8 band;
 	u8 expect_beacon;
 	__le16 channel;
 	__le32 rxon_flags;
 	__le32 rxon_filter_flags;
 	__le32 switch_time;
-	struct iwl_power_per_rate power[IWL_MAX_RATES];
+	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
 } __attribute__ ((packed));
 
 /*
  * CHANNEL_SWITCH_NOTIFICATION = 0x73 (notification only, not a command)
  */
-struct iwl_csa_notification {
+struct iwl3945_csa_notification {
 	__le16 band;
 	__le16 channel;
 	__le32 status;		/* 0 - OK, 1 - fail */
@@ -556,7 +556,7 @@ struct iwl_csa_notification {
  * Quality-of-Service (QOS) Commands & Responses:
  *
  *****************************************************************************/
-struct iwl_ac_qos {
+struct iwl3945_ac_qos {
 	__le16 cw_min;
 	__le16 cw_max;
 	u8 aifsn;
@@ -578,9 +578,9 @@ struct iwl_ac_qos {
 /*
  * REPLY_QOS_PARAM = 0x13 (command, has simple generic response)
  */
-struct iwl_qosparam_cmd {
+struct iwl3945_qosparam_cmd {
 	__le32 qos_flags;
-	struct iwl_ac_qos ac[AC_NUM];
+	struct iwl3945_ac_qos ac[AC_NUM];
 } __attribute__ ((packed));
 
 /******************************************************************************
@@ -638,7 +638,7 @@ struct iwl_qosparam_cmd {
 #define RATE_MCS_ANT_B_MSK	0x8000
 #define RATE_MCS_ANT_AB_MSK	0xc000
 
-struct iwl_keyinfo {
+struct iwl3945_keyinfo {
 	__le16 key_flags;
 	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
 	u8 reserved1;
@@ -658,11 +658,11 @@ struct sta_id_modify {
 /*
  * REPLY_ADD_STA = 0x18 (command)
  */
-struct iwl_addsta_cmd {
+struct iwl3945_addsta_cmd {
 	u8 mode;
 	u8 reserved[3];
 	struct sta_id_modify sta;
-	struct iwl_keyinfo key;
+	struct iwl3945_keyinfo key;
 	__le32 station_flags;
 	__le32 station_flags_msk;
 	__le16 tid_disable_tx;
@@ -675,7 +675,7 @@ struct iwl_addsta_cmd {
 /*
  * REPLY_ADD_STA = 0x18 (response)
  */
-struct iwl_add_sta_resp {
+struct iwl3945_add_sta_resp {
 	u8 status;
 } __attribute__ ((packed));
 
@@ -687,7 +687,7 @@ struct iwl_add_sta_resp {
  *
  *****************************************************************************/
 
-struct iwl_rx_frame_stats {
+struct iwl3945_rx_frame_stats {
 	u8 phy_count;
 	u8 id;
 	u8 rssi;
@@ -697,7 +697,7 @@ struct iwl_rx_frame_stats {
 	u8 payload[0];
 } __attribute__ ((packed));
 
-struct iwl_rx_frame_hdr {
+struct iwl3945_rx_frame_hdr {
 	__le16 channel;
 	__le16 phy_flags;
 	u8 reserved1;
@@ -727,7 +727,7 @@ struct iwl_rx_frame_hdr {
 #define	RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
 #define	RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
 
-struct iwl_rx_frame_end {
+struct iwl3945_rx_frame_end {
 	__le32 status;
 	__le64 timestamp;
 	__le32 beacon_timestamp;
@@ -741,10 +741,10 @@ struct iwl_rx_frame_end {
  * The actual offsets of the hdr and end are dynamic based on
  * stats.phy_count
  */
-struct iwl_rx_frame {
-	struct iwl_rx_frame_stats stats;
-	struct iwl_rx_frame_hdr hdr;
-	struct iwl_rx_frame_end end;
+struct iwl3945_rx_frame {
+	struct iwl3945_rx_frame_stats stats;
+	struct iwl3945_rx_frame_hdr hdr;
+	struct iwl3945_rx_frame_end end;
 } __attribute__ ((packed));
 
 /* Fixed (non-configurable) rx data from phy */
@@ -839,7 +839,7 @@ struct iwl4965_rx_mpdu_res_start {
  * TX command Frame life time
  */
 
-struct iwl_dram_scratch {
+struct iwl3945_dram_scratch {
 	u8 try_cnt;
 	u8 bt_kill_cnt;
 	__le16 reserved;
@@ -848,7 +848,7 @@ struct iwl_dram_scratch {
 /*
  * REPLY_TX = 0x1c (command)
  */
-struct iwl_tx_cmd {
+struct iwl3945_tx_cmd {
 	__le16 len;
 	__le16 next_frame_len;
 	__le32 tx_flags;
@@ -980,7 +980,7 @@ enum {
 /*
  * REPLY_TX = 0x1c (response)
  */
-struct iwl_tx_resp {
+struct iwl3945_tx_resp {
 	u8 failure_rts;
 	u8 failure_frame;
 	u8 bt_kill_count;
@@ -992,7 +992,7 @@ struct iwl_tx_resp {
 /*
  * REPLY_COMPRESSED_BA = 0xc5 (response only, not a command)
  */
-struct iwl_compressed_ba_resp {
+struct iwl3945_compressed_ba_resp {
 	__le32 sta_addr_lo32;
 	__le16 sta_addr_hi16;
 	__le16 reserved;
@@ -1008,21 +1008,21 @@ struct iwl_compressed_ba_resp {
 /*
  * REPLY_TX_PWR_TABLE_CMD = 0x97 (command, has simple generic response)
  */
-struct iwl_txpowertable_cmd {
+struct iwl3945_txpowertable_cmd {
 	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
 	u8 reserved;
 	__le16 channel;
-	struct iwl_power_per_rate power[IWL_MAX_RATES];
+	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
 } __attribute__ ((packed));
 
-struct iwl_rate_scaling_info {
+struct iwl3945_rate_scaling_info {
 	__le16 rate_n_flags;
 	u8 try_cnt;
 	u8 next_rate_index;
 } __attribute__ ((packed));
 
 /**
- * struct iwl_rate_scaling_cmd - Rate Scaling Command & Response
+ * struct iwl3945_rate_scaling_cmd - Rate Scaling Command & Response
  *
  * REPLY_RATE_SCALE = 0x47 (command, has simple generic response)
  *
@@ -1036,16 +1036,16 @@ struct iwl_rate_scaling_info {
  * when passed through ofdm_basic_rates on the REPLY_RXON
  * command would be bit 0 (1<<0)
  */
-struct iwl_rate_scaling_cmd {
+struct iwl3945_rate_scaling_cmd {
 	u8 table_id;
 	u8 reserved[3];
-	struct iwl_rate_scaling_info table[IWL_MAX_RATES];
+	struct iwl3945_rate_scaling_info table[IWL_MAX_RATES];
 } __attribute__ ((packed));
 
 /*
  * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
  */
-struct iwl_bt_cmd {
+struct iwl3945_bt_cmd {
 	u8 flags;
 	u8 lead_time;
 	u8 max_kill;
@@ -1071,18 +1071,18 @@ struct iwl_bt_cmd {
 				 RXON_FILTER_ASSOC_MSK           | \
 				 RXON_FILTER_BCON_AWARE_MSK)
 
-struct iwl_measure_channel {
+struct iwl3945_measure_channel {
 	__le32 duration;	/* measurement duration in extended beacon
 				 * format */
 	u8 channel;		/* channel to measure */
-	u8 type;		/* see enum iwl_measure_type */
+	u8 type;		/* see enum iwl3945_measure_type */
 	__le16 reserved;
 } __attribute__ ((packed));
 
 /*
  * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (command)
  */
-struct iwl_spectrum_cmd {
+struct iwl3945_spectrum_cmd {
 	__le16 len;		/* number of bytes starting from token */
 	u8 token;		/* token id */
 	u8 id;			/* measurement id -- 0 or 1 */
@@ -1095,13 +1095,13 @@ struct iwl_spectrum_cmd {
 	__le32 filter_flags;	/* rxon filter flags */
 	__le16 channel_count;	/* minimum 1, maximum 10 */
 	__le16 reserved3;
-	struct iwl_measure_channel channels[10];
+	struct iwl3945_measure_channel channels[10];
 } __attribute__ ((packed));
 
 /*
  * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (response)
  */
-struct iwl_spectrum_resp {
+struct iwl3945_spectrum_resp {
 	u8 token;
 	u8 id;			/* id of the prior command replaced, or 0xff */
 	__le16 status;		/* 0 - command will be handled
@@ -1109,12 +1109,12 @@ struct iwl_spectrum_resp {
 				 *     measurement) */
 } __attribute__ ((packed));
 
-enum iwl_measurement_state {
+enum iwl3945_measurement_state {
 	IWL_MEASUREMENT_START = 0,
 	IWL_MEASUREMENT_STOP = 1,
 };
 
-enum iwl_measurement_status {
+enum iwl3945_measurement_status {
 	IWL_MEASUREMENT_OK = 0,
 	IWL_MEASUREMENT_CONCURRENT = 1,
 	IWL_MEASUREMENT_CSA_CONFLICT = 2,
@@ -1127,18 +1127,18 @@ enum iwl_measurement_status {
 
 #define NUM_ELEMENTS_IN_HISTOGRAM 8
 
-struct iwl_measurement_histogram {
+struct iwl3945_measurement_histogram {
 	__le32 ofdm[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 0.8usec counts */
 	__le32 cck[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 1usec counts */
 } __attribute__ ((packed));
 
 /* clear channel availability counters */
-struct iwl_measurement_cca_counters {
+struct iwl3945_measurement_cca_counters {
 	__le32 ofdm;
 	__le32 cck;
 } __attribute__ ((packed));
 
-enum iwl_measure_type {
+enum iwl3945_measure_type {
 	IWL_MEASURE_BASIC = (1 << 0),
 	IWL_MEASURE_CHANNEL_LOAD = (1 << 1),
 	IWL_MEASURE_HISTOGRAM_RPI = (1 << 2),
@@ -1151,7 +1151,7 @@ enum iwl_measure_type {
 /*
  * SPECTRUM_MEASURE_NOTIFICATION = 0x75 (notification only, not a command)
  */
-struct iwl_spectrum_notification {
+struct iwl3945_spectrum_notification {
 	u8 id;			/* measurement id -- 0 or 1 */
 	u8 token;
 	u8 channel_index;	/* index in measurement channel list */
@@ -1159,7 +1159,7 @@ struct iwl_spectrum_notification {
 	__le32 start_time;	/* lower 32-bits of TSF */
 	u8 band;		/* 0 - 5.2GHz, 1 - 2.4GHz */
 	u8 channel;
-	u8 type;		/* see enum iwl_measurement_type */
+	u8 type;		/* see enum iwl3945_measurement_type */
 	u8 reserved1;
 	/* NOTE:  cca_ofdm, cca_cck, basic_type, and histogram are only only
 	 * valid if applicable for measurement type requested. */
@@ -1169,9 +1169,9 @@ struct iwl_spectrum_notification {
 	u8 basic_type;		/* 0 - bss, 1 - ofdm preamble, 2 -
 				 * unidentified */
 	u8 reserved2[3];
-	struct iwl_measurement_histogram histogram;
+	struct iwl3945_measurement_histogram histogram;
 	__le32 stop_time;	/* lower 32-bits of TSF */
-	__le32 status;		/* see iwl_measurement_status */
+	__le32 status;		/* see iwl3945_measurement_status */
 } __attribute__ ((packed));
 
 /******************************************************************************
@@ -1181,7 +1181,7 @@ struct iwl_spectrum_notification {
  *****************************************************************************/
 
 /**
- * struct iwl_powertable_cmd - Power Table Command
+ * struct iwl3945_powertable_cmd - Power Table Command
  * @flags: See below:
  *
  * POWER_TABLE_CMD = 0x77 (command, has simple generic response)
@@ -1213,7 +1213,7 @@ struct iwl_spectrum_notification {
 #define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le32(1<<0)
 #define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le32(1<<2)
 #define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le32(1<<3)
-struct iwl_powertable_cmd {
+struct iwl3945_powertable_cmd {
 	__le32 flags;
 	__le32 rx_data_timeout;
 	__le32 tx_data_timeout;
@@ -1224,7 +1224,7 @@ struct iwl_powertable_cmd {
  * PM_SLEEP_NOTIFICATION = 0x7A (notification only, not a command)
  * 3945 and 4965 identical.
  */
-struct iwl_sleep_notification {
+struct iwl3945_sleep_notification {
 	u8 pm_sleep_mode;
 	u8 pm_wakeup_src;
 	__le16 reserved;
@@ -1254,14 +1254,14 @@ enum {
 #define CARD_STATE_CMD_DISABLE 0x00	/* Put card to sleep */
 #define CARD_STATE_CMD_ENABLE  0x01	/* Wake up card */
 #define CARD_STATE_CMD_HALT    0x02	/* Power down permanently */
-struct iwl_card_state_cmd {
+struct iwl3945_card_state_cmd {
 	__le32 status;		/* CARD_STATE_CMD_* request new power state */
 } __attribute__ ((packed));
 
 /*
  * CARD_STATE_NOTIFICATION = 0xa1 (notification only, not a command)
  */
-struct iwl_card_state_notif {
+struct iwl3945_card_state_notif {
 	__le32 flags;
 } __attribute__ ((packed));
 
@@ -1270,7 +1270,7 @@ struct iwl_card_state_notif {
 #define RF_CARD_DISABLED   0x04
 #define RXON_CARD_DISABLED 0x10
 
-struct iwl_ct_kill_config {
+struct iwl3945_ct_kill_config {
 	__le32   reserved;
 	__le32   critical_temperature_M;
 	__le32   critical_temperature_R;
@@ -1282,7 +1282,7 @@ struct iwl_ct_kill_config {
  *
  *****************************************************************************/
 
-struct iwl_scan_channel {
+struct iwl3945_scan_channel {
 	/* type is defined as:
 	 * 0:0 active (0 - passive)
 	 * 1:4 SSID direct
@@ -1291,12 +1291,12 @@ struct iwl_scan_channel {
 	 */
 	u8 type;
 	u8 channel;
-	struct iwl_tx_power tpc;
+	struct iwl3945_tx_power tpc;
 	__le16 active_dwell;
 	__le16 passive_dwell;
 } __attribute__ ((packed));
 
-struct iwl_ssid_ie {
+struct iwl3945_ssid_ie {
 	u8 id;
 	u8 len;
 	u8 ssid[32];
@@ -1310,7 +1310,7 @@ struct iwl_ssid_ie {
 /*
  * REPLY_SCAN_CMD = 0x80 (command)
  */
-struct iwl_scan_cmd {
+struct iwl3945_scan_cmd {
 	__le16 len;
 	u8 reserved0;
 	u8 channel_count;
@@ -1329,14 +1329,14 @@ struct iwl_scan_cmd {
 	__le32 flags;
 	__le32 filter_flags;
 
-	struct iwl_tx_cmd tx_cmd;
-	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
+	struct iwl3945_tx_cmd tx_cmd;
+	struct iwl3945_ssid_ie direct_scan[PROBE_OPTION_MAX];
 
 	u8 data[0];
 	/*
 	 * The channels start after the probe request payload and are of type:
 	 *
-	 * struct iwl_scan_channel channels[0];
+	 * struct iwl3945_scan_channel channels[0];
 	 *
 	 * NOTE:  Only one band of channels can be scanned per pass.  You
 	 * can not mix 2.4GHz channels and 5.2GHz channels and must
@@ -1353,14 +1353,14 @@ struct iwl_scan_cmd {
 /*
  * REPLY_SCAN_CMD = 0x80 (response)
  */
-struct iwl_scanreq_notification {
+struct iwl3945_scanreq_notification {
 	__le32 status;		/* 1: okay, 2: cannot fulfill request */
 } __attribute__ ((packed));
 
 /*
  * SCAN_START_NOTIFICATION = 0x82 (notification only, not a command)
  */
-struct iwl_scanstart_notification {
+struct iwl3945_scanstart_notification {
 	__le32 tsf_low;
 	__le32 tsf_high;
 	__le32 beacon_timer;
@@ -1377,7 +1377,7 @@ struct iwl_scanstart_notification {
 /*
  * SCAN_RESULTS_NOTIFICATION = 0x83 (notification only, not a command)
  */
-struct iwl_scanresults_notification {
+struct iwl3945_scanresults_notification {
 	u8 channel;
 	u8 band;
 	u8 reserved[2];
@@ -1389,7 +1389,7 @@ struct iwl_scanresults_notification {
 /*
  * SCAN_COMPLETE_NOTIFICATION = 0x84 (notification only, not a command)
  */
-struct iwl_scancomplete_notification {
+struct iwl3945_scancomplete_notification {
 	u8 scanned_channels;
 	u8 status;
 	u8 reserved;
@@ -1408,8 +1408,8 @@ struct iwl_scancomplete_notification {
 /*
  * BEACON_NOTIFICATION = 0x90 (notification only, not a command)
  */
-struct iwl_beacon_notif {
-	struct iwl_tx_resp beacon_notify_hdr;
+struct iwl3945_beacon_notif {
+	struct iwl3945_tx_resp beacon_notify_hdr;
 	__le32 low_tsf;
 	__le32 high_tsf;
 	__le32 ibss_mgr_status;
@@ -1418,8 +1418,8 @@ struct iwl_beacon_notif {
 /*
  * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
  */
-struct iwl_tx_beacon_cmd {
-	struct iwl_tx_cmd tx;
+struct iwl3945_tx_beacon_cmd {
+	struct iwl3945_tx_cmd tx;
 	__le16 tim_idx;
 	u8 tim_size;
 	u8 reserved1;
@@ -1541,7 +1541,7 @@ struct statistics_general {
  */
 #define IWL_STATS_CONF_CLEAR_STATS __constant_cpu_to_le32(0x1)	/* see above */
 #define IWL_STATS_CONF_DISABLE_NOTIF __constant_cpu_to_le32(0x2)/* see above */
-struct iwl_statistics_cmd {
+struct iwl3945_statistics_cmd {
 	__le32 configuration_flags;	/* IWL_STATS_CONF_* */
 } __attribute__ ((packed));
 
@@ -1562,7 +1562,7 @@ struct iwl_statistics_cmd {
  */
 #define STATISTICS_REPLY_FLG_BAND_24G_MSK         __constant_cpu_to_le32(0x2)
 #define STATISTICS_REPLY_FLG_FAT_MODE_MSK         __constant_cpu_to_le32(0x8)
-struct iwl_notif_statistics {
+struct iwl3945_notif_statistics {
 	__le32 flag;
 	struct statistics_rx rx;
 	struct statistics_tx tx;
@@ -1577,7 +1577,7 @@ struct iwl_notif_statistics {
  * then this notification will be sent. */
 #define CONSECUTIVE_MISSED_BCONS_TH 20
 
-struct iwl_missed_beacon_notif {
+struct iwl3945_missed_beacon_notif {
 	__le32 consequtive_missed_beacons;
 	__le32 total_missed_becons;
 	__le32 num_expected_beacons;
@@ -1593,12 +1593,12 @@ struct iwl_missed_beacon_notif {
 #define PHY_CALIBRATE_DIFF_GAIN_CMD (7)
 #define HD_TABLE_SIZE  (11)
 
-struct iwl_sensitivity_cmd {
+struct iwl3945_sensitivity_cmd {
 	__le16 control;
 	__le16 table[HD_TABLE_SIZE];
 } __attribute__ ((packed));
 
-struct iwl_calibration_cmd {
+struct iwl3945_calibration_cmd {
 	u8 opCode;
 	u8 flags;
 	__le16 reserved;
@@ -1621,7 +1621,7 @@ struct iwl_calibration_cmd {
  * For each of 3 possible LEDs (Activity/Link/Tech, selected by "id" field),
  * this command turns it on or off, or sets up a periodic blinking cycle.
  */
-struct iwl_led_cmd {
+struct iwl3945_led_cmd {
 	__le32 interval;	/* "interval" in uSec */
 	u8 id;			/* 1: Activity, 2: Link, 3: Tech */
 	u8 off;			/* # intervals off while blinking;
@@ -1637,28 +1637,28 @@ struct iwl_led_cmd {
  *
  *****************************************************************************/
 
-struct iwl_rx_packet {
+struct iwl3945_rx_packet {
 	__le32 len;
-	struct iwl_cmd_header hdr;
+	struct iwl3945_cmd_header hdr;
 	union {
-		struct iwl_alive_resp alive_frame;
-		struct iwl_rx_frame rx_frame;
-		struct iwl_tx_resp tx_resp;
-		struct iwl_spectrum_notification spectrum_notif;
-		struct iwl_csa_notification csa_notif;
-		struct iwl_error_resp err_resp;
-		struct iwl_card_state_notif card_state_notif;
-		struct iwl_beacon_notif beacon_status;
-		struct iwl_add_sta_resp add_sta;
-		struct iwl_sleep_notification sleep_notif;
-		struct iwl_spectrum_resp spectrum;
-		struct iwl_notif_statistics stats;
+		struct iwl3945_alive_resp alive_frame;
+		struct iwl3945_rx_frame rx_frame;
+		struct iwl3945_tx_resp tx_resp;
+		struct iwl3945_spectrum_notification spectrum_notif;
+		struct iwl3945_csa_notification csa_notif;
+		struct iwl3945_error_resp err_resp;
+		struct iwl3945_card_state_notif card_state_notif;
+		struct iwl3945_beacon_notif beacon_status;
+		struct iwl3945_add_sta_resp add_sta;
+		struct iwl3945_sleep_notification sleep_notif;
+		struct iwl3945_spectrum_resp spectrum;
+		struct iwl3945_notif_statistics stats;
 		__le32 status;
 		u8 raw[0];
 	} u;
 } __attribute__ ((packed));
 
-#define IWL_RX_FRAME_SIZE        (4 + sizeof(struct iwl_rx_frame))
+#define IWL_RX_FRAME_SIZE        (4 + sizeof(struct iwl3945_rx_frame))
 
 #define PCI_LINK_CTRL      0x0F0
 #define PCI_POWER_SOURCE   0x0C8
@@ -2070,8 +2070,8 @@ struct iwl_rx_packet {
 #define TFD_TX_CMD_SLOTS 256
 #define TFD_CMD_SLOTS 32
 
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
-			      sizeof(struct iwl_cmd_meta))
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl3945_cmd) - \
+			      sizeof(struct iwl3945_cmd_meta))
 
 /*
  * RX related structures and functions
@@ -2092,41 +2092,41 @@ struct iwl_rx_packet {
 #define IWL_MAX_DATA_SIZE ALM_RTC_DATA_SIZE
 #define IWL_MAX_NUM_QUEUES	8
 
-static inline int iwl_hw_valid_rtc_data_addr(u32 addr)
+static inline int iwl3945_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= RTC_DATA_LOWER_BOUND) &&
 	       (addr < ALM_RTC_DATA_UPPER_BOUND);
 }
 
-/* Base physical address of iwl_shared is provided to FH_TSSR_CBB_BASE
- * and &iwl_shared.rx_read_ptr[0] is provided to FH_RCSR_RPTR_ADDR(0) */
-struct iwl_shared {
+/* Base physical address of iwl3945_shared is provided to FH_TSSR_CBB_BASE
+ * and &iwl3945_shared.rx_read_ptr[0] is provided to FH_RCSR_RPTR_ADDR(0) */
+struct iwl3945_shared {
 	__le32 tx_base_ptr[8];
 	__le32 rx_read_ptr[3];
 } __attribute__ ((packed));
 
-struct iwl_tfd_frame_data {
+struct iwl3945_tfd_frame_data {
 	__le32 addr;
 	__le32 len;
 } __attribute__ ((packed));
 
-struct iwl_tfd_frame {
+struct iwl3945_tfd_frame {
 	__le32 control_flags;
-	struct iwl_tfd_frame_data pa[4];
+	struct iwl3945_tfd_frame_data pa[4];
 	u8 reserved[28];
 } __attribute__ ((packed));
 
-static inline u8 iwl_hw_get_rate(__le16 rate_n_flags)
+static inline u8 iwl3945_hw_get_rate(__le16 rate_n_flags)
 {
 	return le16_to_cpu(rate_n_flags) & 0xFF;
 }
 
-static inline u16 iwl_hw_get_rate_n_flags(__le16 rate_n_flags)
+static inline u16 iwl3945_hw_get_rate_n_flags(__le16 rate_n_flags)
 {
 	return le16_to_cpu(rate_n_flags);
 }
 
-static inline __le16 iwl_hw_set_rate_n_flags(u8 rate, u16 flags)
+static inline __le16 iwl3945_hw_set_rate_n_flags(u8 rate, u16 flags)
 {
 	return cpu_to_le16((u16)rate|flags);
 }
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-io.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-io.h	2007-10-12 14:38:52.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-io.h	2007-10-12 14:38:53.000000000 +0200
@@ -26,8 +26,8 @@
  *
  *****************************************************************************/
 
-#ifndef __iwl_io_h__
-#define __iwl_io_h__
+#ifndef __iwl3945_io_h__
+#define __iwl3945_io_h__
 
 #include <linux/io.h>
 
@@ -50,8 +50,8 @@
  *
  * If you wish to call the function without any debug or state checking,
  * you should use the single _ prefix version (as is used by dependent IO
- * routines, for example _iwl_read_restricted calls the non-check version of
- * _iwl_read32.)
+ * routines, for example _iwl3945_read_restricted calls the non-check version of
+ * _iwl3945_read32.)
  *
  * These declarations are *extremely* useful in quickly isolating code deltas
  * which result in misconfiguring of the hardware I/O.  In combination with
@@ -60,40 +60,40 @@
  *
  */
 
-#define _iwl_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
+#define _iwl3945_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
+static inline void __iwl3945_write32(const char *f, u32 l, struct iwl3945_priv *iwl,
 				 u32 ofs, u32 val)
 {
 	IWL_DEBUG_IO("write_direct32(0x%08X, 0x%08X) - %s %d\n",
 		     (u32) (ofs), (u32) (val), f, l);
-	_iwl_write32(iwl, ofs, val);
+	_iwl3945_write32(iwl, ofs, val);
 }
-#define iwl_write32(iwl, ofs, val) \
-	__iwl_write32(__FILE__, __LINE__, iwl, ofs, val)
+#define iwl3945_write32(iwl, ofs, val) \
+	__iwl3945_write32(__FILE__, __LINE__, iwl, ofs, val)
 #else
-#define iwl_write32(iwl, ofs, val) _iwl_write32(iwl, ofs, val)
+#define iwl3945_write32(iwl, ofs, val) _iwl3945_write32(iwl, ofs, val)
 #endif
 
-#define _iwl_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
+#define _iwl3945_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
 #ifdef CONFIG_IWL3945_DEBUG
-static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *iwl, u32 ofs)
+static inline u32 __iwl3945_read32(char *f, u32 l, struct iwl3945_priv *iwl, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
-	return _iwl_read32(iwl, ofs);
+	return _iwl3945_read32(iwl, ofs);
 }
-#define iwl_read32(iwl, ofs) __iwl_read32(__FILE__, __LINE__, iwl, ofs)
+#define iwl3945_read32(iwl, ofs) __iwl3945_read32(__FILE__, __LINE__, iwl, ofs)
 #else
-#define iwl_read32(p, o) _iwl_read32(p, o)
+#define iwl3945_read32(p, o) _iwl3945_read32(p, o)
 #endif
 
-static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
+static inline int _iwl3945_poll_bit(struct iwl3945_priv *priv, u32 addr,
 				u32 bits, u32 mask, int timeout)
 {
 	int i = 0;
 
 	do {
-		if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
+		if ((_iwl3945_read32(priv, addr) & mask) == (bits & mask))
 			return i;
 		mdelay(10);
 		i += 10;
@@ -102,11 +102,11 @@ static inline int _iwl_poll_bit(struct i
 	return -ETIMEDOUT;
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static inline int __iwl_poll_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 addr,
+static inline int __iwl3945_poll_bit(const char *f, u32 l,
+				 struct iwl3945_priv *priv, u32 addr,
 				 u32 bits, u32 mask, int timeout)
 {
-	int rc = _iwl_poll_bit(priv, addr, bits, mask, timeout);
+	int rc = _iwl3945_poll_bit(priv, addr, bits, mask, timeout);
 	if (unlikely(rc == -ETIMEDOUT))
 		IWL_DEBUG_IO
 		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) - timedout - %s %d\n",
@@ -117,47 +117,47 @@ static inline int __iwl_poll_bit(const c
 		     addr, bits, mask, rc, f, l);
 	return rc;
 }
-#define iwl_poll_bit(iwl, addr, bits, mask, timeout) \
-	__iwl_poll_bit(__FILE__, __LINE__, iwl, addr, bits, mask, timeout)
+#define iwl3945_poll_bit(iwl, addr, bits, mask, timeout) \
+	__iwl3945_poll_bit(__FILE__, __LINE__, iwl, addr, bits, mask, timeout)
 #else
-#define iwl_poll_bit(p, a, b, m, t) _iwl_poll_bit(p, a, b, m, t)
+#define iwl3945_poll_bit(p, a, b, m, t) _iwl3945_poll_bit(p, a, b, m, t)
 #endif
 
-static inline void _iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+static inline void _iwl3945_set_bit(struct iwl3945_priv *priv, u32 reg, u32 mask)
 {
-	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
+	_iwl3945_write32(priv, reg, _iwl3945_read32(priv, reg) | mask);
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl_set_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 reg, u32 mask)
+static inline void __iwl3945_set_bit(const char *f, u32 l,
+				 struct iwl3945_priv *priv, u32 reg, u32 mask)
 {
-	u32 val = _iwl_read32(priv, reg) | mask;
+	u32 val = _iwl3945_read32(priv, reg) | mask;
 	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl_write32(priv, reg, val);
+	_iwl3945_write32(priv, reg, val);
 }
-#define iwl_set_bit(p, r, m) __iwl_set_bit(__FILE__, __LINE__, p, r, m)
+#define iwl3945_set_bit(p, r, m) __iwl3945_set_bit(__FILE__, __LINE__, p, r, m)
 #else
-#define iwl_set_bit(p, r, m) _iwl_set_bit(p, r, m)
+#define iwl3945_set_bit(p, r, m) _iwl3945_set_bit(p, r, m)
 #endif
 
-static inline void _iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+static inline void _iwl3945_clear_bit(struct iwl3945_priv *priv, u32 reg, u32 mask)
 {
-	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
+	_iwl3945_write32(priv, reg, _iwl3945_read32(priv, reg) & ~mask);
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl_clear_bit(const char *f, u32 l,
-				   struct iwl_priv *priv, u32 reg, u32 mask)
+static inline void __iwl3945_clear_bit(const char *f, u32 l,
+				   struct iwl3945_priv *priv, u32 reg, u32 mask)
 {
-	u32 val = _iwl_read32(priv, reg) & ~mask;
+	u32 val = _iwl3945_read32(priv, reg) & ~mask;
 	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl_write32(priv, reg, val);
+	_iwl3945_write32(priv, reg, val);
 }
-#define iwl_clear_bit(p, r, m) __iwl_clear_bit(__FILE__, __LINE__, p, r, m)
+#define iwl3945_clear_bit(p, r, m) __iwl3945_clear_bit(__FILE__, __LINE__, p, r, m)
 #else
-#define iwl_clear_bit(p, r, m) _iwl_clear_bit(p, r, m)
+#define iwl3945_clear_bit(p, r, m) _iwl3945_clear_bit(p, r, m)
 #endif
 
-static inline int _iwl_grab_restricted_access(struct iwl_priv *priv)
+static inline int _iwl3945_grab_restricted_access(struct iwl3945_priv *priv)
 {
 	int rc;
 	u32 gp_ctl;
@@ -172,7 +172,7 @@ static inline int _iwl_grab_restricted_a
 			"wakes up NIC\n");
 
 		/* 10 msec allows time for NIC to complete its data save */
-		gp_ctl = _iwl_read32(priv, CSR_GP_CNTRL);
+		gp_ctl = _iwl3945_read32(priv, CSR_GP_CNTRL);
 		if (gp_ctl & CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY) {
 			IWL_DEBUG_RF_KILL("Wait for complete power-down, "
 				"gpctl = 0x%08x\n", gp_ctl);
@@ -183,8 +183,8 @@ static inline int _iwl_grab_restricted_a
 	}
 
 	/* this bit wakes up the NIC */
-	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	rc = _iwl_poll_bit(priv, CSR_GP_CNTRL,
+	_iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	rc = _iwl3945_poll_bit(priv, CSR_GP_CNTRL,
 			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
@@ -200,8 +200,8 @@ static inline int _iwl_grab_restricted_a
 }
 
 #ifdef CONFIG_IWL3945_DEBUG
-static inline int __iwl_grab_restricted_access(const char *f, u32 l,
-					       struct iwl_priv *priv)
+static inline int __iwl3945_grab_restricted_access(const char *f, u32 l,
+					       struct iwl3945_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt))
 		IWL_DEBUG_INFO("Grabbing access while already held at "
@@ -209,98 +209,98 @@ static inline int __iwl_grab_restricted_
 
 	IWL_DEBUG_IO("grabbing restricted access - %s %d\n", f, l);
 
-	return _iwl_grab_restricted_access(priv);
+	return _iwl3945_grab_restricted_access(priv);
 }
-#define iwl_grab_restricted_access(priv) \
-	__iwl_grab_restricted_access(__FILE__, __LINE__, priv)
+#define iwl3945_grab_restricted_access(priv) \
+	__iwl3945_grab_restricted_access(__FILE__, __LINE__, priv)
 #else
-#define iwl_grab_restricted_access(priv) \
-	_iwl_grab_restricted_access(priv)
+#define iwl3945_grab_restricted_access(priv) \
+	_iwl3945_grab_restricted_access(priv)
 #endif
 
-static inline void _iwl_release_restricted_access(struct iwl_priv *priv)
+static inline void _iwl3945_release_restricted_access(struct iwl3945_priv *priv)
 {
 #ifdef CONFIG_IWL3945_DEBUG
 	if (atomic_dec_and_test(&priv->restrict_refcnt))
 #endif
-		_iwl_clear_bit(priv, CSR_GP_CNTRL,
+		_iwl3945_clear_bit(priv, CSR_GP_CNTRL,
 			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl_release_restricted_access(const char *f, u32 l,
-						   struct iwl_priv *priv)
+static inline void __iwl3945_release_restricted_access(const char *f, u32 l,
+						   struct iwl3945_priv *priv)
 {
 	if (atomic_read(&priv->restrict_refcnt) <= 0)
 		IWL_ERROR("Release unheld restricted access at line %d.\n", l);
 
 	IWL_DEBUG_IO("releasing restricted access - %s %d\n", f, l);
-	_iwl_release_restricted_access(priv);
+	_iwl3945_release_restricted_access(priv);
 }
-#define iwl_release_restricted_access(priv) \
-	__iwl_release_restricted_access(__FILE__, __LINE__, priv)
+#define iwl3945_release_restricted_access(priv) \
+	__iwl3945_release_restricted_access(__FILE__, __LINE__, priv)
 #else
-#define iwl_release_restricted_access(priv) \
-	_iwl_release_restricted_access(priv)
+#define iwl3945_release_restricted_access(priv) \
+	_iwl3945_release_restricted_access(priv)
 #endif
 
-static inline u32 _iwl_read_restricted(struct iwl_priv *priv, u32 reg)
+static inline u32 _iwl3945_read_restricted(struct iwl3945_priv *priv, u32 reg)
 {
-	return _iwl_read32(priv, reg);
+	return _iwl3945_read32(priv, reg);
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static inline u32 __iwl_read_restricted(const char *f, u32 l,
-					struct iwl_priv *priv, u32 reg)
+static inline u32 __iwl3945_read_restricted(const char *f, u32 l,
+					struct iwl3945_priv *priv, u32 reg)
 {
-	u32 value = _iwl_read_restricted(priv, reg);
+	u32 value = _iwl3945_read_restricted(priv, reg);
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from %s %d\n", f, l);
 	IWL_DEBUG_IO("read_restricted(0x%4X) = 0x%08x - %s %d \n", reg, value,
 		     f, l);
 	return value;
 }
-#define iwl_read_restricted(priv, reg) \
-	__iwl_read_restricted(__FILE__, __LINE__, priv, reg)
+#define iwl3945_read_restricted(priv, reg) \
+	__iwl3945_read_restricted(__FILE__, __LINE__, priv, reg)
 #else
-#define iwl_read_restricted _iwl_read_restricted
+#define iwl3945_read_restricted _iwl3945_read_restricted
 #endif
 
-static inline void _iwl_write_restricted(struct iwl_priv *priv,
+static inline void _iwl3945_write_restricted(struct iwl3945_priv *priv,
 					 u32 reg, u32 value)
 {
-	_iwl_write32(priv, reg, value);
+	_iwl3945_write32(priv, reg, value);
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static void __iwl_write_restricted(u32 line,
-				   struct iwl_priv *priv, u32 reg, u32 value)
+static void __iwl3945_write_restricted(u32 line,
+				   struct iwl3945_priv *priv, u32 reg, u32 value)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_write_restricted(priv, reg, value);
+	_iwl3945_write_restricted(priv, reg, value);
 }
-#define iwl_write_restricted(priv, reg, value) \
-	__iwl_write_restricted(__LINE__, priv, reg, value)
+#define iwl3945_write_restricted(priv, reg, value) \
+	__iwl3945_write_restricted(__LINE__, priv, reg, value)
 #else
-#define iwl_write_restricted _iwl_write_restricted
+#define iwl3945_write_restricted _iwl3945_write_restricted
 #endif
 
-static inline void iwl_write_buffer_restricted(struct iwl_priv *priv,
+static inline void iwl3945_write_buffer_restricted(struct iwl3945_priv *priv,
 					       u32 reg, u32 len, u32 *values)
 {
 	u32 count = sizeof(u32);
 
 	if ((priv != NULL) && (values != NULL)) {
 		for (; 0 < len; len -= count, reg += count, values++)
-			_iwl_write_restricted(priv, reg, *values);
+			_iwl3945_write_restricted(priv, reg, *values);
 	}
 }
 
-static inline int _iwl_poll_restricted_bit(struct iwl_priv *priv,
+static inline int _iwl3945_poll_restricted_bit(struct iwl3945_priv *priv,
 					   u32 addr, u32 mask, int timeout)
 {
 	int i = 0;
 
 	do {
-		if ((_iwl_read_restricted(priv, addr) & mask) == mask)
+		if ((_iwl3945_read_restricted(priv, addr) & mask) == mask)
 			return i;
 		mdelay(10);
 		i += 10;
@@ -310,11 +310,11 @@ static inline int _iwl_poll_restricted_b
 }
 
 #ifdef CONFIG_IWL3945_DEBUG
-static inline int __iwl_poll_restricted_bit(const char *f, u32 l,
-					    struct iwl_priv *priv,
+static inline int __iwl3945_poll_restricted_bit(const char *f, u32 l,
+					    struct iwl3945_priv *priv,
 					    u32 addr, u32 mask, int timeout)
 {
-	int rc = _iwl_poll_restricted_bit(priv, addr, mask, timeout);
+	int rc = _iwl3945_poll_restricted_bit(priv, addr, mask, timeout);
 
 	if (unlikely(rc == -ETIMEDOUT))
 		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) - "
@@ -324,119 +324,119 @@ static inline int __iwl_poll_restricted_
 			     "- %s %d\n", addr, mask, rc, f, l);
 	return rc;
 }
-#define iwl_poll_restricted_bit(iwl, addr, mask, timeout) \
-	__iwl_poll_restricted_bit(__FILE__, __LINE__, iwl, addr, mask, timeout)
+#define iwl3945_poll_restricted_bit(iwl, addr, mask, timeout) \
+	__iwl3945_poll_restricted_bit(__FILE__, __LINE__, iwl, addr, mask, timeout)
 #else
-#define iwl_poll_restricted_bit _iwl_poll_restricted_bit
+#define iwl3945_poll_restricted_bit _iwl3945_poll_restricted_bit
 #endif
 
-static inline u32 _iwl_read_restricted_reg(struct iwl_priv *priv, u32 reg)
+static inline u32 _iwl3945_read_restricted_reg(struct iwl3945_priv *priv, u32 reg)
 {
-	_iwl_write_restricted(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	return _iwl_read_restricted(priv, HBUS_TARG_PRPH_RDAT);
+	_iwl3945_write_restricted(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	return _iwl3945_read_restricted(priv, HBUS_TARG_PRPH_RDAT);
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static inline u32 __iwl_read_restricted_reg(u32 line,
-					    struct iwl_priv *priv, u32 reg)
+static inline u32 __iwl3945_read_restricted_reg(u32 line,
+					    struct iwl3945_priv *priv, u32 reg)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from line %d\n", line);
-	return _iwl_read_restricted_reg(priv, reg);
+	return _iwl3945_read_restricted_reg(priv, reg);
 }
 
-#define iwl_read_restricted_reg(priv, reg) \
-	__iwl_read_restricted_reg(__LINE__, priv, reg)
+#define iwl3945_read_restricted_reg(priv, reg) \
+	__iwl3945_read_restricted_reg(__LINE__, priv, reg)
 #else
-#define iwl_read_restricted_reg _iwl_read_restricted_reg
+#define iwl3945_read_restricted_reg _iwl3945_read_restricted_reg
 #endif
 
-static inline void _iwl_write_restricted_reg(struct iwl_priv *priv,
+static inline void _iwl3945_write_restricted_reg(struct iwl3945_priv *priv,
 					     u32 addr, u32 val)
 {
-	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WADDR,
+	_iwl3945_write_restricted(priv, HBUS_TARG_PRPH_WADDR,
 			      ((addr & 0x0000FFFF) | (3 << 24)));
-	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT, val);
+	_iwl3945_write_restricted(priv, HBUS_TARG_PRPH_WDAT, val);
 }
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl_write_restricted_reg(u32 line,
-					      struct iwl_priv *priv,
+static inline void __iwl3945_write_restricted_reg(u32 line,
+					      struct iwl3945_priv *priv,
 					      u32 addr, u32 val)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_write_restricted_reg(priv, addr, val);
+	_iwl3945_write_restricted_reg(priv, addr, val);
 }
 
-#define iwl_write_restricted_reg(priv, addr, val) \
-	__iwl_write_restricted_reg(__LINE__, priv, addr, val);
+#define iwl3945_write_restricted_reg(priv, addr, val) \
+	__iwl3945_write_restricted_reg(__LINE__, priv, addr, val);
 #else
-#define iwl_write_restricted_reg _iwl_write_restricted_reg
+#define iwl3945_write_restricted_reg _iwl3945_write_restricted_reg
 #endif
 
-#define _iwl_set_bits_restricted_reg(priv, reg, mask) \
-	_iwl_write_restricted_reg(priv, reg, \
-				  (_iwl_read_restricted_reg(priv, reg) | mask))
+#define _iwl3945_set_bits_restricted_reg(priv, reg, mask) \
+	_iwl3945_write_restricted_reg(priv, reg, \
+				  (_iwl3945_read_restricted_reg(priv, reg) | mask))
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl_set_bits_restricted_reg(u32 line, struct iwl_priv
+static inline void __iwl3945_set_bits_restricted_reg(u32 line, struct iwl3945_priv
 						 *priv, u32 reg, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_set_bits_restricted_reg(priv, reg, mask);
+	_iwl3945_set_bits_restricted_reg(priv, reg, mask);
 }
-#define iwl_set_bits_restricted_reg(priv, reg, mask) \
-	__iwl_set_bits_restricted_reg(__LINE__, priv, reg, mask)
+#define iwl3945_set_bits_restricted_reg(priv, reg, mask) \
+	__iwl3945_set_bits_restricted_reg(__LINE__, priv, reg, mask)
 #else
-#define iwl_set_bits_restricted_reg _iwl_set_bits_restricted_reg
+#define iwl3945_set_bits_restricted_reg _iwl3945_set_bits_restricted_reg
 #endif
 
-#define _iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
-	_iwl_write_restricted_reg( \
-	    priv, reg, ((_iwl_read_restricted_reg(priv, reg) & mask) | bits))
+#define _iwl3945_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
+	_iwl3945_write_restricted_reg( \
+	    priv, reg, ((_iwl3945_read_restricted_reg(priv, reg) & mask) | bits))
 #ifdef CONFIG_IWL3945_DEBUG
-static inline void __iwl_set_bits_mask_restricted_reg(u32 line,
-		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
+static inline void __iwl3945_set_bits_mask_restricted_reg(u32 line,
+		struct iwl3945_priv *priv, u32 reg, u32 bits, u32 mask)
 {
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask);
+	_iwl3945_set_bits_mask_restricted_reg(priv, reg, bits, mask);
 }
 
-#define iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
-	__iwl_set_bits_mask_restricted_reg(__LINE__, priv, reg, bits, mask)
+#define iwl3945_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
+	__iwl3945_set_bits_mask_restricted_reg(__LINE__, priv, reg, bits, mask)
 #else
-#define iwl_set_bits_mask_restricted_reg _iwl_set_bits_mask_restricted_reg
+#define iwl3945_set_bits_mask_restricted_reg _iwl3945_set_bits_mask_restricted_reg
 #endif
 
-static inline void iwl_clear_bits_restricted_reg(struct iwl_priv
+static inline void iwl3945_clear_bits_restricted_reg(struct iwl3945_priv
 						 *priv, u32 reg, u32 mask)
 {
-	u32 val = _iwl_read_restricted_reg(priv, reg);
-	_iwl_write_restricted_reg(priv, reg, (val & ~mask));
+	u32 val = _iwl3945_read_restricted_reg(priv, reg);
+	_iwl3945_write_restricted_reg(priv, reg, (val & ~mask));
 }
 
-static inline u32 iwl_read_restricted_mem(struct iwl_priv *priv, u32 addr)
+static inline u32 iwl3945_read_restricted_mem(struct iwl3945_priv *priv, u32 addr)
 {
-	iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR, addr);
-	return iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+	iwl3945_write_restricted(priv, HBUS_TARG_MEM_RADDR, addr);
+	return iwl3945_read_restricted(priv, HBUS_TARG_MEM_RDAT);
 }
 
-static inline void iwl_write_restricted_mem(struct iwl_priv *priv, u32 addr,
+static inline void iwl3945_write_restricted_mem(struct iwl3945_priv *priv, u32 addr,
 					    u32 val)
 {
-	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
-	iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, val);
+	iwl3945_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
+	iwl3945_write_restricted(priv, HBUS_TARG_MEM_WDAT, val);
 }
 
-static inline void iwl_write_restricted_mems(struct iwl_priv *priv, u32 addr,
+static inline void iwl3945_write_restricted_mems(struct iwl3945_priv *priv, u32 addr,
 					     u32 len, u32 *values)
 {
-	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
+	iwl3945_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
 	for (; 0 < len; len -= sizeof(u32), values++)
-		iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, *values);
+		iwl3945_write_restricted(priv, HBUS_TARG_MEM_WDAT, *values);
 }
 
-static inline void iwl_write_restricted_regs(struct iwl_priv *priv, u32 reg,
+static inline void iwl3945_write_restricted_regs(struct iwl3945_priv *priv, u32 reg,
 					     u32 len, u8 *values)
 {
 	u32 reg_offset = reg;
@@ -451,10 +451,10 @@ static inline void iwl_write_restricted_
 			memcpy(&value, values, len);
 			reg_offset = (reg_offset & 0x0000FFFF);
 
-			_iwl_write_restricted(priv,
+			_iwl3945_write_restricted(priv,
 					      HBUS_TARG_PRPH_WADDR,
 					      (reg_offset | (size << 24)));
-			_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT,
+			_iwl3945_write_restricted(priv, HBUS_TARG_PRPH_WDAT,
 					      value);
 		}
 
@@ -464,7 +464,7 @@ static inline void iwl_write_restricted_
 	/* now write all the dword-aligned stuff */
 	for (; reg_offset < (reg + len);
 	     reg_offset += sizeof(u32), values += sizeof(u32))
-		_iwl_write_restricted_reg(priv, reg_offset, *((u32 *) values));
+		_iwl3945_write_restricted_reg(priv, reg_offset, *((u32 *) values));
 }
 
 #endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2007-10-12 14:38:38.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2007-10-12 14:38:40.000000000 +0200
@@ -45,7 +45,7 @@
 
 #define RS_NAME "iwl-3945-rs"
 
-struct iwl_rate_scale_data {
+struct iwl3945_rate_scale_data {
 	u64 data;
 	s32 success_counter;
 	s32 success_ratio;
@@ -54,7 +54,7 @@ struct iwl_rate_scale_data {
 	unsigned long stamp;
 };
 
-struct iwl_rate_scale_priv {
+struct iwl3945_rate_scale_priv {
 	spinlock_t lock;
 	s32 *expected_tpt;
 	unsigned long last_partial_flush;
@@ -67,31 +67,31 @@ struct iwl_rate_scale_priv {
 	u8 start_rate;
 	u8 ibss_sta_added;
 	struct timer_list rate_scale_flush;
-	struct iwl_rate_scale_data win[IWL_RATE_COUNT];
+	struct iwl3945_rate_scale_data win[IWL_RATE_COUNT];
 };
 
-static s32 iwl_expected_tpt_g[IWL_RATE_COUNT] = {
+static s32 iwl3945_expected_tpt_g[IWL_RATE_COUNT] = {
 	0, 0, 76, 104, 130, 168, 191, 202, 7, 13, 35, 58
 };
 
-static s32 iwl_expected_tpt_g_prot[IWL_RATE_COUNT] = {
+static s32 iwl3945_expected_tpt_g_prot[IWL_RATE_COUNT] = {
 	0, 0, 0, 80, 93, 113, 123, 125, 7, 13, 35, 58
 };
 
-static s32 iwl_expected_tpt_a[IWL_RATE_COUNT] = {
+static s32 iwl3945_expected_tpt_a[IWL_RATE_COUNT] = {
 	40, 57, 72, 98, 121, 154, 177, 186, 0, 0, 0, 0
 };
 
-static s32 iwl_expected_tpt_b[IWL_RATE_COUNT] = {
+static s32 iwl3945_expected_tpt_b[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 7, 13, 35, 58
 };
 
-struct iwl_tpt_entry {
+struct iwl3945_tpt_entry {
 	s8 min_rssi;
 	u8 index;
 };
 
-static struct iwl_tpt_entry iwl_tpt_table_a[] = {
+static struct iwl3945_tpt_entry iwl3945_tpt_table_a[] = {
 	{-60, IWL_RATE_54M_INDEX},
 	{-64, IWL_RATE_48M_INDEX},
 	{-72, IWL_RATE_36M_INDEX},
@@ -102,7 +102,7 @@ static struct iwl_tpt_entry iwl_tpt_tabl
 	{-89, IWL_RATE_6M_INDEX}
 };
 
-static struct iwl_tpt_entry iwl_tpt_table_b[] = {
+static struct iwl3945_tpt_entry iwl3945_tpt_table_b[] = {
 	{-86, IWL_RATE_11M_INDEX},
 	{-88, IWL_RATE_5M_INDEX},
 	{-90, IWL_RATE_2M_INDEX},
@@ -110,7 +110,7 @@ static struct iwl_tpt_entry iwl_tpt_tabl
 
 };
 
-static struct iwl_tpt_entry iwl_tpt_table_g[] = {
+static struct iwl3945_tpt_entry iwl3945_tpt_table_g[] = {
 	{-60, IWL_RATE_54M_INDEX},
 	{-64, IWL_RATE_48M_INDEX},
 	{-68, IWL_RATE_36M_INDEX},
@@ -131,30 +131,30 @@ static struct iwl_tpt_entry iwl_tpt_tabl
 #define IWL_RATE_MIN_SUCCESS_TH       8
 #define IWL_RATE_DECREASE_TH       1920
 
-static u8 iwl_get_rate_index_by_rssi(s32 rssi, u8 mode)
+static u8 iwl3945_get_rate_index_by_rssi(s32 rssi, u8 mode)
 {
 	u32 index = 0;
 	u32 table_size = 0;
-	struct iwl_tpt_entry *tpt_table = NULL;
+	struct iwl3945_tpt_entry *tpt_table = NULL;
 
 	if ((rssi < IWL_MIN_RSSI_VAL) || (rssi > IWL_MAX_RSSI_VAL))
 		rssi = IWL_MIN_RSSI_VAL;
 
 	switch (mode) {
 	case MODE_IEEE80211G:
-		tpt_table = iwl_tpt_table_g;
-		table_size = ARRAY_SIZE(iwl_tpt_table_g);
+		tpt_table = iwl3945_tpt_table_g;
+		table_size = ARRAY_SIZE(iwl3945_tpt_table_g);
 		break;
 
 	case MODE_IEEE80211A:
-		tpt_table = iwl_tpt_table_a;
-		table_size = ARRAY_SIZE(iwl_tpt_table_a);
+		tpt_table = iwl3945_tpt_table_a;
+		table_size = ARRAY_SIZE(iwl3945_tpt_table_a);
 		break;
 
 	default:
 	case MODE_IEEE80211B:
-		tpt_table = iwl_tpt_table_b;
-		table_size = ARRAY_SIZE(iwl_tpt_table_b);
+		tpt_table = iwl3945_tpt_table_b;
+		table_size = ARRAY_SIZE(iwl3945_tpt_table_b);
 		break;
 	}
 
@@ -166,7 +166,7 @@ static u8 iwl_get_rate_index_by_rssi(s32
 	return tpt_table[index].index;
 }
 
-static void iwl_clear_window(struct iwl_rate_scale_data *window)
+static void iwl3945_clear_window(struct iwl3945_rate_scale_data *window)
 {
 	window->data = 0;
 	window->success_counter = 0;
@@ -177,13 +177,13 @@ static void iwl_clear_window(struct iwl_
 }
 
 /**
- * iwl_rate_scale_flush_windows - flush out the rate scale windows
+ * iwl3945_rate_scale_flush_windows - flush out the rate scale windows
  *
  * Returns the number of windows that have gathered data but were
  * not flushed.  If there were any that were not flushed, then
  * reschedule the rate flushing routine.
  */
-static int iwl_rate_scale_flush_windows(struct iwl_rate_scale_priv *rs_priv)
+static int iwl3945_rate_scale_flush_windows(struct iwl3945_rate_scale_priv *rs_priv)
 {
 	int unflushed = 0;
 	int i;
@@ -204,7 +204,7 @@ static int iwl_rate_scale_flush_windows(
 			IWL_DEBUG_RATE("flushing %d samples of rate "
 				       "index %d\n",
 				       rs_priv->win[i].counter, i);
-			iwl_clear_window(&rs_priv->win[i]);
+			iwl3945_clear_window(&rs_priv->win[i]);
 		} else
 			unflushed++;
 		spin_unlock_irqrestore(&rs_priv->lock, flags);
@@ -216,16 +216,16 @@ static int iwl_rate_scale_flush_windows(
 #define IWL_RATE_FLUSH_MAX              5000	/* msec */
 #define IWL_RATE_FLUSH_MIN              50	/* msec */
 
-static void iwl_bg_rate_scale_flush(unsigned long data)
+static void iwl3945_bg_rate_scale_flush(unsigned long data)
 {
-	struct iwl_rate_scale_priv *rs_priv = (void *)data;
+	struct iwl3945_rate_scale_priv *rs_priv = (void *)data;
 	int unflushed = 0;
 	unsigned long flags;
 	u32 packet_count, duration, pps;
 
 	IWL_DEBUG_RATE("enter\n");
 
-	unflushed = iwl_rate_scale_flush_windows(rs_priv);
+	unflushed = iwl3945_rate_scale_flush_windows(rs_priv);
 
 	spin_lock_irqsave(&rs_priv->lock, flags);
 
@@ -279,14 +279,14 @@ static void iwl_bg_rate_scale_flush(unsi
 }
 
 /**
- * iwl_collect_tx_data - Update the success/failure sliding window
+ * iwl3945_collect_tx_data - Update the success/failure sliding window
  *
  * We keep a sliding window of the last 64 packets transmitted
  * at this rate.  window->data contains the bitmask of successful
  * packets.
  */
-static void iwl_collect_tx_data(struct iwl_rate_scale_priv *rs_priv,
-				struct iwl_rate_scale_data *window,
+static void iwl3945_collect_tx_data(struct iwl3945_rate_scale_priv *rs_priv,
+				struct iwl3945_rate_scale_data *window,
 				int success, int retries)
 {
 	unsigned long flags;
@@ -371,12 +371,12 @@ static void rs_clear(void *priv)
 
 static void *rs_alloc_sta(void *priv, gfp_t gfp)
 {
-	struct iwl_rate_scale_priv *rs_priv;
+	struct iwl3945_rate_scale_priv *rs_priv;
 	int i;
 
 	IWL_DEBUG_RATE("enter\n");
 
-	rs_priv = kzalloc(sizeof(struct iwl_rate_scale_priv), gfp);
+	rs_priv = kzalloc(sizeof(struct iwl3945_rate_scale_priv), gfp);
 	if (!rs_priv) {
 		IWL_DEBUG_RATE("leave: ENOMEM\n");
 		return NULL;
@@ -387,7 +387,7 @@ static void *rs_alloc_sta(void *priv, gf
 	rs_priv->start_rate = IWL_RATE_INVALID;
 
 	/* default to just 802.11b */
-	rs_priv->expected_tpt = iwl_expected_tpt_b;
+	rs_priv->expected_tpt = iwl3945_expected_tpt_b;
 
 	rs_priv->last_partial_flush = jiffies;
 	rs_priv->last_flush = jiffies;
@@ -397,10 +397,10 @@ static void *rs_alloc_sta(void *priv, gf
 
 	init_timer(&rs_priv->rate_scale_flush);
 	rs_priv->rate_scale_flush.data = (unsigned long)rs_priv;
-	rs_priv->rate_scale_flush.function = &iwl_bg_rate_scale_flush;
+	rs_priv->rate_scale_flush.function = &iwl3945_bg_rate_scale_flush;
 
 	for (i = 0; i < IWL_RATE_COUNT; i++)
-		iwl_clear_window(&rs_priv->win[i]);
+		iwl3945_clear_window(&rs_priv->win[i]);
 
 	IWL_DEBUG_RATE("leave\n");
 
@@ -409,7 +409,7 @@ static void *rs_alloc_sta(void *priv, gf
 
 static void rs_free_sta(void *priv, void *priv_sta)
 {
-	struct iwl_rate_scale_priv *rs_priv = priv_sta;
+	struct iwl3945_rate_scale_priv *rs_priv = priv_sta;
 
 	IWL_DEBUG_RATE("enter\n");
 	del_timer_sync(&rs_priv->rate_scale_flush);
@@ -420,7 +420,7 @@ static void rs_free_sta(void *priv, void
 /**
  * rs_tx_status - Update rate control values based on Tx results
  *
- * NOTE: Uses iwl_priv->retry_rate for the # of retries attempted by
+ * NOTE: Uses iwl3945_priv->retry_rate for the # of retries attempted by
  * the hardware for each rate.
  */
 static void rs_tx_status(void *priv_rate,
@@ -433,9 +433,9 @@ static void rs_tx_status(void *priv_rate
 	unsigned long flags;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct iwl_rate_scale_priv *rs_priv;
+	struct iwl3945_rate_scale_priv *rs_priv;
 
 	IWL_DEBUG_RATE("enter\n");
 
@@ -479,12 +479,12 @@ static void rs_tx_status(void *priv_rate
 			last_index = scale_rate_index;
 		} else {
 			current_count = priv->retry_rate;
-			last_index = iwl_get_prev_ieee_rate(scale_rate_index);
+			last_index = iwl3945_get_prev_ieee_rate(scale_rate_index);
 		}
 
 		/* Update this rate accounting for as many retries
 		 * as was used for it (per current_count) */
-		iwl_collect_tx_data(rs_priv,
+		iwl3945_collect_tx_data(rs_priv,
 				    &rs_priv->win[scale_rate_index],
 				    0, current_count);
 		IWL_DEBUG_RATE("Update rate %d for %d retries.\n",
@@ -494,7 +494,7 @@ static void rs_tx_status(void *priv_rate
 
 		if (retries)
 			scale_rate_index =
-			    iwl_get_prev_ieee_rate(scale_rate_index);
+			    iwl3945_get_prev_ieee_rate(scale_rate_index);
 	}
 
 	/* Update the last index window with success/failure based on ACK */
@@ -502,7 +502,7 @@ static void rs_tx_status(void *priv_rate
 		       last_index,
 		       (tx_resp->flags & IEEE80211_TX_STATUS_ACK) ?
 		       "success" : "failure");
-	iwl_collect_tx_data(rs_priv,
+	iwl3945_collect_tx_data(rs_priv,
 			    &rs_priv->win[last_index],
 			    tx_resp->flags & IEEE80211_TX_STATUS_ACK, 1);
 
@@ -529,7 +529,7 @@ static void rs_tx_status(void *priv_rate
 	return;
 }
 
-static struct ieee80211_rate *iwl_get_lowest_rate(struct ieee80211_local
+static struct ieee80211_rate *iwl3945_get_lowest_rate(struct ieee80211_local
 						  *local)
 {
 	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
@@ -545,7 +545,7 @@ static struct ieee80211_rate *iwl_get_lo
 	return &mode->rates[0];
 }
 
-static u16 iwl_get_adjacent_rate(struct iwl_rate_scale_priv *rs_priv,
+static u16 iwl3945_get_adjacent_rate(struct iwl3945_rate_scale_priv *rs_priv,
 				 u8 index, u16 rate_mask, int phymode)
 {
 	u8 high = IWL_RATE_INVALID;
@@ -581,9 +581,9 @@ static u16 iwl_get_adjacent_rate(struct 
 	low = index;
 	while (low != IWL_RATE_INVALID) {
 		if (rs_priv->tgg)
-			low = iwl_rates[low].prev_rs_tgg;
+			low = iwl3945_rates[low].prev_rs_tgg;
 		else
-			low = iwl_rates[low].prev_rs;
+			low = iwl3945_rates[low].prev_rs;
 		if (low == IWL_RATE_INVALID)
 			break;
 		if (rate_mask & (1 << low))
@@ -594,9 +594,9 @@ static u16 iwl_get_adjacent_rate(struct 
 	high = index;
 	while (high != IWL_RATE_INVALID) {
 		if (rs_priv->tgg)
-			high = iwl_rates[high].next_rs_tgg;
+			high = iwl3945_rates[high].next_rs_tgg;
 		else
-			high = iwl_rates[high].next_rs;
+			high = iwl3945_rates[high].next_rs;
 		if (high == IWL_RATE_INVALID)
 			break;
 		if (rate_mask & (1 << high))
@@ -632,8 +632,8 @@ static struct ieee80211_rate *rs_get_rat
 	u8 high = IWL_RATE_INVALID;
 	u16 high_low;
 	int index;
-	struct iwl_rate_scale_priv *rs_priv;
-	struct iwl_rate_scale_data *window = NULL;
+	struct iwl3945_rate_scale_priv *rs_priv;
+	struct iwl3945_rate_scale_data *window = NULL;
 	int current_tpt = IWL_INVALID_VALUE;
 	int low_tpt = IWL_INVALID_VALUE;
 	int high_tpt = IWL_INVALID_VALUE;
@@ -644,7 +644,7 @@ static struct ieee80211_rate *rs_get_rat
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
 	u16 fc, rate_mask;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RATE("enter\n");
@@ -660,7 +660,7 @@ static struct ieee80211_rate *rs_get_rat
 		IWL_DEBUG_RATE("leave: lowest rate (not data or is "
 			       "multicast)\n");
 
-		return iwl_get_lowest_rate(local);
+		return iwl3945_get_lowest_rate(local);
 	}
 
 	sta = sta_info_get(local, hdr->addr1);
@@ -678,12 +678,12 @@ static struct ieee80211_rate *rs_get_rat
 
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
 	    !rs_priv->ibss_sta_added) {
-		u8 sta_id = iwl_hw_find_station(priv, hdr->addr1);
+		u8 sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE("LQ: ADD station %s\n",
 				       print_mac(mac, hdr->addr1));
-			sta_id = iwl_add_station(priv,
+			sta_id = iwl3945_add_station(priv,
 				    hdr->addr1, 0, CMD_ASYNC);
 		}
 		if (sta_id != IWL_INVALID_STATION)
@@ -721,7 +721,7 @@ static struct ieee80211_rate *rs_get_rat
 				rs_priv->expected_tpt[index] + 64) / 128);
 	current_tpt = window->average_tpt;
 
-	high_low = iwl_get_adjacent_rate(rs_priv, index, rate_mask,
+	high_low = iwl3945_get_adjacent_rate(rs_priv, index, rate_mask,
 					 local->hw.conf.phymode);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
@@ -822,11 +822,11 @@ static struct rate_control_ops rs_ops = 
 	.free_sta = rs_free_sta,
 };
 
-int iwl_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
+int iwl3945_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_rate_scale_priv *rs_priv;
+	struct iwl3945_priv *priv = hw->priv;
+	struct iwl3945_rate_scale_priv *rs_priv;
 	struct sta_info *sta;
 	unsigned long flags;
 	int count = 0, i;
@@ -852,7 +852,7 @@ int iwl_fill_rs_info(struct ieee80211_hw
 		int j;
 
 		count +=
-		    sprintf(&buf[count], " %2dMbs: ", iwl_rates[i].ieee / 2);
+		    sprintf(&buf[count], " %2dMbs: ", iwl3945_rates[i].ieee / 2);
 
 		mask = (1ULL << (IWL_RATE_MAX_WINDOW - 1));
 		for (j = 0; j < IWL_RATE_MAX_WINDOW; j++, mask >>= 1)
@@ -861,7 +861,7 @@ int iwl_fill_rs_info(struct ieee80211_hw
 
 		samples += rs_priv->win[i].counter;
 		good += rs_priv->win[i].success_counter;
-		success += rs_priv->win[i].success_counter * iwl_rates[i].ieee;
+		success += rs_priv->win[i].success_counter * iwl3945_rates[i].ieee;
 
 		if (rs_priv->win[i].stamp) {
 			int delta =
@@ -874,7 +874,7 @@ int iwl_fill_rs_info(struct ieee80211_hw
 		} else
 			buf[count++] = '\n';
 
-		j = iwl_get_prev_ieee_rate(i);
+		j = iwl3945_get_prev_ieee_rate(i);
 		if (j == i)
 			break;
 		i = j;
@@ -885,7 +885,7 @@ int iwl_fill_rs_info(struct ieee80211_hw
 	/* Display the average rate of all samples taken.
 	 *
 	 * NOTE:  We multiple # of samples by 2 since the IEEE measurement
-	 * added from iwl_rates is actually 2X the rate */
+	 * added from iwl3945_rates is actually 2X the rate */
 	if (samples)
 		count += sprintf(
 			&buf[count],
@@ -899,13 +899,13 @@ int iwl_fill_rs_info(struct ieee80211_hw
 	return count;
 }
 
-void iwl_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
+void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 	s32 rssi = 0;
 	unsigned long flags;
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct iwl_rate_scale_priv *rs_priv;
+	struct iwl3945_rate_scale_priv *rs_priv;
 	struct sta_info *sta;
 
 	IWL_DEBUG_RATE("enter\n");
@@ -934,19 +934,19 @@ void iwl_rate_scale_init(struct ieee8021
 	case MODE_IEEE80211G:
 		if (priv->active_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
 			rs_priv->tgg = 1;
-			rs_priv->expected_tpt = iwl_expected_tpt_g_prot;
+			rs_priv->expected_tpt = iwl3945_expected_tpt_g_prot;
 		} else
-			rs_priv->expected_tpt = iwl_expected_tpt_g;
+			rs_priv->expected_tpt = iwl3945_expected_tpt_g;
 		break;
 
 	case MODE_IEEE80211A:
-		rs_priv->expected_tpt = iwl_expected_tpt_a;
+		rs_priv->expected_tpt = iwl3945_expected_tpt_a;
 		break;
 
 	default:
 		IWL_WARNING("Invalid phymode.  Defaulting to 802.11b\n");
 	case MODE_IEEE80211B:
-		rs_priv->expected_tpt = iwl_expected_tpt_b;
+		rs_priv->expected_tpt = iwl3945_expected_tpt_b;
 		break;
 	}
 
@@ -959,19 +959,19 @@ void iwl_rate_scale_init(struct ieee8021
 
 	IWL_DEBUG(IWL_DL_INFO | IWL_DL_RATE, "Network RSSI: %d\n", rssi);
 
-	rs_priv->start_rate = iwl_get_rate_index_by_rssi(rssi, priv->phymode);
+	rs_priv->start_rate = iwl3945_get_rate_index_by_rssi(rssi, priv->phymode);
 
 	IWL_DEBUG_RATE("leave: rssi %d assign rate index: "
 		       "%d (plcp 0x%x)\n", rssi, rs_priv->start_rate,
-		       iwl_rates[rs_priv->start_rate].plcp);
+		       iwl3945_rates[rs_priv->start_rate].plcp);
 }
 
-void iwl_rate_control_register(struct ieee80211_hw *hw)
+void iwl3945_rate_control_register(struct ieee80211_hw *hw)
 {
 	ieee80211_rate_control_register(&rs_ops);
 }
 
-void iwl_rate_control_unregister(struct ieee80211_hw *hw)
+void iwl3945_rate_control_unregister(struct ieee80211_hw *hw)
 {
 	ieee80211_rate_control_unregister(&rs_ops);
 }
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.h	2007-10-12 14:38:56.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.h	2007-10-12 14:38:57.000000000 +0200
@@ -24,10 +24,10 @@
  *
  *****************************************************************************/
 
-#ifndef __iwl_3945_rs_h__
-#define __iwl_3945_rs_h__
+#ifndef __iwl3945_3945_rs_h__
+#define __iwl3945_3945_rs_h__
 
-struct iwl_rate_info {
+struct iwl3945_rate_info {
 	u8 plcp;
 	u8 ieee;
 	u8 prev_ieee;		/* previous rate in IEEE speeds */
@@ -140,11 +140,11 @@ enum {
 #define IWL_MIN_RSSI_VAL                 -100
 #define IWL_MAX_RSSI_VAL                    0
 
-extern const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
+extern const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT];
 
-static inline u8 iwl_get_prev_ieee_rate(u8 rate_index)
+static inline u8 iwl3945_get_prev_ieee_rate(u8 rate_index)
 {
-	u8 rate = iwl_rates[rate_index].prev_ieee;
+	u8 rate = iwl3945_rates[rate_index].prev_ieee;
 
 	if (rate == IWL_RATE_INVALID)
 		rate = rate_index;
@@ -152,40 +152,40 @@ static inline u8 iwl_get_prev_ieee_rate(
 }
 
 /**
- * iwl_fill_rs_info - Fill an output text buffer with the rate representation
+ * iwl3945_fill_rs_info - Fill an output text buffer with the rate representation
  *
  * NOTE:  This is provided as a quick mechanism for a user to visualize
  * the performance of the rate control alogirthm and is not meant to be
  * parsed software.
  */
-extern int iwl_fill_rs_info(struct ieee80211_hw *, char *buf, u8 sta_id);
+extern int iwl3945_fill_rs_info(struct ieee80211_hw *, char *buf, u8 sta_id);
 
 /**
- * iwl_rate_scale_init - Initialize the rate scale table based on assoc info
+ * iwl3945_rate_scale_init - Initialize the rate scale table based on assoc info
  *
  * The specific througput table used is based on the type of network
  * the associated with, including A, B, G, and G w/ TGG protection
  */
-extern void iwl_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
+extern void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
 
 /**
- * iwl_rate_control_register - Register the rate control algorithm callbacks
+ * iwl3945_rate_control_register - Register the rate control algorithm callbacks
  *
  * Since the rate control algorithm is hardware specific, there is no need
  * or reason to place it as a stand alone module.  The driver can call
- * iwl_rate_control_register in order to register the rate control callbacks
+ * iwl3945_rate_control_register in order to register the rate control callbacks
  * with the mac80211 subsystem.  This should be performed prior to calling
  * ieee80211_register_hw
  *
  */
-extern void iwl_rate_control_register(struct ieee80211_hw *hw);
+extern void iwl3945_rate_control_register(struct ieee80211_hw *hw);
 
 /**
- * iwl_rate_control_unregister - Unregister the rate control callbacks
+ * iwl3945_rate_control_unregister - Unregister the rate control callbacks
  *
  * This should be called after calling ieee80211_unregister_hw, but before
  * the driver is unloaded.
  */
-extern void iwl_rate_control_unregister(struct ieee80211_hw *hw);
+extern void iwl3945_rate_control_unregister(struct ieee80211_hw *hw);
 
 #endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-10-12 14:38:34.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-10-12 14:58:18.000000000 +0200
@@ -62,7 +62,7 @@
  * maps to IWL_RATE_INVALID
  *
  */
-const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
+const struct iwl3945_rate_info iwl3945_rates[IWL_RATE_COUNT] = {
 	IWL_DECLARE_RATE_INFO(6, 5, 9, 5, 11, 5, 11),        /*  6mbps */
 	IWL_DECLARE_RATE_INFO(9, 6, 11, 5, 11, 5, 11),       /*  9mbps */
 	IWL_DECLARE_RATE_INFO(12, 11, 18, 11, 18, 11, 18),   /* 12mbps */
@@ -77,12 +77,12 @@ const struct iwl_rate_info iwl_rates[IWL
 	IWL_DECLARE_RATE_INFO(11, 9, 12, 5, 12, 5, 18),      /* 11mbps */
 };
 
-/* 1 = enable the iwl_disable_events() function */
+/* 1 = enable the iwl3945_disable_events() function */
 #define IWL_EVT_DISABLE (0)
 #define IWL_EVT_DISABLE_SIZE (1532/32)
 
 /**
- * iwl_disable_events - Disable selected events in uCode event log
+ * iwl3945_disable_events - Disable selected events in uCode event log
  *
  * Disable an event by writing "1"s into "disable"
  *   bitmap in SRAM.  Bit position corresponds to Event # (id/type).
@@ -90,7 +90,7 @@ const struct iwl_rate_info iwl_rates[IWL
  * Use for only special debugging.  This function is just a placeholder as-is,
  *   you'll need to provide the special bits! ...
  *   ... and set IWL_EVT_DISABLE to 1. */
-void iwl_disable_events(struct iwl_priv *priv)
+void iwl3945_disable_events(struct iwl3945_priv *priv)
 {
 	int rc;
 	int i;
@@ -148,32 +148,32 @@ void iwl_disable_events(struct iwl_priv 
 	};
 
 	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-	if (!iwl_hw_valid_rtc_data_addr(base)) {
+	if (!iwl3945_hw_valid_rtc_data_addr(base)) {
 		IWL_ERROR("Invalid event log pointer 0x%08X\n", base);
 		return;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
 
-	disable_ptr = iwl_read_restricted_mem(priv, base + (4 * sizeof(u32)));
-	array_size = iwl_read_restricted_mem(priv, base + (5 * sizeof(u32)));
-	iwl_release_restricted_access(priv);
+	disable_ptr = iwl3945_read_restricted_mem(priv, base + (4 * sizeof(u32)));
+	array_size = iwl3945_read_restricted_mem(priv, base + (5 * sizeof(u32)));
+	iwl3945_release_restricted_access(priv);
 
 	if (IWL_EVT_DISABLE && (array_size == IWL_EVT_DISABLE_SIZE)) {
 		IWL_DEBUG_INFO("Disabling selected uCode log events at 0x%x\n",
 			       disable_ptr);
-		rc = iwl_grab_restricted_access(priv);
+		rc = iwl3945_grab_restricted_access(priv);
 		for (i = 0; i < IWL_EVT_DISABLE_SIZE; i++)
-			iwl_write_restricted_mem(priv,
+			iwl3945_write_restricted_mem(priv,
 						 disable_ptr +
 						 (i * sizeof(u32)),
 						 evt_disable[i]);
 
-		iwl_release_restricted_access(priv);
+		iwl3945_release_restricted_access(priv);
 	} else {
 		IWL_DEBUG_INFO("Selected uCode log events may be disabled\n");
 		IWL_DEBUG_INFO("  by writing \"1\"s into disable bitmap\n");
@@ -194,7 +194,7 @@ void iwl_disable_events(struct iwl_priv 
  * IWL_ANTENNA_MAIN      - Force MAIN antenna
  * IWL_ANTENNA_AUX       - Force AUX antenna
  */
-__le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
+__le32 iwl3945_get_antenna_flags(const struct iwl3945_priv *priv)
 {
 	switch (priv->antenna) {
 	case IWL_ANTENNA_DIVERSITY:
@@ -226,11 +226,11 @@ __le32 iwl3945_get_antenna_flags(const s
  *
  *****************************************************************************/
 
-void iwl_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
 	IWL_DEBUG_RX("Statistics notification received (%d vs %d).\n",
-		     (int)sizeof(struct iwl_notif_statistics),
+		     (int)sizeof(struct iwl3945_notif_statistics),
 		     le32_to_cpu(pkt->len));
 
 	memcpy(&priv->statistics, pkt->u.raw, sizeof(priv->statistics));
@@ -238,15 +238,15 @@ void iwl_hw_rx_statistics(struct iwl_pri
 	priv->last_statistics_time = jiffies;
 }
 
-static void iwl3945_handle_data_packet(struct iwl_priv *priv, int is_data,
-				   struct iwl_rx_mem_buffer *rxb,
+static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
+				   struct iwl3945_rx_mem_buffer *rxb,
 				   struct ieee80211_rx_status *stats,
 				   u16 phy_flags)
 {
 	struct ieee80211_hdr *hdr;
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
-	struct iwl_rx_frame_end *rx_end = IWL_RX_END(pkt);
+	struct iwl3945_rx_packet *pkt = (struct iwl3945_rx_packet *)rxb->skb->data;
+	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
+	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	short len = le16_to_cpu(rx_hdr->len);
 
 	/* We received data from the HW, so stop the watchdog */
@@ -262,11 +262,11 @@ static void iwl3945_handle_data_packet(s
 		return;
 	}
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		if (iwl_param_hwcrypto)
-			iwl_set_decrypted_flag(priv, rxb->skb,
+		if (iwl3945_param_hwcrypto)
+			iwl3945_set_decrypted_flag(priv, rxb->skb,
 					       le32_to_cpu(rx_end->status),
 					       stats);
-		iwl_handle_data_packet_monitor(priv, rxb, IWL_RX_DATA(pkt),
+		iwl3945_handle_data_packet_monitor(priv, rxb, IWL_RX_DATA(pkt),
 					       len, stats, phy_flags);
 		return;
 	}
@@ -277,21 +277,21 @@ static void iwl3945_handle_data_packet(s
 
 	hdr = (void *)rxb->skb->data;
 
-	if (iwl_param_hwcrypto)
-		iwl_set_decrypted_flag(priv, rxb->skb,
+	if (iwl3945_param_hwcrypto)
+		iwl3945_set_decrypted_flag(priv, rxb->skb,
 				       le32_to_cpu(rx_end->status), stats);
 
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	rxb->skb = NULL;
 }
 
-static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
+				struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
-	struct iwl_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
-	struct iwl_rx_frame_end *rx_end = IWL_RX_END(pkt);
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
+	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
+	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	struct ieee80211_hdr *header;
 	u16 phy_flags = le16_to_cpu(rx_hdr->phy_flags);
 	u16 rx_stats_sig_avg = le16_to_cpu(rx_stats->sig_avg);
@@ -347,14 +347,14 @@ static void iwl3945_rx_reply_rx(struct i
 	 * Calculate stats.signal (quality indicator in %) based on SNR. */
 	if (rx_stats_noise_diff) {
 		snr = rx_stats_sig_avg / rx_stats_noise_diff;
-		stats.noise = stats.ssi - iwl_calc_db_from_ratio(snr);
-		stats.signal = iwl_calc_sig_qual(stats.ssi, stats.noise);
+		stats.noise = stats.ssi - iwl3945_calc_db_from_ratio(snr);
+		stats.signal = iwl3945_calc_sig_qual(stats.ssi, stats.noise);
 
 	/* If noise info not available, calculate signal quality indicator (%)
 	 *   using just the dBm signal level. */
 	} else {
 		stats.noise = priv->last_rx_noise;
-		stats.signal = iwl_calc_sig_qual(stats.ssi, 0);
+		stats.signal = iwl3945_calc_sig_qual(stats.ssi, 0);
 	}
 
 
@@ -364,24 +364,24 @@ static void iwl3945_rx_reply_rx(struct i
 
 	stats.freq = ieee80211chan2mhz(stats.channel);
 
-	/* can be covered by iwl_report_frame() in most cases */
+	/* can be covered by iwl3945_report_frame() in most cases */
 /*      IWL_DEBUG_RX("RX status: 0x%08X\n", rx_end->status); */
 
 	header = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
 
-	network_packet = iwl_is_network_packet(priv, header);
+	network_packet = iwl3945_is_network_packet(priv, header);
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl_debug_level & IWL_DL_STATS && net_ratelimit())
+	if (iwl3945_debug_level & IWL_DL_STATS && net_ratelimit())
 		IWL_DEBUG_STATS
 		    ("[%c] %d RSSI: %d Signal: %u, Noise: %u, Rate: %u\n",
 		     network_packet ? '*' : ' ',
 		     stats.channel, stats.ssi, stats.ssi,
 		     stats.ssi, stats.rate);
 
-	if (iwl_debug_level & (IWL_DL_RX))
+	if (iwl3945_debug_level & (IWL_DL_RX))
 		/* Set "1" to report good data frames in groups of 100 */
-		iwl_report_frame(priv, pkt, header, 1);
+		iwl3945_report_frame(priv, pkt, header, 1);
 #endif
 
 	if (network_packet) {
@@ -481,7 +481,7 @@ static void iwl3945_rx_reply_rx(struct i
 		DECLARE_MAC_BUF(mac2);
 		DECLARE_MAC_BUF(mac3);
 
-		if (unlikely(is_duplicate_packet(priv, header)))
+		if (unlikely(iwl3945_is_duplicate_packet(priv, header)))
 			IWL_DEBUG_DROP("Dropping (dup): %s, %s, %s\n",
 				       print_mac(mac1, header->addr1),
 				       print_mac(mac2, header->addr2),
@@ -494,12 +494,12 @@ static void iwl3945_rx_reply_rx(struct i
 	}
 }
 
-int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
+int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl3945_priv *priv, void *ptr,
 				 dma_addr_t addr, u16 len)
 {
 	int count;
 	u32 pad;
-	struct iwl_tfd_frame *tfd = (struct iwl_tfd_frame *)ptr;
+	struct iwl3945_tfd_frame *tfd = (struct iwl3945_tfd_frame *)ptr;
 
 	count = TFD_CTL_COUNT_GET(le32_to_cpu(tfd->control_flags));
 	pad = TFD_CTL_PAD_GET(le32_to_cpu(tfd->control_flags));
@@ -522,14 +522,14 @@ int iwl_hw_txq_attach_buf_to_tfd(struct 
 }
 
 /**
- * iwl_hw_txq_free_tfd - Free one TFD, those at index [txq->q.last_used]
+ * iwl3945_hw_txq_free_tfd - Free one TFD, those at index [txq->q.last_used]
  *
  * Does NOT advance any indexes
  */
-int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+int iwl3945_hw_txq_free_tfd(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq)
 {
-	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
-	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.last_used];
+	struct iwl3945_tfd_frame *bd_tmp = (struct iwl3945_tfd_frame *)&txq->bd[0];
+	struct iwl3945_tfd_frame *bd = &bd_tmp[txq->q.last_used];
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
 	int counter;
@@ -564,7 +564,7 @@ int iwl_hw_txq_free_tfd(struct iwl_priv 
 	return 0;
 }
 
-u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *addr)
+u8 iwl3945_hw_find_station(struct iwl3945_priv *priv, const u8 *addr)
 {
 	int i;
 	int ret = IWL_INVALID_STATION;
@@ -588,11 +588,11 @@ u8 iwl_hw_find_station(struct iwl_priv *
 }
 
 /**
- * iwl_hw_build_tx_cmd_rate - Add rate portion to TX_CMD:
+ * iwl3945_hw_build_tx_cmd_rate - Add rate portion to TX_CMD:
  *
 */
-void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-			      struct iwl_cmd *cmd,
+void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
+			      struct iwl3945_cmd *cmd,
 			      struct ieee80211_tx_control *ctrl,
 			      struct ieee80211_hdr *hdr, int sta_id, int tx_id)
 {
@@ -605,7 +605,7 @@ void iwl_hw_build_tx_cmd_rate(struct iwl
 	__le32 tx_flags;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 
-	rate = iwl_rates[rate_index].plcp;
+	rate = iwl3945_rates[rate_index].plcp;
 	tx_flags = cmd->cmd.tx.tx_flags;
 
 	/* We need to figure out how to get the sta->supp_rates while
@@ -671,10 +671,10 @@ void iwl_hw_build_tx_cmd_rate(struct iwl
 		       cmd->cmd.tx.supp_rates[1], cmd->cmd.tx.supp_rates[0]);
 }
 
-u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
+u8 iwl3945_sync_sta(struct iwl3945_priv *priv, int sta_id, u16 tx_rate, u8 flags)
 {
 	unsigned long flags_spin;
-	struct iwl_station_entry *station;
+	struct iwl3945_station_entry *station;
 
 	if (sta_id == IWL_INVALID_STATION)
 		return IWL_INVALID_STATION;
@@ -689,19 +689,19 @@ u8 iwl3945_sync_sta(struct iwl_priv *pri
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
-	iwl_send_add_station(priv, &station->sta, flags);
+	iwl3945_send_add_station(priv, &station->sta, flags);
 	IWL_DEBUG_RATE("SCALE sync station %d to rate %d\n",
 			sta_id, tx_rate);
 	return sta_id;
 }
 
-static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
+static int iwl3945_nic_set_pwr_src(struct iwl3945_priv *priv, int pwr_max)
 {
 	int rc;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
@@ -713,23 +713,23 @@ static int iwl3945_nic_set_pwr_src(struc
 		rc = pci_read_config_dword(priv->pci_dev,
 				PCI_POWER_SOURCE, &val);
 		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT) {
-			iwl_set_bits_mask_restricted_reg(priv, APMG_PS_CTRL_REG,
+			iwl3945_set_bits_mask_restricted_reg(priv, APMG_PS_CTRL_REG,
 					APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					~APMG_PS_CTRL_MSK_PWR_SRC);
-			iwl_release_restricted_access(priv);
+			iwl3945_release_restricted_access(priv);
 
-			iwl_poll_bit(priv, CSR_GPIO_IN,
+			iwl3945_poll_bit(priv, CSR_GPIO_IN,
 				     CSR_GPIO_IN_VAL_VAUX_PWR_SRC,
 				     CSR_GPIO_IN_BIT_AUX_POWER, 5000);
 		} else
-			iwl_release_restricted_access(priv);
+			iwl3945_release_restricted_access(priv);
 	} else {
-		iwl_set_bits_mask_restricted_reg(priv, APMG_PS_CTRL_REG,
+		iwl3945_set_bits_mask_restricted_reg(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 				~APMG_PS_CTRL_MSK_PWR_SRC);
 
-		iwl_release_restricted_access(priv);
-		iwl_poll_bit(priv, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
+		iwl3945_release_restricted_access(priv);
+		iwl3945_poll_bit(priv, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
 			     CSR_GPIO_IN_BIT_AUX_POWER, 5000);	/* uS */
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -737,24 +737,24 @@ static int iwl3945_nic_set_pwr_src(struc
 	return rc;
 }
 
-static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+static int iwl3945_rx_init(struct iwl3945_priv *priv, struct iwl3945_rx_queue *rxq)
 {
 	int rc;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
-	iwl_write_restricted(priv, FH_RCSR_RBD_BASE(0), rxq->dma_addr);
-	iwl_write_restricted(priv, FH_RCSR_RPTR_ADDR(0),
+	iwl3945_write_restricted(priv, FH_RCSR_RBD_BASE(0), rxq->dma_addr);
+	iwl3945_write_restricted(priv, FH_RCSR_RPTR_ADDR(0),
 			     priv->hw_setting.shared_phys +
-			     offsetof(struct iwl_shared, rx_read_ptr[0]));
-	iwl_write_restricted(priv, FH_RCSR_WPTR(0), 0);
-	iwl_write_restricted(priv, FH_RCSR_CONFIG(0),
+			     offsetof(struct iwl3945_shared, rx_read_ptr[0]));
+	iwl3945_write_restricted(priv, FH_RCSR_WPTR(0), 0);
+	iwl3945_write_restricted(priv, FH_RCSR_CONFIG(0),
 		ALM_FH_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE |
 		ALM_FH_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE |
 		ALM_FH_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN |
@@ -765,44 +765,44 @@ static int iwl3945_rx_init(struct iwl_pr
 		ALM_FH_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH);
 
 	/* fake read to flush all prev I/O */
-	iwl_read_restricted(priv, FH_RSSR_CTRL);
+	iwl3945_read_restricted(priv, FH_RSSR_CTRL);
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
 
-static int iwl3945_tx_reset(struct iwl_priv *priv)
+static int iwl3945_tx_reset(struct iwl3945_priv *priv)
 {
 	int rc;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
 	/* bypass mode */
-	iwl_write_restricted_reg(priv, SCD_MODE_REG, 0x2);
+	iwl3945_write_restricted_reg(priv, SCD_MODE_REG, 0x2);
 
 	/* RA 0 is active */
-	iwl_write_restricted_reg(priv, SCD_ARASTAT_REG, 0x01);
+	iwl3945_write_restricted_reg(priv, SCD_ARASTAT_REG, 0x01);
 
 	/* all 6 fifo are active */
-	iwl_write_restricted_reg(priv, SCD_TXFACT_REG, 0x3f);
+	iwl3945_write_restricted_reg(priv, SCD_TXFACT_REG, 0x3f);
 
-	iwl_write_restricted_reg(priv, SCD_SBYP_MODE_1_REG, 0x010000);
-	iwl_write_restricted_reg(priv, SCD_SBYP_MODE_2_REG, 0x030002);
-	iwl_write_restricted_reg(priv, SCD_TXF4MF_REG, 0x000004);
-	iwl_write_restricted_reg(priv, SCD_TXF5MF_REG, 0x000005);
+	iwl3945_write_restricted_reg(priv, SCD_SBYP_MODE_1_REG, 0x010000);
+	iwl3945_write_restricted_reg(priv, SCD_SBYP_MODE_2_REG, 0x030002);
+	iwl3945_write_restricted_reg(priv, SCD_TXF4MF_REG, 0x000004);
+	iwl3945_write_restricted_reg(priv, SCD_TXF5MF_REG, 0x000005);
 
-	iwl_write_restricted(priv, FH_TSSR_CBB_BASE,
+	iwl3945_write_restricted(priv, FH_TSSR_CBB_BASE,
 			     priv->hw_setting.shared_phys);
 
-	iwl_write_restricted(priv, FH_TSSR_MSG_CONFIG,
+	iwl3945_write_restricted(priv, FH_TSSR_MSG_CONFIG,
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON |
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON |
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B |
@@ -811,7 +811,7 @@ static int iwl3945_tx_reset(struct iwl_p
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH |
 		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH);
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -822,12 +822,12 @@ static int iwl3945_tx_reset(struct iwl_p
  *
  * Destroys all DMA structures and initialize them again
  */
-static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
+static int iwl3945_txq_ctx_reset(struct iwl3945_priv *priv)
 {
 	int rc;
 	int txq_id, slots_num;
 
-	iwl_hw_txq_ctx_free(priv);
+	iwl3945_hw_txq_ctx_free(priv);
 
 	/* Tx CMD queue */
 	rc = iwl3945_tx_reset(priv);
@@ -838,7 +838,7 @@ static int iwl3945_txq_ctx_reset(struct 
 	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 				TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		rc = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
+		rc = iwl3945_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
 				txq_id);
 		if (rc) {
 			IWL_ERROR("Tx %d queue init failed\n", txq_id);
@@ -849,26 +849,26 @@ static int iwl3945_txq_ctx_reset(struct 
 	return rc;
 
  error:
-	iwl_hw_txq_ctx_free(priv);
+	iwl3945_hw_txq_ctx_free(priv);
 	return rc;
 }
 
-int iwl_hw_nic_init(struct iwl_priv *priv)
+int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
 {
 	u8 rev_id;
 	int rc;
 	unsigned long flags;
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl3945_rx_queue *rxq = &priv->rxq;
 
-	iwl_power_init_handle(priv);
+	iwl3945_power_init_handle(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl_set_bit(priv, CSR_ANA_PLL_CFG, (1 << 24));
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+	iwl3945_set_bit(priv, CSR_ANA_PLL_CFG, (1 << 24));
+	iwl3945_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	rc = iwl_poll_bit(priv, CSR_GP_CNTRL,
+	iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	rc = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (rc < 0) {
@@ -877,18 +877,18 @@ int iwl_hw_nic_init(struct iwl_priv *pri
 		return rc;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl_write_restricted_reg(priv, APMG_CLK_EN_REG,
+	iwl3945_write_restricted_reg(priv, APMG_CLK_EN_REG,
 				 APMG_CLK_VAL_DMA_CLK_RQT |
 				 APMG_CLK_VAL_BSM_CLK_RQT);
 	udelay(20);
-	iwl_set_bits_restricted_reg(priv, APMG_PCIDEV_STT_REG,
+	iwl3945_set_bits_restricted_reg(priv, APMG_PCIDEV_STT_REG,
 				    APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Determine HW type */
@@ -904,25 +904,25 @@ int iwl_hw_nic_init(struct iwl_priv *pri
 		IWL_DEBUG_INFO("RTP type \n");
 	else if (rev_id & PCI_CFG_REV_ID_BIT_BASIC_SKU) {
 		IWL_DEBUG_INFO("ALM-MB type\n");
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MB);
 	} else {
 		IWL_DEBUG_INFO("ALM-MM type\n");
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MM);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Initialize the EEPROM */
-	rc = iwl_eeprom_init(priv);
+	rc = iwl3945_eeprom_init(priv);
 	if (rc)
 		return rc;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (EEPROM_SKU_CAP_OP_MODE_MRC == priv->eeprom.sku_cap) {
 		IWL_DEBUG_INFO("SKU OP mode is mrc\n");
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BIT_SKU_MRC);
 	} else
 		IWL_DEBUG_INFO("SKU OP mode is basic\n");
@@ -930,24 +930,24 @@ int iwl_hw_nic_init(struct iwl_priv *pri
 	if ((priv->eeprom.board_revision & 0xF0) == 0xD0) {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
 			       priv->eeprom.board_revision);
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	} else {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
 			       priv->eeprom.board_revision);
-		iwl_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl3945_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
 			      CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	}
 
 	if (priv->eeprom.almgor_m_version <= 1) {
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A);
 		IWL_DEBUG_INFO("Card M type A version is 0x%X\n",
 			       priv->eeprom.almgor_m_version);
 	} else {
 		IWL_DEBUG_INFO("Card M type B version is 0x%X\n",
 			       priv->eeprom.almgor_m_version);
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -960,15 +960,15 @@ int iwl_hw_nic_init(struct iwl_priv *pri
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
-		rc = iwl_rx_queue_alloc(priv);
+		rc = iwl3945_rx_queue_alloc(priv);
 		if (rc) {
 			IWL_ERROR("Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
 	} else
-		iwl_rx_queue_reset(priv, rxq);
+		iwl3945_rx_queue_reset(priv, rxq);
 
-	iwl_rx_replenish(priv);
+	iwl3945_rx_replenish(priv);
 
 	iwl3945_rx_init(priv, rxq);
 
@@ -976,16 +976,16 @@ int iwl_hw_nic_init(struct iwl_priv *pri
 
 	/* Look at using this instead:
 	rxq->need_update = 1;
-	iwl_rx_queue_update_write_ptr(priv, rxq);
+	iwl3945_rx_queue_update_write_ptr(priv, rxq);
 	*/
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl_write_restricted(priv, FH_RCSR_WPTR(0), rxq->write & ~7);
-	iwl_release_restricted_access(priv);
+	iwl3945_write_restricted(priv, FH_RCSR_WPTR(0), rxq->write & ~7);
+	iwl3945_release_restricted_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -999,49 +999,49 @@ int iwl_hw_nic_init(struct iwl_priv *pri
 }
 
 /**
- * iwl_hw_txq_ctx_free - Free TXQ Context
+ * iwl3945_hw_txq_ctx_free - Free TXQ Context
  *
  * Destroy all TX DMA queues and structures
  */
-void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
+void iwl3945_hw_txq_ctx_free(struct iwl3945_priv *priv)
 {
 	int txq_id;
 
 	/* Tx queues */
 	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++)
-		iwl_tx_queue_free(priv, &priv->txq[txq_id]);
+		iwl3945_tx_queue_free(priv, &priv->txq[txq_id]);
 }
 
-void iwl_hw_txq_ctx_stop(struct iwl_priv *priv)
+void iwl3945_hw_txq_ctx_stop(struct iwl3945_priv *priv)
 {
 	int queue;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl_grab_restricted_access(priv)) {
+	if (iwl3945_grab_restricted_access(priv)) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		iwl_hw_txq_ctx_free(priv);
+		iwl3945_hw_txq_ctx_free(priv);
 		return;
 	}
 
 	/* stop SCD */
-	iwl_write_restricted_reg(priv, SCD_MODE_REG, 0);
+	iwl3945_write_restricted_reg(priv, SCD_MODE_REG, 0);
 
 	/* reset TFD queues */
 	for (queue = TFD_QUEUE_MIN; queue < TFD_QUEUE_MAX; queue++) {
-		iwl_write_restricted(priv, FH_TCSR_CONFIG(queue), 0x0);
-		iwl_poll_restricted_bit(priv, FH_TSSR_TX_STATUS,
+		iwl3945_write_restricted(priv, FH_TCSR_CONFIG(queue), 0x0);
+		iwl3945_poll_restricted_bit(priv, FH_TSSR_TX_STATUS,
 				ALM_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(queue),
 				1000);
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl_hw_txq_ctx_free(priv);
+	iwl3945_hw_txq_ctx_free(priv);
 }
 
-int iwl_hw_nic_stop_master(struct iwl_priv *priv)
+int iwl3945_hw_nic_stop_master(struct iwl3945_priv *priv)
 {
 	int rc = 0;
 	u32 reg_val;
@@ -1050,16 +1050,16 @@ int iwl_hw_nic_stop_master(struct iwl_pr
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* set stop master bit */
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+	iwl3945_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	reg_val = iwl_read32(priv, CSR_GP_CNTRL);
+	reg_val = iwl3945_read32(priv, CSR_GP_CNTRL);
 
 	if (CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE ==
 	    (reg_val & CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE))
 		IWL_DEBUG_INFO("Card in power save, master is already "
 			       "stopped\n");
 	else {
-		rc = iwl_poll_bit(priv, CSR_RESET,
+		rc = iwl3945_poll_bit(priv, CSR_RESET,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 		if (rc < 0) {
@@ -1074,47 +1074,47 @@ int iwl_hw_nic_stop_master(struct iwl_pr
 	return rc;
 }
 
-int iwl_hw_nic_reset(struct iwl_priv *priv)
+int iwl3945_hw_nic_reset(struct iwl3945_priv *priv)
 {
 	int rc;
 	unsigned long flags;
 
-	iwl_hw_nic_stop_master(priv);
+	iwl3945_hw_nic_stop_master(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	iwl3945_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
-	rc = iwl_poll_bit(priv, CSR_GP_CNTRL,
+	rc = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (!rc) {
-		iwl_write_restricted_reg(priv, APMG_CLK_CTRL_REG,
+		iwl3945_write_restricted_reg(priv, APMG_CLK_CTRL_REG,
 					 APMG_CLK_VAL_BSM_CLK_RQT);
 
 		udelay(10);
 
-		iwl_set_bit(priv, CSR_GP_CNTRL,
+		iwl3945_set_bit(priv, CSR_GP_CNTRL,
 			    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-		iwl_write_restricted_reg(priv, APMG_RTC_INT_MSK_REG, 0x0);
-		iwl_write_restricted_reg(priv, APMG_RTC_INT_STT_REG,
+		iwl3945_write_restricted_reg(priv, APMG_RTC_INT_MSK_REG, 0x0);
+		iwl3945_write_restricted_reg(priv, APMG_RTC_INT_STT_REG,
 					0xFFFFFFFF);
 
 		/* enable DMA */
-		iwl_write_restricted_reg(priv, APMG_CLK_EN_REG,
+		iwl3945_write_restricted_reg(priv, APMG_CLK_EN_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT |
 					 APMG_CLK_VAL_BSM_CLK_RQT);
 		udelay(10);
 
-		iwl_set_bits_restricted_reg(priv, APMG_PS_CTRL_REG,
+		iwl3945_set_bits_restricted_reg(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_RESET_REQ);
 		udelay(5);
-		iwl_clear_bits_restricted_reg(priv, APMG_PS_CTRL_REG,
+		iwl3945_clear_bits_restricted_reg(priv, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_VAL_RESET_REQ);
-		iwl_release_restricted_access(priv);
+		iwl3945_release_restricted_access(priv);
 	}
 
 	/* Clear the 'host command active' bit... */
@@ -1127,41 +1127,41 @@ int iwl_hw_nic_reset(struct iwl_priv *pr
 }
 
 /**
- * iwl_hw_reg_adjust_power_by_temp - return index delta into power gain settings table
+ * iwl3945_hw_reg_adjust_power_by_temp - return index delta into power gain settings table
  */
-static int iwl_hw_reg_adjust_power_by_temp(int new_reading, int old_reading)
+static int iwl3945_hw_reg_adjust_power_by_temp(int new_reading, int old_reading)
 {
 	return (new_reading - old_reading) * (-11) / 100;
 }
 
 /**
- * iwl_hw_reg_temp_out_of_range - Keep temperature in sane range
+ * iwl3945_hw_reg_temp_out_of_range - Keep temperature in sane range
  */
-static inline int iwl_hw_reg_temp_out_of_range(int temperature)
+static inline int iwl3945_hw_reg_temp_out_of_range(int temperature)
 {
 	return (((temperature < -260) || (temperature > 25)) ? 1 : 0);
 }
 
-int iwl_hw_get_temperature(struct iwl_priv *priv)
+int iwl3945_hw_get_temperature(struct iwl3945_priv *priv)
 {
-	return iwl_read32(priv, CSR_UCODE_DRV_GP2);
+	return iwl3945_read32(priv, CSR_UCODE_DRV_GP2);
 }
 
 /**
- * iwl_hw_reg_txpower_get_temperature - get current temperature by reading from NIC
+ * iwl3945_hw_reg_txpower_get_temperature - get current temperature by reading from NIC
  */
-static int iwl_hw_reg_txpower_get_temperature(struct iwl_priv *priv)
+static int iwl3945_hw_reg_txpower_get_temperature(struct iwl3945_priv *priv)
 {
 	int temperature;
 
-	temperature = iwl_hw_get_temperature(priv);
+	temperature = iwl3945_hw_get_temperature(priv);
 
 	/* driver's okay range is -260 to +25.
 	 *   human readable okay range is 0 to +285 */
 	IWL_DEBUG_INFO("Temperature: %d\n", temperature + IWL_TEMP_CONVERT);
 
 	/* handle insane temp reading */
-	if (iwl_hw_reg_temp_out_of_range(temperature)) {
+	if (iwl3945_hw_reg_temp_out_of_range(temperature)) {
 		IWL_ERROR("Error bad temperature value  %d\n", temperature);
 
 		/* if really really hot(?),
@@ -1186,11 +1186,11 @@ static int iwl_hw_reg_txpower_get_temper
  * records new temperature in tx_mgr->temperature.
  * replaces tx_mgr->last_temperature *only* if calib needed
  *    (assumes caller will actually do the calibration!). */
-static int is_temp_calib_needed(struct iwl_priv *priv)
+static int is_temp_calib_needed(struct iwl3945_priv *priv)
 {
 	int temp_diff;
 
-	priv->temperature = iwl_hw_reg_txpower_get_temperature(priv);
+	priv->temperature = iwl3945_hw_reg_txpower_get_temperature(priv);
 	temp_diff = priv->temperature - priv->last_temperature;
 
 	/* get absolute value */
@@ -1222,7 +1222,7 @@ static int is_temp_calib_needed(struct i
 
 /* radio and DSP power table, each step is 1/2 dB.
  * 1st number is for RF analog gain, 2nd number is for DSP pre-DAC gain. */
-static struct iwl_tx_power power_gain_table[2][IWL_MAX_GAIN_ENTRIES] = {
+static struct iwl3945_tx_power power_gain_table[2][IWL_MAX_GAIN_ENTRIES] = {
 	{
 	 {251, 127},		/* 2.4 GHz, highest power */
 	 {251, 127},
@@ -1383,7 +1383,7 @@ static struct iwl_tx_power power_gain_ta
 	 {3, 120} }		/* 5.x GHz, lowest power */
 };
 
-static inline u8 iwl_hw_reg_fix_power_index(int index)
+static inline u8 iwl3945_hw_reg_fix_power_index(int index)
 {
 	if (index < 0)
 		return 0;
@@ -1396,17 +1396,17 @@ static inline u8 iwl_hw_reg_fix_power_in
 #define REG_RECALIB_PERIOD (60)
 
 /**
- * iwl_hw_reg_set_scan_power - Set Tx power for scan probe requests
+ * iwl3945_hw_reg_set_scan_power - Set Tx power for scan probe requests
  *
  * Set (in our channel info database) the direct scan Tx power for 1 Mbit (CCK)
  * or 6 Mbit (OFDM) rates.
  */
-static void iwl_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_index,
+static void iwl3945_hw_reg_set_scan_power(struct iwl3945_priv *priv, u32 scan_tbl_index,
 			       s32 rate_index, const s8 *clip_pwrs,
-			       struct iwl_channel_info *ch_info,
+			       struct iwl3945_channel_info *ch_info,
 			       int band_index)
 {
-	struct iwl_scan_power_info *scan_power_info;
+	struct iwl3945_scan_power_info *scan_power_info;
 	s8 power;
 	u8 power_index;
 
@@ -1442,7 +1442,7 @@ static void iwl_hw_reg_set_scan_power(st
 	 *   of the table. */
 
 	/* don't exceed table bounds for "real" setting */
-	power_index = iwl_hw_reg_fix_power_index(power_index);
+	power_index = iwl3945_hw_reg_fix_power_index(power_index);
 
 	scan_power_info->power_table_index = power_index;
 	scan_power_info->tpc.tx_gain =
@@ -1452,21 +1452,21 @@ static void iwl_hw_reg_set_scan_power(st
 }
 
 /**
- * iwl_hw_reg_send_txpower - fill in Tx Power command with gain settings
+ * iwl3945_hw_reg_send_txpower - fill in Tx Power command with gain settings
  *
  * Configures power settings for all rates for the current channel,
  * using values from channel info struct, and send to NIC
  */
-int iwl_hw_reg_send_txpower(struct iwl_priv *priv)
+int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv)
 {
 	int rate_idx;
-	const struct iwl_channel_info *ch_info = NULL;
-	struct iwl_txpowertable_cmd txpower = {
+	const struct iwl3945_channel_info *ch_info = NULL;
+	struct iwl3945_txpowertable_cmd txpower = {
 		.channel = priv->active_rxon.channel,
 	};
 
 	txpower.band = (priv->phymode == MODE_IEEE80211A) ? 0 : 1;
-	ch_info = iwl_get_channel_info(priv,
+	ch_info = iwl3945_get_channel_info(priv,
 				       priv->phymode,
 				       le16_to_cpu(priv->active_rxon.channel));
 	if (!ch_info) {
@@ -1485,7 +1485,7 @@ int iwl_hw_reg_send_txpower(struct iwl_p
 	/* fill cmd with power settings for all rates for current channel */
 	for (rate_idx = 0; rate_idx < IWL_RATE_COUNT; rate_idx++) {
 		txpower.power[rate_idx].tpc = ch_info->power_info[rate_idx].tpc;
-		txpower.power[rate_idx].rate = iwl_rates[rate_idx].plcp;
+		txpower.power[rate_idx].rate = iwl3945_rates[rate_idx].plcp;
 
 		IWL_DEBUG_POWER("ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
 				le16_to_cpu(txpower.channel),
@@ -1495,13 +1495,13 @@ int iwl_hw_reg_send_txpower(struct iwl_p
 				txpower.power[rate_idx].rate);
 	}
 
-	return iwl_send_cmd_pdu(priv, REPLY_TX_PWR_TABLE_CMD,
-				sizeof(struct iwl_txpowertable_cmd), &txpower);
+	return iwl3945_send_cmd_pdu(priv, REPLY_TX_PWR_TABLE_CMD,
+				sizeof(struct iwl3945_txpowertable_cmd), &txpower);
 
 }
 
 /**
- * iwl_hw_reg_set_new_power - Configures power tables at new levels
+ * iwl3945_hw_reg_set_new_power - Configures power tables at new levels
  * @ch_info: Channel to update.  Uses power_info.requested_power.
  *
  * Replace requested_power and base_power_index ch_info fields for
@@ -1516,10 +1516,10 @@ int iwl_hw_reg_send_txpower(struct iwl_p
  *	 properly fill out the scan powers, and actual h/w gain settings,
  *	 and send changes to NIC
  */
-static int iwl_hw_reg_set_new_power(struct iwl_priv *priv,
-			     struct iwl_channel_info *ch_info)
+static int iwl3945_hw_reg_set_new_power(struct iwl3945_priv *priv,
+			     struct iwl3945_channel_info *ch_info)
 {
-	struct iwl_channel_power_info *power_info;
+	struct iwl3945_channel_power_info *power_info;
 	int power_changed = 0;
 	int i;
 	const s8 *clip_pwrs;
@@ -1559,7 +1559,7 @@ static int iwl_hw_reg_set_new_power(stru
 		    ch_info->power_info[IWL_RATE_12M_INDEX].
 		    requested_power + IWL_CCK_FROM_OFDM_POWER_DIFF;
 
-		/* do all CCK rates' iwl_channel_power_info structures */
+		/* do all CCK rates' iwl3945_channel_power_info structures */
 		for (i = IWL_FIRST_CCK_RATE; i <= IWL_LAST_CCK_RATE; i++) {
 			power_info->requested_power = power;
 			power_info->base_power_index =
@@ -1573,13 +1573,13 @@ static int iwl_hw_reg_set_new_power(stru
 }
 
 /**
- * iwl_hw_reg_get_ch_txpower_limit - returns new power limit for channel
+ * iwl3945_hw_reg_get_ch_txpower_limit - returns new power limit for channel
  *
  * NOTE: Returned power limit may be less (but not more) than requested,
  *	 based strictly on regulatory (eeprom and spectrum mgt) limitations
  *	 (no consideration for h/w clipping limitations).
  */
-static int iwl_hw_reg_get_ch_txpower_limit(struct iwl_channel_info *ch_info)
+static int iwl3945_hw_reg_get_ch_txpower_limit(struct iwl3945_channel_info *ch_info)
 {
 	s8 max_power;
 
@@ -1598,7 +1598,7 @@ static int iwl_hw_reg_get_ch_txpower_lim
 }
 
 /**
- * iwl_hw_reg_comp_txpower_temp - Compensate for temperature
+ * iwl3945_hw_reg_comp_txpower_temp - Compensate for temperature
  *
  * Compensate txpower settings of *all* channels for temperature.
  * This only accounts for the difference between current temperature
@@ -1607,9 +1607,9 @@ static int iwl_hw_reg_get_ch_txpower_lim
  *
  * If RxOn is "associated", this sends the new Txpower to NIC!
  */
-static int iwl_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
+static int iwl3945_hw_reg_comp_txpower_temp(struct iwl3945_priv *priv)
 {
-	struct iwl_channel_info *ch_info = NULL;
+	struct iwl3945_channel_info *ch_info = NULL;
 	int delta_index;
 	const s8 *clip_pwrs; /* array of h/w max power levels for each rate */
 	u8 a_band;
@@ -1630,7 +1630,7 @@ static int iwl_hw_reg_comp_txpower_temp(
 
 		/* get power index adjustment based on curr and factory
 		 * temps */
-		delta_index = iwl_hw_reg_adjust_power_by_temp(temperature,
+		delta_index = iwl3945_hw_reg_adjust_power_by_temp(temperature,
 							      ref_temp);
 
 		/* set tx power value for all rates, OFDM and CCK */
@@ -1643,7 +1643,7 @@ static int iwl_hw_reg_comp_txpower_temp(
 			power_idx += delta_index;
 
 			/* stay within table range */
-			power_idx = iwl_hw_reg_fix_power_index(power_idx);
+			power_idx = iwl3945_hw_reg_fix_power_index(power_idx);
 			ch_info->power_info[rate_index].
 			    power_table_index = (u8) power_idx;
 			ch_info->power_info[rate_index].tpc =
@@ -1658,19 +1658,19 @@ static int iwl_hw_reg_comp_txpower_temp(
 		     scan_tbl_index < IWL_NUM_SCAN_RATES; scan_tbl_index++) {
 			s32 actual_index = (scan_tbl_index == 0) ?
 			    IWL_RATE_1M_INDEX : IWL_RATE_6M_INDEX;
-			iwl_hw_reg_set_scan_power(priv, scan_tbl_index,
+			iwl3945_hw_reg_set_scan_power(priv, scan_tbl_index,
 					   actual_index, clip_pwrs,
 					   ch_info, a_band);
 		}
 	}
 
 	/* send Txpower command for current channel to ucode */
-	return iwl_hw_reg_send_txpower(priv);
+	return iwl3945_hw_reg_send_txpower(priv);
 }
 
-int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
+int iwl3945_hw_reg_set_txpower(struct iwl3945_priv *priv, s8 power)
 {
-	struct iwl_channel_info *ch_info;
+	struct iwl3945_channel_info *ch_info;
 	s8 max_power;
 	u8 a_band;
 	u8 i;
@@ -1692,26 +1692,26 @@ int iwl_hw_reg_set_txpower(struct iwl_pr
 
 		/* find minimum power of all user and regulatory constraints
 		 *    (does not consider h/w clipping limitations) */
-		max_power = iwl_hw_reg_get_ch_txpower_limit(ch_info);
+		max_power = iwl3945_hw_reg_get_ch_txpower_limit(ch_info);
 		max_power = min(power, max_power);
 		if (max_power != ch_info->curr_txpow) {
 			ch_info->curr_txpow = max_power;
 
 			/* this considers the h/w clipping limitations */
-			iwl_hw_reg_set_new_power(priv, ch_info);
+			iwl3945_hw_reg_set_new_power(priv, ch_info);
 		}
 	}
 
 	/* update txpower settings for all channels,
 	 *   send to NIC if associated. */
 	is_temp_calib_needed(priv);
-	iwl_hw_reg_comp_txpower_temp(priv);
+	iwl3945_hw_reg_comp_txpower_temp(priv);
 
 	return 0;
 }
 
 /* will add 3945 channel switch cmd handling later */
-int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel)
+int iwl3945_hw_channel_switch(struct iwl3945_priv *priv, u16 channel)
 {
 	return 0;
 }
@@ -1726,17 +1726,17 @@ int iwl_hw_channel_switch(struct iwl_pri
  *     -- send new set of gain settings to NIC
  * NOTE:  This should continue working, even when we're not associated,
  *   so we can keep our internal table of scan powers current. */
-void iwl3945_reg_txpower_periodic(struct iwl_priv *priv)
+void iwl3945_reg_txpower_periodic(struct iwl3945_priv *priv)
 {
 	/* This will kick in the "brute force"
-	 * iwl_hw_reg_comp_txpower_temp() below */
+	 * iwl3945_hw_reg_comp_txpower_temp() below */
 	if (!is_temp_calib_needed(priv))
 		goto reschedule;
 
 	/* Set up a new set of temp-adjusted TxPowers, send to NIC.
 	 * This is based *only* on current temperature,
 	 * ignoring any previous power measurements */
-	iwl_hw_reg_comp_txpower_temp(priv);
+	iwl3945_hw_reg_comp_txpower_temp(priv);
 
  reschedule:
 	queue_delayed_work(priv->workqueue,
@@ -1745,7 +1745,7 @@ void iwl3945_reg_txpower_periodic(struct
 
 static void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
 {
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
+	struct iwl3945_priv *priv = container_of(work, struct iwl3945_priv,
 					     thermal_periodic.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -1757,7 +1757,7 @@ static void iwl3945_bg_reg_txpower_perio
 }
 
 /**
- * iwl_hw_reg_get_ch_grp_index - find the channel-group index (0-4)
+ * iwl3945_hw_reg_get_ch_grp_index - find the channel-group index (0-4)
  * 				   for the channel.
  *
  * This function is used when initializing channel-info structs.
@@ -1767,10 +1767,10 @@ static void iwl3945_bg_reg_txpower_perio
  *	 on A-band, EEPROM's "group frequency" entries represent the top
  *	 channel in each group 1-4.  Group 5 All B/G channels are in group 0.
  */
-static u16 iwl_hw_reg_get_ch_grp_index(struct iwl_priv *priv,
-				       const struct iwl_channel_info *ch_info)
+static u16 iwl3945_hw_reg_get_ch_grp_index(struct iwl3945_priv *priv,
+				       const struct iwl3945_channel_info *ch_info)
 {
-	struct iwl_eeprom_txpower_group *ch_grp = &priv->eeprom.groups[0];
+	struct iwl3945_eeprom_txpower_group *ch_grp = &priv->eeprom.groups[0];
 	u8 group;
 	u16 group_index = 0;	/* based on factory calib frequencies */
 	u8 grp_channel;
@@ -1796,20 +1796,20 @@ static u16 iwl_hw_reg_get_ch_grp_index(s
 }
 
 /**
- * iwl_hw_reg_get_matched_power_index - Interpolate to get nominal index
+ * iwl3945_hw_reg_get_matched_power_index - Interpolate to get nominal index
  *
  * Interpolate to get nominal (i.e. at factory calibration temperature) index
  *   into radio/DSP gain settings table for requested power.
  */
-static int iwl_hw_reg_get_matched_power_index(struct iwl_priv *priv,
+static int iwl3945_hw_reg_get_matched_power_index(struct iwl3945_priv *priv,
 				       s8 requested_power,
 				       s32 setting_index, s32 *new_index)
 {
-	const struct iwl_eeprom_txpower_group *chnl_grp = NULL;
+	const struct iwl3945_eeprom_txpower_group *chnl_grp = NULL;
 	s32 index0, index1;
 	s32 power = 2 * requested_power;
 	s32 i;
-	const struct iwl_eeprom_txpower_sample *samples;
+	const struct iwl3945_eeprom_txpower_sample *samples;
 	s32 gains0, gains1;
 	s32 res;
 	s32 denominator;
@@ -1849,11 +1849,11 @@ static int iwl_hw_reg_get_matched_power_
 	return 0;
 }
 
-static void iwl_hw_reg_init_channel_groups(struct iwl_priv *priv)
+static void iwl3945_hw_reg_init_channel_groups(struct iwl3945_priv *priv)
 {
 	u32 i;
 	s32 rate_index;
-	const struct iwl_eeprom_txpower_group *group;
+	const struct iwl3945_eeprom_txpower_group *group;
 
 	IWL_DEBUG_POWER("Initializing factory calib info from EEPROM\n");
 
@@ -1929,10 +1929,10 @@ static void iwl_hw_reg_init_channel_grou
  *
  * This does *not* write values to NIC, just sets up our internal table.
  */
-int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
+int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv)
 {
-	struct iwl_channel_info *ch_info = NULL;
-	struct iwl_channel_power_info *pwr_info;
+	struct iwl3945_channel_info *ch_info = NULL;
+	struct iwl3945_channel_power_info *pwr_info;
 	int delta_index;
 	u8 rate_index;
 	u8 scan_tbl_index;
@@ -1945,10 +1945,10 @@ int iwl3945_txpower_set_from_eeprom(stru
 
 	/* save temperature reference,
 	 *   so we can determine next time to calibrate */
-	temperature = iwl_hw_reg_txpower_get_temperature(priv);
+	temperature = iwl3945_hw_reg_txpower_get_temperature(priv);
 	priv->last_temperature = temperature;
 
-	iwl_hw_reg_init_channel_groups(priv);
+	iwl3945_hw_reg_init_channel_groups(priv);
 
 	/* initialize Tx power info for each and every channel, 2.4 and 5.x */
 	for (i = 0, ch_info = priv->channel_info; i < priv->channel_count;
@@ -1959,14 +1959,14 @@ int iwl3945_txpower_set_from_eeprom(stru
 
 		/* find this channel's channel group (*not* "band") index */
 		ch_info->group_index =
-			iwl_hw_reg_get_ch_grp_index(priv, ch_info);
+			iwl3945_hw_reg_get_ch_grp_index(priv, ch_info);
 
 		/* Get this chnlgrp's rate->max/clip-powers table */
 		clip_pwrs = priv->clip_groups[ch_info->group_index].clip_powers;
 
 		/* calculate power index *adjustment* value according to
 		 *  diff between current temperature and factory temperature */
-		delta_index = iwl_hw_reg_adjust_power_by_temp(temperature,
+		delta_index = iwl3945_hw_reg_adjust_power_by_temp(temperature,
 				priv->eeprom.groups[ch_info->group_index].
 				temperature);
 
@@ -1989,7 +1989,7 @@ int iwl3945_txpower_set_from_eeprom(stru
 
 			/* get base (i.e. at factory-measured temperature)
 			 *    power table index for this rate's power */
-			rc = iwl_hw_reg_get_matched_power_index(priv, pwr,
+			rc = iwl3945_hw_reg_get_matched_power_index(priv, pwr,
 							 ch_info->group_index,
 							 &power_idx);
 			if (rc) {
@@ -2002,9 +2002,9 @@ int iwl3945_txpower_set_from_eeprom(stru
 			power_idx += delta_index;
 
 			/* stay within range of gain table */
-			power_idx = iwl_hw_reg_fix_power_index(power_idx);
+			power_idx = iwl3945_hw_reg_fix_power_index(power_idx);
 
-			/* fill 1 OFDM rate's iwl_channel_power_info struct */
+			/* fill 1 OFDM rate's iwl3945_channel_power_info struct */
 			pwr_info->requested_power = pwr;
 			pwr_info->power_table_index = (u8) power_idx;
 			pwr_info->tpc.tx_gain =
@@ -2023,11 +2023,11 @@ int iwl3945_txpower_set_from_eeprom(stru
 			IWL_CCK_FROM_OFDM_INDEX_DIFF;
 
 		/* stay within table range */
-		pwr_index = iwl_hw_reg_fix_power_index(pwr_index);
+		pwr_index = iwl3945_hw_reg_fix_power_index(pwr_index);
 		gain = power_gain_table[a_band][pwr_index].tx_gain;
 		dsp_atten = power_gain_table[a_band][pwr_index].dsp_atten;
 
-		/* fill each CCK rate's iwl_channel_power_info structure
+		/* fill each CCK rate's iwl3945_channel_power_info structure
 		 * NOTE:  All CCK-rate Txpwrs are the same for a given chnl!
 		 * NOTE:  CCK rates start at end of OFDM rates! */
 		for (rate_index = IWL_OFDM_RATES;
@@ -2045,7 +2045,7 @@ int iwl3945_txpower_set_from_eeprom(stru
 		     scan_tbl_index < IWL_NUM_SCAN_RATES; scan_tbl_index++) {
 			s32 actual_index = (scan_tbl_index == 0) ?
 				IWL_RATE_1M_INDEX : IWL_RATE_6M_INDEX;
-			iwl_hw_reg_set_scan_power(priv, scan_tbl_index,
+			iwl3945_hw_reg_set_scan_power(priv, scan_tbl_index,
 				actual_index, clip_pwrs, ch_info, a_band);
 		}
 	}
@@ -2053,66 +2053,66 @@ int iwl3945_txpower_set_from_eeprom(stru
 	return 0;
 }
 
-int iwl_hw_rxq_stop(struct iwl_priv *priv)
+int iwl3945_hw_rxq_stop(struct iwl3945_priv *priv)
 {
 	int rc;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
-	iwl_write_restricted(priv, FH_RCSR_CONFIG(0), 0);
-	rc = iwl_poll_restricted_bit(priv, FH_RSSR_STATUS, (1 << 24), 1000);
+	iwl3945_write_restricted(priv, FH_RCSR_CONFIG(0), 0);
+	rc = iwl3945_poll_restricted_bit(priv, FH_RSSR_STATUS, (1 << 24), 1000);
 	if (rc < 0)
 		IWL_ERROR("Can't stop Rx DMA.\n");
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
 
-int iwl_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+int iwl3945_hw_tx_queue_init(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq)
 {
 	int rc;
 	unsigned long flags;
 	int txq_id = txq->q.id;
 
-	struct iwl_shared *shared_data = priv->hw_setting.shared_virt;
+	struct iwl3945_shared *shared_data = priv->hw_setting.shared_virt;
 
 	shared_data->tx_base_ptr[txq_id] = cpu_to_le32((u32)txq->q.dma_addr);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl_write_restricted(priv, FH_CBCC_CTRL(txq_id), 0);
-	iwl_write_restricted(priv, FH_CBCC_BASE(txq_id), 0);
+	iwl3945_write_restricted(priv, FH_CBCC_CTRL(txq_id), 0);
+	iwl3945_write_restricted(priv, FH_CBCC_BASE(txq_id), 0);
 
-	iwl_write_restricted(priv, FH_TCSR_CONFIG(txq_id),
+	iwl3945_write_restricted(priv, FH_TCSR_CONFIG(txq_id),
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT |
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF |
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD |
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL |
 		ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE);
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 
 	/* fake read to flush all prev. writes */
-	iwl_read32(priv, FH_TSSR_CBB_BASE);
+	iwl3945_read32(priv, FH_TSSR_CBB_BASE);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
 }
 
-int iwl_hw_get_rx_read(struct iwl_priv *priv)
+int iwl3945_hw_get_rx_read(struct iwl3945_priv *priv)
 {
-	struct iwl_shared *shared_data = priv->hw_setting.shared_virt;
+	struct iwl3945_shared *shared_data = priv->hw_setting.shared_virt;
 
 	return le32_to_cpu(shared_data->rx_read_ptr[0]);
 }
@@ -2120,19 +2120,19 @@ int iwl_hw_get_rx_read(struct iwl_priv *
 /**
  * iwl3945_init_hw_rate_table - Initialize the hardware rate fallback table
  */
-int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
+int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv)
 {
 	int rc, i;
-	struct iwl_rate_scaling_cmd rate_cmd = {
+	struct iwl3945_rate_scaling_cmd rate_cmd = {
 		.reserved = {0, 0, 0},
 	};
-	struct iwl_rate_scaling_info *table = rate_cmd.table;
+	struct iwl3945_rate_scaling_info *table = rate_cmd.table;
 
-	for (i = 0; i < ARRAY_SIZE(iwl_rates); i++) {
+	for (i = 0; i < ARRAY_SIZE(iwl3945_rates); i++) {
 		table[i].rate_n_flags =
-			iwl_hw_set_rate_n_flags(iwl_rates[i].plcp, 0);
+			iwl3945_hw_set_rate_n_flags(iwl3945_rates[i].plcp, 0);
 		table[i].try_cnt = priv->retry_rate;
-		table[i].next_rate_index = iwl_get_prev_ieee_rate(i);
+		table[i].next_rate_index = iwl3945_get_prev_ieee_rate(i);
 	}
 
 	switch (priv->phymode) {
@@ -2169,25 +2169,25 @@ int iwl3945_init_hw_rate_table(struct iw
 
 	/* Update the rate scaling for control frame Tx */
 	rate_cmd.table_id = 0;
-	rc = iwl_send_cmd_pdu(priv, REPLY_RATE_SCALE, sizeof(rate_cmd),
+	rc = iwl3945_send_cmd_pdu(priv, REPLY_RATE_SCALE, sizeof(rate_cmd),
 			      &rate_cmd);
 	if (rc)
 		return rc;
 
 	/* Update the rate scaling for data frame Tx */
 	rate_cmd.table_id = 1;
-	return iwl_send_cmd_pdu(priv, REPLY_RATE_SCALE, sizeof(rate_cmd),
+	return iwl3945_send_cmd_pdu(priv, REPLY_RATE_SCALE, sizeof(rate_cmd),
 				&rate_cmd);
 }
 
-int iwl_hw_set_hw_setting(struct iwl_priv *priv)
+int iwl3945_hw_set_hw_setting(struct iwl3945_priv *priv)
 {
 	memset((void *)&priv->hw_setting, 0,
-	       sizeof(struct iwl_driver_hw_info));
+	       sizeof(struct iwl3945_driver_hw_info));
 
 	priv->hw_setting.shared_virt =
 	    pci_alloc_consistent(priv->pci_dev,
-				 sizeof(struct iwl_shared),
+				 sizeof(struct iwl3945_shared),
 				 &priv->hw_setting.shared_phys);
 
 	if (!priv->hw_setting.shared_virt) {
@@ -2198,7 +2198,7 @@ int iwl_hw_set_hw_setting(struct iwl_pri
 
 	priv->hw_setting.ac_queue_count = AC_NUM;
 	priv->hw_setting.rx_buffer_size = IWL_RX_BUF_SIZE;
-	priv->hw_setting.tx_cmd_len = sizeof(struct iwl_tx_cmd);
+	priv->hw_setting.tx_cmd_len = sizeof(struct iwl3945_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	priv->hw_setting.cck_flag = 0;
@@ -2207,21 +2207,21 @@ int iwl_hw_set_hw_setting(struct iwl_pri
 	return 0;
 }
 
-unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
-			  struct iwl_frame *frame, u8 rate)
+unsigned int iwl3945_hw_get_beacon_cmd(struct iwl3945_priv *priv,
+			  struct iwl3945_frame *frame, u8 rate)
 {
-	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
+	struct iwl3945_tx_beacon_cmd *tx_beacon_cmd;
 	unsigned int frame_size;
 
-	tx_beacon_cmd = (struct iwl_tx_beacon_cmd *)&frame->u;
+	tx_beacon_cmd = (struct iwl3945_tx_beacon_cmd *)&frame->u;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
 	tx_beacon_cmd->tx.sta_id = IWL3945_BROADCAST_ID;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
-	frame_size = iwl_fill_beacon_frame(priv,
+	frame_size = iwl3945_fill_beacon_frame(priv,
 				tx_beacon_cmd->frame,
-				BROADCAST_ADDR,
+				iwl3945_broadcast_addr,
 				sizeof(frame->u) - sizeof(*tx_beacon_cmd));
 
 	BUG_ON(frame_size > MAX_MPDU_SIZE);
@@ -2248,35 +2248,35 @@ unsigned int iwl_hw_get_beacon_cmd(struc
 	tx_beacon_cmd->tx.supp_rates[1] =
 		(IWL_CCK_BASIC_RATES_MASK >> 8) & 0xF;
 
-	return (sizeof(struct iwl_tx_beacon_cmd) + frame_size);
+	return (sizeof(struct iwl3945_tx_beacon_cmd) + frame_size);
 }
 
-void iwl_hw_rx_handler_setup(struct iwl_priv *priv)
+void iwl3945_hw_rx_handler_setup(struct iwl3945_priv *priv)
 {
 	priv->rx_handlers[REPLY_3945_RX] = iwl3945_rx_reply_rx;
 }
 
-void iwl_hw_setup_deferred_work(struct iwl_priv *priv)
+void iwl3945_hw_setup_deferred_work(struct iwl3945_priv *priv)
 {
 	INIT_DELAYED_WORK(&priv->thermal_periodic,
 			  iwl3945_bg_reg_txpower_periodic);
 }
 
-void iwl_hw_cancel_deferred_work(struct iwl_priv *priv)
+void iwl3945_hw_cancel_deferred_work(struct iwl3945_priv *priv)
 {
 	cancel_delayed_work(&priv->thermal_periodic);
 }
 
-struct pci_device_id iwl_hw_card_ids[] = {
+struct pci_device_id iwl3945_hw_card_ids[] = {
 	{0x8086, 0x4222, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0x8086, 0x4227, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0}
 };
 
-inline int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv)
+inline int iwl3945_eeprom_aqcuire_semaphore(struct iwl3945_priv *priv)
 {
-	_iwl_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
+	_iwl3945_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
 	return 0;
 }
 
-MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
+MODULE_DEVICE_TABLE(pci, iwl3945_hw_card_ids);
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-10-12 14:41:08.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-10-12 14:58:22.000000000 +0200
@@ -24,17 +24,17 @@
  *
  *****************************************************************************/
 
-#ifndef __iwl_3945_h__
-#define __iwl_3945_h__
+#ifndef __iwl3945_3945_h__
+#define __iwl3945_3945_h__
 
 #include <linux/pci.h> /* for struct pci_device_id */
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
 
-struct iwl_priv;
+struct iwl3945_priv;
 
 /* Hardware specific file defines the PCI IDs table for that hardware module */
-extern struct pci_device_id iwl_hw_card_ids[];
+extern struct pci_device_id iwl3945_hw_card_ids[];
 
 #define DRV_NAME	"iwl3945"
 #include "iwl-3945-hw.h"
@@ -66,15 +66,15 @@ extern struct pci_device_id iwl_hw_card_
 #define IWL_NOISE_MEAS_NOT_AVAILABLE (-127)
 
 /* Module parameters accessible from iwl-*.c */
-extern int iwl_param_disable_hw_scan;
-extern int iwl_param_debug;
-extern int iwl_param_mode;
-extern int iwl_param_disable;
-extern int iwl_param_antenna;
-extern int iwl_param_hwcrypto;
-extern int iwl_param_queues_num;
+extern int iwl3945_param_disable_hw_scan;
+extern int iwl3945_param_debug;
+extern int iwl3945_param_mode;
+extern int iwl3945_param_disable;
+extern int iwl3945_param_antenna;
+extern int iwl3945_param_hwcrypto;
+extern int iwl3945_param_queues_num;
 
-enum iwl_antenna {
+enum iwl3945_antenna {
 	IWL_ANTENNA_DIVERSITY,
 	IWL_ANTENNA_MAIN,
 	IWL_ANTENNA_AUX
@@ -97,13 +97,13 @@ enum iwl_antenna {
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-struct iwl_rx_mem_buffer {
+struct iwl3945_rx_mem_buffer {
 	dma_addr_t dma_addr;
 	struct sk_buff *skb;
 	struct list_head list;
 };
 
-struct iwl_rt_rx_hdr {
+struct iwl3945_rt_rx_hdr {
 	struct ieee80211_radiotap_header rt_hdr;
 	__le64 rt_tsf;		/* TSF */
 	u8 rt_flags;		/* radiotap packet flags */
@@ -116,7 +116,7 @@ struct iwl_rt_rx_hdr {
 	u8 payload[0];		/* payload... */
 } __attribute__ ((packed));
 
-struct iwl_rt_tx_hdr {
+struct iwl3945_rt_tx_hdr {
 	struct ieee80211_radiotap_header rt_hdr;
 	u8 rt_rate;		/* rate in 500kb/s */
 	__le16 rt_channel;	/* channel in mHz */
@@ -131,7 +131,7 @@ struct iwl_rt_tx_hdr {
  *
  * Contains common data for Rx and Tx queues
  */
-struct iwl_queue {
+struct iwl3945_queue {
 	int n_bd;              /* number of BDs in this queue */
 	int first_empty;       /* 1-st empty entry (index) host_w*/
 	int last_used;         /* last used entry (index) host_r*/
@@ -146,24 +146,24 @@ struct iwl_queue {
 
 #define MAX_NUM_OF_TBS          (20)
 
-struct iwl_tx_info {
+struct iwl3945_tx_info {
 	struct ieee80211_tx_status status;
 	struct sk_buff *skb[MAX_NUM_OF_TBS];
 };
 
 /**
- * struct iwl_tx_queue - Tx Queue for DMA
+ * struct iwl3945_tx_queue - Tx Queue for DMA
  * @need_update: need to update read/write index
  * @shed_retry: queue is HT AGG enabled
  *
  * Queue consists of circular buffer of BD's and required locking structures.
  */
-struct iwl_tx_queue {
-	struct iwl_queue q;
-	struct iwl_tfd_frame *bd;
-	struct iwl_cmd *cmd;
+struct iwl3945_tx_queue {
+	struct iwl3945_queue q;
+	struct iwl3945_tfd_frame *bd;
+	struct iwl3945_cmd *cmd;
 	dma_addr_t dma_addr_cmd;
-	struct iwl_tx_info *txb;
+	struct iwl3945_tx_info *txb;
 	int need_update;
 	int sched_retry;
 	int active;
@@ -171,12 +171,12 @@ struct iwl_tx_queue {
 
 #define IWL_NUM_SCAN_RATES         (2)
 
-struct iwl_channel_tgd_info {
+struct iwl3945_channel_tgd_info {
 	u8 type;
 	s8 max_power;
 };
 
-struct iwl_channel_tgh_info {
+struct iwl3945_channel_tgh_info {
 	s64 last_radar_time;
 };
 
@@ -187,8 +187,8 @@ struct iwl_channel_tgh_info {
  * -- spectrum management
  * -- user preference (e.g. iwconfig)
  * when requested power is set, base power index must also be set. */
-struct iwl_channel_power_info {
-	struct iwl_tx_power tpc;	/* actual radio and DSP gain settings */
+struct iwl3945_channel_power_info {
+	struct iwl3945_tx_power tpc;	/* actual radio and DSP gain settings */
 	s8 power_table_index;	/* actual (compenst'd) index into gain table */
 	s8 base_power_index;	/* gain index for power at factory temp. */
 	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
@@ -196,8 +196,8 @@ struct iwl_channel_power_info {
 
 /* current scan Tx power values to use, one for each scan rate for each
  * channel. */
-struct iwl_scan_power_info {
-	struct iwl_tx_power tpc;	/* actual radio and DSP gain settings */
+struct iwl3945_scan_power_info {
+	struct iwl3945_tx_power tpc;	/* actual radio and DSP gain settings */
 	s8 power_table_index;	/* actual (compenst'd) index into gain table */
 	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
 };
@@ -217,11 +217,11 @@ struct iwl_scan_power_info {
  */
 #define IWL4965_MAX_RATE (33)
 
-struct iwl_channel_info {
-	struct iwl_channel_tgd_info tgd;
-	struct iwl_channel_tgh_info tgh;
-	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
-	struct iwl_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
+struct iwl3945_channel_info {
+	struct iwl3945_channel_tgd_info tgd;
+	struct iwl3945_channel_tgh_info tgh;
+	struct iwl3945_eeprom_channel eeprom;	/* EEPROM regulatory limit */
+	struct iwl3945_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
 						 * FAT channel */
 
 	u8 channel;	  /* channel number */
@@ -238,58 +238,58 @@ struct iwl_channel_info {
 	/* Radio/DSP gain settings for each "normal" data Tx rate.
 	 * These include, in addition to RF and DSP gain, a few fields for
 	 *   remembering/modifying gain settings (indexes). */
-	struct iwl_channel_power_info power_info[IWL4965_MAX_RATE];
+	struct iwl3945_channel_power_info power_info[IWL4965_MAX_RATE];
 
 	/* Radio/DSP gain settings for each scan rate, for directed scans. */
-	struct iwl_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
+	struct iwl3945_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
 };
 
-struct iwl_clip_group {
+struct iwl3945_clip_group {
 	/* maximum power level to prevent clipping for each rate, derived by
 	 *   us from this band's saturation power in EEPROM */
 	const s8 clip_powers[IWL_MAX_RATES];
 };
 
-static inline int is_channel_valid(const struct iwl_channel_info *ch_info)
+static inline int is_channel_valid(const struct iwl3945_channel_info *ch_info)
 {
 	if (ch_info == NULL)
 		return 0;
 	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
 }
 
-static inline int is_channel_narrow(const struct iwl_channel_info *ch_info)
+static inline int is_channel_narrow(const struct iwl3945_channel_info *ch_info)
 {
 	return (ch_info->flags & EEPROM_CHANNEL_NARROW) ? 1 : 0;
 }
 
-static inline int is_channel_radar(const struct iwl_channel_info *ch_info)
+static inline int is_channel_radar(const struct iwl3945_channel_info *ch_info)
 {
 	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
 }
 
-static inline u8 is_channel_a_band(const struct iwl_channel_info *ch_info)
+static inline u8 is_channel_a_band(const struct iwl3945_channel_info *ch_info)
 {
 	return ch_info->phymode == MODE_IEEE80211A;
 }
 
-static inline u8 is_channel_bg_band(const struct iwl_channel_info *ch_info)
+static inline u8 is_channel_bg_band(const struct iwl3945_channel_info *ch_info)
 {
 	return ((ch_info->phymode == MODE_IEEE80211B) ||
 		(ch_info->phymode == MODE_IEEE80211G));
 }
 
-static inline int is_channel_passive(const struct iwl_channel_info *ch)
+static inline int is_channel_passive(const struct iwl3945_channel_info *ch)
 {
 	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
 }
 
-static inline int is_channel_ibss(const struct iwl_channel_info *ch)
+static inline int is_channel_ibss(const struct iwl3945_channel_info *ch)
 {
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
-extern const struct iwl_channel_info *iwl_get_channel_info(
-	const struct iwl_priv *priv, int phymode, u16 channel);
+extern const struct iwl3945_channel_info *iwl3945_get_channel_info(
+	const struct iwl3945_priv *priv, int phymode, u16 channel);
 
 #include "iwl-3945-rs.h"
 
@@ -306,8 +306,8 @@ extern const struct iwl_channel_info *iw
 
 /* Power management (not Tx power) structures */
 
-struct iwl_power_vec_entry {
-	struct iwl_powertable_cmd cmd;
+struct iwl3945_power_vec_entry {
+	struct iwl3945_powertable_cmd cmd;
 	u8 no_dtim;
 };
 #define IWL_POWER_RANGE_0  (0)
@@ -323,10 +323,10 @@ struct iwl_power_vec_entry {
 #define IWL_POWER_ENABLED	0x10
 #define IWL_POWER_LEVEL(x)	((x) & IWL_POWER_MASK)
 
-struct iwl_power_mgr {
+struct iwl3945_power_mgr {
 	spinlock_t lock;
-	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_AC];
-	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_AC];
+	struct iwl3945_power_vec_entry pwr_range_0[IWL_POWER_AC];
+	struct iwl3945_power_vec_entry pwr_range_1[IWL_POWER_AC];
 	u8 active_index;
 	u32 dtim_val;
 };
@@ -336,10 +336,10 @@ struct iwl_power_mgr {
 #define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
 #define IEEE80211_FRAME_LEN             (IEEE80211_DATA_LEN + IEEE80211_HLEN)
 
-struct iwl_frame {
+struct iwl3945_frame {
 	union {
 		struct ieee80211_hdr frame;
-		struct iwl_tx_beacon_cmd beacon;
+		struct iwl3945_tx_beacon_cmd beacon;
 		u8 raw[IEEE80211_FRAME_LEN];
 		u8 cmd[360];
 	} u;
@@ -365,15 +365,15 @@ enum {
 	CMD_WANT_SKB = (1 << 2),
 };
 
-struct iwl_cmd;
-struct iwl_priv;
+struct iwl3945_cmd;
+struct iwl3945_priv;
 
-struct iwl_cmd_meta {
-	struct iwl_cmd_meta *source;
+struct iwl3945_cmd_meta {
+	struct iwl3945_cmd_meta *source;
 	union {
 		struct sk_buff *skb;
-		int (*callback)(struct iwl_priv *priv,
-				struct iwl_cmd *cmd, struct sk_buff *skb);
+		int (*callback)(struct iwl3945_priv *priv,
+				struct iwl3945_cmd *cmd, struct sk_buff *skb);
 	} __attribute__ ((packed)) u;
 
 	/* The CMD_SIZE_HUGE flag bit indicates that the command
@@ -382,37 +382,37 @@ struct iwl_cmd_meta {
 
 } __attribute__ ((packed));
 
-struct iwl_cmd {
-	struct iwl_cmd_meta meta;
-	struct iwl_cmd_header hdr;
+struct iwl3945_cmd {
+	struct iwl3945_cmd_meta meta;
+	struct iwl3945_cmd_header hdr;
 	union {
-		struct iwl_addsta_cmd addsta;
-		struct iwl_led_cmd led;
+		struct iwl3945_addsta_cmd addsta;
+		struct iwl3945_led_cmd led;
 		u32 flags;
 		u8 val8;
 		u16 val16;
 		u32 val32;
-		struct iwl_bt_cmd bt;
-		struct iwl_rxon_time_cmd rxon_time;
-		struct iwl_powertable_cmd powertable;
-		struct iwl_qosparam_cmd qosparam;
-		struct iwl_tx_cmd tx;
-		struct iwl_tx_beacon_cmd tx_beacon;
-		struct iwl_rxon_assoc_cmd rxon_assoc;
+		struct iwl3945_bt_cmd bt;
+		struct iwl3945_rxon_time_cmd rxon_time;
+		struct iwl3945_powertable_cmd powertable;
+		struct iwl3945_qosparam_cmd qosparam;
+		struct iwl3945_tx_cmd tx;
+		struct iwl3945_tx_beacon_cmd tx_beacon;
+		struct iwl3945_rxon_assoc_cmd rxon_assoc;
 		u8 *indirect;
 		u8 payload[360];
 	} __attribute__ ((packed)) cmd;
 } __attribute__ ((packed));
 
-struct iwl_host_cmd {
+struct iwl3945_host_cmd {
 	u8 id;
 	u16 len;
-	struct iwl_cmd_meta meta;
+	struct iwl3945_cmd_meta meta;
 	const void *data;
 };
 
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
-			      sizeof(struct iwl_cmd_meta))
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl3945_cmd) - \
+			      sizeof(struct iwl3945_cmd_meta))
 
 /*
  * RX related structures and functions
@@ -425,7 +425,7 @@ struct iwl_host_cmd {
 #define SUP_RATE_11G_MAX_NUM_CHANNELS  12
 
 /**
- * struct iwl_rx_queue - Rx queue
+ * struct iwl3945_rx_queue - Rx queue
  * @processed: Internal index to last handled Rx packet
  * @read: Shared index to newest available Rx buffer
  * @write: Shared index to oldest written Rx packet
@@ -434,13 +434,13 @@ struct iwl_host_cmd {
  * @rx_used: List of Rx buffers with no SKB
  * @need_update: flag to indicate we need to update read/write index
  *
- * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
+ * NOTE:  rx_free and rx_used are used as a FIFO for iwl3945_rx_mem_buffers
  */
-struct iwl_rx_queue {
+struct iwl3945_rx_queue {
 	__le32 *bd;
 	dma_addr_t dma_addr;
-	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
+	struct iwl3945_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct iwl3945_rx_mem_buffer *queue[RX_QUEUE_SIZE];
 	u32 processed;
 	u32 read;
 	u32 write;
@@ -484,17 +484,17 @@ struct iwl_rx_queue {
 #define IWL_INVALID_RATE     0xFF
 #define IWL_INVALID_VALUE    -1
 
-struct iwl_tid_data {
+struct iwl3945_tid_data {
 	u16 seq_number;
 };
 
-struct iwl_hw_key {
+struct iwl3945_hw_key {
 	enum ieee80211_key_alg alg;
 	int keylen;
 	u8 key[32];
 };
 
-union iwl_ht_rate_supp {
+union iwl3945_ht_rate_supp {
 	u16 rates;
 	struct {
 		u8 siso_rate;
@@ -503,7 +503,7 @@ union iwl_ht_rate_supp {
 };
 
 #ifdef CONFIG_IWL3945_QOS
-union iwl_qos_capabity {
+union iwl3945_qos_capabity {
 	struct {
 		u8 edca_count:4;	/* bit 0-3 */
 		u8 q_ack:1;		/* bit 4 */
@@ -524,20 +524,20 @@ union iwl_qos_capabity {
 };
 
 /* QoS sturctures */
-struct iwl_qos_info {
+struct iwl3945_qos_info {
 	int qos_enable;
 	int qos_active;
-	union iwl_qos_capabity qos_cap;
-	struct iwl_qosparam_cmd def_qos_parm;
+	union iwl3945_qos_capabity qos_cap;
+	struct iwl3945_qosparam_cmd def_qos_parm;
 };
 #endif /*CONFIG_IWL3945_QOS */
 
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
 
-struct iwl_station_entry {
-	struct iwl_addsta_cmd sta;
-	struct iwl_tid_data tid[MAX_TID_COUNT];
+struct iwl3945_station_entry {
+	struct iwl3945_addsta_cmd sta;
+	struct iwl3945_tid_data tid[MAX_TID_COUNT];
 	union {
 		struct {
 			u8 rate;
@@ -547,7 +547,7 @@ struct iwl_station_entry {
 	} current_rate;
 	u8 used;
 	u8 ps_status;
-	struct iwl_hw_key keyinfo;
+	struct iwl3945_hw_key keyinfo;
 };
 
 /* one for each uCode image (inst/data, boot/init/runtime) */
@@ -558,7 +558,7 @@ struct fw_image_desc {
 };
 
 /* uCode file layout */
-struct iwl_ucode {
+struct iwl3945_ucode {
 	__le32 ver;		/* major/minor/subminor */
 	__le32 inst_size;	/* bytes of runtime instructions */
 	__le32 data_size;	/* bytes of runtime data */
@@ -570,7 +570,7 @@ struct iwl_ucode {
 
 #define IWL_IBSS_MAC_HASH_SIZE 32
 
-struct iwl_ibss_seq {
+struct iwl3945_ibss_seq {
 	u8 mac[ETH_ALEN];
 	u16 seq_num;
 	u16 frag_num;
@@ -578,7 +578,7 @@ struct iwl_ibss_seq {
 	struct list_head list;
 };
 
-struct iwl_driver_hw_info {
+struct iwl3945_driver_hw_info {
 	u16 max_txq_num;
 	u16 ac_queue_count;
 	u32 rx_buffer_size;
@@ -604,10 +604,10 @@ struct iwl_driver_hw_info {
 #define HT_SHORT_GI_20MHZ_ONLY          (1 << 0)
 #define HT_SHORT_GI_40MHZ_ONLY          (1 << 1)
 
-#define IWL_RX_HDR(x) ((struct iwl_rx_frame_hdr *)(\
+#define IWL_RX_HDR(x) ((struct iwl3945_rx_frame_hdr *)(\
 		       x->u.rx_frame.stats.payload + \
 		       x->u.rx_frame.stats.phy_count))
-#define IWL_RX_END(x) ((struct iwl_rx_frame_end *)(\
+#define IWL_RX_END(x) ((struct iwl3945_rx_frame_end *)(\
 		       IWL_RX_HDR(x)->payload + \
 		       le16_to_cpu(IWL_RX_HDR(x)->len)))
 #define IWL_RX_STATS(x) (&x->u.rx_frame.stats)
@@ -620,62 +620,62 @@ struct iwl_driver_hw_info {
  * for use by iwl-*.c
  *
  *****************************************************************************/
-struct iwl_addsta_cmd;
-extern int iwl_send_add_station(struct iwl_priv *priv,
-				struct iwl_addsta_cmd *sta, u8 flags);
-extern u8 iwl_add_station(struct iwl_priv *priv, const u8 *bssid,
+struct iwl3945_addsta_cmd;
+extern int iwl3945_send_add_station(struct iwl3945_priv *priv,
+				struct iwl3945_addsta_cmd *sta, u8 flags);
+extern u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *bssid,
 			  int is_ap, u8 flags);
-extern int iwl_is_network_packet(struct iwl_priv *priv,
+extern int iwl3945_is_network_packet(struct iwl3945_priv *priv,
 				 struct ieee80211_hdr *header);
-extern int iwl_power_init_handle(struct iwl_priv *priv);
-extern int iwl_eeprom_init(struct iwl_priv *priv);
+extern int iwl3945_power_init_handle(struct iwl3945_priv *priv);
+extern int iwl3945_eeprom_init(struct iwl3945_priv *priv);
 #ifdef CONFIG_IWL3945_DEBUG
-extern void iwl_report_frame(struct iwl_priv *priv,
-			     struct iwl_rx_packet *pkt,
+extern void iwl3945_report_frame(struct iwl3945_priv *priv,
+			     struct iwl3945_rx_packet *pkt,
 			     struct ieee80211_hdr *header, int group100);
 #else
-static inline void iwl_report_frame(struct iwl_priv *priv,
-				    struct iwl_rx_packet *pkt,
+static inline void iwl3945_report_frame(struct iwl3945_priv *priv,
+				    struct iwl3945_rx_packet *pkt,
 				    struct ieee80211_hdr *header,
 				    int group100) {}
 #endif
-extern void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
-					   struct iwl_rx_mem_buffer *rxb,
+extern void iwl3945_handle_data_packet_monitor(struct iwl3945_priv *priv,
+					   struct iwl3945_rx_mem_buffer *rxb,
 					   void *data, short len,
 					   struct ieee80211_rx_status *stats,
 					   u16 phy_flags);
-extern int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr
-			       *header);
-extern int iwl_rx_queue_alloc(struct iwl_priv *priv);
-extern void iwl_rx_queue_reset(struct iwl_priv *priv,
-			       struct iwl_rx_queue *rxq);
-extern int iwl_calc_db_from_ratio(int sig_ratio);
-extern int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm);
-extern int iwl_tx_queue_init(struct iwl_priv *priv,
-			     struct iwl_tx_queue *txq, int count, u32 id);
-extern void iwl_rx_replenish(void *data);
-extern void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-extern int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
+extern int iwl3945_is_duplicate_packet(struct iwl3945_priv *priv,
+				       struct ieee80211_hdr *header);
+extern int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv);
+extern void iwl3945_rx_queue_reset(struct iwl3945_priv *priv,
+			       struct iwl3945_rx_queue *rxq);
+extern int iwl3945_calc_db_from_ratio(int sig_ratio);
+extern int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm);
+extern int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
+			     struct iwl3945_tx_queue *txq, int count, u32 id);
+extern void iwl3945_rx_replenish(void *data);
+extern void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq);
+extern int iwl3945_send_cmd_pdu(struct iwl3945_priv *priv, u8 id, u16 len,
 			    const void *data);
-extern int __must_check iwl_send_cmd(struct iwl_priv *priv,
-		struct iwl_host_cmd *cmd);
-extern unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
+extern int __must_check iwl3945_send_cmd(struct iwl3945_priv *priv,
+		struct iwl3945_host_cmd *cmd);
+extern unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
 					struct ieee80211_hdr *hdr,
 					const u8 *dest, int left);
-extern int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
-					 struct iwl_rx_queue *q);
-extern int iwl_send_statistics_request(struct iwl_priv *priv);
-extern void iwl_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
+extern int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv,
+					 struct iwl3945_rx_queue *q);
+extern int iwl3945_send_statistics_request(struct iwl3945_priv *priv);
+extern void iwl3945_set_decrypted_flag(struct iwl3945_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
 				   struct ieee80211_rx_status *stats);
 
-extern const u8 BROADCAST_ADDR[ETH_ALEN];
+extern const u8 iwl3945_broadcast_addr[ETH_ALEN];
 
 /*
  * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
  * call this... todo... fix that.
 */
-extern u8 iwl_sync_station(struct iwl_priv *priv, int sta_id,
+extern u8 iwl3945_sync_station(struct iwl3945_priv *priv, int sta_id,
 			   u16 tx_rate, u8 flags);
 
 /******************************************************************************
@@ -687,65 +687,65 @@ extern u8 iwl_sync_station(struct iwl_pr
  * which is why they are in the hardware specific files (vs. iwl-base.c)
  *
  * Naming convention --
- * iwl_         <-- Its part of iwlwifi (should be changed to iwl_)
- * iwl_hw_      <-- Hardware specific (implemented in iwl-XXXX.c by all HW)
+ * iwl3945_         <-- Its part of iwlwifi (should be changed to iwl3945_)
+ * iwl3945_hw_      <-- Hardware specific (implemented in iwl-XXXX.c by all HW)
  * iwlXXXX_     <-- Hardware specific (implemented in iwl-XXXX.c for XXXX)
- * iwl_bg_      <-- Called from work queue context
- * iwl_mac_     <-- mac80211 callback
+ * iwl3945_bg_      <-- Called from work queue context
+ * iwl3945_mac_     <-- mac80211 callback
  *
  ****************************************************************************/
-extern void iwl_hw_rx_handler_setup(struct iwl_priv *priv);
-extern void iwl_hw_setup_deferred_work(struct iwl_priv *priv);
-extern void iwl_hw_cancel_deferred_work(struct iwl_priv *priv);
-extern int iwl_hw_rxq_stop(struct iwl_priv *priv);
-extern int iwl_hw_set_hw_setting(struct iwl_priv *priv);
-extern int iwl_hw_nic_init(struct iwl_priv *priv);
-extern int iwl_hw_nic_stop_master(struct iwl_priv *priv);
-extern void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
-extern void iwl_hw_txq_ctx_stop(struct iwl_priv *priv);
-extern int iwl_hw_nic_reset(struct iwl_priv *priv);
-extern int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
+extern void iwl3945_hw_rx_handler_setup(struct iwl3945_priv *priv);
+extern void iwl3945_hw_setup_deferred_work(struct iwl3945_priv *priv);
+extern void iwl3945_hw_cancel_deferred_work(struct iwl3945_priv *priv);
+extern int iwl3945_hw_rxq_stop(struct iwl3945_priv *priv);
+extern int iwl3945_hw_set_hw_setting(struct iwl3945_priv *priv);
+extern int iwl3945_hw_nic_init(struct iwl3945_priv *priv);
+extern int iwl3945_hw_nic_stop_master(struct iwl3945_priv *priv);
+extern void iwl3945_hw_txq_ctx_free(struct iwl3945_priv *priv);
+extern void iwl3945_hw_txq_ctx_stop(struct iwl3945_priv *priv);
+extern int iwl3945_hw_nic_reset(struct iwl3945_priv *priv);
+extern int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl3945_priv *priv, void *tfd,
 					dma_addr_t addr, u16 len);
-extern int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-extern int iwl_hw_get_temperature(struct iwl_priv *priv);
-extern int iwl_hw_tx_queue_init(struct iwl_priv *priv,
-				struct iwl_tx_queue *txq);
-extern unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
-				 struct iwl_frame *frame, u8 rate);
-extern int iwl_hw_get_rx_read(struct iwl_priv *priv);
-extern void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-				     struct iwl_cmd *cmd,
+extern int iwl3945_hw_txq_free_tfd(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq);
+extern int iwl3945_hw_get_temperature(struct iwl3945_priv *priv);
+extern int iwl3945_hw_tx_queue_init(struct iwl3945_priv *priv,
+				struct iwl3945_tx_queue *txq);
+extern unsigned int iwl3945_hw_get_beacon_cmd(struct iwl3945_priv *priv,
+				 struct iwl3945_frame *frame, u8 rate);
+extern int iwl3945_hw_get_rx_read(struct iwl3945_priv *priv);
+extern void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
+				     struct iwl3945_cmd *cmd,
 				     struct ieee80211_tx_control *ctrl,
 				     struct ieee80211_hdr *hdr,
 				     int sta_id, int tx_id);
-extern int iwl_hw_reg_send_txpower(struct iwl_priv *priv);
-extern int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
-extern void iwl_hw_rx_statistics(struct iwl_priv *priv,
-				 struct iwl_rx_mem_buffer *rxb);
-extern void iwl_disable_events(struct iwl_priv *priv);
-extern int iwl4965_get_temperature(const struct iwl_priv *priv);
+extern int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv);
+extern int iwl3945_hw_reg_set_txpower(struct iwl3945_priv *priv, s8 power);
+extern void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv,
+				 struct iwl3945_rx_mem_buffer *rxb);
+extern void iwl3945_disable_events(struct iwl3945_priv *priv);
+extern int iwl4965_get_temperature(const struct iwl3945_priv *priv);
 
 /**
- * iwl_hw_find_station - Find station id for a given BSSID
+ * iwl3945_hw_find_station - Find station id for a given BSSID
  * @bssid: MAC address of station ID to find
  *
  * NOTE:  This should not be hardware specific but the code has
  * not yet been merged into a single common layer for managing the
  * station tables.
  */
-extern u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
+extern u8 iwl3945_hw_find_station(struct iwl3945_priv *priv, const u8 *bssid);
 
-extern int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel);
+extern int iwl3945_hw_channel_switch(struct iwl3945_priv *priv, u16 channel);
 
 /*
  * Forward declare iwl-3945.c functions for iwl-base.c
  */
-extern int iwl_eeprom_aqcuire_semaphore(struct iwl_priv *priv);
-extern __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv);
-extern int iwl3945_init_hw_rate_table(struct iwl_priv *priv);
-extern void iwl3945_reg_txpower_periodic(struct iwl_priv *priv);
-extern int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv);
-extern u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
+extern int iwl3945_eeprom_aqcuire_semaphore(struct iwl3945_priv *priv);
+extern __le32 iwl3945_get_antenna_flags(const struct iwl3945_priv *priv);
+extern int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv);
+extern void iwl3945_reg_txpower_periodic(struct iwl3945_priv *priv);
+extern int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv);
+extern u8 iwl3945_sync_sta(struct iwl3945_priv *priv, int sta_id,
 		 u16 tx_rate, u8 flags);
 
 
@@ -756,7 +756,7 @@ enum {
 };
 #endif
 
-struct iwl_priv {
+struct iwl3945_priv {
 
 	/* ieee device used by generic ieee processing code */
 	struct ieee80211_hw *hw;
@@ -770,27 +770,27 @@ struct iwl_priv {
 	u8 phymode;
 	int alloc_rxb_skb;
 
-	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb);
+	void (*rx_handlers[REPLY_MAX])(struct iwl3945_priv *priv,
+				       struct iwl3945_rx_mem_buffer *rxb);
 
 	const struct ieee80211_hw_mode *modes;
 
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
-	struct iwl_spectrum_notification measure_report;
+	struct iwl3945_spectrum_notification measure_report;
 	u8 measurement_status;
 #endif
 	/* ucode beacon time */
 	u32 ucode_beacon_time;
 
-	/* we allocate array of iwl_channel_info for NIC's valid channels.
+	/* we allocate array of iwl3945_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
-	struct iwl_channel_info *channel_info;	/* channel info array */
+	struct iwl3945_channel_info *channel_info;	/* channel info array */
 	u8 channel_count;	/* # of channels */
 
 	/* each calibration channel group in the EEPROM has a derived
 	 * clip setting for each rate. */
-	const struct iwl_clip_group clip_groups[5];
+	const struct iwl3945_clip_group clip_groups[5];
 
 	/* thermal calibration */
 	s32 temperature;	/* degrees Kelvin */
@@ -805,7 +805,7 @@ struct iwl_priv {
 	int one_direct_scan;
 	u8 direct_ssid_len;
 	u8 direct_ssid[IW_ESSID_MAX_SIZE];
-	struct iwl_scan_cmd *scan;
+	struct iwl3945_scan_cmd *scan;
 	u8 only_active_channel;
 
 	/* spinlock */
@@ -828,26 +828,26 @@ struct iwl_priv {
 	struct fw_image_desc ucode_boot;	/* bootstrap inst */
 
 
-	struct iwl_rxon_time_cmd rxon_timing;
+	struct iwl3945_rxon_time_cmd rxon_timing;
 
 	/* We declare this const so it can only be
 	 * changed via explicit cast within the
 	 * routines that actually update the physical
 	 * hardware */
-	const struct iwl_rxon_cmd active_rxon;
-	struct iwl_rxon_cmd staging_rxon;
+	const struct iwl3945_rxon_cmd active_rxon;
+	struct iwl3945_rxon_cmd staging_rxon;
 
 	int error_recovering;
-	struct iwl_rxon_cmd recovery_rxon;
+	struct iwl3945_rxon_cmd recovery_rxon;
 
 	/* 1st responses from initialize and runtime uCode images.
 	 * 4965's initialize alive response contains some calibration data. */
-	struct iwl_init_alive_resp card_alive_init;
-	struct iwl_alive_resp card_alive;
+	struct iwl3945_init_alive_resp card_alive_init;
+	struct iwl3945_alive_resp card_alive;
 
 #ifdef LED
 	/* LED related variables */
-	struct iwl_activity_blink activity;
+	struct iwl3945_activity_blink activity;
 	unsigned long led_packets;
 	int led_state;
 #endif
@@ -867,8 +867,8 @@ struct iwl_priv {
 	int activity_timer_active;
 
 	/* Rx and Tx DMA processing queues */
-	struct iwl_rx_queue rxq;
-	struct iwl_tx_queue txq[IWL_MAX_NUM_QUEUES];
+	struct iwl3945_rx_queue rxq;
+	struct iwl3945_tx_queue txq[IWL_MAX_NUM_QUEUES];
 
 	unsigned long status;
 	u32 config;
@@ -876,9 +876,9 @@ struct iwl_priv {
 	int last_rx_rssi;	/* From Rx packet statisitics */
 	int last_rx_noise;	/* From beacon statistics */
 
-	struct iwl_power_mgr power_data;
+	struct iwl3945_power_mgr power_data;
 
-	struct iwl_notif_statistics statistics;
+	struct iwl3945_notif_statistics statistics;
 	unsigned long last_statistics_time;
 
 	/* context information */
@@ -895,7 +895,7 @@ struct iwl_priv {
 	/*station table variables */
 	spinlock_t sta_lock;
 	int num_stations;
-	struct iwl_station_entry stations[IWL_STATION_COUNT];
+	struct iwl3945_station_entry stations[IWL_STATION_COUNT];
 
 	/* Indication if ieee80211_ops->open has been called */
 	int is_open;
@@ -916,7 +916,7 @@ struct iwl_priv {
 	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
 
 	/* eeprom */
-	struct iwl_eeprom eeprom;
+	struct iwl3945_eeprom eeprom;
 
 	int iw_mode;
 
@@ -926,7 +926,7 @@ struct iwl_priv {
 	u32 timestamp0;
 	u32 timestamp1;
 	u16 beacon_int;
-	struct iwl_driver_hw_info hw_setting;
+	struct iwl3945_driver_hw_info hw_setting;
 	int interface_id;
 
 	/* Current association information needed to configure the
@@ -936,7 +936,7 @@ struct iwl_priv {
 	u8 ps_mode;
 
 #ifdef CONFIG_IWL3945_QOS
-	struct iwl_qos_info qos_data;
+	struct iwl3945_qos_info qos_data;
 #endif /*CONFIG_IWL3945_QOS */
 
 	struct workqueue_struct *workqueue;
@@ -978,9 +978,9 @@ struct iwl_priv {
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
 #endif
-};				/*iwl_priv */
+};				/*iwl3945_priv */
 
-static inline int iwl_is_associated(struct iwl_priv *priv)
+static inline int iwl3945_is_associated(struct iwl3945_priv *priv)
 {
 	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-12 14:38:29.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-12 14:57:22.000000000 +0200
@@ -62,11 +62,11 @@
 #include "iwl-helpers.h"
 
 #ifdef CONFIG_IWL3945_DEBUG
-u32 iwl_debug_level;
+u32 iwl3945_debug_level;
 #endif
 
-static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl_tx_queue *txq);
+static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
+				  struct iwl3945_tx_queue *txq);
 
 /******************************************************************************
  *
@@ -75,13 +75,13 @@ static int iwl_tx_queue_update_write_ptr
  ******************************************************************************/
 
 /* module parameters */
-int iwl_param_disable_hw_scan;
-int iwl_param_debug;
-int iwl_param_disable;      /* def: enable radio */
-int iwl_param_antenna;      /* def: 0 = both antennas (use diversity) */
-int iwl_param_hwcrypto;     /* def: using software encryption */
-static int iwl_param_qos_enable = 1;
-int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
+int iwl3945_param_disable_hw_scan;
+int iwl3945_param_debug;
+int iwl3945_param_disable;      /* def: enable radio */
+int iwl3945_param_antenna;      /* def: 0 = both antennas (use diversity) */
+int iwl3945_param_hwcrypto;     /* def: using software encryption */
+static int iwl3945_param_qos_enable = 1;
+int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES;
 
 /*
  * module name, copyright, version, etc.
@@ -128,8 +128,8 @@ static __le16 *ieee80211_get_qos_ctrl(st
 	return NULL;
 }
 
-static const struct ieee80211_hw_mode *iwl_get_hw_mode(
-		struct iwl_priv *priv, int mode)
+static const struct ieee80211_hw_mode *iwl3945_get_hw_mode(
+		struct iwl3945_priv *priv, int mode)
 {
 	int i;
 
@@ -140,7 +140,7 @@ static const struct ieee80211_hw_mode *i
 	return NULL;
 }
 
-static int iwl_is_empty_essid(const char *essid, int essid_len)
+static int iwl3945_is_empty_essid(const char *essid, int essid_len)
 {
 	/* Single white space is for Linksys APs */
 	if (essid_len == 1 && essid[0] == ' ')
@@ -156,13 +156,13 @@ static int iwl_is_empty_essid(const char
 	return 1;
 }
 
-static const char *iwl_escape_essid(const char *essid, u8 essid_len)
+static const char *iwl3945_escape_essid(const char *essid, u8 essid_len)
 {
 	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
 	const char *s = essid;
 	char *d = escaped;
 
-	if (iwl_is_empty_essid(essid, essid_len)) {
+	if (iwl3945_is_empty_essid(essid, essid_len)) {
 		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
 		return escaped;
 	}
@@ -180,10 +180,10 @@ static const char *iwl_escape_essid(cons
 	return escaped;
 }
 
-static void iwl_print_hex_dump(int level, void *p, u32 len)
+static void iwl3945_print_hex_dump(int level, void *p, u32 len)
 {
 #ifdef CONFIG_IWL3945_DEBUG
-	if (!(iwl_debug_level & level))
+	if (!(iwl3945_debug_level & level))
 		return;
 
 	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
@@ -209,7 +209,7 @@ static void iwl_print_hex_dump(int level
  * and four transmit queues for data.
  ***************************************************/
 
-static int iwl_queue_space(const struct iwl_queue *q)
+static int iwl3945_queue_space(const struct iwl3945_queue *q)
 {
 	int s = q->last_used - q->first_empty;
 
@@ -226,25 +226,25 @@ static int iwl_queue_space(const struct 
 }
 
 /* XXX: n_bd must be power-of-two size */
-static inline int iwl_queue_inc_wrap(int index, int n_bd)
+static inline int iwl3945_queue_inc_wrap(int index, int n_bd)
 {
 	return ++index & (n_bd - 1);
 }
 
 /* XXX: n_bd must be power-of-two size */
-static inline int iwl_queue_dec_wrap(int index, int n_bd)
+static inline int iwl3945_queue_dec_wrap(int index, int n_bd)
 {
 	return --index & (n_bd - 1);
 }
 
-static inline int x2_queue_used(const struct iwl_queue *q, int i)
+static inline int x2_queue_used(const struct iwl3945_queue *q, int i)
 {
 	return q->first_empty > q->last_used ?
 		(i >= q->last_used && i < q->first_empty) :
 		!(i < q->last_used && i >= q->first_empty);
 }
 
-static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
+static inline u8 get_cmd_index(struct iwl3945_queue *q, u32 index, int is_huge)
 {
 	if (is_huge)
 		return q->n_window;
@@ -252,15 +252,15 @@ static inline u8 get_cmd_index(struct iw
 	return index & (q->n_window - 1);
 }
 
-static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
+static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl3945_queue *q,
 			  int count, int slots_num, u32 id)
 {
 	q->n_bd = count;
 	q->n_window = slots_num;
 	q->id = id;
 
-	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
-	 * and iwl_queue_dec_wrap are broken. */
+	/* count must be power-of-two size, otherwise iwl3945_queue_inc_wrap
+	 * and iwl3945_queue_dec_wrap are broken. */
 	BUG_ON(!is_power_of_2(count));
 
 	/* slots_num must be power-of-two size, otherwise
@@ -280,8 +280,8 @@ static int iwl_queue_init(struct iwl_pri
 	return 0;
 }
 
-static int iwl_tx_queue_alloc(struct iwl_priv *priv,
-			      struct iwl_tx_queue *txq, u32 id)
+static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
+			      struct iwl3945_tx_queue *txq, u32 id)
 {
 	struct pci_dev *dev = priv->pci_dev;
 
@@ -318,8 +318,8 @@ static int iwl_tx_queue_alloc(struct iwl
 	return -ENOMEM;
 }
 
-int iwl_tx_queue_init(struct iwl_priv *priv,
-		      struct iwl_tx_queue *txq, int slots_num, u32 txq_id)
+int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
+		      struct iwl3945_tx_queue *txq, int slots_num, u32 txq_id)
 {
 	struct pci_dev *dev = priv->pci_dev;
 	int len;
@@ -328,14 +328,14 @@ int iwl_tx_queue_init(struct iwl_priv *p
 	/* alocate command space + one big command for scan since scan
 	 * command is very huge the system will not have two scan at the
 	 * same time */
-	len = sizeof(struct iwl_cmd) * slots_num;
+	len = sizeof(struct iwl3945_cmd) * slots_num;
 	if (txq_id == IWL_CMD_QUEUE_NUM)
 		len +=  IWL_MAX_SCAN_SIZE;
 	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
 	if (!txq->cmd)
 		return -ENOMEM;
 
-	rc = iwl_tx_queue_alloc(priv, txq, txq_id);
+	rc = iwl3945_tx_queue_alloc(priv, txq, txq_id);
 	if (rc) {
 		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
 
@@ -344,26 +344,26 @@ int iwl_tx_queue_init(struct iwl_priv *p
 	txq->need_update = 0;
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
+	 * iwl3945_queue_inc_wrap and iwl3945_queue_dec_wrap are broken. */
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
-	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
+	iwl3945_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
-	iwl_hw_tx_queue_init(priv, txq);
+	iwl3945_hw_tx_queue_init(priv, txq);
 
 	return 0;
 }
 
 /**
- * iwl_tx_queue_free - Deallocate DMA queue.
+ * iwl3945_tx_queue_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
  *
  * Empty queue by removing and destroying all BD's.
  * Free all buffers.  txq itself is not freed.
  *
  */
-void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq)
 {
-	struct iwl_queue *q = &txq->q;
+	struct iwl3945_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
 	int len;
 
@@ -372,10 +372,10 @@ void iwl_tx_queue_free(struct iwl_priv *
 
 	/* first, empty all BD's */
 	for (; q->first_empty != q->last_used;
-	     q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd))
-		iwl_hw_txq_free_tfd(priv, txq);
+	     q->last_used = iwl3945_queue_inc_wrap(q->last_used, q->n_bd))
+		iwl3945_hw_txq_free_tfd(priv, txq);
 
-	len = sizeof(struct iwl_cmd) * q->n_window;
+	len = sizeof(struct iwl3945_cmd) * q->n_window;
 	if (q->id == IWL_CMD_QUEUE_NUM)
 		len += IWL_MAX_SCAN_SIZE;
 
@@ -383,7 +383,7 @@ void iwl_tx_queue_free(struct iwl_priv *
 
 	/* free buffers belonging to queue itself */
 	if (txq->q.n_bd)
-		pci_free_consistent(dev, sizeof(struct iwl_tfd_frame) *
+		pci_free_consistent(dev, sizeof(struct iwl3945_tfd_frame) *
 				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
 
 	if (txq->txb) {
@@ -395,12 +395,12 @@ void iwl_tx_queue_free(struct iwl_priv *
 	memset(txq, 0, sizeof(*txq));
 }
 
-const u8 BROADCAST_ADDR[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+const u8 iwl3945_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /*************** STATION TABLE MANAGEMENT ****
  *
  * NOTE:  This needs to be overhauled to better synchronize between
- * how the iwl-4965.c is using iwl_hw_find_station vs. iwl-3945.c
+ * how the iwl-4965.c is using iwl3945_hw_find_station vs. iwl-3945.c
  *
  * mac80211 should also be examined to determine if sta_info is duplicating
  * the functionality provided here
@@ -408,7 +408,7 @@ const u8 BROADCAST_ADDR[ETH_ALEN] = { 0x
 
 /**************************************************************/
 #if 0 /* temparary disable till we add real remove station */
-static u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
+static u8 iwl3945_remove_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
 	int i;
@@ -444,7 +444,7 @@ out:
 	return 0;
 }
 #endif
-static void iwl_clear_stations_table(struct iwl_priv *priv)
+static void iwl3945_clear_stations_table(struct iwl3945_priv *priv)
 {
 	unsigned long flags;
 
@@ -457,11 +457,11 @@ static void iwl_clear_stations_table(str
 }
 
 
-u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
+u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8 flags)
 {
 	int i;
 	int index = IWL_INVALID_STATION;
-	struct iwl_station_entry *station;
+	struct iwl3945_station_entry *station;
 	unsigned long flags_spin;
 	DECLARE_MAC_BUF(mac);
 	u8 rate;
@@ -502,7 +502,7 @@ u8 iwl_add_station(struct iwl_priv *priv
 	station->used = 1;
 	priv->num_stations++;
 
-	memset(&station->sta, 0, sizeof(struct iwl_addsta_cmd));
+	memset(&station->sta, 0, sizeof(struct iwl3945_addsta_cmd));
 	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
 	station->sta.mode = 0;
 	station->sta.sta.sta_id = index;
@@ -513,19 +513,19 @@ u8 iwl_add_station(struct iwl_priv *priv
 
 	/* Turn on both antennas for the station... */
 	station->sta.rate_n_flags =
-			iwl_hw_set_rate_n_flags(rate, RATE_MCS_ANT_AB_MSK);
+			iwl3945_hw_set_rate_n_flags(rate, RATE_MCS_ANT_AB_MSK);
 	station->current_rate.rate_n_flags =
 			le16_to_cpu(station->sta.rate_n_flags);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-	iwl_send_add_station(priv, &station->sta, flags);
+	iwl3945_send_add_station(priv, &station->sta, flags);
 	return index;
 
 }
 
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
-static inline int iwl_is_ready(struct iwl_priv *priv)
+static inline int iwl3945_is_ready(struct iwl3945_priv *priv)
 {
 	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
 	 * set but EXIT_PENDING is not */
@@ -534,29 +534,29 @@ static inline int iwl_is_ready(struct iw
 	       !test_bit(STATUS_EXIT_PENDING, &priv->status);
 }
 
-static inline int iwl_is_alive(struct iwl_priv *priv)
+static inline int iwl3945_is_alive(struct iwl3945_priv *priv)
 {
 	return test_bit(STATUS_ALIVE, &priv->status);
 }
 
-static inline int iwl_is_init(struct iwl_priv *priv)
+static inline int iwl3945_is_init(struct iwl3945_priv *priv)
 {
 	return test_bit(STATUS_INIT, &priv->status);
 }
 
-static inline int iwl_is_rfkill(struct iwl_priv *priv)
+static inline int iwl3945_is_rfkill(struct iwl3945_priv *priv)
 {
 	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
 	       test_bit(STATUS_RF_KILL_SW, &priv->status);
 }
 
-static inline int iwl_is_ready_rf(struct iwl_priv *priv)
+static inline int iwl3945_is_ready_rf(struct iwl3945_priv *priv)
 {
 
-	if (iwl_is_rfkill(priv))
+	if (iwl3945_is_rfkill(priv))
 		return 0;
 
-	return iwl_is_ready(priv);
+	return iwl3945_is_ready(priv);
 }
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
@@ -615,7 +615,7 @@ static const char *get_cmd_string(u8 cmd
 #define HOST_COMPLETE_TIMEOUT (HZ / 2)
 
 /**
- * iwl_enqueue_hcmd - enqueue a uCode command
+ * iwl3945_enqueue_hcmd - enqueue a uCode command
  * @priv: device private data point
  * @cmd: a point to the ucode command structure
  *
@@ -623,13 +623,13 @@ static const char *get_cmd_string(u8 cmd
  * failed. On success, it turns the index (> 0) of command in the
  * command queue.
  */
-static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
 {
-	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
-	struct iwl_queue *q = &txq->q;
-	struct iwl_tfd_frame *tfd;
+	struct iwl3945_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
+	struct iwl3945_queue *q = &txq->q;
+	struct iwl3945_tfd_frame *tfd;
 	u32 *control_flags;
-	struct iwl_cmd *out_cmd;
+	struct iwl3945_cmd *out_cmd;
 	u32 idx;
 	u16 fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
 	dma_addr_t phys_addr;
@@ -644,7 +644,7 @@ static int iwl_enqueue_hcmd(struct iwl_p
 	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
 	       !(cmd->meta.flags & CMD_SIZE_HUGE));
 
-	if (iwl_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
+	if (iwl3945_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
 		IWL_ERROR("No space for Tx\n");
 		return -ENOSPC;
 	}
@@ -673,8 +673,8 @@ static int iwl_enqueue_hcmd(struct iwl_p
 		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
 
 	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
-			offsetof(struct iwl_cmd, hdr);
-	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
+			offsetof(struct iwl3945_cmd, hdr);
+	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
 	pad = U32_PAD(cmd->len);
 	count = TFD_CTL_COUNT_GET(*control_flags);
@@ -687,14 +687,14 @@ static int iwl_enqueue_hcmd(struct iwl_p
 		     fix_size, q->first_empty, idx, IWL_CMD_QUEUE_NUM);
 
 	txq->need_update = 1;
-	q->first_empty = iwl_queue_inc_wrap(q->first_empty, q->n_bd);
-	ret = iwl_tx_queue_update_write_ptr(priv, txq);
+	q->first_empty = iwl3945_queue_inc_wrap(q->first_empty, q->n_bd);
+	ret = iwl3945_tx_queue_update_write_ptr(priv, txq);
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
 	return ret ? ret : idx;
 }
 
-static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl3945_send_cmd_async(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
 {
 	int ret;
 
@@ -709,16 +709,16 @@ static int iwl_send_cmd_async(struct iwl
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EBUSY;
 
-	ret = iwl_enqueue_hcmd(priv, cmd);
+	ret = iwl3945_enqueue_hcmd(priv, cmd);
 	if (ret < 0) {
-		IWL_ERROR("Error sending %s: iwl_enqueue_hcmd failed: %d\n",
+		IWL_ERROR("Error sending %s: iwl3945_enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		return ret;
 	}
 	return 0;
 }
 
-static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+static int iwl3945_send_cmd_sync(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
@@ -740,10 +740,10 @@ static int iwl_send_cmd_sync(struct iwl_
 	if (cmd->meta.flags & CMD_WANT_SKB)
 		cmd->meta.source = &cmd->meta;
 
-	cmd_idx = iwl_enqueue_hcmd(priv, cmd);
+	cmd_idx = iwl3945_enqueue_hcmd(priv, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
-		IWL_ERROR("Error sending %s: iwl_enqueue_hcmd failed: %d\n",
+		IWL_ERROR("Error sending %s: iwl3945_enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		goto out;
 	}
@@ -787,7 +787,7 @@ static int iwl_send_cmd_sync(struct iwl_
 
 cancel:
 	if (cmd->meta.flags & CMD_WANT_SKB) {
-		struct iwl_cmd *qcmd;
+		struct iwl3945_cmd *qcmd;
 
 		/* Cancel the CMD_WANT_SKB flag for the cmd in the
 		 * TX cmd queue. Otherwise in case the cmd comes
@@ -806,47 +806,47 @@ out:
 	return ret;
 }
 
-int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+int iwl3945_send_cmd(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
 {
 	/* A command can not be asynchronous AND expect an SKB to be set. */
 	BUG_ON((cmd->meta.flags & CMD_ASYNC) &&
 	       (cmd->meta.flags & CMD_WANT_SKB));
 
 	if (cmd->meta.flags & CMD_ASYNC)
-		return iwl_send_cmd_async(priv, cmd);
+		return iwl3945_send_cmd_async(priv, cmd);
 
-	return iwl_send_cmd_sync(priv, cmd);
+	return iwl3945_send_cmd_sync(priv, cmd);
 }
 
-int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
+int iwl3945_send_cmd_pdu(struct iwl3945_priv *priv, u8 id, u16 len, const void *data)
 {
-	struct iwl_host_cmd cmd = {
+	struct iwl3945_host_cmd cmd = {
 		.id = id,
 		.len = len,
 		.data = data,
 	};
 
-	return iwl_send_cmd_sync(priv, &cmd);
+	return iwl3945_send_cmd_sync(priv, &cmd);
 }
 
-static int __must_check iwl_send_cmd_u32(struct iwl_priv *priv, u8 id, u32 val)
+static int __must_check iwl3945_send_cmd_u32(struct iwl3945_priv *priv, u8 id, u32 val)
 {
-	struct iwl_host_cmd cmd = {
+	struct iwl3945_host_cmd cmd = {
 		.id = id,
 		.len = sizeof(val),
 		.data = &val,
 	};
 
-	return iwl_send_cmd_sync(priv, &cmd);
+	return iwl3945_send_cmd_sync(priv, &cmd);
 }
 
-int iwl_send_statistics_request(struct iwl_priv *priv)
+int iwl3945_send_statistics_request(struct iwl3945_priv *priv)
 {
-	return iwl_send_cmd_u32(priv, REPLY_STATISTICS_CMD, 0);
+	return iwl3945_send_cmd_u32(priv, REPLY_STATISTICS_CMD, 0);
 }
 
 /**
- * iwl_set_rxon_channel - Set the phymode and channel values in staging RXON
+ * iwl3945_set_rxon_channel - Set the phymode and channel values in staging RXON
  * @phymode: MODE_IEEE80211A sets to 5.2GHz; all else set to 2.4GHz
  * @channel: Any channel valid for the requested phymode
 
@@ -855,9 +855,9 @@ int iwl_send_statistics_request(struct i
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the phymode
  */
-static int iwl_set_rxon_channel(struct iwl_priv *priv, u8 phymode, u16 channel)
+static int iwl3945_set_rxon_channel(struct iwl3945_priv *priv, u8 phymode, u16 channel)
 {
-	if (!iwl_get_channel_info(priv, phymode, channel)) {
+	if (!iwl3945_get_channel_info(priv, phymode, channel)) {
 		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
 			       channel, phymode);
 		return -EINVAL;
@@ -881,13 +881,13 @@ static int iwl_set_rxon_channel(struct i
 }
 
 /**
- * iwl_check_rxon_cmd - validate RXON structure is valid
+ * iwl3945_check_rxon_cmd - validate RXON structure is valid
  *
  * NOTE:  This is really only useful during development and can eventually
  * be #ifdef'd out once the driver is stable and folks aren't actively
  * making changes
  */
-static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
+static int iwl3945_check_rxon_cmd(struct iwl3945_rxon_cmd *rxon)
 {
 	int error = 0;
 	int counter = 1;
@@ -953,21 +953,21 @@ static int iwl_check_rxon_cmd(struct iwl
 			    le16_to_cpu(rxon->channel));
 
 	if (error) {
-		IWL_ERROR("Not a valid iwl_rxon_assoc_cmd field values\n");
+		IWL_ERROR("Not a valid iwl3945_rxon_assoc_cmd field values\n");
 		return -1;
 	}
 	return 0;
 }
 
 /**
- * iwl_full_rxon_required - determine if RXON_ASSOC can be used in RXON commit
+ * iwl3945_full_rxon_required - determine if RXON_ASSOC can be used in RXON commit
  * @priv: staging_rxon is comapred to active_rxon
  *
  * If the RXON structure is changing sufficient to require a new
  * tune or to clear and reset the RXON_FILTER_ASSOC_MSK then return 1
  * to indicate a new tune is required.
  */
-static int iwl_full_rxon_required(struct iwl_priv *priv)
+static int iwl3945_full_rxon_required(struct iwl3945_priv *priv)
 {
 
 	/* These items are only settable from the full RXON command */
@@ -1002,19 +1002,19 @@ static int iwl_full_rxon_required(struct
 	return 0;
 }
 
-static int iwl_send_rxon_assoc(struct iwl_priv *priv)
+static int iwl3945_send_rxon_assoc(struct iwl3945_priv *priv)
 {
 	int rc = 0;
-	struct iwl_rx_packet *res = NULL;
-	struct iwl_rxon_assoc_cmd rxon_assoc;
-	struct iwl_host_cmd cmd = {
+	struct iwl3945_rx_packet *res = NULL;
+	struct iwl3945_rxon_assoc_cmd rxon_assoc;
+	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_RXON_ASSOC,
 		.len = sizeof(rxon_assoc),
 		.meta.flags = CMD_WANT_SKB,
 		.data = &rxon_assoc,
 	};
-	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
-	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
+	const struct iwl3945_rxon_cmd *rxon1 = &priv->staging_rxon;
+	const struct iwl3945_rxon_cmd *rxon2 = &priv->active_rxon;
 
 	if ((rxon1->flags == rxon2->flags) &&
 	    (rxon1->filter_flags == rxon2->filter_flags) &&
@@ -1030,11 +1030,11 @@ static int iwl_send_rxon_assoc(struct iw
 	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
 	rxon_assoc.reserved = 0;
 
-	rc = iwl_send_cmd_sync(priv, &cmd);
+	rc = iwl3945_send_cmd_sync(priv, &cmd);
 	if (rc)
 		return rc;
 
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl3945_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_RXON_ASSOC command\n");
 		rc = -EIO;
@@ -1047,21 +1047,21 @@ static int iwl_send_rxon_assoc(struct iw
 }
 
 /**
- * iwl_commit_rxon - commit staging_rxon to hardware
+ * iwl3945_commit_rxon - commit staging_rxon to hardware
  *
  * The RXON command in staging_rxon is commited to the hardware and
  * the active_rxon structure is updated with the new data.  This
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
  */
-static int iwl_commit_rxon(struct iwl_priv *priv)
+static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 {
 	/* cast away the const for active_rxon in this function */
-	struct iwl_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
+	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
 	int rc = 0;
 	DECLARE_MAC_BUF(mac);
 
-	if (!iwl_is_alive(priv))
+	if (!iwl3945_is_alive(priv))
 		return -1;
 
 	/* always get timestamp with Rx frame */
@@ -1072,17 +1072,17 @@ static int iwl_commit_rxon(struct iwl_pr
 	    ~(RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_SEL_MSK);
 	priv->staging_rxon.flags |= iwl3945_get_antenna_flags(priv);
 
-	rc = iwl_check_rxon_cmd(&priv->staging_rxon);
+	rc = iwl3945_check_rxon_cmd(&priv->staging_rxon);
 	if (rc) {
 		IWL_ERROR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
 	}
 
 	/* If we don't need to send a full RXON, we can use
-	 * iwl_rxon_assoc_cmd which is used to reconfigure filter
+	 * iwl3945_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
-	if (!iwl_full_rxon_required(priv)) {
-		rc = iwl_send_rxon_assoc(priv);
+	if (!iwl3945_full_rxon_required(priv)) {
+		rc = iwl3945_send_rxon_assoc(priv);
 		if (rc) {
 			IWL_ERROR("Error setting RXON_ASSOC "
 				  "configuration (%d).\n", rc);
@@ -1098,13 +1098,13 @@ static int iwl_commit_rxon(struct iwl_pr
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
-	if (iwl_is_associated(priv) &&
+	if (iwl3945_is_associated(priv) &&
 	    (priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK)) {
 		IWL_DEBUG_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
-		rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
-				      sizeof(struct iwl_rxon_cmd),
+		rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON,
+				      sizeof(struct iwl3945_rxon_cmd),
 				      &priv->active_rxon);
 
 		/* If the mask clearing failed then we set
@@ -1127,8 +1127,8 @@ static int iwl_commit_rxon(struct iwl_pr
 		       print_mac(mac, priv->staging_rxon.bssid_addr));
 
 	/* Apply the new configuration */
-	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
-			      sizeof(struct iwl_rxon_cmd), &priv->staging_rxon);
+	rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON,
+			      sizeof(struct iwl3945_rxon_cmd), &priv->staging_rxon);
 	if (rc) {
 		IWL_ERROR("Error setting new configuration (%d).\n", rc);
 		return rc;
@@ -1136,18 +1136,18 @@ static int iwl_commit_rxon(struct iwl_pr
 
 	memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 
-	iwl_clear_stations_table(priv);
+	iwl3945_clear_stations_table(priv);
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	rc = iwl_hw_reg_send_txpower(priv);
+	rc = iwl3945_hw_reg_send_txpower(priv);
 	if (rc) {
 		IWL_ERROR("Error setting Tx power (%d).\n", rc);
 		return rc;
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (iwl_add_station(priv, BROADCAST_ADDR, 0, 0) ==
+	if (iwl3945_add_station(priv, iwl3945_broadcast_addr, 0, 0) ==
 	    IWL_INVALID_STATION) {
 		IWL_ERROR("Error adding BROADCAST address for transmit.\n");
 		return -EIO;
@@ -1155,9 +1155,9 @@ static int iwl_commit_rxon(struct iwl_pr
 
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
-	if (iwl_is_associated(priv) &&
+	if (iwl3945_is_associated(priv) &&
 	    (priv->iw_mode == IEEE80211_IF_TYPE_STA))
-		if (iwl_add_station(priv, priv->active_rxon.bssid_addr, 1, 0)
+		if (iwl3945_add_station(priv, priv->active_rxon.bssid_addr, 1, 0)
 		    == IWL_INVALID_STATION) {
 			IWL_ERROR("Error adding AP address for transmit.\n");
 			return -EIO;
@@ -1174,9 +1174,9 @@ static int iwl_commit_rxon(struct iwl_pr
 	return 0;
 }
 
-static int iwl_send_bt_config(struct iwl_priv *priv)
+static int iwl3945_send_bt_config(struct iwl3945_priv *priv)
 {
-	struct iwl_bt_cmd bt_cmd = {
+	struct iwl3945_bt_cmd bt_cmd = {
 		.flags = 3,
 		.lead_time = 0xAA,
 		.max_kill = 1,
@@ -1184,15 +1184,15 @@ static int iwl_send_bt_config(struct iwl
 		.kill_cts_mask = 0,
 	};
 
-	return iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-				sizeof(struct iwl_bt_cmd), &bt_cmd);
+	return iwl3945_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+				sizeof(struct iwl3945_bt_cmd), &bt_cmd);
 }
 
-static int iwl_send_scan_abort(struct iwl_priv *priv)
+static int iwl3945_send_scan_abort(struct iwl3945_priv *priv)
 {
 	int rc = 0;
-	struct iwl_rx_packet *res;
-	struct iwl_host_cmd cmd = {
+	struct iwl3945_rx_packet *res;
+	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.meta.flags = CMD_WANT_SKB,
 	};
@@ -1205,13 +1205,13 @@ static int iwl_send_scan_abort(struct iw
 		return 0;
 	}
 
-	rc = iwl_send_cmd_sync(priv, &cmd);
+	rc = iwl3945_send_cmd_sync(priv, &cmd);
 	if (rc) {
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 		return rc;
 	}
 
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl3945_rx_packet *)cmd.meta.u.skb->data;
 	if (res->u.status != CAN_ABORT_STATUS) {
 		/* The scan abort will return 1 for success or
 		 * 2 for "failure".  A failure condition can be
@@ -1229,8 +1229,8 @@ static int iwl_send_scan_abort(struct iw
 	return rc;
 }
 
-static int iwl_card_state_sync_callback(struct iwl_priv *priv,
-					struct iwl_cmd *cmd,
+static int iwl3945_card_state_sync_callback(struct iwl3945_priv *priv,
+					struct iwl3945_cmd *cmd,
 					struct sk_buff *skb)
 {
 	return 1;
@@ -1246,9 +1246,9 @@ static int iwl_card_state_sync_callback(
  * When in the 'halt' state, the card is shut down and must be fully
  * restarted to come back on.
  */
-static int iwl_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
+static int iwl3945_send_card_state(struct iwl3945_priv *priv, u32 flags, u8 meta_flag)
 {
-	struct iwl_host_cmd cmd = {
+	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_CARD_STATE_CMD,
 		.len = sizeof(u32),
 		.data = &flags,
@@ -1256,22 +1256,22 @@ static int iwl_send_card_state(struct iw
 	};
 
 	if (meta_flag & CMD_ASYNC)
-		cmd.meta.u.callback = iwl_card_state_sync_callback;
+		cmd.meta.u.callback = iwl3945_card_state_sync_callback;
 
-	return iwl_send_cmd(priv, &cmd);
+	return iwl3945_send_cmd(priv, &cmd);
 }
 
-static int iwl_add_sta_sync_callback(struct iwl_priv *priv,
-				     struct iwl_cmd *cmd, struct sk_buff *skb)
+static int iwl3945_add_sta_sync_callback(struct iwl3945_priv *priv,
+				     struct iwl3945_cmd *cmd, struct sk_buff *skb)
 {
-	struct iwl_rx_packet *res = NULL;
+	struct iwl3945_rx_packet *res = NULL;
 
 	if (!skb) {
 		IWL_ERROR("Error: Response NULL in REPLY_ADD_STA.\n");
 		return 1;
 	}
 
-	res = (struct iwl_rx_packet *)skb->data;
+	res = (struct iwl3945_rx_packet *)skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
@@ -1289,29 +1289,29 @@ static int iwl_add_sta_sync_callback(str
 	return 1;
 }
 
-int iwl_send_add_station(struct iwl_priv *priv,
-			 struct iwl_addsta_cmd *sta, u8 flags)
+int iwl3945_send_add_station(struct iwl3945_priv *priv,
+			 struct iwl3945_addsta_cmd *sta, u8 flags)
 {
-	struct iwl_rx_packet *res = NULL;
+	struct iwl3945_rx_packet *res = NULL;
 	int rc = 0;
-	struct iwl_host_cmd cmd = {
+	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_ADD_STA,
-		.len = sizeof(struct iwl_addsta_cmd),
+		.len = sizeof(struct iwl3945_addsta_cmd),
 		.meta.flags = flags,
 		.data = sta,
 	};
 
 	if (flags & CMD_ASYNC)
-		cmd.meta.u.callback = iwl_add_sta_sync_callback;
+		cmd.meta.u.callback = iwl3945_add_sta_sync_callback;
 	else
 		cmd.meta.flags |= CMD_WANT_SKB;
 
-	rc = iwl_send_cmd(priv, &cmd);
+	rc = iwl3945_send_cmd(priv, &cmd);
 
 	if (rc || (flags & CMD_ASYNC))
 		return rc;
 
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl3945_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
@@ -1336,7 +1336,7 @@ int iwl_send_add_station(struct iwl_priv
 	return rc;
 }
 
-static int iwl_update_sta_key_info(struct iwl_priv *priv,
+static int iwl3945_update_sta_key_info(struct iwl3945_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
 {
@@ -1371,28 +1371,28 @@ static int iwl_update_sta_key_info(struc
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-	iwl_send_add_station(priv, &priv->stations[sta_id].sta, 0);
+	iwl3945_send_add_station(priv, &priv->stations[sta_id].sta, 0);
 	return 0;
 }
 
-static int iwl_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
+static int iwl3945_clear_sta_key_info(struct iwl3945_priv *priv, u8 sta_id)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	memset(&priv->stations[sta_id].keyinfo, 0, sizeof(struct iwl_hw_key));
-	memset(&priv->stations[sta_id].sta.key, 0, sizeof(struct iwl_keyinfo));
+	memset(&priv->stations[sta_id].keyinfo, 0, sizeof(struct iwl3945_hw_key));
+	memset(&priv->stations[sta_id].sta.key, 0, sizeof(struct iwl3945_keyinfo));
 	priv->stations[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
-	iwl_send_add_station(priv, &priv->stations[sta_id].sta, 0);
+	iwl3945_send_add_station(priv, &priv->stations[sta_id].sta, 0);
 	return 0;
 }
 
-static void iwl_clear_free_frames(struct iwl_priv *priv)
+static void iwl3945_clear_free_frames(struct iwl3945_priv *priv)
 {
 	struct list_head *element;
 
@@ -1402,7 +1402,7 @@ static void iwl_clear_free_frames(struct
 	while (!list_empty(&priv->free_frames)) {
 		element = priv->free_frames.next;
 		list_del(element);
-		kfree(list_entry(element, struct iwl_frame, list));
+		kfree(list_entry(element, struct iwl3945_frame, list));
 		priv->frames_count--;
 	}
 
@@ -1413,9 +1413,9 @@ static void iwl_clear_free_frames(struct
 	}
 }
 
-static struct iwl_frame *iwl_get_free_frame(struct iwl_priv *priv)
+static struct iwl3945_frame *iwl3945_get_free_frame(struct iwl3945_priv *priv)
 {
-	struct iwl_frame *frame;
+	struct iwl3945_frame *frame;
 	struct list_head *element;
 	if (list_empty(&priv->free_frames)) {
 		frame = kzalloc(sizeof(*frame), GFP_KERNEL);
@@ -1430,21 +1430,21 @@ static struct iwl_frame *iwl_get_free_fr
 
 	element = priv->free_frames.next;
 	list_del(element);
-	return list_entry(element, struct iwl_frame, list);
+	return list_entry(element, struct iwl3945_frame, list);
 }
 
-static void iwl_free_frame(struct iwl_priv *priv, struct iwl_frame *frame)
+static void iwl3945_free_frame(struct iwl3945_priv *priv, struct iwl3945_frame *frame)
 {
 	memset(frame, 0, sizeof(*frame));
 	list_add(&frame->list, &priv->free_frames);
 }
 
-unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
+unsigned int iwl3945_fill_beacon_frame(struct iwl3945_priv *priv,
 				struct ieee80211_hdr *hdr,
 				const u8 *dest, int left)
 {
 
-	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
+	if (!iwl3945_is_associated(priv) || !priv->ibss_beacon ||
 	    ((priv->iw_mode != IEEE80211_IF_TYPE_IBSS) &&
 	     (priv->iw_mode != IEEE80211_IF_TYPE_AP)))
 		return 0;
@@ -1457,37 +1457,37 @@ unsigned int iwl_fill_beacon_frame(struc
 	return priv->ibss_beacon->len;
 }
 
-static int iwl_rate_index_from_plcp(int plcp)
+static int iwl3945_rate_index_from_plcp(int plcp)
 {
 	int i = 0;
 
 	for (i = 0; i < IWL_RATE_COUNT; i++)
-		if (iwl_rates[i].plcp == plcp)
+		if (iwl3945_rates[i].plcp == plcp)
 			return i;
 	return -1;
 }
 
-static u8 iwl_rate_get_lowest_plcp(int rate_mask)
+static u8 iwl3945_rate_get_lowest_plcp(int rate_mask)
 {
 	u8 i;
 
 	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
-	     i = iwl_rates[i].next_ieee) {
+	     i = iwl3945_rates[i].next_ieee) {
 		if (rate_mask & (1 << i))
-			return iwl_rates[i].plcp;
+			return iwl3945_rates[i].plcp;
 	}
 
 	return IWL_RATE_INVALID;
 }
 
-static int iwl_send_beacon_cmd(struct iwl_priv *priv)
+static int iwl3945_send_beacon_cmd(struct iwl3945_priv *priv)
 {
-	struct iwl_frame *frame;
+	struct iwl3945_frame *frame;
 	unsigned int frame_size;
 	int rc;
 	u8 rate;
 
-	frame = iwl_get_free_frame(priv);
+	frame = iwl3945_get_free_frame(priv);
 
 	if (!frame) {
 		IWL_ERROR("Could not obtain free frame buffer for beacon "
@@ -1496,22 +1496,22 @@ static int iwl_send_beacon_cmd(struct iw
 	}
 
 	if (!(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)) {
-		rate = iwl_rate_get_lowest_plcp(priv->active_rate_basic &
+		rate = iwl3945_rate_get_lowest_plcp(priv->active_rate_basic &
 						0xFF0);
 		if (rate == IWL_INVALID_RATE)
 			rate = IWL_RATE_6M_PLCP;
 	} else {
-		rate = iwl_rate_get_lowest_plcp(priv->active_rate_basic & 0xF);
+		rate = iwl3945_rate_get_lowest_plcp(priv->active_rate_basic & 0xF);
 		if (rate == IWL_INVALID_RATE)
 			rate = IWL_RATE_1M_PLCP;
 	}
 
-	frame_size = iwl_hw_get_beacon_cmd(priv, frame, rate);
+	frame_size = iwl3945_hw_get_beacon_cmd(priv, frame, rate);
 
-	rc = iwl_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
+	rc = iwl3945_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
 			      &frame->u.cmd[0]);
 
-	iwl_free_frame(priv, frame);
+	iwl3945_free_frame(priv, frame);
 
 	return rc;
 }
@@ -1522,22 +1522,22 @@ static int iwl_send_beacon_cmd(struct iw
  *
  ******************************************************************************/
 
-static void get_eeprom_mac(struct iwl_priv *priv, u8 *mac)
+static void get_eeprom_mac(struct iwl3945_priv *priv, u8 *mac)
 {
 	memcpy(mac, priv->eeprom.mac_address, 6);
 }
 
 /**
- * iwl_eeprom_init - read EEPROM contents
+ * iwl3945_eeprom_init - read EEPROM contents
  *
  * Load the EEPROM from adapter into priv->eeprom
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
-int iwl_eeprom_init(struct iwl_priv *priv)
+int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 {
 	u16 *e = (u16 *)&priv->eeprom;
-	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
+	u32 gp = iwl3945_read32(priv, CSR_EEPROM_GP);
 	u32 r;
 	int sz = sizeof(priv->eeprom);
 	int rc;
@@ -1555,7 +1555,7 @@ int iwl_eeprom_init(struct iwl_priv *pri
 		return -ENOENT;
 	}
 
-	rc = iwl_eeprom_aqcuire_semaphore(priv);
+	rc = iwl3945_eeprom_aqcuire_semaphore(priv);
 	if (rc < 0) {
 		IWL_ERROR("Failed to aqcuire EEPROM semaphore.\n");
 		return -ENOENT;
@@ -1563,12 +1563,12 @@ int iwl_eeprom_init(struct iwl_priv *pri
 
 	/* eeprom is an array of 16bit values */
 	for (addr = 0; addr < sz; addr += sizeof(u16)) {
-		_iwl_write32(priv, CSR_EEPROM_REG, addr << 1);
-		_iwl_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
+		_iwl3945_write32(priv, CSR_EEPROM_REG, addr << 1);
+		_iwl3945_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
 
 		for (i = 0; i < IWL_EEPROM_ACCESS_TIMEOUT;
 					i += IWL_EEPROM_ACCESS_DELAY) {
-			r = _iwl_read_restricted(priv, CSR_EEPROM_REG);
+			r = _iwl3945_read_restricted(priv, CSR_EEPROM_REG);
 			if (r & CSR_EEPROM_REG_READ_VALID_MSK)
 				break;
 			udelay(IWL_EEPROM_ACCESS_DELAY);
@@ -1592,19 +1592,19 @@ int iwl_eeprom_init(struct iwl_priv *pri
 #ifdef CONFIG_IWL3945_DEBUG
 
 /**
- * iwl_report_frame - dump frame to syslog during debug sessions
+ * iwl3945_report_frame - dump frame to syslog during debug sessions
  *
  * hack this function to show different aspects of received frames,
  * including selective frame dumps.
  * group100 parameter selects whether to show 1 out of 100 good frames.
  *
  * TODO:  ieee80211_hdr stuff is common to 3945 and 4965, so frame type
- *        info output is okay, but some of this stuff (e.g. iwl_rx_frame_stats)
+ *        info output is okay, but some of this stuff (e.g. iwl3945_rx_frame_stats)
  *        is 3945-specific and gives bad output for 4965.  Need to split the
  *        functionality, keep common stuff here.
  */
-void iwl_report_frame(struct iwl_priv *priv,
-		      struct iwl_rx_packet *pkt,
+void iwl3945_report_frame(struct iwl3945_priv *priv,
+		      struct iwl3945_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
 	u32 to_us;
@@ -1626,9 +1626,9 @@ void iwl_report_frame(struct iwl_priv *p
 	u8 agc;
 	u16 sig_avg;
 	u16 noise_diff;
-	struct iwl_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
-	struct iwl_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
-	struct iwl_rx_frame_end *rx_end = IWL_RX_END(pkt);
+	struct iwl3945_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
+	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
+	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	u8 *data = IWL_RX_DATA(pkt);
 
 	/* MAC header */
@@ -1704,11 +1704,11 @@ void iwl_report_frame(struct iwl_priv *p
 		else
 			title = "Frame";
 
-		rate = iwl_rate_index_from_plcp(rate_sym);
+		rate = iwl3945_rate_index_from_plcp(rate_sym);
 		if (rate == -1)
 			rate = 0;
 		else
-			rate = iwl_rates[rate].ieee / 2;
+			rate = iwl3945_rates[rate].ieee / 2;
 
 		/* print frame summary.
 		 * MAC addresses show just the last byte (for brevity),
@@ -1730,25 +1730,25 @@ void iwl_report_frame(struct iwl_priv *p
 		}
 	}
 	if (print_dump)
-		iwl_print_hex_dump(IWL_DL_RX, data, length);
+		iwl3945_print_hex_dump(IWL_DL_RX, data, length);
 }
 #endif
 
-static void iwl_unset_hw_setting(struct iwl_priv *priv)
+static void iwl3945_unset_hw_setting(struct iwl3945_priv *priv)
 {
 	if (priv->hw_setting.shared_virt)
 		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct iwl_shared),
+				    sizeof(struct iwl3945_shared),
 				    priv->hw_setting.shared_virt,
 				    priv->hw_setting.shared_phys);
 }
 
 /**
- * iwl_supported_rate_to_ie - fill in the supported rate in IE field
+ * iwl3945_supported_rate_to_ie - fill in the supported rate in IE field
  *
  * return : set the bit for each supported rate insert in ie
  */
-static u16 iwl_supported_rate_to_ie(u8 *ie, u16 supported_rate,
+static u16 iwl3945_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 				    u16 basic_rate, int max_count)
 {
 	u16 ret_rates = 0, bit;
@@ -1760,7 +1760,7 @@ static u16 iwl_supported_rate_to_ie(u8 *
 	for (bit = 1, i = 0; i < IWL_RATE_COUNT; i++, bit <<= 1) {
 		if (bit & supported_rate) {
 			ret_rates |= bit;
-			rates[*ie] = iwl_rates[i].ieee |
+			rates[*ie] = iwl3945_rates[i].ieee |
 			    ((bit & basic_rate) ? 0x80 : 0x00);
 			*ie = *ie + 1;
 			if (*ie >= max_count)
@@ -1772,9 +1772,9 @@ static u16 iwl_supported_rate_to_ie(u8 *
 }
 
 /**
- * iwl_fill_probe_req - fill in all required fields and IE for probe request
+ * iwl3945_fill_probe_req - fill in all required fields and IE for probe request
  */
-static u16 iwl_fill_probe_req(struct iwl_priv *priv,
+static u16 iwl3945_fill_probe_req(struct iwl3945_priv *priv,
 			      struct ieee80211_mgmt *frame,
 			      int left, int is_direct)
 {
@@ -1790,9 +1790,9 @@ static u16 iwl_fill_probe_req(struct iwl
 	len += 24;
 
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, BROADCAST_ADDR, ETH_ALEN);
+	memcpy(frame->da, iwl3945_broadcast_addr, ETH_ALEN);
 	memcpy(frame->sa, priv->mac_addr, ETH_ALEN);
-	memcpy(frame->bssid, BROADCAST_ADDR, ETH_ALEN);
+	memcpy(frame->bssid, iwl3945_broadcast_addr, ETH_ALEN);
 	frame->seq_ctrl = 0;
 
 	/* fill in our indirect SSID IE */
@@ -1831,7 +1831,7 @@ static u16 iwl_fill_probe_req(struct iwl
 	ret_rates = priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
-	iwl_supported_rate_to_ie(pos, priv->active_rate,
+	iwl3945_supported_rate_to_ie(pos, priv->active_rate,
 				 priv->active_rate_basic, left);
 	len += 2 + *pos;
 	pos += (*pos) + 1;
@@ -1848,7 +1848,7 @@ static u16 iwl_fill_probe_req(struct iwl
 	/* ... fill it in... */
 	*pos++ = WLAN_EID_EXT_SUPP_RATES;
 	*pos = 0;
-	iwl_supported_rate_to_ie(pos, ret_rates, priv->active_rate_basic, left);
+	iwl3945_supported_rate_to_ie(pos, ret_rates, priv->active_rate_basic, left);
 	if (*pos > 0)
 		len += 2 + *pos;
 
@@ -1860,15 +1860,15 @@ static u16 iwl_fill_probe_req(struct iwl
  * QoS  support
 */
 #ifdef CONFIG_IWL3945_QOS
-static int iwl_send_qos_params_command(struct iwl_priv *priv,
-				       struct iwl_qosparam_cmd *qos)
+static int iwl3945_send_qos_params_command(struct iwl3945_priv *priv,
+				       struct iwl3945_qosparam_cmd *qos)
 {
 
-	return iwl_send_cmd_pdu(priv, REPLY_QOS_PARAM,
-				sizeof(struct iwl_qosparam_cmd), qos);
+	return iwl3945_send_cmd_pdu(priv, REPLY_QOS_PARAM,
+				sizeof(struct iwl3945_qosparam_cmd), qos);
 }
 
-static void iwl_reset_qos(struct iwl_priv *priv)
+static void iwl3945_reset_qos(struct iwl3945_priv *priv)
 {
 	u16 cw_min = 15;
 	u16 cw_max = 1023;
@@ -1955,7 +1955,7 @@ static void iwl_reset_qos(struct iwl_pri
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
+static void iwl3945_activate_qos(struct iwl3945_priv *priv, u8 force)
 {
 	unsigned long flags;
 
@@ -1982,11 +1982,11 @@ static void iwl_activate_qos(struct iwl_
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (force || iwl_is_associated(priv)) {
+	if (force || iwl3945_is_associated(priv)) {
 		IWL_DEBUG_QOS("send QoS cmd with Qos active %d \n",
 			      priv->qos_data.qos_active);
 
-		iwl_send_qos_params_command(priv,
+		iwl3945_send_qos_params_command(priv,
 				&(priv->qos_data.def_qos_parm));
 	}
 }
@@ -2009,7 +2009,7 @@ static void iwl_activate_qos(struct iwl_
 
 /* default power management (not Tx power) table values */
 /* for tim  0-10 */
-static struct iwl_power_vec_entry range_0[IWL_POWER_AC] = {
+static struct iwl3945_power_vec_entry range_0[IWL_POWER_AC] = {
 	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
 	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(300), SLP_VEC(2, 4, 6, 7, 7)}, 0},
@@ -2019,7 +2019,7 @@ static struct iwl_power_vec_entry range_
 };
 
 /* for tim > 10 */
-static struct iwl_power_vec_entry range_1[IWL_POWER_AC] = {
+static struct iwl3945_power_vec_entry range_1[IWL_POWER_AC] = {
 	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500),
 		 SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
@@ -2032,11 +2032,11 @@ static struct iwl_power_vec_entry range_
 		 SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
-int iwl_power_init_handle(struct iwl_priv *priv)
+int iwl3945_power_init_handle(struct iwl3945_priv *priv)
 {
 	int rc = 0, i;
-	struct iwl_power_mgr *pow_data;
-	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_AC;
+	struct iwl3945_power_mgr *pow_data;
+	int size = sizeof(struct iwl3945_power_vec_entry) * IWL_POWER_AC;
 	u16 pci_pm;
 
 	IWL_DEBUG_POWER("Initialize power \n");
@@ -2055,7 +2055,7 @@ int iwl_power_init_handle(struct iwl_pri
 	if (rc != 0)
 		return 0;
 	else {
-		struct iwl_powertable_cmd *cmd;
+		struct iwl3945_powertable_cmd *cmd;
 
 		IWL_DEBUG_POWER("adjust power command flags\n");
 
@@ -2071,15 +2071,15 @@ int iwl_power_init_handle(struct iwl_pri
 	return rc;
 }
 
-static int iwl_update_power_cmd(struct iwl_priv *priv,
-				struct iwl_powertable_cmd *cmd, u32 mode)
+static int iwl3945_update_power_cmd(struct iwl3945_priv *priv,
+				struct iwl3945_powertable_cmd *cmd, u32 mode)
 {
 	int rc = 0, i;
 	u8 skip;
 	u32 max_sleep = 0;
-	struct iwl_power_vec_entry *range;
+	struct iwl3945_power_vec_entry *range;
 	u8 period = 0;
-	struct iwl_power_mgr *pow_data;
+	struct iwl3945_power_mgr *pow_data;
 
 	if (mode > IWL_POWER_INDEX_5) {
 		IWL_DEBUG_POWER("Error invalid power mode \n");
@@ -2092,7 +2092,7 @@ static int iwl_update_power_cmd(struct i
 	else
 		range = &pow_data->pwr_range_1[1];
 
-	memcpy(cmd, &range[mode].cmd, sizeof(struct iwl_powertable_cmd));
+	memcpy(cmd, &range[mode].cmd, sizeof(struct iwl3945_powertable_cmd));
 
 #ifdef IWL_MAC80211_DISABLE
 	if (priv->assoc_network != NULL) {
@@ -2135,11 +2135,11 @@ static int iwl_update_power_cmd(struct i
 	return rc;
 }
 
-static int iwl_send_power_mode(struct iwl_priv *priv, u32 mode)
+static int iwl3945_send_power_mode(struct iwl3945_priv *priv, u32 mode)
 {
 	u32 final_mode = mode;
 	int rc;
-	struct iwl_powertable_cmd cmd;
+	struct iwl3945_powertable_cmd cmd;
 
 	/* If on battery, set to 3,
 	 * if plugged into AC power, set to CAM ("continuosly aware mode"),
@@ -2156,9 +2156,9 @@ static int iwl_send_power_mode(struct iw
 		break;
 	}
 
-	iwl_update_power_cmd(priv, &cmd, final_mode);
+	iwl3945_update_power_cmd(priv, &cmd, final_mode);
 
-	rc = iwl_send_cmd_pdu(priv, POWER_TABLE_CMD, sizeof(cmd), &cmd);
+	rc = iwl3945_send_cmd_pdu(priv, POWER_TABLE_CMD, sizeof(cmd), &cmd);
 
 	if (final_mode == IWL_POWER_MODE_CAM)
 		clear_bit(STATUS_POWER_PMI, &priv->status);
@@ -2168,7 +2168,7 @@ static int iwl_send_power_mode(struct iw
 	return rc;
 }
 
-int iwl_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
+int iwl3945_is_network_packet(struct iwl3945_priv *priv, struct ieee80211_hdr *header)
 {
 	/* Filter incoming packets to determine if they are targeted toward
 	 * this network, discarding packets coming from ourselves */
@@ -2198,7 +2198,7 @@ int iwl_is_network_packet(struct iwl_pri
 
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-static const char *iwl_get_tx_fail_reason(u32 status)
+static const char *iwl3945_get_tx_fail_reason(u32 status)
 {
 	switch (status & TX_STATUS_MSK) {
 	case TX_STATUS_SUCCESS:
@@ -2225,11 +2225,11 @@ static const char *iwl_get_tx_fail_reaso
 }
 
 /**
- * iwl_scan_cancel - Cancel any currently executing HW scan
+ * iwl3945_scan_cancel - Cancel any currently executing HW scan
  *
  * NOTE: priv->mutex is not required before calling this function
  */
-static int iwl_scan_cancel(struct iwl_priv *priv)
+static int iwl3945_scan_cancel(struct iwl3945_priv *priv)
 {
 	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
 		clear_bit(STATUS_SCANNING, &priv->status);
@@ -2252,17 +2252,17 @@ static int iwl_scan_cancel(struct iwl_pr
 }
 
 /**
- * iwl_scan_cancel_timeout - Cancel any currently executing HW scan
+ * iwl3945_scan_cancel_timeout - Cancel any currently executing HW scan
  * @ms: amount of time to wait (in milliseconds) for scan to abort
  *
  * NOTE: priv->mutex must be held before calling this function
  */
-static int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
+static int iwl3945_scan_cancel_timeout(struct iwl3945_priv *priv, unsigned long ms)
 {
 	unsigned long now = jiffies;
 	int ret;
 
-	ret = iwl_scan_cancel(priv);
+	ret = iwl3945_scan_cancel(priv);
 	if (ret && ms) {
 		mutex_unlock(&priv->mutex);
 		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
@@ -2276,7 +2276,7 @@ static int iwl_scan_cancel_timeout(struc
 	return ret;
 }
 
-static void iwl_sequence_reset(struct iwl_priv *priv)
+static void iwl3945_sequence_reset(struct iwl3945_priv *priv)
 {
 	/* Reset ieee stats */
 
@@ -2287,13 +2287,13 @@ static void iwl_sequence_reset(struct iw
 	priv->last_frag_num = -1;
 	priv->last_packet_time = 0;
 
-	iwl_scan_cancel(priv);
+	iwl3945_scan_cancel(priv);
 }
 
 #define MAX_UCODE_BEACON_INTERVAL	1024
 #define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)
 
-static __le16 iwl_adjust_beacon_interval(u16 beacon_val)
+static __le16 iwl3945_adjust_beacon_interval(u16 beacon_val)
 {
 	u16 new_val = 0;
 	u16 beacon_factor = 0;
@@ -2306,7 +2306,7 @@ static __le16 iwl_adjust_beacon_interval
 	return cpu_to_le16(new_val);
 }
 
-static void iwl_setup_rxon_timing(struct iwl_priv *priv)
+static void iwl3945_setup_rxon_timing(struct iwl3945_priv *priv)
 {
 	u64 interval_tm_unit;
 	u64 tsf, result;
@@ -2336,14 +2336,14 @@ static void iwl_setup_rxon_timing(struct
 			priv->rxon_timing.beacon_interval =
 				cpu_to_le16(beacon_int);
 			priv->rxon_timing.beacon_interval =
-			    iwl_adjust_beacon_interval(
+			    iwl3945_adjust_beacon_interval(
 				le16_to_cpu(priv->rxon_timing.beacon_interval));
 		}
 
 		priv->rxon_timing.atim_window = 0;
 	} else {
 		priv->rxon_timing.beacon_interval =
-			iwl_adjust_beacon_interval(conf->beacon_int);
+			iwl3945_adjust_beacon_interval(conf->beacon_int);
 		/* TODO: we need to get atim_window from upper stack
 		 * for now we set to 0 */
 		priv->rxon_timing.atim_window = 0;
@@ -2362,14 +2362,14 @@ static void iwl_setup_rxon_timing(struct
 		le16_to_cpu(priv->rxon_timing.atim_window));
 }
 
-static int iwl_scan_initiate(struct iwl_priv *priv)
+static int iwl3945_scan_initiate(struct iwl3945_priv *priv)
 {
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
 		IWL_ERROR("APs don't scan.\n");
 		return 0;
 	}
 
-	if (!iwl_is_ready_rf(priv)) {
+	if (!iwl3945_is_ready_rf(priv)) {
 		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
 		return -EIO;
 	}
@@ -2396,9 +2396,9 @@ static int iwl_scan_initiate(struct iwl_
 	return 0;
 }
 
-static int iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
+static int iwl3945_set_rxon_hwcrypto(struct iwl3945_priv *priv, int hw_decrypt)
 {
-	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl3945_rxon_cmd *rxon = &priv->staging_rxon;
 
 	if (hw_decrypt)
 		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
@@ -2408,7 +2408,7 @@ static int iwl_set_rxon_hwcrypto(struct 
 	return 0;
 }
 
-static void iwl_set_flags_for_phymode(struct iwl_priv *priv, u8 phymode)
+static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv, u8 phymode)
 {
 	if (phymode == MODE_IEEE80211A) {
 		priv->staging_rxon.flags &=
@@ -2416,7 +2416,7 @@ static void iwl_set_flags_for_phymode(st
 		      | RXON_FLG_CCK_MSK);
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 	} else {
-		/* Copied from iwl_bg_post_associate() */
+		/* Copied from iwl3945_bg_post_associate() */
 		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
@@ -2434,9 +2434,9 @@ static void iwl_set_flags_for_phymode(st
 /*
  * initilize rxon structure with default values fromm eeprom
  */
-static void iwl_connection_init_rx_config(struct iwl_priv *priv)
+static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv)
 {
-	const struct iwl_channel_info *ch_info;
+	const struct iwl3945_channel_info *ch_info;
 
 	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 
@@ -2473,7 +2473,7 @@ static void iwl_connection_init_rx_confi
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
-	ch_info = iwl_get_channel_info(priv, priv->phymode,
+	ch_info = iwl3945_get_channel_info(priv, priv->phymode,
 				       le16_to_cpu(priv->staging_rxon.channel));
 
 	if (!ch_info)
@@ -2493,7 +2493,7 @@ static void iwl_connection_init_rx_confi
 	else
 		priv->phymode = MODE_IEEE80211G;
 
-	iwl_set_flags_for_phymode(priv, priv->phymode);
+	iwl3945_set_flags_for_phymode(priv, priv->phymode);
 
 	priv->staging_rxon.ofdm_basic_rates =
 	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
@@ -2501,15 +2501,15 @@ static void iwl_connection_init_rx_confi
 	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
 }
 
-static int iwl_set_mode(struct iwl_priv *priv, int mode)
+static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 {
-	if (!iwl_is_ready_rf(priv))
+	if (!iwl3945_is_ready_rf(priv))
 		return -EAGAIN;
 
 	if (mode == IEEE80211_IF_TYPE_IBSS) {
-		const struct iwl_channel_info *ch_info;
+		const struct iwl3945_channel_info *ch_info;
 
-		ch_info = iwl_get_channel_info(priv,
+		ch_info = iwl3945_get_channel_info(priv,
 			priv->phymode,
 			le16_to_cpu(priv->staging_rxon.channel));
 
@@ -2521,7 +2521,7 @@ static int iwl_set_mode(struct iwl_priv 
 	}
 
 	cancel_delayed_work(&priv->scan_check);
-	if (iwl_scan_cancel_timeout(priv, 100)) {
+	if (iwl3945_scan_cancel_timeout(priv, 100)) {
 		IWL_WARNING("Aborted scan still in progress after 100ms\n");
 		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
 		return -EAGAIN;
@@ -2529,23 +2529,23 @@ static int iwl_set_mode(struct iwl_priv 
 
 	priv->iw_mode = mode;
 
-	iwl_connection_init_rx_config(priv);
+	iwl3945_connection_init_rx_config(priv);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
-	iwl_clear_stations_table(priv);
+	iwl3945_clear_stations_table(priv);
 
-	iwl_commit_rxon(priv);
+	iwl3945_commit_rxon(priv);
 
 	return 0;
 }
 
-static void iwl_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
+static void iwl3945_build_tx_cmd_hwcrypto(struct iwl3945_priv *priv,
 				      struct ieee80211_tx_control *ctl,
-				      struct iwl_cmd *cmd,
+				      struct iwl3945_cmd *cmd,
 				      struct sk_buff *skb_frag,
 				      int last_frag)
 {
-	struct iwl_hw_key *keyinfo = &priv->stations[ctl->key_idx].keyinfo;
+	struct iwl3945_hw_key *keyinfo = &priv->stations[ctl->key_idx].keyinfo;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
@@ -2588,8 +2588,8 @@ static void iwl_build_tx_cmd_hwcrypto(st
 /*
  * handle build REPLY_TX command notification.
  */
-static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
-				  struct iwl_cmd *cmd,
+static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
+				  struct iwl3945_cmd *cmd,
 				  struct ieee80211_tx_control *ctrl,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
@@ -2650,7 +2650,7 @@ static void iwl_build_tx_cmd_basic(struc
 	cmd->cmd.tx.next_frame_len = 0;
 }
 
-static int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
+static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *hdr)
 {
 	int sta_id;
 	u16 fc = le16_to_cpu(hdr->frame_control);
@@ -2670,7 +2670,7 @@ static int iwl_get_sta_id(struct iwl_pri
 
 	/* If we are an AP, then find the station, or use BCAST */
 	case IEEE80211_IF_TYPE_AP:
-		sta_id = iwl_hw_find_station(priv, hdr->addr1);
+		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 		return priv->hw_setting.bcast_sta_id;
@@ -2680,11 +2680,11 @@ static int iwl_get_sta_id(struct iwl_pri
 	case IEEE80211_IF_TYPE_IBSS: {
 		DECLARE_MAC_BUF(mac);
 
-		sta_id = iwl_hw_find_station(priv, hdr->addr1);
+		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
-		sta_id = iwl_add_station(priv, hdr->addr1, 0, CMD_ASYNC);
+		sta_id = iwl3945_add_station(priv, hdr->addr1, 0, CMD_ASYNC);
 
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
@@ -2692,7 +2692,7 @@ static int iwl_get_sta_id(struct iwl_pri
 		IWL_DEBUG_DROP("Station %s not in station map. "
 			       "Defaulting to broadcast...\n",
 			       print_mac(mac, hdr->addr1));
-		iwl_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
+		iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_setting.bcast_sta_id;
 	}
 	default:
@@ -2704,18 +2704,18 @@ static int iwl_get_sta_id(struct iwl_pri
 /*
  * start REPLY_TX command process
  */
-static int iwl_tx_skb(struct iwl_priv *priv,
+static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 		      struct sk_buff *skb, struct ieee80211_tx_control *ctl)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl_tfd_frame *tfd;
+	struct iwl3945_tfd_frame *tfd;
 	u32 *control_flags;
 	int txq_id = ctl->queue;
-	struct iwl_tx_queue *txq = NULL;
-	struct iwl_queue *q = NULL;
+	struct iwl3945_tx_queue *txq = NULL;
+	struct iwl3945_queue *q = NULL;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
-	struct iwl_cmd *out_cmd = NULL;
+	struct iwl3945_cmd *out_cmd = NULL;
 	u16 len, idx, len_org;
 	u8 id, hdr_len, unicast;
 	u8 sta_id;
@@ -2727,7 +2727,7 @@ static int iwl_tx_skb(struct iwl_priv *p
 	int rc;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl_is_rfkill(priv)) {
+	if (iwl3945_is_rfkill(priv)) {
 		IWL_DEBUG_DROP("Dropping - RF KILL\n");
 		goto drop_unlock;
 	}
@@ -2756,16 +2756,16 @@ static int iwl_tx_skb(struct iwl_priv *p
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif
 
-	if (!iwl_is_associated(priv) &&
+	if (!iwl3945_is_associated(priv) &&
 	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
-		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
+		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
 		goto drop_unlock;
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	hdr_len = ieee80211_get_hdrlen(fc);
-	sta_id = iwl_get_sta_id(priv, hdr);
+	sta_id = iwl3945_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);
 
@@ -2796,7 +2796,7 @@ static int iwl_tx_skb(struct iwl_priv *p
 	control_flags = (u32 *) tfd;
 	idx = get_cmd_index(q, q->first_empty, 0);
 
-	memset(&(txq->txb[q->first_empty]), 0, sizeof(struct iwl_tx_info));
+	memset(&(txq->txb[q->first_empty]), 0, sizeof(struct iwl3945_tx_info));
 	txq->txb[q->first_empty].skb[0] = skb;
 	memcpy(&(txq->txb[q->first_empty].status.control),
 	       ctl, sizeof(struct ieee80211_tx_control));
@@ -2811,7 +2811,7 @@ static int iwl_tx_skb(struct iwl_priv *p
 
 	/* hdr = (struct ieee80211_hdr *)out_cmd->cmd.tx.hdr; */
 	len = priv->hw_setting.tx_cmd_len +
-		sizeof(struct iwl_cmd_header) + hdr_len;
+		sizeof(struct iwl3945_cmd_header) + hdr_len;
 
 	len_org = len;
 	len = (len + 3) & ~3;
@@ -2821,20 +2821,20 @@ static int iwl_tx_skb(struct iwl_priv *p
 	else
 		len_org = 0;
 
-	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
-		     offsetof(struct iwl_cmd, hdr);
+	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl3945_cmd) * idx +
+		     offsetof(struct iwl3945_cmd, hdr);
 
-	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
+	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
 	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
-		iwl_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, 0);
+		iwl3945_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, 0);
 
 	/* 802.11 null functions have no payload... */
 	len = skb->len - hdr_len;
 	if (len) {
 		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
 					   len, PCI_DMA_TODEVICE);
-		iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
+		iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
 	}
 
 	/* If there is no payload, then only one TFD is used */
@@ -2848,10 +2848,10 @@ static int iwl_tx_skb(struct iwl_priv *p
 	out_cmd->cmd.tx.len = cpu_to_le16(len);
 
 	/* TODO need this for burst mode later on */
-	iwl_build_tx_cmd_basic(priv, out_cmd, ctl, hdr, unicast, sta_id);
+	iwl3945_build_tx_cmd_basic(priv, out_cmd, ctl, hdr, unicast, sta_id);
 
 	/* set is_hcca to 0; it probably will never be implemented */
-	iwl_hw_build_tx_cmd_rate(priv, out_cmd, ctl, hdr, sta_id, 0);
+	iwl3945_hw_build_tx_cmd_rate(priv, out_cmd, ctl, hdr, sta_id, 0);
 
 	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
 	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
@@ -2867,25 +2867,25 @@ static int iwl_tx_skb(struct iwl_priv *p
 		txq->need_update = 0;
 	}
 
-	iwl_print_hex_dump(IWL_DL_TX, out_cmd->cmd.payload,
+	iwl3945_print_hex_dump(IWL_DL_TX, out_cmd->cmd.payload,
 			   sizeof(out_cmd->cmd.tx));
 
-	iwl_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
+	iwl3945_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
 			   ieee80211_get_hdrlen(fc));
 
-	q->first_empty = iwl_queue_inc_wrap(q->first_empty, q->n_bd);
-	rc = iwl_tx_queue_update_write_ptr(priv, txq);
+	q->first_empty = iwl3945_queue_inc_wrap(q->first_empty, q->n_bd);
+	rc = iwl3945_tx_queue_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (rc)
 		return rc;
 
-	if ((iwl_queue_space(q) < q->high_mark)
+	if ((iwl3945_queue_space(q) < q->high_mark)
 	    && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
 			txq->need_update = 1;
-			iwl_tx_queue_update_write_ptr(priv, txq);
+			iwl3945_tx_queue_update_write_ptr(priv, txq);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
@@ -2900,13 +2900,13 @@ drop:
 	return -1;
 }
 
-static void iwl_set_rate(struct iwl_priv *priv)
+static void iwl3945_set_rate(struct iwl3945_priv *priv)
 {
 	const struct ieee80211_hw_mode *hw = NULL;
 	struct ieee80211_rate *rate;
 	int i;
 
-	hw = iwl_get_hw_mode(priv, priv->phymode);
+	hw = iwl3945_get_hw_mode(priv, priv->phymode);
 
 	priv->active_rate = 0;
 	priv->active_rate_basic = 0;
@@ -2920,7 +2920,7 @@ static void iwl_set_rate(struct iwl_priv
 		if ((rate->val < IWL_RATE_COUNT) &&
 		    (rate->flags & IEEE80211_RATE_SUPPORTED)) {
 			IWL_DEBUG_RATE("Adding rate index %d (plcp %d)%s\n",
-				       rate->val, iwl_rates[rate->val].plcp,
+				       rate->val, iwl3945_rates[rate->val].plcp,
 				       (rate->flags & IEEE80211_RATE_BASIC) ?
 				       "*" : "");
 			priv->active_rate |= (1 << rate->val);
@@ -2928,7 +2928,7 @@ static void iwl_set_rate(struct iwl_priv
 				priv->active_rate_basic |= (1 << rate->val);
 		} else
 			IWL_DEBUG_RATE("Not adding rate %d (plcp %d)\n",
-				       rate->val, iwl_rates[rate->val].plcp);
+				       rate->val, iwl3945_rates[rate->val].plcp);
 	}
 
 	IWL_DEBUG_RATE("Set active_rate = %0x, active_rate_basic = %0x\n",
@@ -2957,7 +2957,7 @@ static void iwl_set_rate(struct iwl_priv
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
-static void iwl_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
+static void iwl3945_radio_kill_sw(struct iwl3945_priv *priv, int disable_radio)
 {
 	unsigned long flags;
 
@@ -2968,21 +2968,21 @@ static void iwl_radio_kill_sw(struct iwl
 			  disable_radio ? "OFF" : "ON");
 
 	if (disable_radio) {
-		iwl_scan_cancel(priv);
+		iwl3945_scan_cancel(priv);
 		/* FIXME: This is a workaround for AP */
 		if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
 			spin_lock_irqsave(&priv->lock, flags);
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+			iwl3945_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_SW_BIT_RFKILL);
 			spin_unlock_irqrestore(&priv->lock, flags);
-			iwl_send_card_state(priv, CARD_STATE_CMD_DISABLE, 0);
+			iwl3945_send_card_state(priv, CARD_STATE_CMD_DISABLE, 0);
 			set_bit(STATUS_RF_KILL_SW, &priv->status);
 		}
 		return;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	clear_bit(STATUS_RF_KILL_SW, &priv->status);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -2991,9 +2991,9 @@ static void iwl_radio_kill_sw(struct iwl
 	msleep(10);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl_read32(priv, CSR_UCODE_DRV_GP1);
-	if (!iwl_grab_restricted_access(priv))
-		iwl_release_restricted_access(priv);
+	iwl3945_read32(priv, CSR_UCODE_DRV_GP1);
+	if (!iwl3945_grab_restricted_access(priv))
+		iwl3945_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
@@ -3006,7 +3006,7 @@ static void iwl_radio_kill_sw(struct iwl
 	return;
 }
 
-void iwl_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
+void iwl3945_set_decrypted_flag(struct iwl3945_priv *priv, struct sk_buff *skb,
 			    u32 decrypt_res, struct ieee80211_rx_status *stats)
 {
 	u16 fc =
@@ -3038,13 +3038,13 @@ void iwl_set_decrypted_flag(struct iwl_p
 	}
 }
 
-void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb,
+void iwl3945_handle_data_packet_monitor(struct iwl3945_priv *priv,
+				    struct iwl3945_rx_mem_buffer *rxb,
 				    void *data, short len,
 				    struct ieee80211_rx_status *stats,
 				    u16 phy_flags)
 {
-	struct iwl_rt_rx_hdr *iwl_rt;
+	struct iwl3945_rt_rx_hdr *iwl3945_rt;
 
 	/* First cache any information we need before we overwrite
 	 * the information provided in the skb from the hardware */
@@ -3055,26 +3055,26 @@ void iwl_handle_data_packet_monitor(stru
 	__le16 phy_flags_hw = cpu_to_le16(phy_flags);
 
 	/* We received data from the HW, so stop the watchdog */
-	if (len > IWL_RX_BUF_SIZE - sizeof(*iwl_rt)) {
+	if (len > IWL_RX_BUF_SIZE - sizeof(*iwl3945_rt)) {
 		IWL_DEBUG_DROP("Dropping too large packet in monitor\n");
 		return;
 	}
 
 	/* copy the frame data to write after where the radiotap header goes */
-	iwl_rt = (void *)rxb->skb->data;
-	memmove(iwl_rt->payload, data, len);
+	iwl3945_rt = (void *)rxb->skb->data;
+	memmove(iwl3945_rt->payload, data, len);
 
-	iwl_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
-	iwl_rt->rt_hdr.it_pad = 0; /* always good to zero */
+	iwl3945_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
+	iwl3945_rt->rt_hdr.it_pad = 0; /* always good to zero */
 
 	/* total header + data */
-	iwl_rt->rt_hdr.it_len = cpu_to_le16(sizeof(*iwl_rt));
+	iwl3945_rt->rt_hdr.it_len = cpu_to_le16(sizeof(*iwl3945_rt));
 
 	/* Set the size of the skb to the size of the frame */
-	skb_put(rxb->skb, sizeof(*iwl_rt) + len);
+	skb_put(rxb->skb, sizeof(*iwl3945_rt) + len);
 
 	/* Big bitfield of all the fields we provide in radiotap */
-	iwl_rt->rt_hdr.it_present =
+	iwl3945_rt->rt_hdr.it_present =
 	    cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
 			(1 << IEEE80211_RADIOTAP_FLAGS) |
 			(1 << IEEE80211_RADIOTAP_RATE) |
@@ -3084,39 +3084,39 @@ void iwl_handle_data_packet_monitor(stru
 			(1 << IEEE80211_RADIOTAP_ANTENNA));
 
 	/* Zero the flags, we'll add to them as we go */
-	iwl_rt->rt_flags = 0;
+	iwl3945_rt->rt_flags = 0;
 
-	iwl_rt->rt_tsf = cpu_to_le64(tsf);
+	iwl3945_rt->rt_tsf = cpu_to_le64(tsf);
 
 	/* Convert to dBm */
-	iwl_rt->rt_dbmsignal = signal;
-	iwl_rt->rt_dbmnoise = noise;
+	iwl3945_rt->rt_dbmsignal = signal;
+	iwl3945_rt->rt_dbmnoise = noise;
 
 	/* Convert the channel frequency and set the flags */
-	iwl_rt->rt_channelMHz = cpu_to_le16(stats->freq);
+	iwl3945_rt->rt_channelMHz = cpu_to_le16(stats->freq);
 	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
-		iwl_rt->rt_chbitmask =
+		iwl3945_rt->rt_chbitmask =
 		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ));
 	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
-		iwl_rt->rt_chbitmask =
+		iwl3945_rt->rt_chbitmask =
 		    cpu_to_le16((IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ));
 	else	/* 802.11g */
-		iwl_rt->rt_chbitmask =
+		iwl3945_rt->rt_chbitmask =
 		    cpu_to_le16((IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ));
 
-	rate = iwl_rate_index_from_plcp(rate);
+	rate = iwl3945_rate_index_from_plcp(rate);
 	if (rate == -1)
-		iwl_rt->rt_rate = 0;
+		iwl3945_rt->rt_rate = 0;
 	else
-		iwl_rt->rt_rate = iwl_rates[rate].ieee;
+		iwl3945_rt->rt_rate = iwl3945_rates[rate].ieee;
 
 	/* antenna number */
-	iwl_rt->rt_antenna =
+	iwl3945_rt->rt_antenna =
 		le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
 
 	/* set the preamble flag if we have it */
 	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		iwl_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
+		iwl3945_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
 
 	IWL_DEBUG_RX("Rx packet of %d bytes.\n", rxb->skb->len);
 
@@ -3128,7 +3128,8 @@ void iwl_handle_data_packet_monitor(stru
 
 #define IWL_PACKET_RETRY_TIME HZ
 
-int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
+int iwl3945_is_duplicate_packet(struct iwl3945_priv *priv,
+		struct ieee80211_hdr *header)
 {
 	u16 sc = le16_to_cpu(header->seq_ctrl);
 	u16 seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
@@ -3139,13 +3140,13 @@ int is_duplicate_packet(struct iwl_priv 
 	switch (priv->iw_mode) {
 	case IEEE80211_IF_TYPE_IBSS:{
 		struct list_head *p;
-		struct iwl_ibss_seq *entry = NULL;
+		struct iwl3945_ibss_seq *entry = NULL;
 		u8 *mac = header->addr2;
 		int index = mac[5] & (IWL_IBSS_MAC_HASH_SIZE - 1);
 
 		__list_for_each(p, &priv->ibss_mac_hash[index]) {
 			entry =
-				list_entry(p, struct iwl_ibss_seq, list);
+				list_entry(p, struct iwl3945_ibss_seq, list);
 			if (!compare_ether_addr(entry->mac, mac))
 				break;
 		}
@@ -3210,7 +3211,7 @@ int is_duplicate_packet(struct iwl_priv 
  * the lower 3 bytes is the time in usec within one beacon interval
  */
 
-static u32 iwl_usecs_to_beacons(u32 usec, u32 beacon_interval)
+static u32 iwl3945_usecs_to_beacons(u32 usec, u32 beacon_interval)
 {
 	u32 quot;
 	u32 rem;
@@ -3229,7 +3230,7 @@ static u32 iwl_usecs_to_beacons(u32 usec
  * the same as HW timer counter counting down
  */
 
-static __le32 iwl_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
+static __le32 iwl3945_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
 {
 	u32 base_low = base & BEACON_TIME_MASK_LOW;
 	u32 addon_low = addon & BEACON_TIME_MASK_LOW;
@@ -3248,13 +3249,13 @@ static __le32 iwl_add_beacon_time(u32 ba
 	return cpu_to_le32(res);
 }
 
-static int iwl_get_measurement(struct iwl_priv *priv,
+static int iwl3945_get_measurement(struct iwl3945_priv *priv,
 			       struct ieee80211_measurement_params *params,
 			       u8 type)
 {
-	struct iwl_spectrum_cmd spectrum;
-	struct iwl_rx_packet *res;
-	struct iwl_host_cmd cmd = {
+	struct iwl3945_spectrum_cmd spectrum;
+	struct iwl3945_rx_packet *res;
+	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
 		.data = (void *)&spectrum,
 		.meta.flags = CMD_WANT_SKB,
@@ -3264,9 +3265,9 @@ static int iwl_get_measurement(struct iw
 	int spectrum_resp_status;
 	int duration = le16_to_cpu(params->duration);
 
-	if (iwl_is_associated(priv))
+	if (iwl3945_is_associated(priv))
 		add_time =
-		    iwl_usecs_to_beacons(
+		    iwl3945_usecs_to_beacons(
 			le64_to_cpu(params->start_time) - priv->last_tsf,
 			le16_to_cpu(priv->rxon_timing.beacon_interval));
 
@@ -3279,9 +3280,9 @@ static int iwl_get_measurement(struct iw
 	cmd.len = sizeof(spectrum);
 	spectrum.len = cpu_to_le16(cmd.len - sizeof(spectrum.len));
 
-	if (iwl_is_associated(priv))
+	if (iwl3945_is_associated(priv))
 		spectrum.start_time =
-		    iwl_add_beacon_time(priv->last_beacon_time,
+		    iwl3945_add_beacon_time(priv->last_beacon_time,
 				add_time,
 				le16_to_cpu(priv->rxon_timing.beacon_interval));
 	else
@@ -3294,11 +3295,11 @@ static int iwl_get_measurement(struct iw
 		spectrum.flags |= RXON_FLG_BAND_24G_MSK |
 		    RXON_FLG_AUTO_DETECT_MSK | RXON_FLG_TGG_PROTECT_MSK;
 
-	rc = iwl_send_cmd_sync(priv, &cmd);
+	rc = iwl3945_send_cmd_sync(priv, &cmd);
 	if (rc)
 		return rc;
 
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl3945_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_RX_ON_ASSOC command\n");
 		rc = -EIO;
@@ -3328,8 +3329,8 @@ static int iwl_get_measurement(struct iw
 }
 #endif
 
-static void iwl_txstatus_to_ieee(struct iwl_priv *priv,
-				 struct iwl_tx_info *tx_sta)
+static void iwl3945_txstatus_to_ieee(struct iwl3945_priv *priv,
+				 struct iwl3945_tx_info *tx_sta)
 {
 
 	tx_sta->status.ack_signal = 0;
@@ -3348,16 +3349,16 @@ static void iwl_txstatus_to_ieee(struct 
 }
 
 /**
- * iwl_tx_queue_reclaim - Reclaim Tx queue entries no more used by NIC.
+ * iwl3945_tx_queue_reclaim - Reclaim Tx queue entries no more used by NIC.
  *
  * When FW advances 'R' index, all entries between old and
  * new 'R' index need to be reclaimed. As result, some free space
  * forms. If there is enough free space (> low mark), wake Tx queue.
  */
-static int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
+static int iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv, int txq_id, int index)
 {
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
+	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl3945_queue *q = &txq->q;
 	int nfreed = 0;
 
 	if ((index >= q->n_bd) || (x2_queue_used(q, index) == 0)) {
@@ -3367,13 +3368,13 @@ static int iwl_tx_queue_reclaim(struct i
 		return 0;
 	}
 
-	for (index = iwl_queue_inc_wrap(index, q->n_bd);
+	for (index = iwl3945_queue_inc_wrap(index, q->n_bd);
 		q->last_used != index;
-		q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd)) {
+		q->last_used = iwl3945_queue_inc_wrap(q->last_used, q->n_bd)) {
 		if (txq_id != IWL_CMD_QUEUE_NUM) {
-			iwl_txstatus_to_ieee(priv,
+			iwl3945_txstatus_to_ieee(priv,
 					&(txq->txb[txq->q.last_used]));
-			iwl_hw_txq_free_tfd(priv, txq);
+			iwl3945_hw_txq_free_tfd(priv, txq);
 		} else if (nfreed > 1) {
 			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
 					q->first_empty, q->last_used);
@@ -3382,7 +3383,7 @@ static int iwl_tx_queue_reclaim(struct i
 		nfreed++;
 	}
 
-	if (iwl_queue_space(q) > q->low_mark && (txq_id >= 0) &&
+	if (iwl3945_queue_space(q) > q->low_mark && (txq_id >= 0) &&
 			(txq_id != IWL_CMD_QUEUE_NUM) &&
 			priv->mac80211_registered)
 		ieee80211_wake_queue(priv->hw, txq_id);
@@ -3391,7 +3392,7 @@ static int iwl_tx_queue_reclaim(struct i
 	return nfreed;
 }
 
-static int iwl_is_tx_success(u32 status)
+static int iwl3945_is_tx_success(u32 status)
 {
 	return (status & 0xFF) == 0x1;
 }
@@ -3401,16 +3402,16 @@ static int iwl_is_tx_success(u32 status)
  * Generic RX handler implementations
  *
  ******************************************************************************/
-static void iwl_rx_reply_tx(struct iwl_priv *priv,
-			    struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
+			    struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
 	struct ieee80211_tx_status *tx_status;
-	struct iwl_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	struct iwl3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
 
 	if ((index >= txq->q.n_bd) || (x2_queue_used(&txq->q, index) == 0)) {
@@ -3429,28 +3430,28 @@ static void iwl_rx_reply_tx(struct iwl_p
 	tx_status->queue_length |= tx_resp->failure_rts;
 
 	tx_status->flags =
-	    iwl_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
+	    iwl3945_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
 
-	tx_status->control.tx_rate = iwl_rate_index_from_plcp(tx_resp->rate);
+	tx_status->control.tx_rate = iwl3945_rate_index_from_plcp(tx_resp->rate);
 
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
-			txq_id, iwl_get_tx_fail_reason(status), status,
+			txq_id, iwl3945_get_tx_fail_reason(status), status,
 			tx_resp->rate, tx_resp->failure_frame);
 
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
 	if (index != -1)
-		iwl_tx_queue_reclaim(priv, txq_id, index);
+		iwl3945_tx_queue_reclaim(priv, txq_id, index);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
 
-static void iwl_rx_reply_alive(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_reply_alive(struct iwl3945_priv *priv,
+			       struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_alive_resp *palive;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_alive_resp *palive;
 	struct delayed_work *pwork;
 
 	palive = &pkt->u.alive_frame;
@@ -3464,14 +3465,14 @@ static void iwl_rx_reply_alive(struct iw
 		IWL_DEBUG_INFO("Initialization Alive received.\n");
 		memcpy(&priv->card_alive_init,
 		       &pkt->u.alive_frame,
-		       sizeof(struct iwl_init_alive_resp));
+		       sizeof(struct iwl3945_init_alive_resp));
 		pwork = &priv->init_alive_start;
 	} else {
 		IWL_DEBUG_INFO("Runtime Alive received.\n");
 		memcpy(&priv->card_alive, &pkt->u.alive_frame,
-		       sizeof(struct iwl_alive_resp));
+		       sizeof(struct iwl3945_alive_resp));
 		pwork = &priv->alive_start;
-		iwl_disable_events(priv);
+		iwl3945_disable_events(priv);
 	}
 
 	/* We delay the ALIVE response by 5ms to
@@ -3483,19 +3484,19 @@ static void iwl_rx_reply_alive(struct iw
 		IWL_WARNING("uCode did not respond OK.\n");
 }
 
-static void iwl_rx_reply_add_sta(struct iwl_priv *priv,
-				 struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_reply_add_sta(struct iwl3945_priv *priv,
+				 struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
 
 	IWL_DEBUG_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
 	return;
 }
 
-static void iwl_rx_reply_error(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_reply_error(struct iwl3945_priv *priv,
+			       struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
 
 	IWL_ERROR("Error Reply type 0x%08X cmd %s (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
@@ -3508,23 +3509,23 @@ static void iwl_rx_reply_error(struct iw
 
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_csa(struct iwl3945_priv *priv, struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
-	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_rxon_cmd *rxon = (void *)&priv->active_rxon;
+	struct iwl3945_csa_notification *csa = &(pkt->u.csa_notif);
 	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
 		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
 	rxon->channel = csa->channel;
 	priv->staging_rxon.channel = csa->channel;
 }
 
-static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
-					  struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_spectrum_measure_notif(struct iwl3945_priv *priv,
+					  struct iwl3945_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
 		IWL_DEBUG(IWL_DL_11H | IWL_DL_INFO,
@@ -3537,31 +3538,31 @@ static void iwl_rx_spectrum_measure_noti
 #endif
 }
 
-static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
-				  struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_pm_sleep_notif(struct iwl3945_priv *priv,
+				  struct iwl3945_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
 }
 
-static void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
-					     struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_pm_debug_statistics_notif(struct iwl3945_priv *priv,
+					     struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
 	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	iwl_print_hex_dump(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
+	iwl3945_print_hex_dump(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
 }
 
-static void iwl_bg_beacon_update(struct work_struct *work)
+static void iwl3945_bg_beacon_update(struct work_struct *work)
 {
-	struct iwl_priv *priv =
-		container_of(work, struct iwl_priv, beacon_update);
+	struct iwl3945_priv *priv =
+		container_of(work, struct iwl3945_priv, beacon_update);
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
@@ -3580,15 +3581,15 @@ static void iwl_bg_beacon_update(struct 
 	priv->ibss_beacon = beacon;
 	mutex_unlock(&priv->mutex);
 
-	iwl_send_beacon_cmd(priv);
+	iwl3945_send_beacon_cmd(priv);
 }
 
-static void iwl_rx_beacon_notif(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_beacon_notif(struct iwl3945_priv *priv,
+				struct iwl3945_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_beacon_notif *beacon = &(pkt->u.beacon_status);
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = beacon->beacon_notify_hdr.rate;
 
 	IWL_DEBUG_RX("beacon status %x retries %d iss %d "
@@ -3606,25 +3607,25 @@ static void iwl_rx_beacon_notif(struct i
 }
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
-static void iwl_rx_reply_scan(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_reply_scan(struct iwl3945_priv *priv,
+			      struct iwl3945_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_scanreq_notification *notif =
-	    (struct iwl_scanreq_notification *)pkt->u.raw;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_scanreq_notification *notif =
+	    (struct iwl3945_scanreq_notification *)pkt->u.raw;
 
 	IWL_DEBUG_RX("Scan request status = 0x%x\n", notif->status);
 #endif
 }
 
 /* Service SCAN_START_NOTIFICATION (0x82) */
-static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_scan_start_notif(struct iwl3945_priv *priv,
+				    struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_scanstart_notification *notif =
-	    (struct iwl_scanstart_notification *)pkt->u.raw;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_scanstart_notification *notif =
+	    (struct iwl3945_scanstart_notification *)pkt->u.raw;
 	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
 	IWL_DEBUG_SCAN("Scan start: "
 		       "%d [802.11%s] "
@@ -3636,12 +3637,12 @@ static void iwl_rx_scan_start_notif(stru
 }
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
-static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
-				      struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_scan_results_notif(struct iwl3945_priv *priv,
+				      struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_scanresults_notification *notif =
-	    (struct iwl_scanresults_notification *)pkt->u.raw;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_scanresults_notification *notif =
+	    (struct iwl3945_scanresults_notification *)pkt->u.raw;
 
 	IWL_DEBUG_SCAN("Scan ch.res: "
 		       "%d [802.11%s] "
@@ -3660,11 +3661,11 @@ static void iwl_rx_scan_results_notif(st
 }
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
-static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
+				       struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 
 	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
 		       scan_notif->scanned_channels,
@@ -3717,10 +3718,10 @@ reschedule:
 
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
-static void iwl_rx_card_state_notif(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_rx_card_state_notif(struct iwl3945_priv *priv,
+				    struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
 
@@ -3728,7 +3729,7 @@ static void iwl_rx_card_state_notif(stru
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & SW_CARD_DISABLED) ? "Kill" : "On");
 
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_SET,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	if (flags & HW_CARD_DISABLED)
@@ -3742,7 +3743,7 @@ static void iwl_rx_card_state_notif(stru
 	else
 		clear_bit(STATUS_RF_KILL_SW, &priv->status);
 
-	iwl_scan_cancel(priv);
+	iwl3945_scan_cancel(priv);
 
 	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
 	     test_bit(STATUS_RF_KILL_HW, &priv->status)) ||
@@ -3754,7 +3755,7 @@ static void iwl_rx_card_state_notif(stru
 }
 
 /**
- * iwl_setup_rx_handlers - Initialize Rx handler callbacks
+ * iwl3945_setup_rx_handlers - Initialize Rx handler callbacks
  *
  * Setup the RX handlers for each of the reply types sent from the uCode
  * to the host.
@@ -3762,20 +3763,20 @@ static void iwl_rx_card_state_notif(stru
  * This function chains into the hardware specific files for them to setup
  * any hardware specific handlers as well.
  */
-static void iwl_setup_rx_handlers(struct iwl_priv *priv)
+static void iwl3945_setup_rx_handlers(struct iwl3945_priv *priv)
 {
-	priv->rx_handlers[REPLY_ALIVE] = iwl_rx_reply_alive;
-	priv->rx_handlers[REPLY_ADD_STA] = iwl_rx_reply_add_sta;
-	priv->rx_handlers[REPLY_ERROR] = iwl_rx_reply_error;
-	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl_rx_csa;
+	priv->rx_handlers[REPLY_ALIVE] = iwl3945_rx_reply_alive;
+	priv->rx_handlers[REPLY_ADD_STA] = iwl3945_rx_reply_add_sta;
+	priv->rx_handlers[REPLY_ERROR] = iwl3945_rx_reply_error;
+	priv->rx_handlers[CHANNEL_SWITCH_NOTIFICATION] = iwl3945_rx_csa;
 	priv->rx_handlers[SPECTRUM_MEASURE_NOTIFICATION] =
-	    iwl_rx_spectrum_measure_notif;
-	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl_rx_pm_sleep_notif;
+	    iwl3945_rx_spectrum_measure_notif;
+	priv->rx_handlers[PM_SLEEP_NOTIFICATION] = iwl3945_rx_pm_sleep_notif;
 	priv->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
-	    iwl_rx_pm_debug_statistics_notif;
-	priv->rx_handlers[BEACON_NOTIFICATION] = iwl_rx_beacon_notif;
+	    iwl3945_rx_pm_debug_statistics_notif;
+	priv->rx_handlers[BEACON_NOTIFICATION] = iwl3945_rx_beacon_notif;
 
-	/* NOTE:  iwl_rx_statistics is different based on whether
+	/* NOTE:  iwl3945_rx_statistics is different based on whether
 	 * the build is for the 3945 or the 4965.  See the
 	 * corresponding implementation in iwl-XXXX.c
 	 *
@@ -3783,40 +3784,40 @@ static void iwl_setup_rx_handlers(struct
 	 * discrete statistics request from the host as well as
 	 * for the periodic statistics notification from the uCode
 	 */
-	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl_hw_rx_statistics;
-	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl_hw_rx_statistics;
+	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl3945_hw_rx_statistics;
+	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl3945_hw_rx_statistics;
 
-	priv->rx_handlers[REPLY_SCAN_CMD] = iwl_rx_reply_scan;
-	priv->rx_handlers[SCAN_START_NOTIFICATION] = iwl_rx_scan_start_notif;
+	priv->rx_handlers[REPLY_SCAN_CMD] = iwl3945_rx_reply_scan;
+	priv->rx_handlers[SCAN_START_NOTIFICATION] = iwl3945_rx_scan_start_notif;
 	priv->rx_handlers[SCAN_RESULTS_NOTIFICATION] =
-	    iwl_rx_scan_results_notif;
+	    iwl3945_rx_scan_results_notif;
 	priv->rx_handlers[SCAN_COMPLETE_NOTIFICATION] =
-	    iwl_rx_scan_complete_notif;
-	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl_rx_card_state_notif;
-	priv->rx_handlers[REPLY_TX] = iwl_rx_reply_tx;
+	    iwl3945_rx_scan_complete_notif;
+	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl3945_rx_card_state_notif;
+	priv->rx_handlers[REPLY_TX] = iwl3945_rx_reply_tx;
 
 	/* Setup hardware specific Rx handlers */
-	iwl_hw_rx_handler_setup(priv);
+	iwl3945_hw_rx_handler_setup(priv);
 }
 
 /**
- * iwl_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
+ * iwl3945_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
  * @rxb: Rx buffer to reclaim
  *
  * If an Rx buffer has an async callback associated with it the callback
  * will be executed.  The attached skb (if present) will only be freed
  * if the callback returns 1
  */
-static void iwl_tx_cmd_complete(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
+static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
+				struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl3945_rx_packet *pkt = (struct iwl3945_rx_packet *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
 	int huge = sequence & SEQ_HUGE_FRAME;
 	int cmd_index;
-	struct iwl_cmd *cmd;
+	struct iwl3945_cmd *cmd;
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
@@ -3837,7 +3838,7 @@ static void iwl_tx_cmd_complete(struct i
 		   !cmd->meta.u.callback(priv, cmd, rxb->skb))
 		rxb->skb = NULL;
 
-	iwl_tx_queue_reclaim(priv, txq_id, index);
+	iwl3945_tx_queue_reclaim(priv, txq_id, index);
 
 	if (!(cmd->meta.flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
@@ -3879,7 +3880,7 @@ static void iwl_tx_cmd_complete(struct i
  * + A list of pre-allocated SKBs is stored in iwl->rxq->rx_free.  When
  *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
  *   to replensish the iwl->rxq->rx_free.
- * + In iwl_rx_replenish (scheduled) if 'processed' != 'read' then the
+ * + In iwl3945_rx_replenish (scheduled) if 'processed' != 'read' then the
  *   iwl->rxq is replenished and the READ INDEX is updated (updating the
  *   'processed' and 'read' driver indexes as well)
  * + A received packet is processed and handed to the kernel network stack,
@@ -3892,28 +3893,28 @@ static void iwl_tx_cmd_complete(struct i
  *
  * Driver sequence:
  *
- * iwl_rx_queue_alloc()       Allocates rx_free
- * iwl_rx_replenish()         Replenishes rx_free list from rx_used, and calls
- *                            iwl_rx_queue_restock
- * iwl_rx_queue_restock()     Moves available buffers from rx_free into Rx
+ * iwl3945_rx_queue_alloc()       Allocates rx_free
+ * iwl3945_rx_replenish()         Replenishes rx_free list from rx_used, and calls
+ *                            iwl3945_rx_queue_restock
+ * iwl3945_rx_queue_restock()     Moves available buffers from rx_free into Rx
  *                            queue, updates firmware pointers, and updates
  *                            the WRITE index.  If insufficient rx_free buffers
- *                            are available, schedules iwl_rx_replenish
+ *                            are available, schedules iwl3945_rx_replenish
  *
  * -- enable interrupts --
- * ISR - iwl_rx()             Detach iwl_rx_mem_buffers from pool up to the
+ * ISR - iwl3945_rx()             Detach iwl3945_rx_mem_buffers from pool up to the
  *                            READ INDEX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
- *                            Calls iwl_rx_queue_restock to refill any empty
+ *                            Calls iwl3945_rx_queue_restock to refill any empty
  *                            slots.
  * ...
  *
  */
 
 /**
- * iwl_rx_queue_space - Return number of free slots available in queue.
+ * iwl3945_rx_queue_space - Return number of free slots available in queue.
  */
-static int iwl_rx_queue_space(const struct iwl_rx_queue *q)
+static int iwl3945_rx_queue_space(const struct iwl3945_rx_queue *q)
 {
 	int s = q->read - q->write;
 	if (s <= 0)
@@ -3926,7 +3927,7 @@ static int iwl_rx_queue_space(const stru
 }
 
 /**
- * iwl_rx_queue_update_write_ptr - Update the write pointer for the RX queue
+ * iwl3945_rx_queue_update_write_ptr - Update the write pointer for the RX queue
  *
  * NOTE: This function has 3945 and 4965 specific code sections
  * but is declared in base due to the majority of the
@@ -3934,7 +3935,7 @@ static int iwl_rx_queue_space(const stru
  * different)
  *
  */
-int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
+int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl3945_rx_queue *q)
 {
 	u32 reg = 0;
 	int rc = 0;
@@ -3946,23 +3947,23 @@ int iwl_rx_queue_update_write_ptr(struct
 		goto exit_unlock;
 
 	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
+		reg = iwl3945_read32(priv, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			iwl_set_bit(priv, CSR_GP_CNTRL,
+			iwl3945_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			goto exit_unlock;
 		}
 
-		rc = iwl_grab_restricted_access(priv);
+		rc = iwl3945_grab_restricted_access(priv);
 		if (rc)
 			goto exit_unlock;
 
-		iwl_write_restricted(priv, FH_RSCSR_CHNL0_WPTR,
+		iwl3945_write_restricted(priv, FH_RSCSR_CHNL0_WPTR,
 				     q->write & ~0x7);
-		iwl_release_restricted_access(priv);
+		iwl3945_release_restricted_access(priv);
 	} else
-		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
+		iwl3945_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
 
 
 	q->need_update = 0;
@@ -3973,18 +3974,18 @@ int iwl_rx_queue_update_write_ptr(struct
 }
 
 /**
- * iwl_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer pointer.
+ * iwl3945_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer pointer.
  *
  * NOTE: This function has 3945 and 4965 specific code paths in it.
  */
-static inline __le32 iwl_dma_addr2rbd_ptr(struct iwl_priv *priv,
+static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl3945_priv *priv,
 					  dma_addr_t dma_addr)
 {
 	return cpu_to_le32((u32)dma_addr);
 }
 
 /**
- * iwl_rx_queue_restock - refill RX queue from pre-allocated pool
+ * iwl3945_rx_queue_restock - refill RX queue from pre-allocated pool
  *
  * If there are slots in the RX queue that  need to be restocked,
  * and we have free pre-allocated buffers, fill the ranks as much
@@ -3994,21 +3995,21 @@ static inline __le32 iwl_dma_addr2rbd_pt
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
-static int iwl_rx_queue_restock(struct iwl_priv *priv)
+static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
 {
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl3945_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
-	struct iwl_rx_mem_buffer *rxb;
+	struct iwl3945_rx_mem_buffer *rxb;
 	unsigned long flags;
 	int write, rc;
 
 	spin_lock_irqsave(&rxq->lock, flags);
 	write = rxq->write & ~0x7;
-	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+	while ((iwl3945_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
 		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		rxb = list_entry(element, struct iwl3945_rx_mem_buffer, list);
 		list_del(element);
-		rxq->bd[rxq->write] = iwl_dma_addr2rbd_ptr(priv, rxb->dma_addr);
+		rxq->bd[rxq->write] = iwl3945_dma_addr2rbd_ptr(priv, rxb->dma_addr);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
@@ -4026,7 +4027,7 @@ static int iwl_rx_queue_restock(struct i
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
 		spin_unlock_irqrestore(&rxq->lock, flags);
-		rc = iwl_rx_queue_update_write_ptr(priv, rxq);
+		rc = iwl3945_rx_queue_update_write_ptr(priv, rxq);
 		if (rc)
 			return rc;
 	}
@@ -4035,24 +4036,24 @@ static int iwl_rx_queue_restock(struct i
 }
 
 /**
- * iwl_rx_replensih - Move all used packet from rx_used to rx_free
+ * iwl3945_rx_replensih - Move all used packet from rx_used to rx_free
  *
  * When moving to rx_free an SKB is allocated for the slot.
  *
- * Also restock the Rx queue via iwl_rx_queue_restock.
+ * Also restock the Rx queue via iwl3945_rx_queue_restock.
  * This is called as a scheduled work item (except for during intialization)
  */
-void iwl_rx_replenish(void *data)
+void iwl3945_rx_replenish(void *data)
 {
-	struct iwl_priv *priv = data;
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl3945_priv *priv = data;
+	struct iwl3945_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
-	struct iwl_rx_mem_buffer *rxb;
+	struct iwl3945_rx_mem_buffer *rxb;
 	unsigned long flags;
 	spin_lock_irqsave(&rxq->lock, flags);
 	while (!list_empty(&rxq->rx_used)) {
 		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		rxb = list_entry(element, struct iwl3945_rx_mem_buffer, list);
 		rxb->skb =
 		    alloc_skb(IWL_RX_BUF_SIZE, __GFP_NOWARN | GFP_ATOMIC);
 		if (!rxb->skb) {
@@ -4075,7 +4076,7 @@ void iwl_rx_replenish(void *data)
 	spin_unlock_irqrestore(&rxq->lock, flags);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl_rx_queue_restock(priv);
+	iwl3945_rx_queue_restock(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
@@ -4084,7 +4085,7 @@ void iwl_rx_replenish(void *data)
  * This free routine walks the list of POOL entries and if SKB is set to
  * non NULL it is unmapped and freed
  */
-static void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+static void iwl3945_rx_queue_free(struct iwl3945_priv *priv, struct iwl3945_rx_queue *rxq)
 {
 	int i;
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
@@ -4101,9 +4102,9 @@ static void iwl_rx_queue_free(struct iwl
 	rxq->bd = NULL;
 }
 
-int iwl_rx_queue_alloc(struct iwl_priv *priv)
+int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv)
 {
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl3945_rx_queue *rxq = &priv->rxq;
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
 
@@ -4124,7 +4125,7 @@ int iwl_rx_queue_alloc(struct iwl_priv *
 	return 0;
 }
 
-void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+void iwl3945_rx_queue_reset(struct iwl3945_priv *priv, struct iwl3945_rx_queue *rxq)
 {
 	unsigned long flags;
 	int i;
@@ -4171,7 +4172,7 @@ static u8 ratio2dB[100] = {
 /* Calculates a relative dB value from a ratio of linear
  *   (i.e. not dB) signal levels.
  * Conversion assumes that levels are voltages (20*log), not powers (10*log). */
-int iwl_calc_db_from_ratio(int sig_ratio)
+int iwl3945_calc_db_from_ratio(int sig_ratio)
 {
 	/* Anything above 1000:1 just report as 60 dB */
 	if (sig_ratio > 1000)
@@ -4197,7 +4198,7 @@ int iwl_calc_db_from_ratio(int sig_ratio
 /* Calculate an indication of rx signal quality (a percentage, not dBm!).
  * See http://www.ces.clemson.edu/linux/signal_quality.shtml for info
  *   about formulas used below. */
-int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm)
+int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm)
 {
 	int sig_qual;
 	int degradation = PERFECT_RSSI - rssi_dbm;
@@ -4232,22 +4233,22 @@ int iwl_calc_sig_qual(int rssi_dbm, int 
 }
 
 /**
- * iwl_rx_handle - Main entry function for receiving responses from the uCode
+ * iwl3945_rx_handle - Main entry function for receiving responses from the uCode
  *
  * Uses the priv->rx_handlers callback function array to invoke
  * the appropriate handlers, including command responses,
  * frame-received notifications, and other notifications.
  */
-static void iwl_rx_handle(struct iwl_priv *priv)
+static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 {
-	struct iwl_rx_mem_buffer *rxb;
-	struct iwl_rx_packet *pkt;
-	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct iwl3945_rx_mem_buffer *rxb;
+	struct iwl3945_rx_packet *pkt;
+	struct iwl3945_rx_queue *rxq = &priv->rxq;
 	u32 r, i;
 	int reclaim;
 	unsigned long flags;
 
-	r = iwl_hw_get_rx_read(priv);
+	r = iwl3945_hw_get_rx_read(priv);
 	i = rxq->read;
 
 	/* Rx interrupt, but nothing sent from uCode */
@@ -4267,7 +4268,7 @@ static void iwl_rx_handle(struct iwl_pri
 		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->dma_addr,
 					    IWL_RX_BUF_SIZE,
 					    PCI_DMA_FROMDEVICE);
-		pkt = (struct iwl_rx_packet *)rxb->skb->data;
+		pkt = (struct iwl3945_rx_packet *)rxb->skb->data;
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
@@ -4281,7 +4282,7 @@ static void iwl_rx_handle(struct iwl_pri
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
-		 *   rx_handlers table.  See iwl_setup_rx_handlers() */
+		 *   rx_handlers table.  See iwl3945_setup_rx_handlers() */
 		if (priv->rx_handlers[pkt->hdr.cmd]) {
 			IWL_DEBUG(IWL_DL_HOST_COMMAND | IWL_DL_RX | IWL_DL_ISR,
 				"r = %d, i = %d, %s, 0x%02x\n", r, i,
@@ -4297,10 +4298,10 @@ static void iwl_rx_handle(struct iwl_pri
 
 		if (reclaim) {
 			/* Invoke any callbacks, transfer the skb to caller,
-			 * and fire off the (possibly) blocking iwl_send_cmd()
+			 * and fire off the (possibly) blocking iwl3945_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb && rxb->skb)
-				iwl_tx_cmd_complete(priv, rxb);
+				iwl3945_tx_cmd_complete(priv, rxb);
 			else
 				IWL_WARNING("Claim null rxb?\n");
 		}
@@ -4324,11 +4325,11 @@ static void iwl_rx_handle(struct iwl_pri
 
 	/* Backtrack one entry */
 	priv->rxq.read = i;
-	iwl_rx_queue_restock(priv);
+	iwl3945_rx_queue_restock(priv);
 }
 
-static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl_tx_queue *txq)
+static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
+				  struct iwl3945_tx_queue *txq)
 {
 	u32 reg = 0;
 	int rc = 0;
@@ -4342,27 +4343,27 @@ static int iwl_tx_queue_update_write_ptr
 		/* wake up nic if it's powered down ...
 		 * uCode will wake up, and interrupt us again, so next
 		 * time we'll skip this part. */
-		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
+		reg = iwl3945_read32(priv, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 			IWL_DEBUG_INFO("Requesting wakeup, GP1 = 0x%x\n", reg);
-			iwl_set_bit(priv, CSR_GP_CNTRL,
+			iwl3945_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			return rc;
 		}
 
 		/* restore this queue's parameters in nic hardware. */
-		rc = iwl_grab_restricted_access(priv);
+		rc = iwl3945_grab_restricted_access(priv);
 		if (rc)
 			return rc;
-		iwl_write_restricted(priv, HBUS_TARG_WRPTR,
+		iwl3945_write_restricted(priv, HBUS_TARG_WRPTR,
 				     txq->q.first_empty | (txq_id << 8));
-		iwl_release_restricted_access(priv);
+		iwl3945_release_restricted_access(priv);
 
 	/* else not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx). */
 	} else
-		iwl_write32(priv, HBUS_TARG_WRPTR,
+		iwl3945_write32(priv, HBUS_TARG_WRPTR,
 			    txq->q.first_empty | (txq_id << 8));
 
 	txq->need_update = 0;
@@ -4371,12 +4372,12 @@ static int iwl_tx_queue_update_write_ptr
 }
 
 #ifdef CONFIG_IWL3945_DEBUG
-static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
+static void iwl3945_print_rx_config_cmd(struct iwl3945_rxon_cmd *rxon)
 {
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
-	iwl_print_hex_dump(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
+	iwl3945_print_hex_dump(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
 	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
 	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
 	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
@@ -4393,24 +4394,24 @@ static void iwl_print_rx_config_cmd(stru
 }
 #endif
 
-static void iwl_enable_interrupts(struct iwl_priv *priv)
+static void iwl3945_enable_interrupts(struct iwl3945_priv *priv)
 {
 	IWL_DEBUG_ISR("Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
-	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
+	iwl3945_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
 }
 
-static inline void iwl_disable_interrupts(struct iwl_priv *priv)
+static inline void iwl3945_disable_interrupts(struct iwl3945_priv *priv)
 {
 	clear_bit(STATUS_INT_ENABLED, &priv->status);
 
 	/* disable interrupts from uCode/NIC to host */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+	iwl3945_write32(priv, CSR_INT_MASK, 0x00000000);
 
 	/* acknowledge/clear/reset any interrupts still pending
 	 * from uCode or flow handler (Rx/Tx DMA) */
-	iwl_write32(priv, CSR_INT, 0xffffffff);
-	iwl_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
+	iwl3945_write32(priv, CSR_INT, 0xffffffff);
+	iwl3945_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
 	IWL_DEBUG_ISR("Disabled interrupts\n");
 }
 
@@ -4437,7 +4438,7 @@ static const char *desc_lookup(int i)
 #define ERROR_START_OFFSET  (1 * sizeof(u32))
 #define ERROR_ELEM_SIZE     (7 * sizeof(u32))
 
-static void iwl_dump_nic_error_log(struct iwl_priv *priv)
+static void iwl3945_dump_nic_error_log(struct iwl3945_priv *priv)
 {
 	u32 i;
 	u32 desc, time, count, base, data1;
@@ -4446,18 +4447,18 @@ static void iwl_dump_nic_error_log(struc
 
 	base = le32_to_cpu(priv->card_alive.error_event_table_ptr);
 
-	if (!iwl_hw_valid_rtc_data_addr(base)) {
+	if (!iwl3945_hw_valid_rtc_data_addr(base)) {
 		IWL_ERROR("Not valid error log pointer 0x%08X\n", base);
 		return;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
 
-	count = iwl_read_restricted_mem(priv, base);
+	count = iwl3945_read_restricted_mem(priv, base);
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
 		IWL_ERROR("Start IWL Error Log Dump:\n");
@@ -4470,19 +4471,19 @@ static void iwl_dump_nic_error_log(struc
 	for (i = ERROR_START_OFFSET;
 	     i < (count * ERROR_ELEM_SIZE) + ERROR_START_OFFSET;
 	     i += ERROR_ELEM_SIZE) {
-		desc = iwl_read_restricted_mem(priv, base + i);
+		desc = iwl3945_read_restricted_mem(priv, base + i);
 		time =
-		    iwl_read_restricted_mem(priv, base + i + 1 * sizeof(u32));
+		    iwl3945_read_restricted_mem(priv, base + i + 1 * sizeof(u32));
 		blink1 =
-		    iwl_read_restricted_mem(priv, base + i + 2 * sizeof(u32));
+		    iwl3945_read_restricted_mem(priv, base + i + 2 * sizeof(u32));
 		blink2 =
-		    iwl_read_restricted_mem(priv, base + i + 3 * sizeof(u32));
+		    iwl3945_read_restricted_mem(priv, base + i + 3 * sizeof(u32));
 		ilink1 =
-		    iwl_read_restricted_mem(priv, base + i + 4 * sizeof(u32));
+		    iwl3945_read_restricted_mem(priv, base + i + 4 * sizeof(u32));
 		ilink2 =
-		    iwl_read_restricted_mem(priv, base + i + 5 * sizeof(u32));
+		    iwl3945_read_restricted_mem(priv, base + i + 5 * sizeof(u32));
 		data1 =
-		    iwl_read_restricted_mem(priv, base + i + 6 * sizeof(u32));
+		    iwl3945_read_restricted_mem(priv, base + i + 6 * sizeof(u32));
 
 		IWL_ERROR
 		    ("%-13s (#%d) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
@@ -4490,18 +4491,18 @@ static void iwl_dump_nic_error_log(struc
 		     ilink1, ilink2, data1);
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 
 }
 
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
 
 /**
- * iwl_print_event_log - Dump error event log to syslog
+ * iwl3945_print_event_log - Dump error event log to syslog
  *
- * NOTE: Must be called with iwl_grab_restricted_access() already obtained!
+ * NOTE: Must be called with iwl3945_grab_restricted_access() already obtained!
  */
-static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
+static void iwl3945_print_event_log(struct iwl3945_priv *priv, u32 start_idx,
 				u32 num_events, u32 mode)
 {
 	u32 i;
@@ -4525,21 +4526,21 @@ static void iwl_print_event_log(struct i
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	 * place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read_restricted_mem(priv, ptr);
+		ev = iwl3945_read_restricted_mem(priv, ptr);
 		ptr += sizeof(u32);
-		time = iwl_read_restricted_mem(priv, ptr);
+		time = iwl3945_read_restricted_mem(priv, ptr);
 		ptr += sizeof(u32);
 		if (mode == 0)
 			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
 		else {
-			data = iwl_read_restricted_mem(priv, ptr);
+			data = iwl3945_read_restricted_mem(priv, ptr);
 			ptr += sizeof(u32);
 			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
 		}
 	}
 }
 
-static void iwl_dump_nic_event_log(struct iwl_priv *priv)
+static void iwl3945_dump_nic_event_log(struct iwl3945_priv *priv)
 {
 	int rc;
 	u32 base;       /* SRAM byte address of event log header */
@@ -4550,29 +4551,29 @@ static void iwl_dump_nic_event_log(struc
 	u32 size;       /* # entries that we'll print */
 
 	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
-	if (!iwl_hw_valid_rtc_data_addr(base)) {
+	if (!iwl3945_hw_valid_rtc_data_addr(base)) {
 		IWL_ERROR("Invalid event log pointer 0x%08X\n", base);
 		return;
 	}
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read from adapter at this time.\n");
 		return;
 	}
 
 	/* event log header */
-	capacity = iwl_read_restricted_mem(priv, base);
-	mode = iwl_read_restricted_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_restricted_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl_read_restricted_mem(priv, base + (3 * sizeof(u32)));
+	capacity = iwl3945_read_restricted_mem(priv, base);
+	mode = iwl3945_read_restricted_mem(priv, base + (1 * sizeof(u32)));
+	num_wraps = iwl3945_read_restricted_mem(priv, base + (2 * sizeof(u32)));
+	next_entry = iwl3945_read_restricted_mem(priv, base + (3 * sizeof(u32)));
 
 	size = num_wraps ? capacity : next_entry;
 
 	/* bail out if nothing in log */
 	if (size == 0) {
 		IWL_ERROR("Start IWL Event Log Dump: nothing in log\n");
-		iwl_release_restricted_access(priv);
+		iwl3945_release_restricted_access(priv);
 		return;
 	}
 
@@ -4582,31 +4583,31 @@ static void iwl_dump_nic_event_log(struc
 	/* if uCode has wrapped back to top of log, start at the oldest entry,
 	 * i.e the next one that uCode would fill. */
 	if (num_wraps)
-		iwl_print_event_log(priv, next_entry,
+		iwl3945_print_event_log(priv, next_entry,
 				    capacity - next_entry, mode);
 
 	/* (then/else) start at top of log */
-	iwl_print_event_log(priv, 0, next_entry, mode);
+	iwl3945_print_event_log(priv, 0, next_entry, mode);
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 }
 
 /**
- * iwl_irq_handle_error - called for HW or SW error interrupt from card
+ * iwl3945_irq_handle_error - called for HW or SW error interrupt from card
  */
-static void iwl_irq_handle_error(struct iwl_priv *priv)
+static void iwl3945_irq_handle_error(struct iwl3945_priv *priv)
 {
-	/* Set the FW error flag -- cleared on iwl_down */
+	/* Set the FW error flag -- cleared on iwl3945_down */
 	set_bit(STATUS_FW_ERROR, &priv->status);
 
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
-		iwl_dump_nic_error_log(priv);
-		iwl_dump_nic_event_log(priv);
-		iwl_print_rx_config_cmd(&priv->staging_rxon);
+	if (iwl3945_debug_level & IWL_DL_FW_ERRORS) {
+		iwl3945_dump_nic_error_log(priv);
+		iwl3945_dump_nic_event_log(priv);
+		iwl3945_print_rx_config_cmd(&priv->staging_rxon);
 	}
 #endif
 
@@ -4620,7 +4621,7 @@ static void iwl_irq_handle_error(struct 
 		IWL_DEBUG(IWL_DL_INFO | IWL_DL_FW_ERRORS,
 			  "Restarting adapter due to uCode error.\n");
 
-		if (iwl_is_associated(priv)) {
+		if (iwl3945_is_associated(priv)) {
 			memcpy(&priv->recovery_rxon, &priv->active_rxon,
 			       sizeof(priv->recovery_rxon));
 			priv->error_recovering = 1;
@@ -4629,16 +4630,16 @@ static void iwl_irq_handle_error(struct 
 	}
 }
 
-static void iwl_error_recovery(struct iwl_priv *priv)
+static void iwl3945_error_recovery(struct iwl3945_priv *priv)
 {
 	unsigned long flags;
 
 	memcpy(&priv->staging_rxon, &priv->recovery_rxon,
 	       sizeof(priv->staging_rxon));
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl_commit_rxon(priv);
+	iwl3945_commit_rxon(priv);
 
-	iwl_add_station(priv, priv->bssid, 1, 0);
+	iwl3945_add_station(priv, priv->bssid, 1, 0);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
@@ -4646,7 +4647,7 @@ static void iwl_error_recovery(struct iw
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static void iwl_irq_tasklet(struct iwl_priv *priv)
+static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 {
 	u32 inta, handled = 0;
 	u32 inta_fh;
@@ -4660,18 +4661,18 @@ static void iwl_irq_tasklet(struct iwl_p
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
 	 *  and will clear only when CSR_FH_INT_STATUS gets cleared. */
-	inta = iwl_read32(priv, CSR_INT);
-	iwl_write32(priv, CSR_INT, inta);
+	inta = iwl3945_read32(priv, CSR_INT);
+	iwl3945_write32(priv, CSR_INT, inta);
 
 	/* Ack/clear/reset pending flow-handler (DMA) interrupts.
 	 * Any new interrupts that happen after this, either while we're
 	 * in this tasklet, or later, will show up in next ISR/tasklet. */
-	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
-	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
+	inta_fh = iwl3945_read32(priv, CSR_FH_INT_STATUS);
+	iwl3945_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl_debug_level & IWL_DL_ISR) {
-		inta_mask = iwl_read32(priv, CSR_INT_MASK); /* just for debug */
+	if (iwl3945_debug_level & IWL_DL_ISR) {
+		inta_mask = iwl3945_read32(priv, CSR_INT_MASK); /* just for debug */
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
@@ -4691,9 +4692,9 @@ static void iwl_irq_tasklet(struct iwl_p
 		IWL_ERROR("Microcode HW error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
-		iwl_disable_interrupts(priv);
+		iwl3945_disable_interrupts(priv);
 
-		iwl_irq_handle_error(priv);
+		iwl3945_irq_handle_error(priv);
 
 		handled |= CSR_INT_BIT_HW_ERR;
 
@@ -4703,7 +4704,7 @@ static void iwl_irq_tasklet(struct iwl_p
 	}
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
+	if (iwl3945_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_MAC_CLK_ACTV)
 			IWL_DEBUG_ISR("Microcode started or stopped.\n");
@@ -4719,7 +4720,7 @@ static void iwl_irq_tasklet(struct iwl_p
 	/* HW RF KILL switch toggled (4965 only) */
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		int hw_rf_kill = 0;
-		if (!(iwl_read32(priv, CSR_GP_CNTRL) &
+		if (!(iwl3945_read32(priv, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
@@ -4730,7 +4731,7 @@ static void iwl_irq_tasklet(struct iwl_p
 		/* Queue restart only if RF_KILL switch was set to "kill"
 		 *   when we loaded driver, and is now set to "enable".
 		 * After we're Alive, RF_KILL gets handled by
-		 *   iwl_rx_card_state_notif() */
+		 *   iwl3945_rx_card_state_notif() */
 		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status))
 			queue_work(priv->workqueue, &priv->restart);
 
@@ -4747,20 +4748,20 @@ static void iwl_irq_tasklet(struct iwl_p
 	if (inta & CSR_INT_BIT_SW_ERR) {
 		IWL_ERROR("Microcode SW error detected.  Restarting 0x%X.\n",
 			  inta);
-		iwl_irq_handle_error(priv);
+		iwl3945_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
 
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
-		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
-		iwl_tx_queue_update_write_ptr(priv, &priv->txq[0]);
-		iwl_tx_queue_update_write_ptr(priv, &priv->txq[1]);
-		iwl_tx_queue_update_write_ptr(priv, &priv->txq[2]);
-		iwl_tx_queue_update_write_ptr(priv, &priv->txq[3]);
-		iwl_tx_queue_update_write_ptr(priv, &priv->txq[4]);
-		iwl_tx_queue_update_write_ptr(priv, &priv->txq[5]);
+		iwl3945_rx_queue_update_write_ptr(priv, &priv->rxq);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[0]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[1]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[2]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[3]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[4]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[5]);
 
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
@@ -4769,19 +4770,19 @@ static void iwl_irq_tasklet(struct iwl_p
 	 * Rx "responses" (frame-received notification), and other
 	 * notifications from uCode come through here*/
 	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
-		iwl_rx_handle(priv);
+		iwl3945_rx_handle(priv);
 		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
 	}
 
 	if (inta & CSR_INT_BIT_FH_TX) {
 		IWL_DEBUG_ISR("Tx interrupt\n");
 
-		iwl_write32(priv, CSR_FH_INT_STATUS, (1 << 6));
-		if (!iwl_grab_restricted_access(priv)) {
-			iwl_write_restricted(priv,
+		iwl3945_write32(priv, CSR_FH_INT_STATUS, (1 << 6));
+		if (!iwl3945_grab_restricted_access(priv)) {
+			iwl3945_write_restricted(priv,
 					     FH_TCSR_CREDIT
 					     (ALM_FH_SRVC_CHNL), 0x0);
-			iwl_release_restricted_access(priv);
+			iwl3945_release_restricted_access(priv);
 		}
 		handled |= CSR_INT_BIT_FH_TX;
 	}
@@ -4796,13 +4797,13 @@ static void iwl_irq_tasklet(struct iwl_p
 	}
 
 	/* Re-enable all interrupts */
-	iwl_enable_interrupts(priv);
+	iwl3945_enable_interrupts(priv);
 
 #ifdef CONFIG_IWL3945_DEBUG
-	if (iwl_debug_level & (IWL_DL_ISR)) {
-		inta = iwl_read32(priv, CSR_INT);
-		inta_mask = iwl_read32(priv, CSR_INT_MASK);
-		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
+	if (iwl3945_debug_level & (IWL_DL_ISR)) {
+		inta = iwl3945_read32(priv, CSR_INT);
+		inta_mask = iwl3945_read32(priv, CSR_INT_MASK);
+		inta_fh = iwl3945_read32(priv, CSR_FH_INT_STATUS);
 		IWL_DEBUG_ISR("End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
@@ -4810,9 +4811,9 @@ static void iwl_irq_tasklet(struct iwl_p
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static irqreturn_t iwl_isr(int irq, void *data)
+static irqreturn_t iwl3945_isr(int irq, void *data)
 {
-	struct iwl_priv *priv = data;
+	struct iwl3945_priv *priv = data;
 	u32 inta, inta_mask;
 	u32 inta_fh;
 	if (!priv)
@@ -4824,12 +4825,12 @@ static irqreturn_t iwl_isr(int irq, void
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+	inta_mask = iwl3945_read32(priv, CSR_INT_MASK);  /* just for debug */
+	iwl3945_write32(priv, CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(priv, CSR_INT);
-	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
+	inta = iwl3945_read32(priv, CSR_INT);
+	inta_fh = iwl3945_read32(priv, CSR_FH_INT_STATUS);
 
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
@@ -4848,7 +4849,7 @@ static irqreturn_t iwl_isr(int irq, void
 	IWL_DEBUG_ISR("ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 		      inta, inta_mask, inta_fh);
 
-	/* iwl_irq_tasklet() will service interrupts and re-enable them */
+	/* iwl3945_irq_tasklet() will service interrupts and re-enable them */
 	tasklet_schedule(&priv->irq_tasklet);
 	spin_unlock(&priv->lock);
 
@@ -4856,18 +4857,18 @@ static irqreturn_t iwl_isr(int irq, void
 
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
-	iwl_enable_interrupts(priv);
+	iwl3945_enable_interrupts(priv);
 	spin_unlock(&priv->lock);
 	return IRQ_NONE;
 }
 
 /************************** EEPROM BANDS ****************************
  *
- * The iwl_eeprom_band definitions below provide the mapping from the
+ * The iwl3945_eeprom_band definitions below provide the mapping from the
  * EEPROM contents to the specific channel number supported for each
  * band.
  *
- * For example, iwl_priv->eeprom.band_3_channels[4] from the band_3
+ * For example, iwl3945_priv->eeprom.band_3_channels[4] from the band_3
  * definition below maps to physical channel 42 in the 5.2GHz spectrum.
  * The specific geography and calibration information for that channel
  * is contained in the eeprom map itself.
@@ -4893,58 +4894,58 @@ static irqreturn_t iwl_isr(int irq, void
  *********************************************************************/
 
 /* 2.4 GHz */
-static const u8 iwl_eeprom_band_1[14] = {
+static const u8 iwl3945_eeprom_band_1[14] = {
 	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
 };
 
 /* 5.2 GHz bands */
-static const u8 iwl_eeprom_band_2[] = {
+static const u8 iwl3945_eeprom_band_2[] = {
 	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
 };
 
-static const u8 iwl_eeprom_band_3[] = {	/* 5205-5320MHz */
+static const u8 iwl3945_eeprom_band_3[] = {	/* 5205-5320MHz */
 	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
 };
 
-static const u8 iwl_eeprom_band_4[] = {	/* 5500-5700MHz */
+static const u8 iwl3945_eeprom_band_4[] = {	/* 5500-5700MHz */
 	100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
 };
 
-static const u8 iwl_eeprom_band_5[] = {	/* 5725-5825MHz */
+static const u8 iwl3945_eeprom_band_5[] = {	/* 5725-5825MHz */
 	145, 149, 153, 157, 161, 165
 };
 
-static void iwl_init_band_reference(const struct iwl_priv *priv, int band,
+static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int band,
 				    int *eeprom_ch_count,
-				    const struct iwl_eeprom_channel
+				    const struct iwl3945_eeprom_channel
 				    **eeprom_ch_info,
 				    const u8 **eeprom_ch_index)
 {
 	switch (band) {
 	case 1:		/* 2.4GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_1);
+		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_1);
 		*eeprom_ch_info = priv->eeprom.band_1_channels;
-		*eeprom_ch_index = iwl_eeprom_band_1;
+		*eeprom_ch_index = iwl3945_eeprom_band_1;
 		break;
 	case 2:		/* 5.2GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_2);
+		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_2);
 		*eeprom_ch_info = priv->eeprom.band_2_channels;
-		*eeprom_ch_index = iwl_eeprom_band_2;
+		*eeprom_ch_index = iwl3945_eeprom_band_2;
 		break;
 	case 3:		/* 5.2GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_3);
+		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_3);
 		*eeprom_ch_info = priv->eeprom.band_3_channels;
-		*eeprom_ch_index = iwl_eeprom_band_3;
+		*eeprom_ch_index = iwl3945_eeprom_band_3;
 		break;
 	case 4:		/* 5.2GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_4);
+		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_4);
 		*eeprom_ch_info = priv->eeprom.band_4_channels;
-		*eeprom_ch_index = iwl_eeprom_band_4;
+		*eeprom_ch_index = iwl3945_eeprom_band_4;
 		break;
 	case 5:		/* 5.2GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_5);
+		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_5);
 		*eeprom_ch_info = priv->eeprom.band_5_channels;
-		*eeprom_ch_index = iwl_eeprom_band_5;
+		*eeprom_ch_index = iwl3945_eeprom_band_5;
 		break;
 	default:
 		BUG();
@@ -4952,7 +4953,7 @@ static void iwl_init_band_reference(cons
 	}
 }
 
-const struct iwl_channel_info *iwl_get_channel_info(const struct iwl_priv *priv,
+const struct iwl3945_channel_info *iwl3945_get_channel_info(const struct iwl3945_priv *priv,
 						    int phymode, u16 channel)
 {
 	int i;
@@ -4979,13 +4980,13 @@ const struct iwl_channel_info *iwl_get_c
 #define CHECK_AND_PRINT(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
 			    ? # x " " : "")
 
-static int iwl_init_channel_map(struct iwl_priv *priv)
+static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 {
 	int eeprom_ch_count = 0;
 	const u8 *eeprom_ch_index = NULL;
-	const struct iwl_eeprom_channel *eeprom_ch_info = NULL;
+	const struct iwl3945_eeprom_channel *eeprom_ch_info = NULL;
 	int band, ch;
-	struct iwl_channel_info *ch_info;
+	struct iwl3945_channel_info *ch_info;
 
 	if (priv->channel_count) {
 		IWL_DEBUG_INFO("Channel map already initialized.\n");
@@ -5001,15 +5002,15 @@ static int iwl_init_channel_map(struct i
 	IWL_DEBUG_INFO("Initializing regulatory info from EEPROM\n");
 
 	priv->channel_count =
-	    ARRAY_SIZE(iwl_eeprom_band_1) +
-	    ARRAY_SIZE(iwl_eeprom_band_2) +
-	    ARRAY_SIZE(iwl_eeprom_band_3) +
-	    ARRAY_SIZE(iwl_eeprom_band_4) +
-	    ARRAY_SIZE(iwl_eeprom_band_5);
+	    ARRAY_SIZE(iwl3945_eeprom_band_1) +
+	    ARRAY_SIZE(iwl3945_eeprom_band_2) +
+	    ARRAY_SIZE(iwl3945_eeprom_band_3) +
+	    ARRAY_SIZE(iwl3945_eeprom_band_4) +
+	    ARRAY_SIZE(iwl3945_eeprom_band_5);
 
 	IWL_DEBUG_INFO("Parsing data for %d channels.\n", priv->channel_count);
 
-	priv->channel_info = kzalloc(sizeof(struct iwl_channel_info) *
+	priv->channel_info = kzalloc(sizeof(struct iwl3945_channel_info) *
 				     priv->channel_count, GFP_KERNEL);
 	if (!priv->channel_info) {
 		IWL_ERROR("Could not allocate channel_info\n");
@@ -5024,7 +5025,7 @@ static int iwl_init_channel_map(struct i
 	 * what just in the EEPROM) */
 	for (band = 1; band <= 5; band++) {
 
-		iwl_init_band_reference(priv, band, &eeprom_ch_count,
+		iwl3945_init_band_reference(priv, band, &eeprom_ch_count,
 					&eeprom_ch_info, &eeprom_ch_index);
 
 		/* Loop through each band adding each of the channels */
@@ -5117,7 +5118,7 @@ static int iwl_init_channel_map(struct i
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
-static inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv, int phymode)
+static inline u16 iwl3945_get_active_dwell_time(struct iwl3945_priv *priv, int phymode)
 {
 	if (phymode == MODE_IEEE80211A)
 		return IWL_ACTIVE_DWELL_TIME_52;
@@ -5125,14 +5126,14 @@ static inline u16 iwl_get_active_dwell_t
 		return IWL_ACTIVE_DWELL_TIME_24;
 }
 
-static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv, int phymode)
+static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv, int phymode)
 {
-	u16 active = iwl_get_active_dwell_time(priv, phymode);
+	u16 active = iwl3945_get_active_dwell_time(priv, phymode);
 	u16 passive = (phymode != MODE_IEEE80211A) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
-	if (iwl_is_associated(priv)) {
+	if (iwl3945_is_associated(priv)) {
 		/* If we're associated, we clamp the maximum passive
 		 * dwell time to be 98% of the beacon interval (minus
 		 * 2 * channel tune time) */
@@ -5148,30 +5149,30 @@ static u16 iwl_get_passive_dwell_time(st
 	return passive;
 }
 
-static int iwl_get_channels_for_scan(struct iwl_priv *priv, int phymode,
+static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv, int phymode,
 				     u8 is_active, u8 direct_mask,
-				     struct iwl_scan_channel *scan_ch)
+				     struct iwl3945_scan_channel *scan_ch)
 {
 	const struct ieee80211_channel *channels = NULL;
 	const struct ieee80211_hw_mode *hw_mode;
-	const struct iwl_channel_info *ch_info;
+	const struct iwl3945_channel_info *ch_info;
 	u16 passive_dwell = 0;
 	u16 active_dwell = 0;
 	int added, i;
 
-	hw_mode = iwl_get_hw_mode(priv, phymode);
+	hw_mode = iwl3945_get_hw_mode(priv, phymode);
 	if (!hw_mode)
 		return 0;
 
 	channels = hw_mode->channels;
 
-	active_dwell = iwl_get_active_dwell_time(priv, phymode);
-	passive_dwell = iwl_get_passive_dwell_time(priv, phymode);
+	active_dwell = iwl3945_get_active_dwell_time(priv, phymode);
+	passive_dwell = iwl3945_get_passive_dwell_time(priv, phymode);
 
 	for (i = 0, added = 0; i < hw_mode->num_channels; i++) {
 		if (channels[i].chan ==
 		    le16_to_cpu(priv->active_rxon.channel)) {
-			if (iwl_is_associated(priv)) {
+			if (iwl3945_is_associated(priv)) {
 				IWL_DEBUG_SCAN
 				    ("Skipping current channel %d\n",
 				     le16_to_cpu(priv->active_rxon.channel));
@@ -5182,7 +5183,7 @@ static int iwl_get_channels_for_scan(str
 
 		scan_ch->channel = channels[i].chan;
 
-		ch_info = iwl_get_channel_info(priv, phymode, scan_ch->channel);
+		ch_info = iwl3945_get_channel_info(priv, phymode, scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
 				       scan_ch->channel);
@@ -5233,7 +5234,7 @@ static int iwl_get_channels_for_scan(str
 	return added;
 }
 
-static void iwl_reset_channel_flag(struct iwl_priv *priv)
+static void iwl3945_reset_channel_flag(struct iwl3945_priv *priv)
 {
 	int i, j;
 	for (i = 0; i < 3; i++) {
@@ -5243,13 +5244,13 @@ static void iwl_reset_channel_flag(struc
 	}
 }
 
-static void iwl_init_hw_rates(struct iwl_priv *priv,
+static void iwl3945_init_hw_rates(struct iwl3945_priv *priv,
 			      struct ieee80211_rate *rates)
 {
 	int i;
 
 	for (i = 0; i < IWL_RATE_COUNT; i++) {
-		rates[i].rate = iwl_rates[i].ieee * 5;
+		rates[i].rate = iwl3945_rates[i].ieee * 5;
 		rates[i].val = i; /* Rate scaling will work on indexes */
 		rates[i].val2 = i;
 		rates[i].flags = IEEE80211_RATE_SUPPORTED;
@@ -5261,7 +5262,7 @@ static void iwl_init_hw_rates(struct iwl
 			 * If CCK 1M then set rate flag to CCK else CCK_2
 			 * which is CCK | PREAMBLE2
 			 */
-			rates[i].flags |= (iwl_rates[i].plcp == 10) ?
+			rates[i].flags |= (iwl3945_rates[i].plcp == 10) ?
 				IEEE80211_RATE_CCK : IEEE80211_RATE_CCK_2;
 		}
 
@@ -5272,11 +5273,11 @@ static void iwl_init_hw_rates(struct iwl
 }
 
 /**
- * iwl_init_geos - Initialize mac80211's geo/channel info based from eeprom
+ * iwl3945_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
-static int iwl_init_geos(struct iwl_priv *priv)
+static int iwl3945_init_geos(struct iwl3945_priv *priv)
 {
-	struct iwl_channel_info *ch;
+	struct iwl3945_channel_info *ch;
 	struct ieee80211_hw_mode *modes;
 	struct ieee80211_channel *channels;
 	struct ieee80211_channel *geo_ch;
@@ -5322,7 +5323,7 @@ static int iwl_init_geos(struct iwl_priv
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
 	modes[A].mode = MODE_IEEE80211A;
-	modes[A].channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
+	modes[A].channels = &channels[ARRAY_SIZE(iwl3945_eeprom_band_1)];
 	modes[A].rates = rates;
 	modes[A].num_rates = 8;	/* just OFDM */
 	modes[A].num_channels = 0;
@@ -5342,7 +5343,7 @@ static int iwl_init_geos(struct iwl_priv
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
 
-	iwl_init_hw_rates(priv, rates);
+	iwl3945_init_hw_rates(priv, rates);
 
 	for (i = 0, geo_ch = channels; i < priv->channel_count; i++) {
 		ch = &priv->channel_info[i];
@@ -5425,7 +5426,7 @@ static int iwl_init_geos(struct iwl_priv
  *
  ******************************************************************************/
 
-static void iwl_dealloc_ucode_pci(struct iwl_priv *priv)
+static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
 {
 	if (priv->ucode_code.v_addr != NULL) {
 		pci_free_consistent(priv->pci_dev,
@@ -5472,10 +5473,10 @@ static void iwl_dealloc_ucode_pci(struct
 }
 
 /**
- * iwl_verify_inst_full - verify runtime uCode image in card vs. host,
+ * iwl3945_verify_inst_full - verify runtime uCode image in card vs. host,
  *     looking at all data.
  */
-static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 * image, u32 len)
+static int iwl3945_verify_inst_full(struct iwl3945_priv *priv, __le32 * image, u32 len)
 {
 	u32 val;
 	u32 save_len = len;
@@ -5484,18 +5485,18 @@ static int iwl_verify_inst_full(struct i
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc)
 		return rc;
 
-	iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
+	iwl3945_write_restricted(priv, HBUS_TARG_MEM_RADDR, RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
 	for (; len > 0; len -= sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		val = _iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl3945_read_restricted(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("uCode INST section is invalid at "
 				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
@@ -5507,7 +5508,7 @@ static int iwl_verify_inst_full(struct i
 		}
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 
 	if (!errcnt)
 		IWL_DEBUG_INFO
@@ -5518,11 +5519,11 @@ static int iwl_verify_inst_full(struct i
 
 
 /**
- * iwl_verify_inst_sparse - verify runtime uCode image in card vs. host,
+ * iwl3945_verify_inst_sparse - verify runtime uCode image in card vs. host,
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
+static int iwl3945_verify_inst_sparse(struct iwl3945_priv *priv, __le32 *image, u32 len)
 {
 	u32 val;
 	int rc = 0;
@@ -5531,7 +5532,7 @@ static int iwl_verify_inst_sparse(struct
 
 	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc)
 		return rc;
 
@@ -5539,9 +5540,9 @@ static int iwl_verify_inst_sparse(struct
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR,
+		iwl3945_write_restricted(priv, HBUS_TARG_MEM_RADDR,
 			i + RTC_INST_LOWER_BOUND);
-		val = _iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+		val = _iwl3945_read_restricted(priv, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
 			IWL_ERROR("uCode INST section is invalid at "
@@ -5555,17 +5556,17 @@ static int iwl_verify_inst_sparse(struct
 		}
 	}
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 
 	return rc;
 }
 
 
 /**
- * iwl_verify_ucode - determine which instruction image is in SRAM,
+ * iwl3945_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-static int iwl_verify_ucode(struct iwl_priv *priv)
+static int iwl3945_verify_ucode(struct iwl3945_priv *priv)
 {
 	__le32 *image;
 	u32 len;
@@ -5574,7 +5575,7 @@ static int iwl_verify_ucode(struct iwl_p
 	/* Try bootstrap */
 	image = (__le32 *)priv->ucode_boot.v_addr;
 	len = priv->ucode_boot.len;
-	rc = iwl_verify_inst_sparse(priv, image, len);
+	rc = iwl3945_verify_inst_sparse(priv, image, len);
 	if (rc == 0) {
 		IWL_DEBUG_INFO("Bootstrap uCode is good in inst SRAM\n");
 		return 0;
@@ -5583,7 +5584,7 @@ static int iwl_verify_ucode(struct iwl_p
 	/* Try initialize */
 	image = (__le32 *)priv->ucode_init.v_addr;
 	len = priv->ucode_init.len;
-	rc = iwl_verify_inst_sparse(priv, image, len);
+	rc = iwl3945_verify_inst_sparse(priv, image, len);
 	if (rc == 0) {
 		IWL_DEBUG_INFO("Initialize uCode is good in inst SRAM\n");
 		return 0;
@@ -5592,7 +5593,7 @@ static int iwl_verify_ucode(struct iwl_p
 	/* Try runtime/protocol */
 	image = (__le32 *)priv->ucode_code.v_addr;
 	len = priv->ucode_code.len;
-	rc = iwl_verify_inst_sparse(priv, image, len);
+	rc = iwl3945_verify_inst_sparse(priv, image, len);
 	if (rc == 0) {
 		IWL_DEBUG_INFO("Runtime uCode is good in inst SRAM\n");
 		return 0;
@@ -5604,14 +5605,14 @@ static int iwl_verify_ucode(struct iwl_p
 	 * Selection of bootstrap image is arbitrary. */
 	image = (__le32 *)priv->ucode_boot.v_addr;
 	len = priv->ucode_boot.len;
-	rc = iwl_verify_inst_full(priv, image, len);
+	rc = iwl3945_verify_inst_full(priv, image, len);
 
 	return rc;
 }
 
 
 /* check contents of special bootstrap uCode SRAM */
-static int iwl_verify_bsm(struct iwl_priv *priv)
+static int iwl3945_verify_bsm(struct iwl3945_priv *priv)
 {
 	__le32 *image = priv->ucode_boot.v_addr;
 	u32 len = priv->ucode_boot.len;
@@ -5621,11 +5622,11 @@ static int iwl_verify_bsm(struct iwl_pri
 	IWL_DEBUG_INFO("Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
-	val = iwl_read_restricted_reg(priv, BSM_WR_DWCOUNT_REG);
+	val = iwl3945_read_restricted_reg(priv, BSM_WR_DWCOUNT_REG);
 	for (reg = BSM_SRAM_LOWER_BOUND;
 	     reg < BSM_SRAM_LOWER_BOUND + len;
 	     reg += sizeof(u32), image ++) {
-		val = iwl_read_restricted_reg(priv, reg);
+		val = iwl3945_read_restricted_reg(priv, reg);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERROR("BSM uCode verification failed at "
 				  "addr 0x%08X+%u (of %u), is 0x%x, s/b 0x%x\n",
@@ -5642,7 +5643,7 @@ static int iwl_verify_bsm(struct iwl_pri
 }
 
 /**
- * iwl_load_bsm - Load bootstrap instructions
+ * iwl3945_load_bsm - Load bootstrap instructions
  *
  * BSM operation:
  *
@@ -5673,7 +5674,7 @@ static int iwl_verify_bsm(struct iwl_pri
  * the runtime uCode instructions and the backup data cache into SRAM,
  * and re-launches the runtime uCode from where it left off.
  */
-static int iwl_load_bsm(struct iwl_priv *priv)
+static int iwl3945_load_bsm(struct iwl3945_priv *priv)
 {
 	__le32 *image = priv->ucode_boot.v_addr;
 	u32 len = priv->ucode_boot.len;
@@ -5694,7 +5695,7 @@ static int iwl_load_bsm(struct iwl_priv 
 
 	/* Tell bootstrap uCode where to find the "Initialize" uCode
 	 *   in host DRAM ... bits 31:0 for 3945, bits 35:4 for 4965.
-	 * NOTE:  iwl_initialize_alive_start() will replace these values,
+	 * NOTE:  iwl3945_initialize_alive_start() will replace these values,
 	 *        after the "initialize" uCode has run, to point to
 	 *        runtime/protocol instructions and backup data cache. */
 	pinst = priv->ucode_init.p_addr;
@@ -5702,42 +5703,42 @@ static int iwl_load_bsm(struct iwl_priv 
 	inst_len = priv->ucode_init.len;
 	data_len = priv->ucode_init_data.len;
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc)
 		return rc;
 
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
+	iwl3945_write_restricted_reg(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl3945_write_restricted_reg(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl3945_write_restricted_reg(priv, BSM_DRAM_INST_BYTECOUNT_REG, inst_len);
+	iwl3945_write_restricted_reg(priv, BSM_DRAM_DATA_BYTECOUNT_REG, data_len);
 
 	/* Fill BSM memory with bootstrap instructions */
 	for (reg_offset = BSM_SRAM_LOWER_BOUND;
 	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
 	     reg_offset += sizeof(u32), image++)
-		_iwl_write_restricted_reg(priv, reg_offset,
+		_iwl3945_write_restricted_reg(priv, reg_offset,
 					  le32_to_cpu(*image));
 
-	rc = iwl_verify_bsm(priv);
+	rc = iwl3945_verify_bsm(priv);
 	if (rc) {
-		iwl_release_restricted_access(priv);
+		iwl3945_release_restricted_access(priv);
 		return rc;
 	}
 
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
-	iwl_write_restricted_reg(priv, BSM_WR_MEM_SRC_REG, 0x0);
-	iwl_write_restricted_reg(priv, BSM_WR_MEM_DST_REG,
+	iwl3945_write_restricted_reg(priv, BSM_WR_MEM_SRC_REG, 0x0);
+	iwl3945_write_restricted_reg(priv, BSM_WR_MEM_DST_REG,
 				 RTC_INST_LOWER_BOUND);
-	iwl_write_restricted_reg(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
+	iwl3945_write_restricted_reg(priv, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
 	 *   to prepare to load "initialize" uCode */
-	iwl_write_restricted_reg(priv, BSM_WR_CTRL_REG,
+	iwl3945_write_restricted_reg(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START);
 
 	/* Wait for load of bootstrap uCode to finish */
 	for (i = 0; i < 100; i++) {
-		done = iwl_read_restricted_reg(priv, BSM_WR_CTRL_REG);
+		done = iwl3945_read_restricted_reg(priv, BSM_WR_CTRL_REG);
 		if (!(done & BSM_WR_CTRL_REG_BIT_START))
 			break;
 		udelay(10);
@@ -5751,28 +5752,28 @@ static int iwl_load_bsm(struct iwl_priv 
 
 	/* Enable future boot loads whenever power management unit triggers it
 	 *   (e.g. when powering back up after power-save shutdown) */
-	iwl_write_restricted_reg(priv, BSM_WR_CTRL_REG,
+	iwl3945_write_restricted_reg(priv, BSM_WR_CTRL_REG,
 		BSM_WR_CTRL_REG_BIT_START_EN);
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 
 	return 0;
 }
 
-static void iwl_nic_start(struct iwl_priv *priv)
+static void iwl3945_nic_start(struct iwl3945_priv *priv)
 {
 	/* Remove all resets to allow NIC to operate */
-	iwl_write32(priv, CSR_RESET, 0);
+	iwl3945_write32(priv, CSR_RESET, 0);
 }
 
 /**
- * iwl_read_ucode - Read uCode images from disk file.
+ * iwl3945_read_ucode - Read uCode images from disk file.
  *
  * Copy into buffers for card to fetch via bus-mastering
  */
-static int iwl_read_ucode(struct iwl_priv *priv)
+static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 {
-	struct iwl_ucode *ucode;
+	struct iwl3945_ucode *ucode;
 	int rc = 0;
 	const struct firmware *ucode_raw;
 	/* firmware file name contains uCode/driver compatibility version */
@@ -5929,7 +5930,7 @@ static int iwl_read_ucode(struct iwl_pri
 		priv->ucode_code.v_addr, (u32)priv->ucode_code.p_addr);
 
 	/* Runtime data (2nd block)
-	 * NOTE:  Copy into backup buffer will be done in iwl_up()  */
+	 * NOTE:  Copy into backup buffer will be done in iwl3945_up()  */
 	src = &ucode->data[inst_size];
 	len = priv->ucode_data.len;
 	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %d\n",
@@ -5969,7 +5970,7 @@ static int iwl_read_ucode(struct iwl_pri
  err_pci_alloc:
 	IWL_ERROR("failed to allocate pci memory\n");
 	rc = -ENOMEM;
-	iwl_dealloc_ucode_pci(priv);
+	iwl3945_dealloc_ucode_pci(priv);
 
  err_release:
 	release_firmware(ucode_raw);
@@ -5980,7 +5981,7 @@ static int iwl_read_ucode(struct iwl_pri
 
 
 /**
- * iwl_set_ucode_ptrs - Set uCode address location
+ * iwl3945_set_ucode_ptrs - Set uCode address location
  *
  * Tell initialization uCode where to find runtime uCode.
  *
@@ -5988,7 +5989,7 @@ static int iwl_read_ucode(struct iwl_pri
  * We need to replace them to load runtime uCode inst and data,
  * and to save runtime data when powering down.
  */
-static int iwl_set_ucode_ptrs(struct iwl_priv *priv)
+static int iwl3945_set_ucode_ptrs(struct iwl3945_priv *priv)
 {
 	dma_addr_t pinst;
 	dma_addr_t pdata;
@@ -6000,24 +6001,24 @@ static int iwl_set_ucode_ptrs(struct iwl
 	pdata = priv->ucode_data_backup.p_addr;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
 
 	/* Tell bootstrap uCode where to find image to load */
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_PTR_REG, pinst);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_PTR_REG, pdata);
-	iwl_write_restricted_reg(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
+	iwl3945_write_restricted_reg(priv, BSM_DRAM_INST_PTR_REG, pinst);
+	iwl3945_write_restricted_reg(priv, BSM_DRAM_DATA_PTR_REG, pdata);
+	iwl3945_write_restricted_reg(priv, BSM_DRAM_DATA_BYTECOUNT_REG,
 				 priv->ucode_data.len);
 
 	/* Inst bytecount must be last to set up, bit 31 signals uCode
 	 *   that all new ptr/size info is in place */
-	iwl_write_restricted_reg(priv, BSM_DRAM_INST_BYTECOUNT_REG,
+	iwl3945_write_restricted_reg(priv, BSM_DRAM_INST_BYTECOUNT_REG,
 				 priv->ucode_code.len | BSM_DRAM_INST_LOAD);
 
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -6027,7 +6028,7 @@ static int iwl_set_ucode_ptrs(struct iwl
 }
 
 /**
- * iwl_init_alive_start - Called after REPLY_ALIVE notification receieved
+ * iwl3945_init_alive_start - Called after REPLY_ALIVE notification receieved
  *
  * Called after REPLY_ALIVE notification received from "initialize" uCode.
  *
@@ -6037,7 +6038,7 @@ static int iwl_set_ucode_ptrs(struct iwl
  *
  * Tell "initialize" uCode to go ahead and load the runtime uCode.
 */
-static void iwl_init_alive_start(struct iwl_priv *priv)
+static void iwl3945_init_alive_start(struct iwl3945_priv *priv)
 {
 	/* Check alive response for "valid" sign from uCode */
 	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
@@ -6050,7 +6051,7 @@ static void iwl_init_alive_start(struct 
 	/* Bootstrap uCode has loaded initialize uCode ... verify inst image.
 	 * This is a paranoid check, because we would not have gotten the
 	 * "initialize" alive if code weren't properly loaded.  */
-	if (iwl_verify_ucode(priv)) {
+	if (iwl3945_verify_ucode(priv)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
 		IWL_DEBUG_INFO("Bad \"initialize\" uCode load.\n");
@@ -6061,7 +6062,7 @@ static void iwl_init_alive_start(struct 
 	 * load and launch runtime uCode, which will send us another "Alive"
 	 * notification. */
 	IWL_DEBUG_INFO("Initialization Alive received.\n");
-	if (iwl_set_ucode_ptrs(priv)) {
+	if (iwl3945_set_ucode_ptrs(priv)) {
 		/* Runtime instruction load won't happen;
 		 * take it all the way back down so we can try again */
 		IWL_DEBUG_INFO("Couldn't set up uCode pointers.\n");
@@ -6075,11 +6076,11 @@ static void iwl_init_alive_start(struct 
 
 
 /**
- * iwl_alive_start - called after REPLY_ALIVE notification received
+ * iwl3945_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
- *                   Alive gets handled by iwl_init_alive_start()).
+ *                   Alive gets handled by iwl3945_init_alive_start()).
  */
-static void iwl_alive_start(struct iwl_priv *priv)
+static void iwl3945_alive_start(struct iwl3945_priv *priv)
 {
 	int rc = 0;
 	int thermal_spin = 0;
@@ -6097,30 +6098,30 @@ static void iwl_alive_start(struct iwl_p
 	/* Initialize uCode has loaded Runtime uCode ... verify inst image.
 	 * This is a paranoid check, because we would not have gotten the
 	 * "runtime" alive if code weren't properly loaded.  */
-	if (iwl_verify_ucode(priv)) {
+	if (iwl3945_verify_ucode(priv)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
 		IWL_DEBUG_INFO("Bad runtime uCode load.\n");
 		goto restart;
 	}
 
-	iwl_clear_stations_table(priv);
+	iwl3945_clear_stations_table(priv);
 
-	rc = iwl_grab_restricted_access(priv);
+	rc = iwl3945_grab_restricted_access(priv);
 	if (rc) {
 		IWL_WARNING("Can not read rfkill status from adapter\n");
 		return;
 	}
 
-	rfkill = iwl_read_restricted_reg(priv, APMG_RFKILL_REG);
+	rfkill = iwl3945_read_restricted_reg(priv, APMG_RFKILL_REG);
 	IWL_DEBUG_INFO("RFKILL status: 0x%x\n", rfkill);
-	iwl_release_restricted_access(priv);
+	iwl3945_release_restricted_access(priv);
 
 	if (rfkill & 0x1) {
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 		/* if rfkill is not on, then wait for thermal
 		 * sensor in adapter to kick in */
-		while (iwl_hw_get_temperature(priv) == 0) {
+		while (iwl3945_hw_get_temperature(priv) == 0) {
 			thermal_spin++;
 			udelay(10);
 		}
@@ -6137,22 +6138,22 @@ static void iwl_alive_start(struct iwl_p
 	/* Clear out the uCode error bit if it is set */
 	clear_bit(STATUS_FW_ERROR, &priv->status);
 
-	rc = iwl_init_channel_map(priv);
+	rc = iwl3945_init_channel_map(priv);
 	if (rc) {
 		IWL_ERROR("initializing regulatory failed: %d\n", rc);
 		return;
 	}
 
-	iwl_init_geos(priv);
+	iwl3945_init_geos(priv);
 
-	if (iwl_is_rfkill(priv))
+	if (iwl3945_is_rfkill(priv))
 		return;
 
 	if (!priv->mac80211_registered) {
 		/* Unlock so any user space entry points can call back into
 		 * the driver without a deadlock... */
 		mutex_unlock(&priv->mutex);
-		iwl_rate_control_register(priv->hw);
+		iwl3945_rate_control_register(priv->hw);
 		rc = ieee80211_register_hw(priv->hw);
 		priv->hw->conf.beacon_int = 100;
 		mutex_lock(&priv->mutex);
@@ -6165,33 +6166,33 @@ static void iwl_alive_start(struct iwl_p
 
 		priv->mac80211_registered = 1;
 
-		iwl_reset_channel_flag(priv);
+		iwl3945_reset_channel_flag(priv);
 	} else
 		ieee80211_start_queues(priv->hw);
 
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
-	iwl_send_power_mode(priv, IWL_POWER_LEVEL(priv->power_mode));
+	iwl3945_send_power_mode(priv, IWL_POWER_LEVEL(priv->power_mode));
 
-	if (iwl_is_associated(priv)) {
-		struct iwl_rxon_cmd *active_rxon =
-				(struct iwl_rxon_cmd *)(&priv->active_rxon);
+	if (iwl3945_is_associated(priv)) {
+		struct iwl3945_rxon_cmd *active_rxon =
+				(struct iwl3945_rxon_cmd *)(&priv->active_rxon);
 
 		memcpy(&priv->staging_rxon, &priv->active_rxon,
 		       sizeof(priv->staging_rxon));
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		iwl_connection_init_rx_config(priv);
+		iwl3945_connection_init_rx_config(priv);
 		memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	}
 
 	/* Configure BT coexistence */
-	iwl_send_bt_config(priv);
+	iwl3945_send_bt_config(priv);
 
 	/* Configure the adapter for unassociated operation */
-	iwl_commit_rxon(priv);
+	iwl3945_commit_rxon(priv);
 
 	/* At this point, the NIC is initialized and operational */
 	priv->notif_missed_beacons = 0;
@@ -6202,7 +6203,7 @@ static void iwl_alive_start(struct iwl_p
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
 
 	if (priv->error_recovering)
-		iwl_error_recovery(priv);
+		iwl3945_error_recovery(priv);
 
 	return;
 
@@ -6210,9 +6211,9 @@ static void iwl_alive_start(struct iwl_p
 	queue_work(priv->workqueue, &priv->restart);
 }
 
-static void iwl_cancel_deferred_work(struct iwl_priv *priv);
+static void iwl3945_cancel_deferred_work(struct iwl3945_priv *priv);
 
-static void __iwl_down(struct iwl_priv *priv)
+static void __iwl3945_down(struct iwl3945_priv *priv)
 {
 	unsigned long flags;
 	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
@@ -6225,12 +6226,12 @@ static void __iwl_down(struct iwl_priv *
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	iwl_clear_stations_table(priv);
+	iwl3945_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
 
-	iwl_cancel_deferred_work(priv);
+	iwl3945_cancel_deferred_work(priv);
 
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
@@ -6238,17 +6239,17 @@ static void __iwl_down(struct iwl_priv *
 		clear_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* stop and reset the on-board processor */
-	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	iwl3945_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
-	iwl_disable_interrupts(priv);
+	iwl3945_disable_interrupts(priv);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
-	/* If we have not previously called iwl_init() then
+	/* If we have not previously called iwl3945_init() then
 	 * clear all bits but the RF Kill and SUSPEND bits and return */
-	if (!iwl_is_init(priv)) {
+	if (!iwl3945_is_init(priv)) {
 		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 					STATUS_RF_KILL_HW |
 			       test_bit(STATUS_RF_KILL_SW, &priv->status) <<
@@ -6270,47 +6271,47 @@ static void __iwl_down(struct iwl_priv *
 				STATUS_FW_ERROR;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	iwl3945_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl_hw_txq_ctx_stop(priv);
-	iwl_hw_rxq_stop(priv);
+	iwl3945_hw_txq_ctx_stop(priv);
+	iwl3945_hw_rxq_stop(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (!iwl_grab_restricted_access(priv)) {
-		iwl_write_restricted_reg(priv, APMG_CLK_DIS_REG,
+	if (!iwl3945_grab_restricted_access(priv)) {
+		iwl3945_write_restricted_reg(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl_release_restricted_access(priv);
+		iwl3945_release_restricted_access(priv);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	udelay(5);
 
-	iwl_hw_nic_stop_master(priv);
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-	iwl_hw_nic_reset(priv);
+	iwl3945_hw_nic_stop_master(priv);
+	iwl3945_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	iwl3945_hw_nic_reset(priv);
 
  exit:
-	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
+	memset(&priv->card_alive, 0, sizeof(struct iwl3945_alive_resp));
 
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
 	priv->ibss_beacon = NULL;
 
 	/* clear out any free frames */
-	iwl_clear_free_frames(priv);
+	iwl3945_clear_free_frames(priv);
 }
 
-static void iwl_down(struct iwl_priv *priv)
+static void iwl3945_down(struct iwl3945_priv *priv)
 {
 	mutex_lock(&priv->mutex);
-	__iwl_down(priv);
+	__iwl3945_down(priv);
 	mutex_unlock(&priv->mutex);
 }
 
 #define MAX_HW_RESTARTS 5
 
-static int __iwl_up(struct iwl_priv *priv)
+static int __iwl3945_up(struct iwl3945_priv *priv)
 {
 	DECLARE_MAC_BUF(mac);
 	int rc, i;
@@ -6326,26 +6327,26 @@ static int __iwl_up(struct iwl_priv *pri
 		return 0;
 	}
 
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
 
-	rc = iwl_hw_nic_init(priv);
+	rc = iwl3945_hw_nic_init(priv);
 	if (rc) {
 		IWL_ERROR("Unable to int nic\n");
 		return rc;
 	}
 
 	/* make sure rfkill handshake bits are cleared */
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	/* clear (again), then enable host interrupts */
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(priv);
+	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl3945_enable_interrupts(priv);
 
 	/* really make sure rfkill handshake bits are cleared */
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* Copy original ucode data image from disk into backup cache.
 	 * This will be used to initialize the on-board processor's
@@ -6355,12 +6356,12 @@ static int __iwl_up(struct iwl_priv *pri
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
-		iwl_clear_stations_table(priv);
+		iwl3945_clear_stations_table(priv);
 
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
-		rc = iwl_load_bsm(priv);
+		rc = iwl3945_load_bsm(priv);
 
 		if (rc) {
 			IWL_ERROR("Unable to set up bootstrap uCode: %d\n", rc);
@@ -6368,7 +6369,7 @@ static int __iwl_up(struct iwl_priv *pri
 		}
 
 		/* start card; "initialize" will load runtime ucode */
-		iwl_nic_start(priv);
+		iwl3945_nic_start(priv);
 
 		/* MAC Address location in EEPROM same for 3945/4965 */
 		get_eeprom_mac(priv, priv->mac_addr);
@@ -6383,7 +6384,7 @@ static int __iwl_up(struct iwl_priv *pri
 	}
 
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
-	__iwl_down(priv);
+	__iwl3945_down(priv);
 
 	/* tried to restart and config the device for as long as our
 	 * patience could withstand */
@@ -6398,35 +6399,35 @@ static int __iwl_up(struct iwl_priv *pri
  *
  *****************************************************************************/
 
-static void iwl_bg_init_alive_start(struct work_struct *data)
+static void iwl3945_bg_init_alive_start(struct work_struct *data)
 {
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, init_alive_start.work);
+	struct iwl3945_priv *priv =
+	    container_of(data, struct iwl3945_priv, init_alive_start.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	mutex_lock(&priv->mutex);
-	iwl_init_alive_start(priv);
+	iwl3945_init_alive_start(priv);
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_alive_start(struct work_struct *data)
+static void iwl3945_bg_alive_start(struct work_struct *data)
 {
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, alive_start.work);
+	struct iwl3945_priv *priv =
+	    container_of(data, struct iwl3945_priv, alive_start.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	mutex_lock(&priv->mutex);
-	iwl_alive_start(priv);
+	iwl3945_alive_start(priv);
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_rf_kill(struct work_struct *work)
+static void iwl3945_bg_rf_kill(struct work_struct *work)
 {
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
+	struct iwl3945_priv *priv = container_of(work, struct iwl3945_priv, rf_kill);
 
 	wake_up_interruptible(&priv->wait_command_queue);
 
@@ -6435,7 +6436,7 @@ static void iwl_bg_rf_kill(struct work_s
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl_is_rfkill(priv)) {
+	if (!iwl3945_is_rfkill(priv)) {
 		IWL_DEBUG(IWL_DL_INFO | IWL_DL_RF_KILL,
 			  "HW and/or SW RF Kill no longer active, restarting "
 			  "device\n");
@@ -6456,10 +6457,10 @@ static void iwl_bg_rf_kill(struct work_s
 
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
 
-static void iwl_bg_scan_check(struct work_struct *data)
+static void iwl3945_bg_scan_check(struct work_struct *data)
 {
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, scan_check.work);
+	struct iwl3945_priv *priv =
+	    container_of(data, struct iwl3945_priv, scan_check.work);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6476,17 +6477,17 @@ static void iwl_bg_scan_check(struct wor
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_request_scan(struct work_struct *data)
+static void iwl3945_bg_request_scan(struct work_struct *data)
 {
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, request_scan);
-	struct iwl_host_cmd cmd = {
+	struct iwl3945_priv *priv =
+	    container_of(data, struct iwl3945_priv, request_scan);
+	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
-		.len = sizeof(struct iwl_scan_cmd),
+		.len = sizeof(struct iwl3945_scan_cmd),
 		.meta.flags = CMD_SIZE_HUGE,
 	};
 	int rc = 0;
-	struct iwl_scan_cmd *scan;
+	struct iwl3945_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
 	u8 direct_mask;
 	int phymode;
@@ -6495,7 +6496,7 @@ static void iwl_bg_request_scan(struct w
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl_is_ready(priv)) {
+	if (!iwl3945_is_ready(priv)) {
 		IWL_WARNING("request scan called when driver not ready.\n");
 		goto done;
 	}
@@ -6524,7 +6525,7 @@ static void iwl_bg_request_scan(struct w
 		goto done;
 	}
 
-	if (iwl_is_rfkill(priv)) {
+	if (iwl3945_is_rfkill(priv)) {
 		IWL_DEBUG_HC("Aborting scan due to RF Kill activation\n");
 		goto done;
 	}
@@ -6540,7 +6541,7 @@ static void iwl_bg_request_scan(struct w
 	}
 
 	if (!priv->scan) {
-		priv->scan = kmalloc(sizeof(struct iwl_scan_cmd) +
+		priv->scan = kmalloc(sizeof(struct iwl3945_scan_cmd) +
 				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!priv->scan) {
 			rc = -ENOMEM;
@@ -6548,12 +6549,12 @@ static void iwl_bg_request_scan(struct w
 		}
 	}
 	scan = priv->scan;
-	memset(scan, 0, sizeof(struct iwl_scan_cmd) + IWL_MAX_SCAN_SIZE);
+	memset(scan, 0, sizeof(struct iwl3945_scan_cmd) + IWL_MAX_SCAN_SIZE);
 
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
-	if (iwl_is_associated(priv)) {
+	if (iwl3945_is_associated(priv)) {
 		u16 interval = 0;
 		u32 extra;
 		u32 suspend_time = 100;
@@ -6590,14 +6591,14 @@ static void iwl_bg_request_scan(struct w
 	if (priv->one_direct_scan) {
 		IWL_DEBUG_SCAN
 		    ("Kicking off one direct scan for '%s'\n",
-		     iwl_escape_essid(priv->direct_ssid,
+		     iwl3945_escape_essid(priv->direct_ssid,
 				      priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
 		       priv->direct_ssid, priv->direct_ssid_len);
 		direct_mask = 1;
-	} else if (!iwl_is_associated(priv)) {
+	} else if (!iwl3945_is_associated(priv)) {
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
@@ -6608,7 +6609,7 @@ static void iwl_bg_request_scan(struct w
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.len = cpu_to_le16(
-		iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
+		iwl3945_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
 			IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
@@ -6644,23 +6645,23 @@ static void iwl_bg_request_scan(struct w
 	if (direct_mask)
 		IWL_DEBUG_SCAN
 		    ("Initiating direct scan for %s.\n",
-		     iwl_escape_essid(priv->essid, priv->essid_len));
+		     iwl3945_escape_essid(priv->essid, priv->essid_len));
 	else
 		IWL_DEBUG_SCAN("Initiating indirect scan.\n");
 
 	scan->channel_count =
-		iwl_get_channels_for_scan(
+		iwl3945_get_channels_for_scan(
 			priv, phymode, 1, /* active */
 			direct_mask,
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
-	    scan->channel_count * sizeof(struct iwl_scan_channel);
+	    scan->channel_count * sizeof(struct iwl3945_scan_channel);
 	cmd.data = scan;
 	scan->len = cpu_to_le16(cmd.len);
 
 	set_bit(STATUS_SCAN_HW, &priv->status);
-	rc = iwl_send_cmd_sync(priv, &cmd);
+	rc = iwl3945_send_cmd_sync(priv, &cmd);
 	if (rc)
 		goto done;
 
@@ -6676,45 +6677,45 @@ static void iwl_bg_request_scan(struct w
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_up(struct work_struct *data)
+static void iwl3945_bg_up(struct work_struct *data)
 {
-	struct iwl_priv *priv = container_of(data, struct iwl_priv, up);
+	struct iwl3945_priv *priv = container_of(data, struct iwl3945_priv, up);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	mutex_lock(&priv->mutex);
-	__iwl_up(priv);
+	__iwl3945_up(priv);
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_restart(struct work_struct *data)
+static void iwl3945_bg_restart(struct work_struct *data)
 {
-	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
+	struct iwl3945_priv *priv = container_of(data, struct iwl3945_priv, restart);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	iwl_down(priv);
+	iwl3945_down(priv);
 	queue_work(priv->workqueue, &priv->up);
 }
 
-static void iwl_bg_rx_replenish(struct work_struct *data)
+static void iwl3945_bg_rx_replenish(struct work_struct *data)
 {
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, rx_replenish);
+	struct iwl3945_priv *priv =
+	    container_of(data, struct iwl3945_priv, rx_replenish);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	mutex_lock(&priv->mutex);
-	iwl_rx_replenish(priv);
+	iwl3945_rx_replenish(priv);
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_post_associate(struct work_struct *data)
+static void iwl3945_bg_post_associate(struct work_struct *data)
 {
-	struct iwl_priv *priv = container_of(data, struct iwl_priv,
+	struct iwl3945_priv *priv = container_of(data, struct iwl3945_priv,
 					     post_associate.work);
 
 	int rc = 0;
@@ -6739,11 +6740,11 @@ static void iwl_bg_post_associate(struct
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl_commit_rxon(priv);
+	iwl3945_commit_rxon(priv);
 
-	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
-	iwl_setup_rxon_timing(priv);
-	rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
+	memset(&priv->rxon_timing, 0, sizeof(struct iwl3945_rxon_time_cmd));
+	iwl3945_setup_rxon_timing(priv);
+	rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
 	if (rc)
 		IWL_WARNING("REPLY_RXON_TIMING failed - "
@@ -6772,26 +6773,26 @@ static void iwl_bg_post_associate(struct
 
 	}
 
-	iwl_commit_rxon(priv);
+	iwl3945_commit_rxon(priv);
 
 	switch (priv->iw_mode) {
 	case IEEE80211_IF_TYPE_STA:
-		iwl_rate_scale_init(priv->hw, IWL_AP_ID);
+		iwl3945_rate_scale_init(priv->hw, IWL_AP_ID);
 		break;
 
 	case IEEE80211_IF_TYPE_IBSS:
 
 		/* clear out the station table */
-		iwl_clear_stations_table(priv);
+		iwl3945_clear_stations_table(priv);
 
-		iwl_add_station(priv, BROADCAST_ADDR, 0, 0);
-		iwl_add_station(priv, priv->bssid, 0, 0);
+		iwl3945_add_station(priv, iwl3945_broadcast_addr, 0, 0);
+		iwl3945_add_station(priv, priv->bssid, 0, 0);
 		iwl3945_sync_sta(priv, IWL_STA_ID,
 				 (priv->phymode == MODE_IEEE80211A)?
 				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
 				 CMD_ASYNC);
-		iwl_rate_scale_init(priv->hw, IWL_STA_ID);
-		iwl_send_beacon_cmd(priv);
+		iwl3945_rate_scale_init(priv->hw, IWL_STA_ID);
+		iwl3945_send_beacon_cmd(priv);
 
 		break;
 
@@ -6801,34 +6802,34 @@ static void iwl_bg_post_associate(struct
 		break;
 	}
 
-	iwl_sequence_reset(priv);
+	iwl3945_sequence_reset(priv);
 
 #ifdef CONFIG_IWL3945_QOS
-	iwl_activate_qos(priv, 0);
+	iwl3945_activate_qos(priv, 0);
 #endif /* CONFIG_IWL3945_QOS */
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_abort_scan(struct work_struct *work)
+static void iwl3945_bg_abort_scan(struct work_struct *work)
 {
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
+	struct iwl3945_priv *priv = container_of(work, struct iwl3945_priv,
 					     abort_scan);
 
-	if (!iwl_is_ready(priv))
+	if (!iwl3945_is_ready(priv))
 		return;
 
 	mutex_lock(&priv->mutex);
 
 	set_bit(STATUS_SCAN_ABORTING, &priv->status);
-	iwl_send_scan_abort(priv);
+	iwl3945_send_scan_abort(priv);
 
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_scan_completed(struct work_struct *work)
+static void iwl3945_bg_scan_completed(struct work_struct *work)
 {
-	struct iwl_priv *priv =
-	    container_of(work, struct iwl_priv, scan_completed);
+	struct iwl3945_priv *priv =
+	    container_of(work, struct iwl3945_priv, scan_completed);
 
 	IWL_DEBUG(IWL_DL_INFO | IWL_DL_SCAN, "SCAN complete scan\n");
 
@@ -6840,7 +6841,7 @@ static void iwl_bg_scan_completed(struct
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
 	mutex_lock(&priv->mutex);
-	iwl_hw_reg_send_txpower(priv);
+	iwl3945_hw_reg_send_txpower(priv);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -6850,9 +6851,9 @@ static void iwl_bg_scan_completed(struct
  *
  *****************************************************************************/
 
-static int iwl_mac_start(struct ieee80211_hw *hw)
+static int iwl3945_mac_start(struct ieee80211_hw *hw)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -6861,7 +6862,7 @@ static int iwl_mac_start(struct ieee8021
 
 	priv->is_open = 1;
 
-	if (!iwl_is_rfkill(priv))
+	if (!iwl3945_is_rfkill(priv))
 		ieee80211_start_queues(priv->hw);
 
 	mutex_unlock(&priv->mutex);
@@ -6869,9 +6870,9 @@ static int iwl_mac_start(struct ieee8021
 	return 0;
 }
 
-static void iwl_mac_stop(struct ieee80211_hw *hw)
+static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 	priv->is_open = 0;
@@ -6880,10 +6881,10 @@ static void iwl_mac_stop(struct ieee8021
 	IWL_DEBUG_MAC80211("leave\n");
 }
 
-static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct ieee80211_tx_control *ctl)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -6895,17 +6896,17 @@ static int iwl_mac_tx(struct ieee80211_h
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ctl->tx_rate);
 
-	if (iwl_tx_skb(priv, skb, ctl))
+	if (iwl3945_tx_skb(priv, skb, ctl))
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 }
 
-static int iwl_mac_add_interface(struct ieee80211_hw *hw,
+static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
@@ -6925,7 +6926,7 @@ static int iwl_mac_add_interface(struct 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	mutex_lock(&priv->mutex);
-	iwl_set_mode(priv, conf->type);
+	iwl3945_set_mode(priv, conf->type);
 
 	IWL_DEBUG_MAC80211("leave\n");
 	mutex_unlock(&priv->mutex);
@@ -6934,22 +6935,22 @@ static int iwl_mac_add_interface(struct 
 }
 
 /**
- * iwl_mac_config - mac80211 config callback
+ * iwl3945_mac_config - mac80211 config callback
  *
  * We ignore conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME since it seems to
  * be set inappropriately and the driver currently sets the hardware up to
  * use it whenever needed.
  */
-static int iwl_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
+static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
-	struct iwl_priv *priv = hw->priv;
-	const struct iwl_channel_info *ch_info;
+	struct iwl3945_priv *priv = hw->priv;
+	const struct iwl3945_channel_info *ch_info;
 	unsigned long flags;
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
 
-	if (!iwl_is_ready(priv)) {
+	if (!iwl3945_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		mutex_unlock(&priv->mutex);
 		return -EIO;
@@ -6957,7 +6958,7 @@ static int iwl_mac_config(struct ieee802
 
 	/* TODO: Figure out how to get ieee80211_local->sta_scanning w/ only
 	 * what is exposed through include/ declrations */
-	if (unlikely(!iwl_param_disable_hw_scan &&
+	if (unlikely(!iwl3945_param_disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211("leave - scanning\n");
 		mutex_unlock(&priv->mutex);
@@ -6966,7 +6967,7 @@ static int iwl_mac_config(struct ieee802
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ch_info = iwl_get_channel_info(priv, conf->phymode, conf->channel);
+	ch_info = iwl3945_get_channel_info(priv, conf->phymode, conf->channel);
 	if (!is_channel_valid(ch_info)) {
 		IWL_DEBUG_SCAN("Channel %d [%d] is INVALID for this SKU.\n",
 			       conf->channel, conf->phymode);
@@ -6976,26 +6977,26 @@ static int iwl_mac_config(struct ieee802
 		return -EINVAL;
 	}
 
-	iwl_set_rxon_channel(priv, conf->phymode, conf->channel);
+	iwl3945_set_rxon_channel(priv, conf->phymode, conf->channel);
 
-	iwl_set_flags_for_phymode(priv, conf->phymode);
+	iwl3945_set_flags_for_phymode(priv, conf->phymode);
 
 	/* The list of supported rates and rate mask can be different
 	 * for each phymode; since the phymode may have changed, reset
 	 * the rate mask to what mac80211 lists */
-	iwl_set_rate(priv);
+	iwl3945_set_rate(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 #ifdef IEEE80211_CONF_CHANNEL_SWITCH
 	if (conf->flags & IEEE80211_CONF_CHANNEL_SWITCH) {
-		iwl_hw_channel_switch(priv, conf->channel);
+		iwl3945_hw_channel_switch(priv, conf->channel);
 		mutex_unlock(&priv->mutex);
 		return 0;
 	}
 #endif
 
-	iwl_radio_kill_sw(priv, !conf->radio_enabled);
+	iwl3945_radio_kill_sw(priv, !conf->radio_enabled);
 
 	if (!conf->radio_enabled) {
 		IWL_DEBUG_MAC80211("leave - radio disabled\n");
@@ -7003,17 +7004,17 @@ static int iwl_mac_config(struct ieee802
 		return 0;
 	}
 
-	if (iwl_is_rfkill(priv)) {
+	if (iwl3945_is_rfkill(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF kill\n");
 		mutex_unlock(&priv->mutex);
 		return -EIO;
 	}
 
-	iwl_set_rate(priv);
+	iwl3945_set_rate(priv);
 
 	if (memcmp(&priv->active_rxon,
 		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
-		iwl_commit_rxon(priv);
+		iwl3945_commit_rxon(priv);
 	else
 		IWL_DEBUG_INFO("No re-sending same RXON configuration.\n");
 
@@ -7024,7 +7025,7 @@ static int iwl_mac_config(struct ieee802
 	return 0;
 }
 
-static void iwl_config_ap(struct iwl_priv *priv)
+static void iwl3945_config_ap(struct iwl3945_priv *priv)
 {
 	int rc = 0;
 
@@ -7036,12 +7037,12 @@ static void iwl_config_ap(struct iwl_pri
 
 		/* RXON - unassoc (to set timing command) */
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl_commit_rxon(priv);
+		iwl3945_commit_rxon(priv);
 
 		/* RXON Timing */
-		memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
-		iwl_setup_rxon_timing(priv);
-		rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
+		memset(&priv->rxon_timing, 0, sizeof(struct iwl3945_rxon_time_cmd));
+		iwl3945_setup_rxon_timing(priv);
+		rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 				sizeof(priv->rxon_timing), &priv->rxon_timing);
 		if (rc)
 			IWL_WARNING("REPLY_RXON_TIMING failed - "
@@ -7071,20 +7072,20 @@ static void iwl_config_ap(struct iwl_pri
 		}
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		iwl_commit_rxon(priv);
-		iwl_add_station(priv, BROADCAST_ADDR, 0, 0);
+		iwl3945_commit_rxon(priv);
+		iwl3945_add_station(priv, iwl3945_broadcast_addr, 0, 0);
 	}
-	iwl_send_beacon_cmd(priv);
+	iwl3945_send_beacon_cmd(priv);
 
 	/* FIXME - we need to add code here to detect a totally new
 	 * configuration, reset the AP, unassoc, rxon timing, assoc,
 	 * clear sta table, add BCAST sta... */
 }
 
-static int iwl_mac_config_interface(struct ieee80211_hw *hw, int if_id,
+static int iwl3945_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 				    struct ieee80211_if_conf *conf)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 	DECLARE_MAC_BUF(mac);
 	unsigned long flags;
 	int rc;
@@ -7143,7 +7144,7 @@ static int iwl_mac_config_interface(stru
 	    !is_multicast_ether_addr(conf->bssid)) {
 		/* If there is currently a HW scan going on in the background
 		 * then we need to cancel it else the RXON below will fail. */
-		if (iwl_scan_cancel_timeout(priv, 100)) {
+		if (iwl3945_scan_cancel_timeout(priv, 100)) {
 			IWL_WARNING("Aborted scan still in progress "
 				    "after 100ms\n");
 			IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
@@ -7159,19 +7160,19 @@ static int iwl_mac_config_interface(stru
 		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 
 		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
-			iwl_config_ap(priv);
+			iwl3945_config_ap(priv);
 		else {
 			priv->staging_rxon.filter_flags |=
 						RXON_FILTER_ASSOC_MSK;
-			rc = iwl_commit_rxon(priv);
+			rc = iwl3945_commit_rxon(priv);
 			if ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && rc)
-				iwl_add_station(priv,
+				iwl3945_add_station(priv,
 					priv->active_rxon.bssid_addr, 1, 0);
 		}
 
 	} else {
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl_commit_rxon(priv);
+		iwl3945_commit_rxon(priv);
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -7189,22 +7190,22 @@ static int iwl_mac_config_interface(stru
 	return 0;
 }
 
-static void iwl_configure_filter(struct ieee80211_hw *hw,
+static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
 				 int mc_count, struct dev_addr_list *mc_list)
 {
 	/*
 	 * XXX: dummy
-	 * see also iwl_connection_init_rx_config
+	 * see also iwl3945_connection_init_rx_config
 	 */
 	*total_flags = 0;
 }
 
-static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
+static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_if_init_conf *conf)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7222,17 +7223,17 @@ static void iwl_mac_remove_interface(str
 }
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
-static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
+static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	int rc = 0;
 	unsigned long flags;
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (!iwl_is_ready_rf(priv)) {
+	if (!iwl3945_is_ready_rf(priv)) {
 		rc = -EIO;
 		IWL_DEBUG_MAC80211("leave - not ready or exit pending\n");
 		goto out_unlock;
@@ -7254,7 +7255,7 @@ static int iwl_mac_hw_scan(struct ieee80
 	if (len) {
 		IWL_DEBUG_SCAN("direct scan for  "
 			       "%s [%d]\n ",
-			       iwl_escape_essid(ssid, len), (int)len);
+			       iwl3945_escape_essid(ssid, len), (int)len);
 
 		priv->one_direct_scan = 1;
 		priv->direct_ssid_len = (u8)
@@ -7262,7 +7263,7 @@ static int iwl_mac_hw_scan(struct ieee80
 		memcpy(priv->direct_ssid, ssid, priv->direct_ssid_len);
 	}
 
-	rc = iwl_scan_initiate(priv);
+	rc = iwl3945_scan_initiate(priv);
 
 	IWL_DEBUG_MAC80211("leave\n");
 
@@ -7272,17 +7273,17 @@ out_unlock:
 	return rc;
 }
 
-static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   const u8 *local_addr, const u8 *addr,
 			   struct ieee80211_key_conf *key)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 	int rc = 0;
 	u8 sta_id;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl_param_hwcrypto) {
+	if (!iwl3945_param_hwcrypto) {
 		IWL_DEBUG_MAC80211("leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
@@ -7291,7 +7292,7 @@ static int iwl_mac_set_key(struct ieee80
 		/* only support pairwise keys */
 		return -EOPNOTSUPP;
 
-	sta_id = iwl_hw_find_station(priv, addr);
+	sta_id = iwl3945_hw_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);
 
@@ -7304,20 +7305,20 @@ static int iwl_mac_set_key(struct ieee80
 
 	switch (cmd) {
 	case  SET_KEY:
-		rc = iwl_update_sta_key_info(priv, key, sta_id);
+		rc = iwl3945_update_sta_key_info(priv, key, sta_id);
 		if (!rc) {
-			iwl_set_rxon_hwcrypto(priv, 1);
-			iwl_commit_rxon(priv);
+			iwl3945_set_rxon_hwcrypto(priv, 1);
+			iwl3945_commit_rxon(priv);
 			key->hw_key_idx = sta_id;
 			IWL_DEBUG_MAC80211("set_key success, using hwcrypto\n");
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		}
 		break;
 	case DISABLE_KEY:
-		rc = iwl_clear_sta_key_info(priv, sta_id);
+		rc = iwl3945_clear_sta_key_info(priv, sta_id);
 		if (!rc) {
-			iwl_set_rxon_hwcrypto(priv, 0);
-			iwl_commit_rxon(priv);
+			iwl3945_set_rxon_hwcrypto(priv, 0);
+			iwl3945_commit_rxon(priv);
 			IWL_DEBUG_MAC80211("disable hwcrypto key\n");
 		}
 		break;
@@ -7331,10 +7332,10 @@ static int iwl_mac_set_key(struct ieee80
 	return rc;
 }
 
-static int iwl_mac_conf_tx(struct ieee80211_hw *hw, int queue,
+static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, int queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 #ifdef CONFIG_IWL3945_QOS
 	unsigned long flags;
 	int q;
@@ -7342,7 +7343,7 @@ static int iwl_mac_conf_tx(struct ieee80
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl_is_ready_rf(priv)) {
+	if (!iwl3945_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
 		return -EIO;
 	}
@@ -7375,9 +7376,9 @@ static int iwl_mac_conf_tx(struct ieee80
 
 	mutex_lock(&priv->mutex);
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
-		iwl_activate_qos(priv, 1);
-	else if (priv->assoc_id && iwl_is_associated(priv))
-		iwl_activate_qos(priv, 0);
+		iwl3945_activate_qos(priv, 1);
+	else if (priv->assoc_id && iwl3945_is_associated(priv))
+		iwl3945_activate_qos(priv, 0);
 
 	mutex_unlock(&priv->mutex);
 
@@ -7387,18 +7388,18 @@ static int iwl_mac_conf_tx(struct ieee80
 	return 0;
 }
 
-static int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
+static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 				struct ieee80211_tx_queue_stats *stats)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 	int i, avail;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
+	struct iwl3945_tx_queue *txq;
+	struct iwl3945_queue *q;
 	unsigned long flags;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl_is_ready_rf(priv)) {
+	if (!iwl3945_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
 		return -EIO;
 	}
@@ -7408,7 +7409,7 @@ static int iwl_mac_get_tx_stats(struct i
 	for (i = 0; i < AC_NUM; i++) {
 		txq = &priv->txq[i];
 		q = &txq->q;
-		avail = iwl_queue_space(q);
+		avail = iwl3945_queue_space(q);
 
 		stats->data[i].len = q->n_window - avail;
 		stats->data[i].limit = q->n_window - q->high_mark;
@@ -7422,7 +7423,7 @@ static int iwl_mac_get_tx_stats(struct i
 	return 0;
 }
 
-static int iwl_mac_get_stats(struct ieee80211_hw *hw,
+static int iwl3945_mac_get_stats(struct ieee80211_hw *hw,
 			     struct ieee80211_low_level_stats *stats)
 {
 	IWL_DEBUG_MAC80211("enter\n");
@@ -7431,7 +7432,7 @@ static int iwl_mac_get_stats(struct ieee
 	return 0;
 }
 
-static u64 iwl_mac_get_tsf(struct ieee80211_hw *hw)
+static u64 iwl3945_mac_get_tsf(struct ieee80211_hw *hw)
 {
 	IWL_DEBUG_MAC80211("enter\n");
 	IWL_DEBUG_MAC80211("leave\n");
@@ -7439,16 +7440,16 @@ static u64 iwl_mac_get_tsf(struct ieee80
 	return 0;
 }
 
-static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
+static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 	unsigned long flags;
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
 #ifdef CONFIG_IWL3945_QOS
-	iwl_reset_qos(priv);
+	iwl3945_reset_qos(priv);
 #endif
 	cancel_delayed_work(&priv->post_associate);
 
@@ -7478,7 +7479,7 @@ static void iwl_mac_reset_tsf(struct iee
 		return;
 	}
 
-	if (!iwl_is_ready_rf(priv)) {
+	if (!iwl3945_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		mutex_unlock(&priv->mutex);
 		return;
@@ -7486,7 +7487,7 @@ static void iwl_mac_reset_tsf(struct iee
 
 	priv->only_active_channel = 0;
 
-	iwl_set_rate(priv);
+	iwl3945_set_rate(priv);
 
 	mutex_unlock(&priv->mutex);
 
@@ -7494,16 +7495,16 @@ static void iwl_mac_reset_tsf(struct iee
 
 }
 
-static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 				 struct ieee80211_tx_control *control)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl3945_priv *priv = hw->priv;
 	unsigned long flags;
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl_is_ready_rf(priv)) {
+	if (!iwl3945_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
 		mutex_unlock(&priv->mutex);
 		return -EIO;
@@ -7528,7 +7529,7 @@ static int iwl_mac_beacon_update(struct 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 #ifdef CONFIG_IWL3945_QOS
-	iwl_reset_qos(priv);
+	iwl3945_reset_qos(priv);
 #endif
 
 	queue_work(priv->workqueue, &priv->post_associate.work);
@@ -7556,7 +7557,7 @@ static int iwl_mac_beacon_update(struct 
 
 static ssize_t show_debug_level(struct device_driver *d, char *buf)
 {
-	return sprintf(buf, "0x%08X\n", iwl_debug_level);
+	return sprintf(buf, "0x%08X\n", iwl3945_debug_level);
 }
 static ssize_t store_debug_level(struct device_driver *d,
 				 const char *buf, size_t count)
@@ -7569,7 +7570,7 @@ static ssize_t store_debug_level(struct 
 		printk(KERN_INFO DRV_NAME
 		       ": %s is not in hex or decimal form.\n", buf);
 	else
-		iwl_debug_level = val;
+		iwl3945_debug_level = val;
 
 	return strnlen(buf, count);
 }
@@ -7588,7 +7589,7 @@ static ssize_t show_rf_kill(struct devic
 	 * 2 - HW based RF kill active
 	 * 3 - Both HW and SW based RF kill active
 	 */
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 	int val = (test_bit(STATUS_RF_KILL_SW, &priv->status) ? 0x1 : 0x0) |
 		  (test_bit(STATUS_RF_KILL_HW, &priv->status) ? 0x2 : 0x0);
 
@@ -7599,10 +7600,10 @@ static ssize_t store_rf_kill(struct devi
 			     struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 
 	mutex_lock(&priv->mutex);
-	iwl_radio_kill_sw(priv, buf[0] == '1');
+	iwl3945_radio_kill_sw(priv, buf[0] == '1');
 	mutex_unlock(&priv->mutex);
 
 	return count;
@@ -7613,12 +7614,12 @@ static DEVICE_ATTR(rf_kill, S_IWUSR | S_
 static ssize_t show_temperature(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 
-	if (!iwl_is_alive(priv))
+	if (!iwl3945_is_alive(priv))
 		return -EAGAIN;
 
-	return sprintf(buf, "%d\n", iwl_hw_get_temperature(priv));
+	return sprintf(buf, "%d\n", iwl3945_hw_get_temperature(priv));
 }
 
 static DEVICE_ATTR(temperature, S_IRUGO, show_temperature, NULL);
@@ -7627,15 +7628,15 @@ static ssize_t show_rs_window(struct dev
 			      struct device_attribute *attr,
 			      char *buf)
 {
-	struct iwl_priv *priv = d->driver_data;
-	return iwl_fill_rs_info(priv->hw, buf, IWL_AP_ID);
+	struct iwl3945_priv *priv = d->driver_data;
+	return iwl3945_fill_rs_info(priv->hw, buf, IWL_AP_ID);
 }
 static DEVICE_ATTR(rs_window, S_IRUGO, show_rs_window, NULL);
 
 static ssize_t show_tx_power(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 	return sprintf(buf, "%d\n", priv->user_txpower_limit);
 }
 
@@ -7643,7 +7644,7 @@ static ssize_t store_tx_power(struct dev
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 	char *p = (char *)buf;
 	u32 val;
 
@@ -7652,7 +7653,7 @@ static ssize_t store_tx_power(struct dev
 		printk(KERN_INFO DRV_NAME
 		       ": %s is not in decimal form.\n", buf);
 	else
-		iwl_hw_reg_set_txpower(priv, val);
+		iwl3945_hw_reg_set_txpower(priv, val);
 
 	return count;
 }
@@ -7662,7 +7663,7 @@ static DEVICE_ATTR(tx_power, S_IWUSR | S
 static ssize_t show_flags(struct device *d,
 			  struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 
 	return sprintf(buf, "0x%04X\n", priv->active_rxon.flags);
 }
@@ -7671,19 +7672,19 @@ static ssize_t store_flags(struct device
 			   struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 	u32 flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging_rxon.flags) != flags) {
 		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel_timeout(priv, 100))
+		if (iwl3945_scan_cancel_timeout(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.flags = 0x%04X\n",
 				       flags);
 			priv->staging_rxon.flags = cpu_to_le32(flags);
-			iwl_commit_rxon(priv);
+			iwl3945_commit_rxon(priv);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -7696,7 +7697,7 @@ static DEVICE_ATTR(flags, S_IWUSR | S_IR
 static ssize_t show_filter_flags(struct device *d,
 				 struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 
 	return sprintf(buf, "0x%04X\n",
 		le32_to_cpu(priv->active_rxon.filter_flags));
@@ -7706,20 +7707,20 @@ static ssize_t store_filter_flags(struct
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 	u32 filter_flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging_rxon.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel_timeout(priv, 100))
+		if (iwl3945_scan_cancel_timeout(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
 			priv->staging_rxon.filter_flags =
 				cpu_to_le32(filter_flags);
-			iwl_commit_rxon(priv);
+			iwl3945_commit_rxon(priv);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -7733,20 +7734,20 @@ static DEVICE_ATTR(filter_flags, S_IWUSR
 static ssize_t show_tune(struct device *d,
 			 struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 
 	return sprintf(buf, "0x%04X\n",
 		       (priv->phymode << 8) |
 			le16_to_cpu(priv->active_rxon.channel));
 }
 
-static void iwl_set_flags_for_phymode(struct iwl_priv *priv, u8 phymode);
+static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv, u8 phymode);
 
 static ssize_t store_tune(struct device *d,
 			  struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 	char *p = (char *)buf;
 	u16 tune = simple_strtoul(p, &p, 0);
 	u8 phymode = (tune >> 8) & 0xff;
@@ -7757,9 +7758,9 @@ static ssize_t store_tune(struct device 
 	mutex_lock(&priv->mutex);
 	if ((le16_to_cpu(priv->staging_rxon.channel) != channel) ||
 	    (priv->phymode != phymode)) {
-		const struct iwl_channel_info *ch_info;
+		const struct iwl3945_channel_info *ch_info;
 
-		ch_info = iwl_get_channel_info(priv, phymode, channel);
+		ch_info = iwl3945_get_channel_info(priv, phymode, channel);
 		if (!ch_info) {
 			IWL_WARNING("Requested invalid phymode/channel "
 				    "combination: %d %d\n", phymode, channel);
@@ -7768,18 +7769,18 @@ static ssize_t store_tune(struct device 
 		}
 
 		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel_timeout(priv, 100))
+		if (iwl3945_scan_cancel_timeout(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing phymode and "
 				       "rxon.channel = %d %d\n",
 				       phymode, channel);
 
-			iwl_set_rxon_channel(priv, phymode, channel);
-			iwl_set_flags_for_phymode(priv, phymode);
+			iwl3945_set_rxon_channel(priv, phymode, channel);
+			iwl3945_set_flags_for_phymode(priv, phymode);
 
-			iwl_set_rate(priv);
-			iwl_commit_rxon(priv);
+			iwl3945_set_rate(priv);
+			iwl3945_commit_rxon(priv);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -7794,8 +7795,8 @@ static DEVICE_ATTR(tune, S_IWUSR | S_IRU
 static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	struct iwl_spectrum_notification measure_report;
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_spectrum_notification measure_report;
 	u32 size = sizeof(measure_report), len = 0, ofs = 0;
 	u8 *data = (u8 *) & measure_report;
 	unsigned long flags;
@@ -7827,7 +7828,7 @@ static ssize_t store_measurement(struct 
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	struct ieee80211_measurement_params params = {
 		.channel = le16_to_cpu(priv->active_rxon.channel),
 		.start_time = cpu_to_le64(priv->last_tsf),
@@ -7853,7 +7854,7 @@ static ssize_t store_measurement(struct 
 
 	IWL_DEBUG_INFO("Invoking measurement of type %d on "
 		       "channel %d (for '%s')\n", type, params.channel, buf);
-	iwl_get_measurement(priv, &params, type);
+	iwl3945_get_measurement(priv, &params, type);
 
 	return count;
 }
@@ -7865,7 +7866,7 @@ static DEVICE_ATTR(measurement, S_IRUSR 
 static ssize_t show_rate(struct device *d,
 			 struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	unsigned long flags;
 	int i;
 
@@ -7876,13 +7877,13 @@ static ssize_t show_rate(struct device *
 		i = priv->stations[IWL_STA_ID].current_rate.s.rate;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	i = iwl_rate_index_from_plcp(i);
+	i = iwl3945_rate_index_from_plcp(i);
 	if (i == -1)
 		return sprintf(buf, "0\n");
 
 	return sprintf(buf, "%d%s\n",
-		       (iwl_rates[i].ieee >> 1),
-		       (iwl_rates[i].ieee & 0x1) ? ".5" : "");
+		       (iwl3945_rates[i].ieee >> 1),
+		       (iwl3945_rates[i].ieee & 0x1) ? ".5" : "");
 }
 
 static DEVICE_ATTR(rate, S_IRUSR, show_rate, NULL);
@@ -7891,7 +7892,7 @@ static ssize_t store_retry_rate(struct d
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
 
 	priv->retry_rate = simple_strtoul(buf, NULL, 0);
 	if (priv->retry_rate <= 0)
@@ -7903,7 +7904,7 @@ static ssize_t store_retry_rate(struct d
 static ssize_t show_retry_rate(struct device *d,
 			       struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	return sprintf(buf, "%d", priv->retry_rate);
 }
 
@@ -7914,14 +7915,14 @@ static ssize_t store_power_level(struct 
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	int rc;
 	int mode;
 
 	mode = simple_strtoul(buf, NULL, 0);
 	mutex_lock(&priv->mutex);
 
-	if (!iwl_is_ready(priv)) {
+	if (!iwl3945_is_ready(priv)) {
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -7932,7 +7933,7 @@ static ssize_t store_power_level(struct 
 		mode |= IWL_POWER_ENABLED;
 
 	if (mode != priv->power_mode) {
-		rc = iwl_send_power_mode(priv, IWL_POWER_LEVEL(mode));
+		rc = iwl3945_send_power_mode(priv, IWL_POWER_LEVEL(mode));
 		if (rc) {
 			IWL_DEBUG_MAC80211("failed setting power mode.\n");
 			goto out;
@@ -7968,7 +7969,7 @@ static const s32 period_duration[] = {
 static ssize_t show_power_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	int level = IWL_POWER_LEVEL(priv->power_mode);
 	char *p = buf;
 
@@ -8003,18 +8004,18 @@ static DEVICE_ATTR(power_level, S_IWUSR 
 static ssize_t show_channels(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	int len = 0, i;
 	struct ieee80211_channel *channels = NULL;
 	const struct ieee80211_hw_mode *hw_mode = NULL;
 	int count = 0;
 
-	if (!iwl_is_ready(priv))
+	if (!iwl3945_is_ready(priv))
 		return -EAGAIN;
 
-	hw_mode = iwl_get_hw_mode(priv, MODE_IEEE80211G);
+	hw_mode = iwl3945_get_hw_mode(priv, MODE_IEEE80211G);
 	if (!hw_mode)
-		hw_mode = iwl_get_hw_mode(priv, MODE_IEEE80211B);
+		hw_mode = iwl3945_get_hw_mode(priv, MODE_IEEE80211B);
 	if (hw_mode) {
 		channels = hw_mode->channels;
 		count = hw_mode->num_channels;
@@ -8041,7 +8042,7 @@ static ssize_t show_channels(struct devi
 			       flag & IEEE80211_CHAN_W_ACTIVE_SCAN ?
 			       "active/passive" : "passive only");
 
-	hw_mode = iwl_get_hw_mode(priv, MODE_IEEE80211A);
+	hw_mode = iwl3945_get_hw_mode(priv, MODE_IEEE80211A);
 	if (hw_mode) {
 		channels = hw_mode->channels;
 		count = hw_mode->num_channels;
@@ -8077,17 +8078,17 @@ static DEVICE_ATTR(channels, S_IRUSR, sh
 static ssize_t show_statistics(struct device *d,
 			       struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	u32 size = sizeof(struct iwl_notif_statistics);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
+	u32 size = sizeof(struct iwl3945_notif_statistics);
 	u32 len = 0, ofs = 0;
 	u8 *data = (u8 *) & priv->statistics;
 	int rc = 0;
 
-	if (!iwl_is_alive(priv))
+	if (!iwl3945_is_alive(priv))
 		return -EAGAIN;
 
 	mutex_lock(&priv->mutex);
-	rc = iwl_send_statistics_request(priv);
+	rc = iwl3945_send_statistics_request(priv);
 	mutex_unlock(&priv->mutex);
 
 	if (rc) {
@@ -8115,9 +8116,9 @@ static DEVICE_ATTR(statistics, S_IRUGO, 
 static ssize_t show_antenna(struct device *d,
 			    struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
 
-	if (!iwl_is_alive(priv))
+	if (!iwl3945_is_alive(priv))
 		return -EAGAIN;
 
 	return sprintf(buf, "%d\n", priv->antenna);
@@ -8128,7 +8129,7 @@ static ssize_t store_antenna(struct devi
 			     const char *buf, size_t count)
 {
 	int ant;
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl3945_priv *priv = dev_get_drvdata(d);
 
 	if (count == 0)
 		return 0;
@@ -8140,7 +8141,7 @@ static ssize_t store_antenna(struct devi
 
 	if ((ant >= 0) && (ant <= 2)) {
 		IWL_DEBUG_INFO("Setting antenna select to %d.\n", ant);
-		priv->antenna = (enum iwl_antenna)ant;
+		priv->antenna = (enum iwl3945_antenna)ant;
 	} else
 		IWL_DEBUG_INFO("Bad antenna select value %d.\n", ant);
 
@@ -8153,8 +8154,8 @@ static DEVICE_ATTR(antenna, S_IWUSR | S_
 static ssize_t show_status(struct device *d,
 			   struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	if (!iwl_is_alive(priv))
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
+	if (!iwl3945_is_alive(priv))
 		return -EAGAIN;
 	return sprintf(buf, "0x%08x\n", (int)priv->status);
 }
@@ -8168,7 +8169,7 @@ static ssize_t dump_error_log(struct dev
 	char *p = (char *)buf;
 
 	if (p[0] == '1')
-		iwl_dump_nic_error_log((struct iwl_priv *)d->driver_data);
+		iwl3945_dump_nic_error_log((struct iwl3945_priv *)d->driver_data);
 
 	return strnlen(buf, count);
 }
@@ -8182,7 +8183,7 @@ static ssize_t dump_event_log(struct dev
 	char *p = (char *)buf;
 
 	if (p[0] == '1')
-		iwl_dump_nic_event_log((struct iwl_priv *)d->driver_data);
+		iwl3945_dump_nic_event_log((struct iwl3945_priv *)d->driver_data);
 
 	return strnlen(buf, count);
 }
@@ -8195,34 +8196,34 @@ static DEVICE_ATTR(dump_events, S_IWUSR,
  *
  *****************************************************************************/
 
-static void iwl_setup_deferred_work(struct iwl_priv *priv)
+static void iwl3945_setup_deferred_work(struct iwl3945_priv *priv)
 {
 	priv->workqueue = create_workqueue(DRV_NAME);
 
 	init_waitqueue_head(&priv->wait_command_queue);
 
-	INIT_WORK(&priv->up, iwl_bg_up);
-	INIT_WORK(&priv->restart, iwl_bg_restart);
-	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
-	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
-	INIT_WORK(&priv->request_scan, iwl_bg_request_scan);
-	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
-	INIT_WORK(&priv->rf_kill, iwl_bg_rf_kill);
-	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
-	INIT_DELAYED_WORK(&priv->post_associate, iwl_bg_post_associate);
-	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
-	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
-	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
+	INIT_WORK(&priv->up, iwl3945_bg_up);
+	INIT_WORK(&priv->restart, iwl3945_bg_restart);
+	INIT_WORK(&priv->rx_replenish, iwl3945_bg_rx_replenish);
+	INIT_WORK(&priv->scan_completed, iwl3945_bg_scan_completed);
+	INIT_WORK(&priv->request_scan, iwl3945_bg_request_scan);
+	INIT_WORK(&priv->abort_scan, iwl3945_bg_abort_scan);
+	INIT_WORK(&priv->rf_kill, iwl3945_bg_rf_kill);
+	INIT_WORK(&priv->beacon_update, iwl3945_bg_beacon_update);
+	INIT_DELAYED_WORK(&priv->post_associate, iwl3945_bg_post_associate);
+	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
+	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
+	INIT_DELAYED_WORK(&priv->scan_check, iwl3945_bg_scan_check);
 
-	iwl_hw_setup_deferred_work(priv);
+	iwl3945_hw_setup_deferred_work(priv);
 
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-		     iwl_irq_tasklet, (unsigned long)priv);
+		     iwl3945_irq_tasklet, (unsigned long)priv);
 }
 
-static void iwl_cancel_deferred_work(struct iwl_priv *priv)
+static void iwl3945_cancel_deferred_work(struct iwl3945_priv *priv)
 {
-	iwl_hw_cancel_deferred_work(priv);
+	iwl3945_hw_cancel_deferred_work(priv);
 
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
@@ -8230,7 +8231,7 @@ static void iwl_cancel_deferred_work(str
 	cancel_work_sync(&priv->beacon_update);
 }
 
-static struct attribute *iwl_sysfs_entries[] = {
+static struct attribute *iwl3945_sysfs_entries[] = {
 	&dev_attr_antenna.attr,
 	&dev_attr_channels.attr,
 	&dev_attr_dump_errors.attr,
@@ -8254,45 +8255,45 @@ static struct attribute *iwl_sysfs_entri
 	NULL
 };
 
-static struct attribute_group iwl_attribute_group = {
+static struct attribute_group iwl3945_attribute_group = {
 	.name = NULL,		/* put in device directory */
-	.attrs = iwl_sysfs_entries,
+	.attrs = iwl3945_sysfs_entries,
 };
 
-static struct ieee80211_ops iwl_hw_ops = {
-	.tx = iwl_mac_tx,
-	.start = iwl_mac_start,
-	.stop = iwl_mac_stop,
-	.add_interface = iwl_mac_add_interface,
-	.remove_interface = iwl_mac_remove_interface,
-	.config = iwl_mac_config,
-	.config_interface = iwl_mac_config_interface,
-	.configure_filter = iwl_configure_filter,
-	.set_key = iwl_mac_set_key,
-	.get_stats = iwl_mac_get_stats,
-	.get_tx_stats = iwl_mac_get_tx_stats,
-	.conf_tx = iwl_mac_conf_tx,
-	.get_tsf = iwl_mac_get_tsf,
-	.reset_tsf = iwl_mac_reset_tsf,
-	.beacon_update = iwl_mac_beacon_update,
-	.hw_scan = iwl_mac_hw_scan
+static struct ieee80211_ops iwl3945_hw_ops = {
+	.tx = iwl3945_mac_tx,
+	.start = iwl3945_mac_start,
+	.stop = iwl3945_mac_stop,
+	.add_interface = iwl3945_mac_add_interface,
+	.remove_interface = iwl3945_mac_remove_interface,
+	.config = iwl3945_mac_config,
+	.config_interface = iwl3945_mac_config_interface,
+	.configure_filter = iwl3945_configure_filter,
+	.set_key = iwl3945_mac_set_key,
+	.get_stats = iwl3945_mac_get_stats,
+	.get_tx_stats = iwl3945_mac_get_tx_stats,
+	.conf_tx = iwl3945_mac_conf_tx,
+	.get_tsf = iwl3945_mac_get_tsf,
+	.reset_tsf = iwl3945_mac_reset_tsf,
+	.beacon_update = iwl3945_mac_beacon_update,
+	.hw_scan = iwl3945_mac_hw_scan
 };
 
-static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0;
 	u32 pci_id;
-	struct iwl_priv *priv;
+	struct iwl3945_priv *priv;
 	struct ieee80211_hw *hw;
 	int i;
 
-	if (iwl_param_disable_hw_scan) {
+	if (iwl3945_param_disable_hw_scan) {
 		IWL_DEBUG_INFO("Disabling hw_scan\n");
-		iwl_hw_ops.hw_scan = NULL;
+		iwl3945_hw_ops.hw_scan = NULL;
 	}
 
-	if ((iwl_param_queues_num > IWL_MAX_NUM_QUEUES) ||
-	    (iwl_param_queues_num < IWL_MIN_NUM_QUEUES)) {
+	if ((iwl3945_param_queues_num > IWL_MAX_NUM_QUEUES) ||
+	    (iwl3945_param_queues_num < IWL_MIN_NUM_QUEUES)) {
 		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
 			  IWL_MIN_NUM_QUEUES, IWL_MAX_NUM_QUEUES);
 		err = -EINVAL;
@@ -8301,7 +8302,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	/* mac80211 allocates memory for this device instance, including
 	 *   space for this driver's private structure */
-	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv), &iwl_hw_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct iwl3945_priv), &iwl3945_hw_ops);
 	if (hw == NULL) {
 		IWL_ERROR("Can not allocate network device\n");
 		err = -ENOMEM;
@@ -8314,9 +8315,9 @@ static int iwl_pci_probe(struct pci_dev 
 	priv->hw = hw;
 
 	priv->pci_dev = pdev;
-	priv->antenna = (enum iwl_antenna)iwl_param_antenna;
+	priv->antenna = (enum iwl3945_antenna)iwl3945_param_antenna;
 #ifdef CONFIG_IWL3945_DEBUG
-	iwl_debug_level = iwl_param_debug;
+	iwl3945_debug_level = iwl3945_param_debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
 	priv->retry_rate = 1;
@@ -8355,7 +8356,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	pci_set_master(pdev);
 
-	iwl_clear_stations_table(priv);
+	iwl3945_clear_stations_table(priv);
 
 	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
@@ -8389,7 +8390,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	/* Initialize module parameter values here */
 
-	if (iwl_param_disable) {
+	if (iwl3945_param_disable) {
 		set_bit(STATUS_RF_KILL_SW, &priv->status);
 		IWL_DEBUG_INFO("Radio disabled.\n");
 	}
@@ -8424,25 +8425,25 @@ static int iwl_pci_probe(struct pci_dev 
 	       priv->is_abg ? "A" : "");
 
 	/* Device-specific setup */
-	if (iwl_hw_set_hw_setting(priv)) {
+	if (iwl3945_hw_set_hw_setting(priv)) {
 		IWL_ERROR("failed to set hw settings\n");
 		mutex_unlock(&priv->mutex);
 		goto out_iounmap;
 	}
 
 #ifdef CONFIG_IWL3945_QOS
-	if (iwl_param_qos_enable)
+	if (iwl3945_param_qos_enable)
 		priv->qos_data.qos_enable = 1;
 
-	iwl_reset_qos(priv);
+	iwl3945_reset_qos(priv);
 
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
 #endif /* CONFIG_IWL3945_QOS */
 
-	iwl_set_rxon_channel(priv, MODE_IEEE80211G, 6);
-	iwl_setup_deferred_work(priv);
-	iwl_setup_rx_handlers(priv);
+	iwl3945_set_rxon_channel(priv, MODE_IEEE80211G, 6);
+	iwl3945_setup_deferred_work(priv);
+	iwl3945_setup_rx_handlers(priv);
 
 	priv->rates_mask = IWL_RATES_MASK;
 	/* If power management is turned on, default to AC mode */
@@ -8451,7 +8452,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	pci_enable_msi(pdev);
 
-	err = request_irq(pdev->irq, iwl_isr, IRQF_SHARED, DRV_NAME, priv);
+	err = request_irq(pdev->irq, iwl3945_isr, IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IWL_ERROR("Error allocating IRQ %d\n", pdev->irq);
 		goto out_disable_msi;
@@ -8459,7 +8460,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	mutex_lock(&priv->mutex);
 
-	err = sysfs_create_group(&pdev->dev.kobj, &iwl_attribute_group);
+	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
 		mutex_unlock(&priv->mutex);
@@ -8468,7 +8469,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
 	 * ucode filename and max sizes are card-specific. */
-	err = iwl_read_ucode(priv);
+	err = iwl3945_read_ucode(priv);
 	if (err) {
 		IWL_ERROR("Could not read microcode: %d\n", err);
 		mutex_unlock(&priv->mutex);
@@ -8484,9 +8485,9 @@ static int iwl_pci_probe(struct pci_dev 
 	return 0;
 
  out_pci_alloc:
-	iwl_dealloc_ucode_pci(priv);
+	iwl3945_dealloc_ucode_pci(priv);
 
-	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
+	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
  out_release_irq:
 	free_irq(pdev->irq, priv);
@@ -8495,7 +8496,7 @@ static int iwl_pci_probe(struct pci_dev 
 	pci_disable_msi(pdev);
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
-	iwl_unset_hw_setting(priv);
+	iwl3945_unset_hw_setting(priv);
 
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
@@ -8510,9 +8511,9 @@ static int iwl_pci_probe(struct pci_dev 
 	return err;
 }
 
-static void iwl_pci_remove(struct pci_dev *pdev)
+static void iwl3945_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 	struct list_head *p, *q;
 	int i;
 
@@ -8523,34 +8524,34 @@ static void iwl_pci_remove(struct pci_de
 
 	mutex_lock(&priv->mutex);
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
-	__iwl_down(priv);
+	__iwl3945_down(priv);
 	mutex_unlock(&priv->mutex);
 
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
 		list_for_each_safe(p, q, &priv->ibss_mac_hash[i]) {
 			list_del(p);
-			kfree(list_entry(p, struct iwl_ibss_seq, list));
+			kfree(list_entry(p, struct iwl3945_ibss_seq, list));
 		}
 	}
 
-	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
+	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
-	iwl_dealloc_ucode_pci(priv);
+	iwl3945_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
-		iwl_rx_queue_free(priv, &priv->rxq);
-	iwl_hw_txq_ctx_free(priv);
+		iwl3945_rx_queue_free(priv, &priv->rxq);
+	iwl3945_hw_txq_ctx_free(priv);
 
-	iwl_unset_hw_setting(priv);
-	iwl_clear_stations_table(priv);
+	iwl3945_unset_hw_setting(priv);
+	iwl3945_clear_stations_table(priv);
 
 	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
-		iwl_rate_control_unregister(priv->hw);
+		iwl3945_rate_control_unregister(priv->hw);
 	}
 
-	/* ieee80211_unregister_hw calls iwl_mac_stop, which flushes
+	/* ieee80211_unregister_hw calls iwl3945_mac_stop, which flushes
 	 * priv->workqueue... so we can't take down the workqueue
 	 * until now... */
 	destroy_workqueue(priv->workqueue);
@@ -8576,16 +8577,16 @@ static void iwl_pci_remove(struct pci_de
 
 #ifdef CONFIG_PM
 
-static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 
 	mutex_lock(&priv->mutex);
 
 	set_bit(STATUS_IN_SUSPEND, &priv->status);
 
 	/* Take down the device; powers it off, etc. */
-	__iwl_down(priv);
+	__iwl3945_down(priv);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
@@ -8599,7 +8600,7 @@ static int iwl_pci_suspend(struct pci_de
 	return 0;
 }
 
-static void iwl_resume(struct iwl_priv *priv)
+static void iwl3945_resume(struct iwl3945_priv *priv)
 {
 	unsigned long flags;
 
@@ -8608,47 +8609,47 @@ static void iwl_resume(struct iwl_priv *
 	 * Without all of the following, resume will not attempt to take
 	 * down the NIC (it shouldn't really need to) and will just try
 	 * and bring the NIC back up.  However that fails during the
-	 * ucode verification process.  This then causes iwl_down to be
-	 * called *after* iwl_hw_nic_init() has succeeded -- which
+	 * ucode verification process.  This then causes iwl3945_down to be
+	 * called *after* iwl3945_hw_nic_init() has succeeded -- which
 	 * then lets the next init sequence succeed.  So, we've
 	 * replicated all of that NIC init code here... */
 
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
 
-	iwl_hw_nic_init(priv);
+	iwl3945_hw_nic_init(priv);
 
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl3945_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* tell the device to stop sending interrupts */
-	iwl_disable_interrupts(priv);
+	iwl3945_disable_interrupts(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	iwl3945_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
-	if (!iwl_grab_restricted_access(priv)) {
-		iwl_write_restricted_reg(priv, APMG_CLK_DIS_REG,
+	if (!iwl3945_grab_restricted_access(priv)) {
+		iwl3945_write_restricted_reg(priv, APMG_CLK_DIS_REG,
 					 APMG_CLK_VAL_DMA_CLK_RQT);
-		iwl_release_restricted_access(priv);
+		iwl3945_release_restricted_access(priv);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	udelay(5);
 
-	iwl_hw_nic_reset(priv);
+	iwl3945_hw_nic_reset(priv);
 
 	/* Bring the device back up */
 	clear_bit(STATUS_IN_SUSPEND, &priv->status);
 	queue_work(priv->workqueue, &priv->up);
 }
 
-static int iwl_pci_resume(struct pci_dev *pdev)
+static int iwl3945_pci_resume(struct pci_dev *pdev)
 {
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 	int err;
 
 	printk(KERN_INFO "Coming out of suspend...\n");
@@ -8667,7 +8668,7 @@ static int iwl_pci_resume(struct pci_dev
 	 */
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
-	iwl_resume(priv);
+	iwl3945_resume(priv);
 	mutex_unlock(&priv->mutex);
 
 	return 0;
@@ -8681,33 +8682,33 @@ static int iwl_pci_resume(struct pci_dev
  *
  *****************************************************************************/
 
-static struct pci_driver iwl_driver = {
+static struct pci_driver iwl3945_driver = {
 	.name = DRV_NAME,
-	.id_table = iwl_hw_card_ids,
-	.probe = iwl_pci_probe,
-	.remove = __devexit_p(iwl_pci_remove),
+	.id_table = iwl3945_hw_card_ids,
+	.probe = iwl3945_pci_probe,
+	.remove = __devexit_p(iwl3945_pci_remove),
 #ifdef CONFIG_PM
-	.suspend = iwl_pci_suspend,
-	.resume = iwl_pci_resume,
+	.suspend = iwl3945_pci_suspend,
+	.resume = iwl3945_pci_resume,
 #endif
 };
 
-static int __init iwl_init(void)
+static int __init iwl3945_init(void)
 {
 
 	int ret;
 	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", " DRV_VERSION "\n");
 	printk(KERN_INFO DRV_NAME ": " DRV_COPYRIGHT "\n");
-	ret = pci_register_driver(&iwl_driver);
+	ret = pci_register_driver(&iwl3945_driver);
 	if (ret) {
 		IWL_ERROR("Unable to initialize PCI module\n");
 		return ret;
 	}
 #ifdef CONFIG_IWL3945_DEBUG
-	ret = driver_create_file(&iwl_driver.driver, &driver_attr_debug_level);
+	ret = driver_create_file(&iwl3945_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
-		pci_unregister_driver(&iwl_driver);
+		pci_unregister_driver(&iwl3945_driver);
 		return ret;
 	}
 #endif
@@ -8715,32 +8716,32 @@ static int __init iwl_init(void)
 	return ret;
 }
 
-static void __exit iwl_exit(void)
+static void __exit iwl3945_exit(void)
 {
 #ifdef CONFIG_IWL3945_DEBUG
-	driver_remove_file(&iwl_driver.driver, &driver_attr_debug_level);
+	driver_remove_file(&iwl3945_driver.driver, &driver_attr_debug_level);
 #endif
-	pci_unregister_driver(&iwl_driver);
+	pci_unregister_driver(&iwl3945_driver);
 }
 
-module_param_named(antenna, iwl_param_antenna, int, 0444);
+module_param_named(antenna, iwl3945_param_antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(disable, iwl_param_disable, int, 0444);
+module_param_named(disable, iwl3945_param_disable, int, 0444);
 MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
-module_param_named(hwcrypto, iwl_param_hwcrypto, int, 0444);
+module_param_named(hwcrypto, iwl3945_param_hwcrypto, int, 0444);
 MODULE_PARM_DESC(hwcrypto,
 		 "using hardware crypto engine (default 0 [software])\n");
-module_param_named(debug, iwl_param_debug, int, 0444);
+module_param_named(debug, iwl3945_param_debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
-module_param_named(disable_hw_scan, iwl_param_disable_hw_scan, int, 0444);
+module_param_named(disable_hw_scan, iwl3945_param_disable_hw_scan, int, 0444);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 
-module_param_named(queues_num, iwl_param_queues_num, int, 0444);
+module_param_named(queues_num, iwl3945_param_queues_num, int, 0444);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
 
 /* QoS */
-module_param_named(qos_enable, iwl_param_qos_enable, int, 0444);
+module_param_named(qos_enable, iwl3945_param_qos_enable, int, 0444);
 MODULE_PARM_DESC(qos_enable, "enable all QoS functionality");
 
-module_exit(iwl_exit);
-module_init(iwl_init);
+module_exit(iwl3945_exit);
+module_init(iwl3945_init);
Index: linux-2.6/drivers/net/wireless/iwlwifi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/Kconfig	2007-10-12 15:02:02.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/Kconfig	2007-10-12 15:02:17.000000000 +0200
@@ -88,9 +88,8 @@ config IWL4965_DEBUG
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
-	depends on m && PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
-	default m
 	---help---
 	  Select to build the driver supporting the:
 
@@ -118,7 +117,6 @@ config IWL3945
 config IWL3945_QOS
 	bool "Enable Wireless QoS in iwl3945 driver"
 	depends on IWL3945
-	default y
 	---help---
 	  This option will enable wireless quality of service (QoS) for the
 	  iwl3945 driver.
@@ -126,14 +124,12 @@ config IWL3945_QOS
 config IWL3945_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl3945 drivers"
 	depends on IWL3945
-	default y
 	---help---
 	  This option will enable spectrum measurement for the iwl3945 driver.
 
 config IWL3945_DEBUG
 	bool "Enable full debugging output in iwl3945 driver"
 	depends on IWL3945
-	default y
 	---help---
 	  This option will enable debug tracing output for the iwl3945
 	  driver.
