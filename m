Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbXJLMec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbXJLMec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757652AbXJLMdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:33:45 -0400
Received: from verein.lst.de ([213.95.11.210]:51437 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759145AbXJLMdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:33:23 -0400
Date: Fri, 12 Oct 2007 14:33:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] iwl3945 & iwl4965: cleanup Kconfig and ifdefs
Message-ID: <20071012123314.GC20794@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the iwl3945 & iwl4965 drivers share some common Kconfig
symbols.  This split it up into options for the individual drivers
and gets rid of all the CONFIG_IWLWIFI cruft.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/net/wireless/Makefile
===================================================================
--- linux-2.6.orig/drivers/net/wireless/Makefile	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/Makefile	2007-10-12 12:07:02.000000000 +0200
@@ -52,7 +52,9 @@ obj-$(CONFIG_RTL8187)	+= rtl8187.o
 
 obj-$(CONFIG_ADM8211)	+= adm8211.o
 
-obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
+obj-$(CONFIG_IWL3945)	+= iwlwifi/
+obj-$(CONFIG_IWL4965)	+= iwlwifi/
+
 obj-$(CONFIG_RT2X00)	+= rt2x00/
 
 obj-$(CONFIG_P54_COMMON)	+= p54common.o
Index: linux-2.6/drivers/net/wireless/iwlwifi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/Kconfig	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/Kconfig	2007-10-12 12:07:02.000000000 +0200
@@ -1,107 +1,95 @@
-config IWLWIFI
-	bool "Intel Wireless WiFi Link Drivers"
-	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+config IWL4965
+	tristate "Intel Wireless WiFi 4965AGN"
+	depends on m && PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
-	default n
-	---help---
-	  Select to enable drivers based on the iwlwifi project.  This
-	  project provides a common foundation for Intel's wireless
-	  drivers designed to use the mac80211 subsystem.
-
-	  See <file:Documentation/networking/README.iwlwifi> for
-	  information on the capabilities currently enabled in this
-	  driver and for tips for debugging issues and problems.
-
-config IWLWIFI_DEBUG
-	bool "Enable full debugging output in iwlwifi drivers"
-	depends on IWLWIFI
-	default y
+	default m
 	---help---
-	  This option will enable debug tracing output for the iwlwifi
-	  drivers.
+	  Select to build the driver supporting the:
 
-	  This will result in the kernel module being ~100k larger.  You can
-	  control which debug output is sent to the kernel log by setting the
-	  value in
+	  Intel Wireless WiFi Link 4965AGN
 
-	          /sys/bus/pci/drivers/${DRIVER}/debug_level
+	  This driver uses the kernel's mac80211 subsystem.
 
-	  This entry will only exist if this option is enabled.
+	  See <file:Documentation/networking/README.iwlwifi> for
+	  information on the capabilities currently enabled in this
+	  driver and for tips for debugging any issues or problems.
 
-	  To set a value, simply echo an 8-byte hex value to the same file:
+	  In order to use this driver, you will need a microcode (uCode)
+	  image for it. You can obtain the microcode from:
 
-		  % echo 0x43fff > /sys/bus/pci/drivers/${DRIVER}/debug_level
+	          <http://intellinuxwireless.org/>.
 
-	  You can find the list of debug mask values in:
-		  drivers/net/wireless/mac80211/iwlwifi/iwl-debug.h
+	  See the above referenced README.iwlwifi for information on where
+	  to install the microcode images.
 
-	  If this is your first time using this driver, you should say Y here
-	  as the debug information can assist others in helping you resolve
-	  any problems you may encounter.
+	  If you want to compile the driver as a module ( = code which can be
+	  inserted in and remvoed from the running kernel whenever you want),
+	  say M here and read <file:Documentation/modules.txt>.  The module
+	  will be called iwl4965.ko.
 
-config IWLWIFI_SENSITIVITY
-	bool "Enable Sensitivity Calibration in iwlwifi drivers"
-	depends on IWLWIFI
+config IWL4965_QOS
+	bool "Enable Wireless QoS in iwl4965 driver"
+	depends on IWL4965
 	default y
 	---help---
-	  This option will enable sensitivity calibration for the iwlwifi
-	  drivers.
+	  This option will enable wireless quality of service (QoS) for the
+	  iw4965 driver.
 
-config IWLWIFI_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iwlwifi drivers"
-	depends on IWLWIFI
+config IWL4965_SPECTRUM_MEASUREMENT
+	bool "Enable Spectrum Measurement in iw4965 driver"
+	depends on IWL4965
 	default y
 	---help---
-	  This option will enable spectrum measurement for the iwlwifi drivers.
+	  This option will enable spectrum measurement for the iwl4965 driver.
 
-config IWLWIFI_QOS
-	bool "Enable Wireless QoS in iwlwifi drivers"
-	depends on IWLWIFI
+config IWL4965_SENSITIVITY
+	bool "Enable Sensitivity Calibration in iwl4965 driver"
+	depends on IWL4965
 	default y
 	---help---
-	  This option will enable wireless quality of service (QoS) for the
-	  iwlwifi drivers.
+	  This option will enable sensitivity calibration for the iwl4965
+	  driver.
 
-config IWLWIFI_HT
-	bool "Enable 802.11n HT features in iwlwifi drivers"
+config IWL4965_HT
+	bool "Enable 802.11n HT features in iwl4965 driver"
 	depends on EXPERIMENTAL
-	depends on IWLWIFI && MAC80211_HT
+	depends on IWL4965 && MAC80211_HT
 	default n
 	---help---
 	  This option enables IEEE 802.11n High Throughput features
-	  for the iwlwifi drivers.
+	  for the iwl4965 driver.
 
-config IWL4965
-	tristate "Intel Wireless WiFi 4965AGN"
-	depends on m && IWLWIFI && EXPERIMENTAL
-	default m
+config IWL4965_DEBUG
+	bool "Enable full debugging output in iwl4965 driver"
+	depends on IWL4965
+	default y
 	---help---
-	  Select to build the driver supporting the:
+	  This option will enable debug tracing output for the iwl4965
+	  driver.
 
-	  Intel Wireless WiFi Link 4965AGN
+	  This will result in the kernel module being ~100k larger.  You can
+	  control which debug output is sent to the kernel log by setting the
+	  value in
 
-	  This driver uses the kernel's mac80211 subsystem.
+	          /sys/bus/pci/drivers/${DRIVER}/debug_level
 
-	  See <file:Documentation/networking/README.iwlwifi> for
-	  information on the capabilities currently enabled in this
-	  driver and for tips for debugging any issues or problems.
+	  This entry will only exist if this option is enabled.
 
-	  In order to use this driver, you will need a microcode (uCode)
-	  image for it. You can obtain the microcode from:
+	  To set a value, simply echo an 8-byte hex value to the same file:
 
-	          <http://intellinuxwireless.org/>.
+		  % echo 0x43fff > /sys/bus/pci/drivers/${DRIVER}/debug_level
 
-	  See the above referenced README.iwlwifi for information on where
-	  to install the microcode images.
+	  You can find the list of debug mask values in:
+		  drivers/net/wireless/iwlwifi/iwl-4965-debug.h
 
