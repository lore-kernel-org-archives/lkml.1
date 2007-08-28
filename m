Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbXH1QAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbXH1QAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbXH1QAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:00:13 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47737 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbXH1QAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:00:09 -0400
Message-id: <2440910618305782004@pripojeni.net>
In-reply-to: <2713029743177393055@pripojeni.net>
Subject: [PATCH 3/5] Net: ath5k, use int as retval
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Date: Tue, 28 Aug 2007 12:00:09 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ath5k, use int as retval

Convert some functions to return int and proper negative return value on
error as we are used to.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit ceeaf6b9aac9daaa41ec38fbba3d2c1972af4470
tree 44cd0736147325e35c32274eb53bd543fb1510a9
parent 64b9d0578668fe8c7a43eadace673bc3e57fc22b
author Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 16:10:36 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 16:24:57 +0200

 drivers/net/wireless/ath5k.h      |   27 +++---
 drivers/net/wireless/ath5k_base.c |    2 
 drivers/net/wireless/ath5k_hw.c   |  169 +++++++++++++++++--------------------
 3 files changed, 91 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/ath5k.h b/drivers/net/wireless/ath5k.h
index 26f1229..0c6f3f5 100644
--- a/drivers/net/wireless/ath5k.h
+++ b/drivers/net/wireless/ath5k.h
@@ -919,10 +919,10 @@ extern int ath5k_hw_stop_rx_dma(struct ath_hw *hal);
 extern u32 ath5k_hw_get_rx_buf(struct ath_hw *hal);
 extern void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr);
 extern int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue);
-extern bool ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue);
+extern int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue);
 extern u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue);
 extern int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr);
-extern bool ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase);
+extern int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase);
 /* Interrupt handling */
 extern bool ath5k_hw_is_intr_pending(struct ath_hw *hal);
 extern int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask);
@@ -930,19 +930,19 @@ extern enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_m
 /* EEPROM access functions */
 extern int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain);
 /* Protocol Control Unit Functions */
-extern void ath5k_hw_set_opmode(struct ath_hw *hal);
+extern int ath5k_hw_set_opmode(struct ath_hw *hal);
 /* BSSID Functions */
 extern void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac);
-extern bool ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac);
+extern int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac);
 extern void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id);
-extern bool ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask);
+extern int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask);
 /* Receive start/stop functions */
 extern void ath5k_hw_start_rx_pcu(struct ath_hw *hal);
 extern void ath5k_hw_stop_pcu_recv(struct ath_hw *hal);
 /* RX Filter functions */
 extern void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1);
-extern bool ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index);
-extern bool ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index);
+extern int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index);
+extern int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index);
 extern u32 ath5k_hw_get_rx_filter(struct ath_hw *ah);
 extern void ath5k_hw_set_rx_filter(struct ath_hw *ah, u32 filter);
 /* Beacon related functions */
@@ -950,14 +950,14 @@ extern u32 ath5k_hw_get_tsf32(struct ath_hw *hal);
 extern u64 ath5k_hw_get_tsf64(struct ath_hw *hal);
 extern void ath5k_hw_reset_tsf(struct ath_hw *hal);
 extern void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval);
-extern void ath5k_hw_set_beacon_timers(struct ath_hw *hal, const struct ath5k_beacon_state *state);
+extern int ath5k_hw_set_beacon_timers(struct ath_hw *hal, const struct ath5k_beacon_state *state);
 extern void ath5k_hw_reset_beacon(struct ath_hw *hal);
-extern bool ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr);
+extern int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr);
 extern void ath5k_hw_update_mib_counters(struct ath_hw *hal, struct ath5k_mib_stats *statistics);
 /* ACK/CTS Timeouts */
-extern bool ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout);
+extern int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout);
 extern unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal);
-extern bool ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout);
+extern int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout);
 extern unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal);
 /* Key table (WEP) functions */
 extern int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry);
@@ -971,7 +971,7 @@ extern int ath5k_hw_get_tx_queueprops(struct ath_hw *hal, int queue, struct ath5
 extern void ath5k_hw_release_tx_queue(struct ath_hw *hal, unsigned int queue);
 extern int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue);
 extern u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue);
-extern bool ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time);
+extern int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time);
 extern unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal);
 /* Hardware Descriptor Functions */
 extern int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc, u32 size, unsigned int flags);
@@ -987,9 +987,6 @@ extern u16 ath5k_get_regdomain(struct ath_hw *hal);
 /* Misc functions */
 extern void ath5k_hw_dump_state(struct ath_hw *hal);
 extern int ath5k_hw_get_capability(struct ath_hw *hal, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
-bool ath5k_hw_query_pspoll_support(struct ath_hw *hal);
-bool ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid, u16 assoc_id);
-bool ath5k_hw_disable_pspoll(struct ath_hw *hal);
 
 
 /* Initial register settings functions */
diff --git a/drivers/net/wireless/ath5k_base.c b/drivers/net/wireless/ath5k_base.c
index 4bbccf9..5ee36b5 100644
--- a/drivers/net/wireless/ath5k_base.c
+++ b/drivers/net/wireless/ath5k_base.c
@@ -577,7 +577,7 @@ static void ath_beacon_send(struct ath_softc *sc)
 	 * This should never fail since we check above that no frames
 	 * are still pending on the queue.
 	 */
-	if (unlikely(!ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
+	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
 		printk(KERN_WARNING "ath: beacon queue %u didn't stop?\n",
 				sc->bhalq);
 		/* NB: the HAL still stops DMA, so proceed */
diff --git a/drivers/net/wireless/ath5k_hw.c b/drivers/net/wireless/ath5k_hw.c
index d92da20..a15aa21 100644
--- a/drivers/net/wireless/ath5k_hw.c
+++ b/drivers/net/wireless/ath5k_hw.c
@@ -61,6 +61,9 @@ static int ath5k_hw_get_capabilities(struct ath_hw *);
 static int ath5k_eeprom_init(struct ath_hw *);
 static int ath5k_eeprom_read_mac(struct ath_hw *, u8 *);
 
+static int ath5k_hw_enable_pspoll(struct ath_hw *, u8 *, u16);
+static int ath5k_hw_disable_pspoll(struct ath_hw *);
+
 /*
  * Enable to overwrite the country code (use "00" for debug)
  */
@@ -1265,8 +1268,7 @@ int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue)
  * Stop DMA transmit for a specific queue
  * (see also QCU/DCU functions)
  */
-bool
-ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
+int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 {
 	unsigned int i = 100;
 	u32 tx_queue, pending;
@@ -1276,7 +1278,7 @@ ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 
 	/* Return if queue is declared inactive */
 	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
-		return false;
+		return -EIO;
 
 	if (hal->ah_version == AR5K_AR5210) {
 		tx_queue = ath5k_hw_reg_read(hal, AR5K_CR);
@@ -1295,7 +1297,7 @@ ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 			ath5k_hw_reg_write(hal, 0, AR5K_BSR);
 			break;
 		default:
-			return false;
+			return -EINVAL;
 		}
 
 		/* Stop queue */
@@ -1318,8 +1320,8 @@ ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 		ath5k_hw_reg_write(hal, 0, AR5K_QCU_TXD);
 	}
 
-	/* TODO: Check for success else return false */
-	return true;
+	/* TODO: Check for success else return error */
+	return 0;
 }
 
 /*
@@ -1404,11 +1406,10 @@ int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr)
 /*
  * Update tx trigger level
  */