-	  If you want to compile the driver as a module ( = code which can be
-	  inserted in and remvoed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called iwl4965.ko.
+	  If this is your first time using this driver, you should say Y here
+	  as the debug information can assist others in helping you resolve
+	  any problems you may encounter.
 
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
-	depends on m && IWLWIFI && EXPERIMENTAL
+	depends on m && PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select FW_LOADER
 	default m
 	---help---
 	  Select to build the driver supporting the:
@@ -126,3 +114,46 @@ config IWL3945
 	  inserted in and remvoed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/modules.txt>.  The module
 	  will be called iwl3945.ko.
+
+config IWL3945_QOS
+	bool "Enable Wireless QoS in iwl3945 driver"
+	depends on IWL3945
+	default y
+	---help---
+	  This option will enable wireless quality of service (QoS) for the
+	  iwl3945 driver.
+
+config IWL3945_SPECTRUM_MEASUREMENT
+	bool "Enable Spectrum Measurement in iwl3945 drivers"
+	depends on IWL3945
+	default y
+	---help---
+	  This option will enable spectrum measurement for the iwl3945 driver.
+
+config IWL3945_DEBUG
+	bool "Enable full debugging output in iwl3945 driver"
+	depends on IWL3945
+	default y
+	---help---
+	  This option will enable debug tracing output for the iwl3945
+	  driver.
+
+	  This will result in the kernel module being ~100k larger.  You can
+	  control which debug output is sent to the kernel log by setting the
+	  value in
+
+	          /sys/bus/pci/drivers/${DRIVER}/debug_level
+
+	  This entry will only exist if this option is enabled.
+
+	  To set a value, simply echo an 8-byte hex value to the same file:
+
+		  % echo 0x43fff > /sys/bus/pci/drivers/${DRIVER}/debug_level
+
+	  You can find the list of debug mask values in:
+		  drivers/net/wireless/iwlwifi/iwl-3945-debug.h
+
+	  If this is your first time using this driver, you should say Y here
+	  as the debug information can assist others in helping you resolve
+	  any problems you may encounter.
+
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-debug.h	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-debug.h	2007-10-12 12:07:02.000000000 +0200
@@ -29,7 +29,7 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 extern u32 iwl_debug_level;
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (iwl_debug_level & (level)) \
@@ -47,7 +47,7 @@ static inline void IWL_DEBUG(int level, 
 static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 {
 }
-#endif				/* CONFIG_IWLWIFI_DEBUG */
+#endif				/* CONFIG_IWL3945_DEBUG */
 
 /*
  * To use the debug system;
@@ -71,7 +71,7 @@ static inline void IWL_DEBUG_LIMIT(int l
  * you simply need to add your entry to the iwl_debug_levels array.
  *
  * If you do not see debug_level in /proc/net/iwl then you do not have
- * CONFIG_IWLWIFI_DEBUG defined in your kernel configuration
+ * CONFIG_IWL3945_DEBUG defined in your kernel configuration
  *
  */
 
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-io.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-io.h	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-io.h	2007-10-12 12:07:02.000000000 +0200
@@ -61,7 +61,7 @@
  */
 
 #define _iwl_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
 				 u32 ofs, u32 val)
 {
@@ -76,7 +76,7 @@ static inline void __iwl_write32(const c
 #endif
 
 #define _iwl_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *iwl, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
@@ -101,7 +101,7 @@ static inline int _iwl_poll_bit(struct i
 
 	return -ETIMEDOUT;
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline int __iwl_poll_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 addr,
 				 u32 bits, u32 mask, int timeout)
@@ -127,7 +127,7 @@ static inline void _iwl_set_bit(struct i
 {
 	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_set_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 reg, u32 mask)
 {
@@ -144,7 +144,7 @@ static inline void _iwl_clear_bit(struct
 {
 	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_clear_bit(const char *f, u32 l,
 				   struct iwl_priv *priv, u32 reg, u32 mask)
 {
@@ -162,7 +162,7 @@ static inline int _iwl_grab_restricted_a
 	int rc;
 	u32 gp_ctl;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (atomic_read(&priv->restrict_refcnt))
 		return 0;
 #endif
@@ -193,13 +193,13 @@ static inline int _iwl_grab_restricted_a
 		return -EIO;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	atomic_inc(&priv->restrict_refcnt);
 #endif
 	return 0;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline int __iwl_grab_restricted_access(const char *f, u32 l,
 					       struct iwl_priv *priv)
 {
@@ -220,13 +220,13 @@ static inline int __iwl_grab_restricted_
 
 static inline void _iwl_release_restricted_access(struct iwl_priv *priv)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (atomic_dec_and_test(&priv->restrict_refcnt))
 #endif
 		_iwl_clear_bit(priv, CSR_GP_CNTRL,
 			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_release_restricted_access(const char *f, u32 l,
 						   struct iwl_priv *priv)
 {
@@ -247,7 +247,7 @@ static inline u32 _iwl_read_restricted(s
 {
 	return _iwl_read32(priv, reg);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline u32 __iwl_read_restricted(const char *f, u32 l,
 					struct iwl_priv *priv, u32 reg)
 {
@@ -269,7 +269,7 @@ static inline void _iwl_write_restricted
 {
 	_iwl_write32(priv, reg, value);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static void __iwl_write_restricted(u32 line,
 				   struct iwl_priv *priv, u32 reg, u32 value)
 {
@@ -309,7 +309,7 @@ static inline int _iwl_poll_restricted_b
 	return -ETIMEDOUT;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline int __iwl_poll_restricted_bit(const char *f, u32 l,
 					    struct iwl_priv *priv,
 					    u32 addr, u32 mask, int timeout)
@@ -335,7 +335,7 @@ static inline u32 _iwl_read_restricted_r
 	_iwl_write_restricted(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	return _iwl_read_restricted(priv, HBUS_TARG_PRPH_RDAT);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline u32 __iwl_read_restricted_reg(u32 line,
 					    struct iwl_priv *priv, u32 reg)
 {
@@ -357,7 +357,7 @@ static inline void _iwl_write_restricted
 			      ((addr & 0x0000FFFF) | (3 << 24)));
 	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT, val);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_write_restricted_reg(u32 line,
 					      struct iwl_priv *priv,
 					      u32 addr, u32 val)
@@ -376,7 +376,7 @@ static inline void __iwl_write_restricte
 #define _iwl_set_bits_restricted_reg(priv, reg, mask) \
 	_iwl_write_restricted_reg(priv, reg, \
 				  (_iwl_read_restricted_reg(priv, reg) | mask))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_set_bits_restricted_reg(u32 line, struct iwl_priv
 						 *priv, u32 reg, u32 mask)
 {
@@ -393,7 +393,7 @@ static inline void __iwl_set_bits_restri
 #define _iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
 	_iwl_write_restricted_reg( \
 	    priv, reg, ((_iwl_read_restricted_reg(priv, reg) & mask) | bits))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static inline void __iwl_set_bits_mask_restricted_reg(u32 line,
 		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-10-12 12:07:02.000000000 +0200
@@ -371,7 +371,7 @@ static void iwl3945_rx_reply_rx(struct i
 
 	network_packet = iwl_is_network_packet(priv, header);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & IWL_DL_STATS && net_ratelimit())
 		IWL_DEBUG_STATS
 		    ("[%c] %d RSSI: %d Signal: %u, Noise: %u, Rate: %u\n",
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-10-12 12:06:56.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-10-12 12:07:26.000000000 +0200
@@ -502,7 +502,7 @@ union iwl_ht_rate_supp {
 	};
 };
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 union iwl_qos_capabity {
 	struct {
 		u8 edca_count:4;	/* bit 0-3 */
@@ -530,7 +530,7 @@ struct iwl_qos_info {
 	union iwl_qos_capabity qos_cap;
 	struct iwl_qosparam_cmd def_qos_parm;
 };
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL3945_QOS */
 
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
@@ -629,7 +629,7 @@ extern int iwl_is_network_packet(struct 
 				 struct ieee80211_hdr *header);
 extern int iwl_power_init_handle(struct iwl_priv *priv);
 extern int iwl_eeprom_init(struct iwl_priv *priv);
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 extern void iwl_report_frame(struct iwl_priv *priv,
 			     struct iwl_rx_packet *pkt,
 			     struct ieee80211_hdr *header, int group100);
@@ -749,7 +749,7 @@ extern u8 iwl3945_sync_sta(struct iwl_pr
 		 u16 tx_rate, u8 flags);
 
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 enum {
 	MEASUREMENT_READY = (1 << 0),
 	MEASUREMENT_ACTIVE = (1 << 1),
@@ -775,7 +775,7 @@ struct iwl_priv {
 
 	const struct ieee80211_hw_mode *modes;
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
 	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
@@ -935,9 +935,9 @@ struct iwl_priv {
 	u16 assoc_capability;
 	u8 ps_mode;
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	struct iwl_qos_info qos_data;
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL3945_QOS */
 
 	struct workqueue_struct *workqueue;
 
@@ -973,7 +973,7 @@ struct iwl_priv {
 	u32 pm_state[16];
 #endif
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	/* debugging info */
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965-debug.h	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-debug.h	2007-10-12 12:07:02.000000000 +0200
@@ -29,7 +29,7 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 extern u32 iwl_debug_level;
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (iwl_debug_level & (level)) \
@@ -47,7 +47,7 @@ static inline void IWL_DEBUG(int level, 
 static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 {
 }
-#endif				/* CONFIG_IWLWIFI_DEBUG */
+#endif				/* CONFIG_IWL4965_DEBUG */
 
 /*
  * To use the debug system;
@@ -71,7 +71,7 @@ static inline void IWL_DEBUG_LIMIT(int l
  * you simply need to add your entry to the iwl_debug_levels array.
  *
  * If you do not see debug_level in /proc/net/iwl then you do not have
- * CONFIG_IWLWIFI_DEBUG defined in your kernel configuration
+ * CONFIG_IWL4965_DEBUG defined in your kernel configuration
  *
  */
 
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-io.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965-io.h	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-io.h	2007-10-12 12:07:02.000000000 +0200
@@ -61,7 +61,7 @@
  */
 
 #define _iwl_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
 				 u32 ofs, u32 val)
 {
@@ -76,7 +76,7 @@ static inline void __iwl_write32(const c
 #endif
 
 #define _iwl_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *iwl, u32 ofs)
 {
 	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
@@ -101,7 +101,7 @@ static inline int _iwl_poll_bit(struct i
 
 	return -ETIMEDOUT;
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline int __iwl_poll_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 addr,
 				 u32 bits, u32 mask, int timeout)
@@ -127,7 +127,7 @@ static inline void _iwl_set_bit(struct i
 {
 	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_set_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 reg, u32 mask)
 {
@@ -144,7 +144,7 @@ static inline void _iwl_clear_bit(struct
 {
 	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_clear_bit(const char *f, u32 l,
 				   struct iwl_priv *priv, u32 reg, u32 mask)
 {
@@ -162,7 +162,7 @@ static inline int _iwl_grab_restricted_a
 	int rc;
 	u32 gp_ctl;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (atomic_read(&priv->restrict_refcnt))
 		return 0;
 #endif
@@ -193,13 +193,13 @@ static inline int _iwl_grab_restricted_a
 		return -EIO;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	atomic_inc(&priv->restrict_refcnt);
 #endif
 	return 0;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline int __iwl_grab_restricted_access(const char *f, u32 l,
 					       struct iwl_priv *priv)
 {
@@ -220,13 +220,13 @@ static inline int __iwl_grab_restricted_
 
 static inline void _iwl_release_restricted_access(struct iwl_priv *priv)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (atomic_dec_and_test(&priv->restrict_refcnt))
 #endif
 		_iwl_clear_bit(priv, CSR_GP_CNTRL,
 			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_release_restricted_access(const char *f, u32 l,
 						   struct iwl_priv *priv)
 {
@@ -247,7 +247,7 @@ static inline u32 _iwl_read_restricted(s
 {
 	return _iwl_read32(priv, reg);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline u32 __iwl_read_restricted(const char *f, u32 l,
 					struct iwl_priv *priv, u32 reg)
 {
@@ -269,7 +269,7 @@ static inline void _iwl_write_restricted
 {
 	_iwl_write32(priv, reg, value);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static void __iwl_write_restricted(u32 line,
 				   struct iwl_priv *priv, u32 reg, u32 value)
 {
@@ -309,7 +309,7 @@ static inline int _iwl_poll_restricted_b
 	return -ETIMEDOUT;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline int __iwl_poll_restricted_bit(const char *f, u32 l,
 					    struct iwl_priv *priv,
 					    u32 addr, u32 mask, int timeout)
@@ -335,7 +335,7 @@ static inline u32 _iwl_read_restricted_r
 	_iwl_write_restricted(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	return _iwl_read_restricted(priv, HBUS_TARG_PRPH_RDAT);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline u32 __iwl_read_restricted_reg(u32 line,
 					    struct iwl_priv *priv, u32 reg)
 {
@@ -357,7 +357,7 @@ static inline void _iwl_write_restricted
 			      ((addr & 0x0000FFFF) | (3 << 24)));
 	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT, val);
 }
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_write_restricted_reg(u32 line,
 					      struct iwl_priv *priv,
 					      u32 addr, u32 val)
@@ -376,7 +376,7 @@ static inline void __iwl_write_restricte
 #define _iwl_set_bits_restricted_reg(priv, reg, mask) \
 	_iwl_write_restricted_reg(priv, reg, \
 				  (_iwl_read_restricted_reg(priv, reg) | mask))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_set_bits_restricted_reg(u32 line, struct iwl_priv
 						 *priv, u32 reg, u32 mask)
 {
@@ -393,7 +393,7 @@ static inline void __iwl_set_bits_restri
 #define _iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
 	_iwl_write_restricted_reg( \
 	    priv, reg, ((_iwl_read_restricted_reg(priv, reg) & mask) | bits))
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static inline void __iwl_set_bits_mask_restricted_reg(u32 line,
 		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
 {
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2007-10-12 12:07:02.000000000 +0200
@@ -199,7 +199,7 @@ static inline u8 iwl_rate_get_rate(u32 r
 static int rs_send_lq_cmd(struct iwl_priv *priv,
 			  struct iwl_link_quality_cmd *lq, u8 flags)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	int i;
 #endif
 	int rc = -1;
@@ -222,7 +222,7 @@ static int rs_send_lq_cmd(struct iwl_pri
 	IWL_DEBUG_RATE("lq dta 0x%X 0x%X\n",
 		       lq->general_params.single_stream_ant_msk,
 		       lq->general_params.dual_stream_ant_msk);
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		IWL_DEBUG_RATE("lq index %d 0x%X\n",
 				i, lq->rs_table[i].rate_n_flags);
@@ -456,14 +456,14 @@ static inline void rs_toggle_antenna(str
 static inline s8 rs_use_green(struct iwl_priv *priv)
 {
 	s8 rc = 0;
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht)
 		return 0;
 
 	if ((priv->current_assoc_ht.is_green_field) &&
 	    !(priv->current_assoc_ht.operating_mode & 0x4))
 		rc = 1;
-#endif	/*CONFIG_IWLWIFI_HT */
+#endif	/*CONFIG_IWL4965_HT */
 	return rc;
 }
 
@@ -848,7 +848,7 @@ static void rs_get_expected_tpt_table(st
 		tbl->expected_tpt = expected_tpt_G;
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 static s32 rs_get_best_rate(struct iwl_priv *priv,
 			    struct iwl_rate_scale_priv *lq_data,
 			    struct iwl_scale_tbl_info *tbl,
@@ -901,7 +901,7 @@ static s32 rs_get_best_rate(struct iwl_p
 
 	return new_rate;
 }
-#endif				/* CONFIG_IWLWIFI_HT */
+#endif				/* CONFIG_IWL4965_HT */
 
 static inline u8 rs_is_both_ant_supp(u8 valid_antenna)
 {
@@ -913,7 +913,7 @@ static int rs_switch_to_mimo(struct iwl_
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
 	int rc = -1;
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	u16 rate_mask;
 	s32 rate;
 	s8 is_green = lq_data->is_green;
@@ -962,7 +962,7 @@ static int rs_switch_to_mimo(struct iwl_
 	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate.rate_n_flags, is_green);
 
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 	return rc;
 }
 
@@ -971,7 +971,7 @@ static int rs_switch_to_siso(struct iwl_
 			     struct iwl_scale_tbl_info *tbl, int index)
 {
 	int rc = -1;
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	u16 rate_mask;
 	u8 is_green = lq_data->is_green;
 	s32 rate;
@@ -1018,7 +1018,7 @@ static int rs_switch_to_siso(struct iwl_
 	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate.rate_n_flags, is_green);
 
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 	return rc;
 }
 
@@ -1597,7 +1597,7 @@ static void rs_rate_scale_perform(struct
 		tbl1 = &(lq_data->lq_info[lq_data->active_tbl]);
 
 		if (is_legacy(tbl1->lq_type) &&
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 		    !priv->current_assoc_ht.is_ht &&
 #endif
 		    (lq_data->action_counter >= 1)) {
@@ -1608,14 +1608,14 @@ static void rs_rate_scale_perform(struct
 
 		if (lq_data->enable_counter &&
 		    (lq_data->action_counter >= IWL_ACTION_LIMIT)) {
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 			if ((lq_data->last_tpt > TID_AGG_TPT_THREHOLD) &&
 			    (priv->lq_mngr.agg_ctrl.auto_agg)) {
 				priv->lq_mngr.agg_ctrl.tid_retry =
 				    TID_ALL_SPECIFIED;
 				schedule_work(&priv->agg_work);
 			}
-#endif /*CONFIG_IWLWIFI_HT_AGG */
+#endif /*CONFIG_IWL4965_HT_AGG */
 			lq_data->action_counter = 0;
 			rs_set_stay_in_table(0, lq_data);
 		}
@@ -1861,7 +1861,7 @@ static void rs_rate_init(void *priv_rate
 	crl->active_rate &= ~(0x1000);
 	crl->active_rate_basic = priv->active_rate_basic;
 	crl->phymode = priv->phymode;
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	crl->active_siso_rate = (priv->current_assoc_ht.supp_rates[0] << 1);
 	crl->active_siso_rate |= (priv->current_assoc_ht.supp_rates[0] & 0x1);
 	crl->active_siso_rate &= ~((u16)0x2);
@@ -1873,7 +1873,7 @@ static void rs_rate_init(void *priv_rate
 	crl->active_mimo_rate = crl->active_mimo_rate << IWL_FIRST_OFDM_RATE;
 	IWL_DEBUG_HT("MIMO RATE 0x%X SISO MASK 0x%X\n", crl->active_siso_rate,
 		     crl->active_mimo_rate);
-#endif /*CONFIG_IWLWIFI_HT*/
+#endif /*CONFIG_IWL4965_HT*/
 #ifdef CONFIG_MAC80211_DEBUGFS
 	crl->drv = priv;
 #endif
@@ -1992,12 +1992,12 @@ static void rs_clear(void *priv_rate)
 	IWL_DEBUG_RATE("enter\n");
 
 	priv->lq_mngr.lq_ready = 0;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	if (priv->lq_mngr.agg_ctrl.granted_ba)
 		iwl4965_turn_off_agg(priv, TID_ALL_SPECIFIED);
-#endif /*CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 	IWL_DEBUG_RATE("leave\n");
 }
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-10-12 12:07:02.000000000 +0200
@@ -88,14 +88,14 @@ static int is_fat_channel(__le32 rxon_fl
 
 static u8 is_single_stream(struct iwl_priv *priv)
 {
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht ||
 	    (priv->active_rate_ht[1] == 0) ||
 	    (priv->ps_mode == IWL_MIMO_PS_STATIC))
 		return 1;
 #else
 	return 1;
-#endif	/*CONFIG_IWLWIFI_HT */
+#endif	/*CONFIG_IWL4965_HT */
 	return 0;
 }
 
@@ -747,7 +747,7 @@ void iwl4965_rf_kill_ct_config(struct iw
 		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded\n");
 }
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 
 /* "false alarms" are signals that our DSP tries to lock onto,
  *   but then determines that they are either noise, or transmissions
@@ -1550,7 +1550,7 @@ static void iwl4965_bg_sensitivity_work(
 	mutex_unlock(&priv->mutex);
 	return;
 }
-#endif /*CONFIG_IWLWIFI_SENSITIVITY*/
+#endif /*CONFIG_IWL4965_SENSITIVITY*/
 
 static void iwl4965_bg_txpower_work(struct work_struct *work)
 {
@@ -1642,7 +1642,7 @@ int iwl4965_alive_notify(struct iwl_priv
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	memset(&(priv->sensitivity_data), 0,
 	       sizeof(struct iwl_sensitivity_data));
 	memset(&(priv->chain_noise_data), 0,
@@ -1650,7 +1650,7 @@ int iwl4965_alive_notify(struct iwl_priv
 	for (i = 0; i < NUM_RX_CHAINS; i++)
 		priv->chain_noise_data.delta_gain_code[i] =
 				CHAIN_NOISE_DELTA_GAIN_INIT_VAL;
-#endif /* CONFIG_IWLWIFI_SENSITIVITY*/
+#endif /* CONFIG_IWL4965_SENSITIVITY*/
 	rc = iwl_grab_restricted_access(priv);
 	if (rc) {
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -2820,8 +2820,8 @@ void iwl4965_set_rxon_chain(struct iwl_p
 	IWL_DEBUG_ASSOC("rx chain %X\n", priv->staging_rxon.rx_chain);
 }
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 /*
 	get the traffic load value for tid
 */
@@ -3155,8 +3155,8 @@ static void iwl4965_bg_agg_work(struct w
 	spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
 	return;
 }
-#endif /*CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 		   u8 sta_id, dma_addr_t txcmd_phys,
@@ -3171,11 +3171,11 @@ int iwl4965_tx_cmd(struct iwl_priv *priv
 	u16 fc;
 	u16 rate_flags;
 	int rate_index = min(ctrl->tx_rate & 0xffff, IWL_RATE_COUNT - 1);
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	__le16 *qc;
-#endif /*CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 	unicast = !is_multicast_ether_addr(hdr->addr1);
 
@@ -3238,8 +3238,8 @@ int iwl4965_tx_cmd(struct iwl_priv *priv
 	else if (ieee80211_is_back_request(fc))
 		tx->tx_flags |= TX_CMD_FLG_ACK_MSK |
 			TX_CMD_FLG_IMM_BA_RSP_MASK;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	qc = ieee80211_get_qos_ctrl(hdr);
 	if (qc &&
 	    (priv->iw_mode != IEEE80211_IF_TYPE_IBSS)) {
@@ -3451,7 +3451,7 @@ void iwl_hw_rx_statistics(struct iwl_pri
 	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
 	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
 		iwl4965_rx_calc_noise(priv);
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 		queue_work(priv->workqueue, &priv->sensitivity_work);
 #endif
 	}
@@ -3604,7 +3604,7 @@ static int iwl4965_calc_rssi(struct iwl4
 	return (max_rssi - agc - IWL_RSSI_OFFSET);
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 
 /* Parsed Information Elements */
 struct ieee802_11_elems {
@@ -3676,7 +3676,7 @@ static int parse_elems(u8 *start, size_t
 
 	return 0;
 }
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT */
 
 static void iwl4965_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
@@ -3736,9 +3736,9 @@ static void iwl4965_rx_reply_rx(struct i
 		.antenna = 0,
 		.rate = iwl_hw_get_rate(rx_start->rate_n_flags),
 		.flag = 0,
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 		.ordered = 0
-#endif /* CONFIG_IWLWIFI_HT_AGG */
+#endif /* CONFIG_IWL4965_HT_AGG */
 	};
 	u8 network_packet;
 
@@ -3810,7 +3810,7 @@ static void iwl4965_rx_reply_rx(struct i
 	if (!iwl_is_associated(priv))
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	/* TODO:  Parts of iwl_report_frame are broken for 4965 */
 	if (iwl_debug_level & (IWL_DL_RX))
 		/* Set "1" to report good data frames in groups of 100 */
@@ -3874,10 +3874,10 @@ static void iwl4965_rx_reply_rx(struct i
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:
 			if (network_packet && iwl_is_associated(priv)) {
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 				u8 *pos = NULL;
 				struct ieee802_11_elems elems;
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 				struct ieee80211_mgmt *mgnt =
 					(struct ieee80211_mgmt *)header;
 
@@ -3886,7 +3886,7 @@ static void iwl4965_rx_reply_rx(struct i
 				priv->assoc_capability =
 					le16_to_cpu(
 						mgnt->u.assoc_resp.capab_info);
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 				pos = mgnt->u.assoc_resp.variable;
 				if (!parse_elems(pos,
 						 len - (pos - (u8 *) mgnt),
@@ -3895,7 +3895,7 @@ static void iwl4965_rx_reply_rx(struct i
 					    elems.ht_cap_param)
 						break;
 				}
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 				/* assoc_id is 0 no association */
 				if (!priv->assoc_id)
 					break;
@@ -3927,7 +3927,7 @@ static void iwl4965_rx_reply_rx(struct i
 		break;
 
 	case IEEE80211_FTYPE_CTL:
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_BACK_REQ:
 			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
@@ -3987,7 +3987,7 @@ static void iwl4965_rx_missed_beacon_not
 					   struct iwl_rx_mem_buffer *rxb)
 
 {
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_missed_beacon_notif *missed_beacon;
 
@@ -4002,11 +4002,11 @@ static void iwl4965_rx_missed_beacon_not
 		if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)))
 			queue_work(priv->workqueue, &priv->sensitivity_work);
 	}
-#endif /*CONFIG_IWLWIFI_SENSITIVITY*/
+#endif /*CONFIG_IWL4965_SENSITIVITY*/
 }
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 
 static void iwl4965_set_tx_status(struct iwl_priv *priv, int txq_id, int idx,
 				  u32 status, u32 retry_count, u32 rate)
@@ -4275,8 +4275,8 @@ static int iwl4965_tx_queue_agg_disable(
 	return 0;
 }
 
-#endif/* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif/* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 /*
  * RATE SCALE CODE
  */
@@ -4339,7 +4339,7 @@ void iwl4965_add_station(struct iwl_priv
 			 &link_cmd);
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 
 static u8 iwl_is_channel_extension(struct iwl_priv *priv, int phymode,
 				   u16 channel, u8 extension_chan_offset)
@@ -4476,7 +4476,7 @@ void iwl4965_set_ht_add_station(struct i
 	return;
 }
 
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 
 static void iwl4965_sta_modify_add_ba_tid(struct iwl_priv *priv,
 					  int sta_id, int tid, u16 ssn)
@@ -4650,8 +4650,8 @@ int iwl_mac_ht_rx_agg_stop(struct ieee80
 	return 0;
 }
 
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 /* Set up 4965-specific Rx frame reply handlers */
 void iwl_hw_rx_handler_setup(struct iwl_priv *priv)
@@ -4666,25 +4666,25 @@ void iwl_hw_rx_handler_setup(struct iwl_
 	priv->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
 	    iwl4965_rx_missed_beacon_notif;
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwl4965_rx_reply_compressed_ba;
-#endif /* CONFIG_IWLWIFI_AGG */
-#endif /* CONFIG_IWLWIFI */
+#endif
+#endif
 }
 
 void iwl_hw_setup_deferred_work(struct iwl_priv *priv)
 {
 	INIT_WORK(&priv->txpower_work, iwl4965_bg_txpower_work);
 	INIT_WORK(&priv->statistics_work, iwl4965_bg_statistics_work);
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	INIT_WORK(&priv->sensitivity_work, iwl4965_bg_sensitivity_work);
 #endif
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	INIT_WORK(&priv->agg_work, iwl4965_bg_agg_work);
-#endif /* CONFIG_IWLWIFI_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif
+#endif
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
 	priv->statistics_periodic.function = iwl4965_bg_statistics_periodic;
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-10-12 12:07:02.000000000 +0200
@@ -493,8 +493,8 @@ struct iwl_rx_queue {
 #define IWL_INVALID_RATE     0xFF
 #define IWL_INVALID_VALUE    -1
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 struct iwl_ht_agg {
 	u16 txq_id;
 	u16 frame_count;
@@ -504,16 +504,16 @@ struct iwl_ht_agg {
 	u32 bitmap1;
 	u32 rate_n_flags;
 };
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 struct iwl_tid_data {
 	u16 seq_number;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	struct iwl_ht_agg agg;
-#endif	/* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif	/* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 };
 
 struct iwl_hw_key {
@@ -530,7 +530,7 @@ union iwl_ht_rate_supp {
 	};
 };
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 #define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
 #define HT_IE_MAX_AMSDU_SIZE_4K     (0)
 #define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
@@ -553,9 +553,9 @@ struct sta_ht_info {
 	u8 tx_chan_width;
 	u8 chan_width_cap;
 };
-#endif				/*CONFIG_IWLWIFI_HT */
+#endif				/*CONFIG_IWL4965_HT */
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 
 union iwl_qos_capabity {
 	struct {
@@ -584,7 +584,7 @@ struct iwl_qos_info {
 	union iwl_qos_capabity qos_cap;
 	struct iwl_qosparam_cmd def_qos_parm;
 };
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL4965_QOS */
 
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
@@ -676,7 +676,7 @@ extern int iwl_is_network_packet(struct 
 				 struct ieee80211_hdr *header);
 extern int iwl_power_init_handle(struct iwl_priv *priv);
 extern int iwl_eeprom_init(struct iwl_priv *priv);
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 extern void iwl_report_frame(struct iwl_priv *priv,
 			     struct iwl_rx_packet *pkt,
 			     struct ieee80211_hdr *header, int group100);
@@ -824,8 +824,8 @@ extern int iwl4965_set_fat_chan_info(str
 				u8 fat_extension_channel);
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 extern int iwl_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da,
 				   u16 tid, u16 *start_seq_num);
 extern int iwl_mac_ht_rx_agg_start(struct ieee80211_hw *hw, u8 *da,
@@ -835,8 +835,8 @@ extern int iwl_mac_ht_rx_agg_stop(struct
 extern int iwl_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da,
 				  u16 tid, int generator);
 extern void iwl4965_turn_off_agg(struct iwl_priv *priv, u8 tid);
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /*CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /*CONFIG_IWL4965_HT */
 /* Structures, enum, and defines specific to the 4965 */
 
 #define IWL4965_KW_SIZE 0x1000	/*4k */
@@ -903,7 +903,7 @@ struct iwl_traffic_load {
 	u32 total;
 };
 
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 struct iwl_agg_control {
 	unsigned long next_retry;
 	u32 wait_for_agg_status;
@@ -915,10 +915,10 @@ struct iwl_agg_control {
 	u32 ba_timeout;
 	struct iwl_traffic_load traffic_load[TID_MAX_LOAD_COUNT];
 };
-#endif				/*CONFIG_IWLWIFI_HT_AGG */
+#endif				/*CONFIG_IWL4965_HT_AGG */
 
 struct iwl_lq_mngr {
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 	struct iwl_agg_control agg_ctrl;
 #endif
 	spinlock_t lock;
@@ -1098,7 +1098,7 @@ struct iwl_chain_noise_data {
 #define	EEPROM_SEM_TIMEOUT 10
 #define EEPROM_SEM_RETRY_LIMIT 1000
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 enum {
 	MEASUREMENT_READY = (1 << 0),
 	MEASUREMENT_ACTIVE = (1 << 1),
@@ -1123,7 +1123,7 @@ struct iwl_priv {
 
 	const struct ieee80211_hw_mode *modes;
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
 	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
@@ -1212,14 +1212,14 @@ struct iwl_priv {
 	u8 channel_width;	/* 0=20MHZ, 1=40MHZ */
 	u8 current_channel_width;
 	u8 valid_antenna;	/* Bit mask of antennas actually connected */
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	struct iwl_sensitivity_data sensitivity_data;
 	struct iwl_chain_noise_data chain_noise_data;
 	u8 start_calib;
 	__le16 sensitivity_tbl[HD_TABLE_SIZE];
-#endif /*CONFIG_IWLWIFI_SENSITIVITY*/
+#endif /*CONFIG_IWL4965_SENSITIVITY*/
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	struct sta_ht_info current_assoc_ht;
 #endif
 	u8 active_rate_ht[2];
@@ -1308,9 +1308,9 @@ struct iwl_priv {
 	u16 assoc_capability;
 	u8 ps_mode;
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	struct iwl_qos_info qos_data;
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL4965_QOS */
 
 	struct workqueue_struct *workqueue;
 
@@ -1346,20 +1346,20 @@ struct iwl_priv {
 	u32 pm_state[16];
 #endif
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	/* debugging info */
 	u32 framecnt_to_us;
 	atomic_t restrict_refcnt;
 #endif
 
 	struct work_struct txpower_work;
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	struct work_struct sensitivity_work;
 #endif
 	struct work_struct statistics_work;
 	struct timer_list statistics_periodic;
 
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 	struct work_struct agg_work;
 #endif
 };				/*iwl_priv */
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-12 12:07:02.000000000 +0200
@@ -61,7 +61,7 @@
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 u32 iwl_debug_level;
 #endif
 
@@ -91,13 +91,13 @@ int iwl_param_queues_num = IWL_MAX_NUM_Q
 #define DRV_DESCRIPTION	\
 "Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 #define VD "d"
 #else
 #define VD
 #endif
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 #define VS "s"
 #else
 #define VS
@@ -182,7 +182,7 @@ static const char *iwl_escape_essid(cons
 
 static void iwl_print_hex_dump(int level, void *p, u32 len)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (!(iwl_debug_level & level))
 		return;
 
@@ -1589,7 +1589,7 @@ int iwl_eeprom_init(struct iwl_priv *pri
  * Misc. internal state and helper functions
  *
  ******************************************************************************/
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 
 /**
  * iwl_report_frame - dump frame to syslog during debug sessions
@@ -1859,7 +1859,7 @@ static u16 iwl_fill_probe_req(struct iwl
 /*
  * QoS  support
 */
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 static int iwl_send_qos_params_command(struct iwl_priv *priv,
 				       struct iwl_qosparam_cmd *qos)
 {
@@ -1991,7 +1991,7 @@ static void iwl_activate_qos(struct iwl_
 	}
 }
 
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL3945_QOS */
 /*
  * Power management (not Tx power!) functions
  */
@@ -2747,7 +2747,7 @@ static int iwl_tx_skb(struct iwl_priv *p
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_request(fc))
@@ -3195,7 +3195,7 @@ int is_duplicate_packet(struct iwl_priv 
 	return 1;
 }
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 
 #include "iwl-spectrum.h"
 
@@ -3522,7 +3522,7 @@ static void iwl_rx_csa(struct iwl_priv *
 static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
@@ -3540,7 +3540,7 @@ static void iwl_rx_spectrum_measure_noti
 static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 				  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
@@ -3586,7 +3586,7 @@ static void iwl_bg_beacon_update(struct 
 static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = beacon->beacon_notify_hdr.rate;
@@ -3609,7 +3609,7 @@ static void iwl_rx_beacon_notif(struct i
 static void iwl_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
@@ -4370,7 +4370,7 @@ static int iwl_tx_queue_update_write_ptr
 	return rc;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 {
 	DECLARE_MAC_BUF(mac);
@@ -4602,7 +4602,7 @@ static void iwl_irq_handle_error(struct 
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
 		iwl_dump_nic_error_log(priv);
 		iwl_dump_nic_event_log(priv);
@@ -4651,7 +4651,7 @@ static void iwl_irq_tasklet(struct iwl_p
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	u32 inta_mask;
 #endif
 
@@ -4669,7 +4669,7 @@ static void iwl_irq_tasklet(struct iwl_p
 	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & IWL_DL_ISR) {
 		inta_mask = iwl_read32(priv, CSR_INT_MASK); /* just for debug */
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -4702,7 +4702,7 @@ static void iwl_irq_tasklet(struct iwl_p
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_MAC_CLK_ACTV)
@@ -4798,7 +4798,7 @@ static void iwl_irq_tasklet(struct iwl_p
 	/* Re-enable all interrupts */
 	iwl_enable_interrupts(priv);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
@@ -6803,9 +6803,9 @@ static void iwl_bg_post_associate(struct
 
 	iwl_sequence_reset(priv);
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	iwl_activate_qos(priv, 0);
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL3945_QOS */
 	mutex_unlock(&priv->mutex);
 }
 
@@ -7335,7 +7335,7 @@ static int iwl_mac_conf_tx(struct ieee80
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	unsigned long flags;
 	int q;
 #endif /* CONFIG_IWL_QOS */
@@ -7352,7 +7352,7 @@ static int iwl_mac_conf_tx(struct ieee80
 		return 0;
 	}
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	if (!priv->qos_data.qos_enable) {
 		priv->qos_data.qos_active = 0;
 		IWL_DEBUG_MAC80211("leave - qos not enabled\n");
@@ -7381,7 +7381,7 @@ static int iwl_mac_conf_tx(struct ieee80
 
 	mutex_unlock(&priv->mutex);
 
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL3945_QOS */
 
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
@@ -7447,7 +7447,7 @@ static void iwl_mac_reset_tsf(struct iee
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	iwl_reset_qos(priv);
 #endif
 	cancel_delayed_work(&priv->post_associate);
@@ -7527,7 +7527,7 @@ static int iwl_mac_beacon_update(struct 
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	iwl_reset_qos(priv);
 #endif
 
@@ -7544,7 +7544,7 @@ static int iwl_mac_beacon_update(struct 
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 
 /*
  * The following adds a new attribute to the sysfs representation
@@ -7577,7 +7577,7 @@ static ssize_t store_debug_level(struct 
 static DRIVER_ATTR(debug_level, S_IWUSR | S_IRUGO,
 		   show_debug_level, store_debug_level);
 
-#endif /* CONFIG_IWLWIFI_DEBUG */
+#endif /* CONFIG_IWL3945_DEBUG */
 
 static ssize_t show_rf_kill(struct device *d,
 			    struct device_attribute *attr, char *buf)
@@ -7789,7 +7789,7 @@ static ssize_t store_tune(struct device 
 
 static DEVICE_ATTR(tune, S_IWUSR | S_IRUGO, show_tune, store_tune);
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 
 static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
@@ -7860,7 +7860,7 @@ static ssize_t store_measurement(struct 
 
 static DEVICE_ATTR(measurement, S_IRUSR | S_IWUSR,
 		   show_measurement, store_measurement);
-#endif /* CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT */
+#endif /* CONFIG_IWL3945_SPECTRUM_MEASUREMENT */
 
 static ssize_t show_rate(struct device *d,
 			 struct device_attribute *attr, char *buf)
@@ -8237,7 +8237,7 @@ static struct attribute *iwl_sysfs_entri
 	&dev_attr_dump_events.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	&dev_attr_measurement.attr,
 #endif
 	&dev_attr_power_level.attr,
@@ -8315,7 +8315,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	priv->pci_dev = pdev;
 	priv->antenna = (enum iwl_antenna)iwl_param_antenna;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	iwl_debug_level = iwl_param_debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
@@ -8430,7 +8430,7 @@ static int iwl_pci_probe(struct pci_dev 
 		goto out_iounmap;
 	}
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL3945_QOS
 	if (iwl_param_qos_enable)
 		priv->qos_data.qos_enable = 1;
 
@@ -8438,7 +8438,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL3945_QOS */
 
 	iwl_set_rxon_channel(priv, MODE_IEEE80211G, 6);
 	iwl_setup_deferred_work(priv);
@@ -8703,7 +8703,7 @@ static int __init iwl_init(void)
 		IWL_ERROR("Unable to initialize PCI module\n");
 		return ret;
 	}
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	ret = driver_create_file(&iwl_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
@@ -8717,7 +8717,7 @@ static int __init iwl_init(void)
 
 static void __exit iwl_exit(void)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL3945_DEBUG
 	driver_remove_file(&iwl_driver.driver, &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&iwl_driver);
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-12 12:06:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-12 12:07:02.000000000 +0200
@@ -61,7 +61,7 @@
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 u32 iwl_debug_level;
 #endif
 
@@ -90,13 +90,13 @@ int iwl_param_queues_num = IWL_MAX_NUM_Q
 
 #define DRV_DESCRIPTION	"Intel(R) Wireless WiFi Link 4965AGN driver for Linux"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 #define VD "d"
 #else
 #define VD
 #endif
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 #define VS "s"
 #else
 #define VS
@@ -181,7 +181,7 @@ static const char *iwl_escape_essid(cons
 
 static void iwl_print_hex_dump(int level, void *p, u32 len)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (!(iwl_debug_level & level))
 		return;
 
@@ -509,12 +509,12 @@ u8 iwl_add_station(struct iwl_priv *priv
 	station->sta.sta.sta_id = index;
 	station->sta.station_flags = 0;
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	/* BCAST station and IBSS stations do not work in HT mode */
 	if (index != priv->hw_setting.bcast_sta_id &&
 	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
 		iwl4965_set_ht_add_station(priv, index);
-#endif /*CONFIG_IWLWIFI_HT*/
+#endif /*CONFIG_IWL4965_HT*/
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 	iwl_send_add_station(priv, &station->sta, flags);
@@ -1118,13 +1118,13 @@ static int iwl_commit_rxon(struct iwl_pr
 	/* station table will be cleared */
 	priv->assoc_station_added = 0;
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	priv->sensitivity_data.state = IWL_SENS_CALIB_NEED_REINIT;
 	if (!priv->error_recovering)
 		priv->start_calib = 0;
 
 	iwl4965_init_sensitivity(priv, CMD_ASYNC, 1);
-#endif /* CONFIG_IWLWIFI_SENSITIVITY */
+#endif /* CONFIG_IWL4965_SENSITIVITY */
 
 	/* If we are currently associated and the new config requires
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
@@ -1168,13 +1168,13 @@ static int iwl_commit_rxon(struct iwl_pr
 
 	iwl_clear_stations_table(priv);
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	if (!priv->error_recovering)
 		priv->start_calib = 0;
 
 	priv->sensitivity_data.state = IWL_SENS_CALIB_NEED_REINIT;
 	iwl4965_init_sensitivity(priv, CMD_ASYNC, 1);
-#endif /* CONFIG_IWLWIFI_SENSITIVITY */
+#endif /* CONFIG_IWL4965_SENSITIVITY */
 
 	memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 
@@ -1642,7 +1642,7 @@ done:
  * Misc. internal state and helper functions
  *
  ******************************************************************************/
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 
 /**
  * iwl_report_frame - dump frame to syslog during debug sessions
@@ -1824,7 +1824,7 @@ static u16 iwl_supported_rate_to_ie(u8 *
 	return ret_rates;
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 void static iwl_set_ht_capab(struct ieee80211_hw *hw,
 			     struct ieee80211_ht_capability *ht_cap,
 			     u8 use_wide_chan);
@@ -1911,7 +1911,7 @@ static u16 iwl_fill_probe_req(struct iwl
 	if (*pos > 0)
 		len += 2 + *pos;
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	if (is_direct && priv->is_ht_enabled) {
 		u8 use_wide_chan = 1;
 
@@ -1924,7 +1924,7 @@ static u16 iwl_fill_probe_req(struct iwl
 				 use_wide_chan);
 		len += 2 + sizeof(struct ieee80211_ht_capability);
 	}
-#endif  /*CONFIG_IWLWIFI_HT */
+#endif  /*CONFIG_IWL4965_HT */
 
  fill_end:
 	return (u16)len;
@@ -1933,7 +1933,7 @@ static u16 iwl_fill_probe_req(struct iwl
 /*
  * QoS  support
 */
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 static int iwl_send_qos_params_command(struct iwl_priv *priv,
 				       struct iwl_qosparam_cmd *qos)
 {
@@ -2065,7 +2065,7 @@ static void iwl_activate_qos(struct iwl_
 	}
 }
 
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL4965_QOS */
 /*
  * Power management (not Tx power!) functions
  */
@@ -2830,7 +2830,7 @@ static int iwl_tx_skb(struct iwl_priv *p
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_request(fc))
@@ -2868,13 +2868,13 @@ static int iwl_tx_skb(struct iwl_priv *p
 			(hdr->seq_ctrl &
 				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
 		seq_number += 0x10;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 		/* aggregation is on for this <sta,tid> */
 		if (ctl->flags & IEEE80211_TXCTL_HT_MPDU_AGG)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 	}
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
@@ -3283,7 +3283,7 @@ int is_duplicate_packet(struct iwl_priv 
 	return 1;
 }
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 
 #include "iwl-spectrum.h"
 
@@ -3491,8 +3491,8 @@ static int iwl_is_tx_success(u32 status)
  * Generic RX handler implementations
  *
  ******************************************************************************/
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 
 static inline int iwl_get_ra_sta_id(struct iwl_priv *priv,
 				    struct ieee80211_hdr *hdr)
@@ -3648,8 +3648,8 @@ static void iwl_rx_reply_tx(struct iwl_p
 	struct ieee80211_tx_status *tx_status;
 	struct iwl_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	int tid, sta_id;
 #endif
 #endif
@@ -3662,8 +3662,8 @@ static void iwl_rx_reply_tx(struct iwl_p
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	if (txq->sched_retry) {
 		const u32 scd_ssn = iwl_get_scd_ssn(tx_resp);
 		struct ieee80211_hdr *hdr =
@@ -3700,8 +3700,8 @@ static void iwl_rx_reply_tx(struct iwl_p
 			iwl_tx_queue_reclaim(priv, txq_id, index);
 		}
 	} else {
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 	tx_status = &(txq->txb[txq->q.last_used].status);
 
 	tx_status->retry_count = tx_resp->failure_frame;
@@ -3723,11 +3723,11 @@ static void iwl_rx_reply_tx(struct iwl_p
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
 	if (index != -1)
 		iwl_tx_queue_reclaim(priv, txq_id, index);
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	}
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
@@ -3809,7 +3809,7 @@ static void iwl_rx_csa(struct iwl_priv *
 static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
@@ -3827,7 +3827,7 @@ static void iwl_rx_spectrum_measure_noti
 static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 				  struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
@@ -3873,7 +3873,7 @@ static void iwl_bg_beacon_update(struct 
 static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
@@ -3896,7 +3896,7 @@ static void iwl_rx_beacon_notif(struct i
 static void iwl_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
@@ -4694,7 +4694,7 @@ static int iwl_tx_queue_update_write_ptr
 	return rc;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 {
 	DECLARE_MAC_BUF(mac);
@@ -4918,7 +4918,7 @@ static void iwl_irq_handle_error(struct 
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & IWL_DL_FW_ERRORS) {
 		iwl_dump_nic_error_log(priv);
 		iwl_dump_nic_event_log(priv);
@@ -4967,7 +4967,7 @@ static void iwl_irq_tasklet(struct iwl_p
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	u32 inta_mask;
 #endif
 
@@ -4985,7 +4985,7 @@ static void iwl_irq_tasklet(struct iwl_p
 	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & IWL_DL_ISR) {
 		inta_mask = iwl_read32(priv, CSR_INT_MASK); /* just for debug */
 		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -5018,7 +5018,7 @@ static void iwl_irq_tasklet(struct iwl_p
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_MAC_CLK_ACTV)
@@ -5106,7 +5106,7 @@ static void iwl_irq_tasklet(struct iwl_p
 	/* Re-enable all interrupts */
 	iwl_enable_interrupts(priv);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
@@ -7125,7 +7125,7 @@ static void iwl_bg_post_associate(struct
 
 	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	if (priv->is_ht_enabled && priv->current_assoc_ht.is_ht)
 		iwl4965_set_rxon_ht(priv, &priv->current_assoc_ht);
 	else {
@@ -7133,7 +7133,7 @@ static void iwl_bg_post_associate(struct
 		priv->active_rate_ht[1] = 0;
 		priv->current_channel_width = IWL_CHANNEL_WIDTH_20MHZ;
 	}
-#endif /* CONFIG_IWLWIFI_HT*/
+#endif /* CONFIG_IWL4965_HT*/
 	iwl4965_set_rxon_chain(priv);
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 
@@ -7183,18 +7183,18 @@ static void iwl_bg_post_associate(struct
 
 	iwl_sequence_reset(priv);
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
+#ifdef CONFIG_IWL4965_SENSITIVITY
 	/* Enable Rx differential gain and sensitivity calibrations */
 	iwl4965_chain_noise_reset(priv);
 	priv->start_calib = 1;
-#endif /* CONFIG_IWLWIFI_SENSITIVITY */
+#endif /* CONFIG_IWL4965_SENSITIVITY */
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
 		priv->assoc_station_added = 1;
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	iwl_activate_qos(priv, 0);
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL4965_QOS */
 	mutex_unlock(&priv->mutex);
 }
 
@@ -7365,7 +7365,7 @@ static int iwl_mac_config(struct ieee802
 		return -EINVAL;
 	}
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	/* if we are switching fron ht to 2.4 clear flags
 	 * from any ht related info since 2.4 does not
 	 * support ht */
@@ -7375,7 +7375,7 @@ static int iwl_mac_config(struct ieee802
 #endif
 	)
 		priv->staging_rxon.flags = 0;
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT */
 
 	iwl_set_rxon_channel(priv, conf->phymode, conf->channel);
 
@@ -7475,7 +7475,7 @@ static void iwl_config_ap(struct iwl_pri
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl_commit_rxon(priv);
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 		iwl_activate_qos(priv, 1);
 #endif
 		iwl_rxon_add_station(priv, BROADCAST_ADDR, 0);
@@ -7738,7 +7738,7 @@ static int iwl_mac_conf_tx(struct ieee80
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	unsigned long flags;
 	int q;
 #endif /* CONFIG_IWL_QOS */
@@ -7755,7 +7755,7 @@ static int iwl_mac_conf_tx(struct ieee80
 		return 0;
 	}
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	if (!priv->qos_data.qos_enable) {
 		priv->qos_data.qos_active = 0;
 		IWL_DEBUG_MAC80211("leave - qos not enabled\n");
@@ -7784,7 +7784,7 @@ static int iwl_mac_conf_tx(struct ieee80
 
 	mutex_unlock(&priv->mutex);
 
-#endif /*CONFIG_IWLWIFI_QOS */
+#endif /*CONFIG_IWL4965_QOS */
 
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
@@ -7851,11 +7851,11 @@ static void iwl_mac_reset_tsf(struct iee
 	IWL_DEBUG_MAC80211("enter\n");
 
 	priv->lq_mngr.lq_ready = 0;
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	spin_lock_irqsave(&priv->lock, flags);
 	memset(&priv->current_assoc_ht, 0, sizeof(struct sta_ht_info));
 	spin_unlock_irqrestore(&priv->lock, flags);
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 /*	if (priv->lq_mngr.agg_ctrl.granted_ba)
 		iwl4965_turn_off_agg(priv, TID_ALL_SPECIFIED);*/
 
@@ -7866,10 +7866,10 @@ static void iwl_mac_reset_tsf(struct iee
 
 	if (priv->lq_mngr.agg_ctrl.auto_agg)
 		priv->lq_mngr.agg_ctrl.requested_ba = TID_ALL_ENABLED;
-#endif /*CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /*CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	iwl_reset_qos(priv);
 #endif
 
@@ -7951,7 +7951,7 @@ static int iwl_mac_beacon_update(struct 
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	iwl_reset_qos(priv);
 #endif
 
@@ -7962,7 +7962,7 @@ static int iwl_mac_beacon_update(struct 
 	return 0;
 }
 
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 union ht_cap_info {
 	struct {
 		u16 advanced_coding_cap		:1;
@@ -8154,7 +8154,7 @@ static void iwl_mac_get_ht_capab(struct 
 	iwl_set_ht_capab(hw, ht_cap, use_wide_channel);
 	IWL_DEBUG_MAC80211("leave: \n");
 }
-#endif /*CONFIG_IWLWIFI_HT*/
+#endif /*CONFIG_IWL4965_HT*/
 
 /*****************************************************************************
  *
@@ -8162,7 +8162,7 @@ static void iwl_mac_get_ht_capab(struct 
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 
 /*
  * The following adds a new attribute to the sysfs representation
@@ -8195,7 +8195,7 @@ static ssize_t store_debug_level(struct 
 static DRIVER_ATTR(debug_level, S_IWUSR | S_IRUGO,
 		   show_debug_level, store_debug_level);
 
-#endif /* CONFIG_IWLWIFI_DEBUG */
+#endif /* CONFIG_IWL4965_DEBUG */
 
 static ssize_t show_rf_kill(struct device *d,
 			    struct device_attribute *attr, char *buf)
@@ -8407,7 +8407,7 @@ static ssize_t store_tune(struct device 
 
 static DEVICE_ATTR(tune, S_IWUSR | S_IRUGO, show_tune, store_tune);
 
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 
 static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
@@ -8478,7 +8478,7 @@ static ssize_t store_measurement(struct 
 
 static DEVICE_ATTR(measurement, S_IRUSR | S_IWUSR,
 		   show_measurement, store_measurement);
-#endif /* CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT */
+#endif /* CONFIG_IWL4965_SPECTRUM_MEASUREMENT */
 
 static ssize_t store_retry_rate(struct device *d,
 				struct device_attribute *attr,
@@ -8830,7 +8830,7 @@ static struct attribute *iwl_sysfs_entri
 	&dev_attr_dump_events.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+#ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 	&dev_attr_measurement.attr,
 #endif
 	&dev_attr_power_level.attr,
@@ -8867,16 +8867,16 @@ static struct ieee80211_ops iwl_hw_ops =
 	.get_tsf = iwl_mac_get_tsf,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.beacon_update = iwl_mac_beacon_update,
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWL4965_HT
 	.conf_ht = iwl_mac_conf_ht,
 	.get_ht_capab = iwl_mac_get_ht_capab,
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT_AGG
 	.ht_tx_agg_start = iwl_mac_ht_tx_agg_start,
 	.ht_tx_agg_stop = iwl_mac_ht_tx_agg_stop,
 	.ht_rx_agg_start = iwl_mac_ht_rx_agg_start,
 	.ht_rx_agg_stop = iwl_mac_ht_rx_agg_stop,
-#endif  /* CONFIG_IWLWIFI_HT_AGG */
-#endif  /* CONFIG_IWLWIFI_HT */
+#endif  /* CONFIG_IWL4965_HT_AGG */
+#endif  /* CONFIG_IWL4965_HT */
 	.hw_scan = iwl_mac_hw_scan
 };
 
@@ -8916,7 +8916,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	priv->pci_dev = pdev;
 	priv->antenna = (enum iwl_antenna)iwl_param_antenna;
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	iwl_debug_level = iwl_param_debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
@@ -8937,11 +8937,11 @@ static int iwl_pci_probe(struct pci_dev 
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
 
 	hw->queues = 4;
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWL4965_HT
+#ifdef CONFIG_IWL4965_HT_AGG
 	hw->queues = 16;
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
+#endif /* CONFIG_IWL4965_HT_AGG */
+#endif /* CONFIG_IWL4965_HT */
 
 	spin_lock_init(&priv->lock);
 	spin_lock_init(&priv->power_data.lock);
@@ -9024,7 +9024,7 @@ static int iwl_pci_probe(struct pci_dev 
 		goto out_iounmap;
 	}
 
-#ifdef CONFIG_IWLWIFI_QOS
+#ifdef CONFIG_IWL4965_QOS
 	if (iwl_param_qos_enable)
 		priv->qos_data.qos_enable = 1;
 
@@ -9032,7 +9032,7 @@ static int iwl_pci_probe(struct pci_dev 
 
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
-#endif /* CONFIG_IWLWIFI_QOS */
+#endif /* CONFIG_IWL4965_QOS */
 
 	iwl_set_rxon_channel(priv, MODE_IEEE80211G, 6);
 	iwl_setup_deferred_work(priv);
@@ -9297,7 +9297,7 @@ static int __init iwl_init(void)
 		IWL_ERROR("Unable to initialize PCI module\n");
 		return ret;
 	}
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	ret = driver_create_file(&iwl_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
@@ -9311,7 +9311,7 @@ static int __init iwl_init(void)
 
 static void __exit iwl_exit(void)
 {
-#ifdef CONFIG_IWLWIFI_DEBUG
+#ifdef CONFIG_IWL4965_DEBUG
 	driver_remove_file(&iwl_driver.driver, &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&iwl_driver);