-bool
-ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
+int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
 {
 	u32 trigger_level, imr;
-	bool status = false;
+	int ret = -EIO;
 
 	AR5K_TRACE;
 
@@ -1437,7 +1438,7 @@ ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
 		AR5K_REG_WRITE_BITS(hal, AR5K_TXCFG,
 				AR5K_TXCFG_TXFULL, trigger_level);
 
-	status = true;
+	ret = 0;
 
 done:
 	/*
@@ -1445,7 +1446,7 @@ done:
 	 */
 	ath5k_hw_set_intr(hal, imr);
 
-	return status;
+	return ret;
 }
 
 /*
@@ -2252,8 +2253,7 @@ static int ath5k_hw_get_capabilities(struct ath_hw *hal)
 /*
  * Set Operation mode
  */
-void
-ath5k_hw_set_opmode(struct ath_hw *hal)
+int ath5k_hw_set_opmode(struct ath_hw *hal)
 {
 	u32 pcu_reg, beacon_reg, low_id, high_id;
 
@@ -2288,7 +2288,7 @@ ath5k_hw_set_opmode(struct ath_hw *hal)
 		break;
 
 	default:
-		return;
+		return -EINVAL;
 	}
 
 	/*
@@ -2304,6 +2304,8 @@ ath5k_hw_set_opmode(struct ath_hw *hal)
 	 */
 	if (hal->ah_version == AR5K_AR5210)
 		ath5k_hw_reg_write(hal, beacon_reg, AR5K_BCR);
+
+	return 0;
 }
 
 /*
@@ -2322,8 +2324,7 @@ void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac)
 /*
  * Set station id
  */
-bool
-ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
+int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
 {
 	u32 low_id, high_id;
 
@@ -2337,14 +2338,13 @@ ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
 	ath5k_hw_reg_write(hal, low_id, AR5K_STA_ID0);
 	ath5k_hw_reg_write(hal, high_id, AR5K_STA_ID1);
 
-	return true;
+	return 0;
 }
 
 /*
  * Set BSSID
  */
-void
-ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
+void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
 {
 	u32 low_id, high_id;
 	u16 tim_offset = 0;
@@ -2381,8 +2381,7 @@ ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
 /*
  * Set BSSID mask on 5212
  */
-bool
-ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
+int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
 {
 	u32 low_id, high_id;
 	AR5K_TRACE;
@@ -2394,10 +2393,10 @@ ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
 		ath5k_hw_reg_write(hal, low_id, AR5K_BSS_IDM0);
 		ath5k_hw_reg_write(hal, high_id, AR5K_BSS_IDM1);
 
-		return true;
+		return 0;
 	}
 
-	return false;
+	return -EIO;
 }
 
 /*
@@ -2407,8 +2406,7 @@ ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
 /*
  * Start receive on PCU
  */
-void
-ath5k_hw_start_rx_pcu(struct ath_hw *hal)
+void ath5k_hw_start_rx_pcu(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 	AR5K_REG_DISABLE_BITS(hal, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
@@ -2417,8 +2415,7 @@ ath5k_hw_start_rx_pcu(struct ath_hw *hal)
 /*
  * Stop receive on PCU
  */
-void
-ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
+void ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 	AR5K_REG_ENABLE_BITS(hal, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
@@ -2431,8 +2428,7 @@ ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
 /*
  * Set multicast filter
  */
-void
-ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1)
+void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1)
 {
 	AR5K_TRACE;
 	/* Set the multicat filter */
@@ -2443,46 +2439,43 @@ ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1)
 /*
  * Set multicast filter by index
  */
-bool
-ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index)
+int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index)
 {
 
 	AR5K_TRACE;
 	if (index >= 64)
-		return false;
+		return -EINVAL;
 	else if (index >= 32)
 		AR5K_REG_ENABLE_BITS(hal, AR5K_MCAST_FILTER1,
 				(1 << (index - 32)));
 	else
 		AR5K_REG_ENABLE_BITS(hal, AR5K_MCAST_FILTER0, (1 << index));
 
-	return true;
+	return 0;
 }
 
 /*
  * Clear Multicast filter by index
  */
-bool
-ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index)
+int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index)
 {
 
 	AR5K_TRACE;
 	if (index >= 64)
-		return false;
+		return -EINVAL;
 	else if (index >= 32)
 		AR5K_REG_DISABLE_BITS(hal, AR5K_MCAST_FILTER1,
 				(1 << (index - 32)));
 	else
 		AR5K_REG_DISABLE_BITS(hal, AR5K_MCAST_FILTER0, (1 << index));
 
-	return true;
+	return 0;
 }
 
 /*
  * Get current rx filter
  */
-u32
-ath5k_hw_get_rx_filter(struct ath_hw *ah)
+u32 ath5k_hw_get_rx_filter(struct ath_hw *ah)
 {
 	u32 data, filter = 0;
 
@@ -2624,8 +2617,7 @@ void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
 /*
  * Set beacon timers
  */
-void
-ath5k_hw_set_beacon_timers(struct ath_hw *hal,
+int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 		const struct ath5k_beacon_state *state)
 {
 	u32 cfp_period, next_cfp, dtim, interval, next_beacon;
@@ -2645,7 +2637,7 @@ ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 	AR5K_TRACE;
 	/* Return on an invalid beacon state */
 	if (state->bs_interval < 1)
-		return;
+		return -EINVAL;
 
 	interval = state->bs_interval;
 	dtim = state->bs_dtim_period;
@@ -2725,7 +2717,7 @@ ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 			dtim = state->bs_sleep_duration;
 
 		if (interval > dtim)
-			return;
+			return -EINVAL;
 
 		next_beacon = interval == dtim ? state->bs_next_dtim :
 			state->bs_next_beacon;
@@ -2745,13 +2737,14 @@ ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 			AR5K_REG_SM(interval, AR5K_SLEEP2_TIM_PER) |
 			AR5K_REG_SM(dtim, AR5K_SLEEP2_DTIM_PER), AR5K_SLEEP2);
 	}
+
+	return 0;
 }
 
 /*
  * Reset beacon timers
  */
-void
-ath5k_hw_reset_beacon(struct ath_hw *hal)
+void ath5k_hw_reset_beacon(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 	/*
@@ -2771,11 +2764,10 @@ ath5k_hw_reset_beacon(struct ath_hw *hal)
  * Wait for beacon queue to finish
  * TODO: This function's name is misleading, rename
  */
-bool
-ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
+int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 {
 	unsigned int i;
-	bool ret;
+	int ret;
 
 	AR5K_TRACE;
 
@@ -2802,17 +2794,17 @@ ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 			ath5k_hw_reg_write(hal, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
 					AR5K_BCR);
 
-			return false;
+			return -EIO;
 		}
-		ret = true;
+		ret = 0;
 	} else {
 	/*5211/5212*/
 		ret = ath5k_hw_register_timeout(hal,
 			AR5K_QUEUE_STATUS(AR5K_TX_QUEUE_ID_BEACON),
-			AR5K_QCU_STS_FRMPENDCNT, 0, false) ? false : true;
+			AR5K_QCU_STS_FRMPENDCNT, 0, false);
 
 		if (AR5K_REG_READ_Q(hal, AR5K_QCU_TXE, AR5K_TX_QUEUE_ID_BEACON))
-			return false;
+			return -EIO;
 	}
 
 	return ret;
@@ -2821,8 +2813,7 @@ ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 /*
  * Update mib counters (statistics)
  */
-void
-ath5k_hw_update_mib_counters(struct ath_hw *hal,
+void ath5k_hw_update_mib_counters(struct ath_hw *hal,
 		struct ath5k_mib_stats *statistics)
 {
 	AR5K_TRACE;
@@ -2849,58 +2840,54 @@ ath5k_hw_update_mib_counters(struct ath_hw *hal,
 /*
  * Set ACK timeout on PCU
  */
-bool
-ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout)
+int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout)
 {
 	AR5K_TRACE;
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK),
 			hal->ah_turbo) <= timeout)
-		return false;
+		return -EINVAL;
 
 	AR5K_REG_WRITE_BITS(hal, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
 		ath5k_hw_htoclock(timeout, hal->ah_turbo));
 
-	return true;
+	return 0;
 }
 
 /*
  * Read the ACK timeout from PCU
  */
-unsigned int
-ath5k_hw_get_ack_timeout(struct ath_hw *hal)
+unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 
-	return (ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), hal->ah_turbo));
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), hal->ah_turbo);
 }
 
 /*
  * Set CTS timeout on PCU
  */
-bool
-ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout)
+int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout)
 {
 	AR5K_TRACE;
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS),
 			hal->ah_turbo) <= timeout)
-		return false;
+		return -EINVAL;
 
 	AR5K_REG_WRITE_BITS(hal, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
 			ath5k_hw_htoclock(timeout, hal->ah_turbo));
 
-	return true;
+	return 0;
 }
 
 /*
  * Read CTS timeout from PCU
  */
-unsigned int
-ath5k_hw_get_cts_timeout(struct ath_hw *hal)
+unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal)
 {
 	AR5K_TRACE;
-	return (ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), hal->ah_turbo));
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), hal->ah_turbo);
 }
 
 /*
@@ -3388,8 +3375,7 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
  * Get number of pending frames
  * for a specific queue [5211+]
  */
-u32
-ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
+u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
 	AR5K_TRACE;
 	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
 
@@ -3407,12 +3393,11 @@ ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
 /*
  * Set slot time
  */
-bool
-ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
+int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
 {
 	AR5K_TRACE;
 	if (slot_time < AR5K_SLOT_TIME_9 || slot_time > AR5K_SLOT_TIME_MAX)
-		return false;
+		return -EINVAL;
 
 	if (hal->ah_version == AR5K_AR5210)
 		ath5k_hw_reg_write(hal, ath5k_hw_htoclock(slot_time,
@@ -3420,19 +3405,18 @@ ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
 	else
 		ath5k_hw_reg_write(hal, slot_time, AR5K_DCU_GBL_IFS_SLOT);
 
-	return true;
+	return 0;
 }
 
 /*
  * Get slot time
  */
-unsigned int
-ath5k_hw_get_slot_time(struct ath_hw *hal)
+unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal)
 {
 	AR5K_TRACE;
 	if (hal->ah_version == AR5K_AR5210)
-		return (ath5k_hw_clocktoh(ath5k_hw_reg_read(hal,
-				AR5K_SLOT_TIME) & 0xffff, hal->ah_turbo));
+		return ath5k_hw_clocktoh(ath5k_hw_reg_read(hal,
+				AR5K_SLOT_TIME) & 0xffff, hal->ah_turbo);
 	else
 		return ath5k_hw_reg_read(hal, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
 }
@@ -4358,38 +4342,41 @@ yes:
 	return 0;
 }
 
-bool
-ath5k_hw_query_pspoll_support(struct ath_hw *hal)
+#if 0
+static bool ath5k_hw_query_pspoll_support(struct ath_hw *hal)
 {
 	AR5K_TRACE;
+
 	if (hal->ah_version == AR5K_AR5210)
-		return(true);
+		return true;
 
 	return false;
 }
+#endif
 
-bool
-ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid, u16 assoc_id)
+static int ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid,
+		u16 assoc_id)
 {
 	AR5K_TRACE;
+
 	if (hal->ah_version == AR5K_AR5210) {
 		AR5K_REG_DISABLE_BITS(hal, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
-		return true;
+		return 0;
 	}
 
-	return false;
+	return -EIO;
 }
 
-bool
-ath5k_hw_disable_pspoll(struct ath_hw *hal)
+static int ath5k_hw_disable_pspoll(struct ath_hw *hal)
 {
 	AR5K_TRACE;
+
 	if (hal->ah_version == AR5K_AR5210) {
 		AR5K_REG_ENABLE_BITS(hal, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
-		return true;
+		return 0;
 	}
 
-	return false;
+	return -EIO;
 }
