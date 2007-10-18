Return-Path: <linux-kernel-owner+w=401wt.eu-S1762430AbXJRI05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762430AbXJRI05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbXJRI0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:26:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57336 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbXJRI0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:26:38 -0400
Date: Thu, 18 Oct 2007 09:26:35 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iwl3945 & iwl4965: mark more functions/variables static
Message-ID: <20071018082635.GA10343@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Christoph Hellwig <hch@lst.de>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071012123258.GA20794@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012123258.GA20794@lst.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ping.

On Fri, Oct 12, 2007 at 02:32:58PM +0200, Christoph Hellwig wrote:
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-10-12 10:57:09.000000000 +0200
> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-10-12 10:59:47.000000000 +0200
> @@ -698,21 +698,6 @@ u8 iwl3945_sync_sta(struct iwl_priv *pri
>  	return sta_id;
>  }
>  
> -void iwl_hw_card_show_info(struct iwl_priv *priv)
> -{
> -	IWL_DEBUG_INFO("3945ABG HW Version %u.%u.%u\n",
> -		       ((priv->eeprom.board_revision >> 8) & 0x0F),
> -		       ((priv->eeprom.board_revision >> 8) >> 4),
> -		       (priv->eeprom.board_revision & 0x00FF));
> -
> -	IWL_DEBUG_INFO("3945ABG PBA Number %.*s\n",
> -		       (int)sizeof(priv->eeprom.board_pba_number),
> -		       priv->eeprom.board_pba_number);
> -
> -	IWL_DEBUG_INFO("EEPROM_ANTENNA_SWITCH_TYPE is 0x%02X\n",
> -		       priv->eeprom.antenna_switch_type);
> -}
> -
>  static int iwl3945_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
>  {
>  	int rc;
> @@ -1761,7 +1746,7 @@ void iwl3945_reg_txpower_periodic(struct
>  			   &priv->thermal_periodic, REG_RECALIB_PERIOD * HZ);
>  }
>  
> -void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
> +static void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
>  {
>  	struct iwl_priv *priv = container_of(work, struct iwl_priv,
>  					     thermal_periodic.work);
> Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.h
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-10-12 10:59:26.000000000 +0200
> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-10-12 10:59:29.000000000 +0200
> @@ -34,7 +34,6 @@ extern int iwl_eeprom_aqcuire_semaphore(
>  extern __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv);
>  extern int iwl3945_init_hw_rate_table(struct iwl_priv *priv);
>  extern void iwl3945_reg_txpower_periodic(struct iwl_priv *priv);
> -extern void iwl3945_bg_reg_txpower_periodic(struct work_struct *work);
>  extern int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv);
>  extern u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
>  		 u16 tx_rate, u8 flags);
> Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-10-12 10:57:28.000000000 +0200
> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-10-12 10:58:45.000000000 +0200
> @@ -45,6 +45,8 @@
>  #include "iwl-4965.h"
>  #include "iwl-helpers.h"
>  
> +static void iwl_hw_card_show_info(struct iwl_priv *priv);
> +
>  #define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
>  	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
>  				    IWL_RATE_SISO_##s##M_PLCP, \
> @@ -2750,7 +2752,7 @@ int iwl_hw_txq_attach_buf_to_tfd(struct 
>  	return 0;
>  }
>  
> -void iwl_hw_card_show_info(struct iwl_priv *priv)
> +static void iwl_hw_card_show_info(struct iwl_priv *priv)
>  {
>  	u16 hw_version = priv->eeprom.board_revision_4965;
>  
> Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-12 11:00:11.000000000 +0200
> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-12 11:06:06.000000000 +0200
> @@ -68,6 +68,9 @@
>  u32 iwl_debug_level;
>  #endif
>  
> +static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
> +				  struct iwl_tx_queue *txq);
> +
>  /******************************************************************************
>   *
>   * module boiler plate
> @@ -80,7 +83,7 @@ int iwl_param_debug;
>  int iwl_param_disable;      /* def: enable radio */
>  int iwl_param_antenna;      /* def: 0 = both antennas (use diversity) */
>  int iwl_param_hwcrypto;     /* def: using software encryption */
> -int iwl_param_qos_enable = 1;
> +static int iwl_param_qos_enable = 1;
>  int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
>  
>  /*
> @@ -118,7 +121,7 @@ MODULE_VERSION(DRV_VERSION);
>  MODULE_AUTHOR(DRV_COPYRIGHT);
>  MODULE_LICENSE("GPL");
>  
> -__le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
> +static __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
>  {
>  	u16 fc = le16_to_cpu(hdr->frame_control);
>  	int hdr_len = ieee80211_get_hdrlen(fc);
> @@ -694,7 +697,7 @@ static int iwl_enqueue_hcmd(struct iwl_p
>  	return ret ? ret : idx;
>  }
>  
> -int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
> +static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>  {
>  	int ret;
>  
> @@ -718,7 +721,7 @@ int iwl_send_cmd_async(struct iwl_priv *
>  	return 0;
>  }
>  
> -int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
> +static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>  {
>  	int cmd_idx;
>  	int ret;
> @@ -2198,7 +2201,7 @@ int iwl_is_network_packet(struct iwl_pri
>  
>  #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
>  
> -const char *iwl_get_tx_fail_reason(u32 status)
> +static const char *iwl_get_tx_fail_reason(u32 status)
>  {
>  	switch (status & TX_STATUS_MSK) {
>  	case TX_STATUS_SUCCESS:
> @@ -3354,7 +3357,7 @@ static void iwl_txstatus_to_ieee(struct 
>   * new 'R' index need to be reclaimed. As result, some free space
>   * forms. If there is enough free space (> low mark), wake Tx queue.
>   */
> -int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
> +static int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
>  {
>  	struct iwl_tx_queue *txq = &priv->txq[txq_id];
>  	struct iwl_queue *q = &txq->q;
> @@ -3994,7 +3997,7 @@ static inline __le32 iwl_dma_addr2rbd_pt
>   * also updates the memory address in the firmware to reference the new
>   * target buffer.
>   */
> -int iwl_rx_queue_restock(struct iwl_priv *priv)
> +static int iwl_rx_queue_restock(struct iwl_priv *priv)
>  {
>  	struct iwl_rx_queue *rxq = &priv->rxq;
>  	struct list_head *element;
> @@ -4084,7 +4087,7 @@ void iwl_rx_replenish(void *data)
>   * This free routine walks the list of POOL entries and if SKB is set to
>   * non NULL it is unmapped and freed
>   */
> -void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
> +static void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
>  {
>  	int i;
>  	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
> @@ -4327,7 +4330,7 @@ static void iwl_rx_handle(struct iwl_pri
>  	iwl_rx_queue_restock(priv);
>  }
>  
> -int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
> +static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
>  				  struct iwl_tx_queue *txq)
>  {
>  	u32 reg = 0;
> Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-12 11:01:10.000000000 +0200
> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-12 11:06:19.000000000 +0200
> @@ -68,6 +68,9 @@
>  u32 iwl_debug_level;
>  #endif
>  
> +static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
> +				  struct iwl_tx_queue *txq);
> +
>  /******************************************************************************
>   *
>   * module boiler plate
> @@ -80,7 +83,7 @@ int iwl_param_debug;
>  int iwl_param_disable;      /* def: enable radio */
>  int iwl_param_antenna;      /* def: 0 = both antennas (use diversity) */
>  int iwl_param_hwcrypto;     /* def: using software encryption */
> -int iwl_param_qos_enable = 1;
> +static int iwl_param_qos_enable = 1;
>  int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
>  
>  /*
> @@ -694,7 +697,7 @@ static int iwl_enqueue_hcmd(struct iwl_p
>  	return ret ? ret : idx;
>  }
>  
> -int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
> +static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>  {
>  	int ret;
>  
> @@ -718,7 +721,7 @@ int iwl_send_cmd_async(struct iwl_priv *
>  	return 0;
>  }
>  
> -int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
> +static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>  {
>  	int cmd_idx;
>  	int ret;
> @@ -2274,7 +2277,7 @@ int iwl_is_network_packet(struct iwl_pri
>  
>  #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
>  
> -const char *iwl_get_tx_fail_reason(u32 status)
> +static const char *iwl_get_tx_fail_reason(u32 status)
>  {
>  	switch (status & TX_STATUS_MSK) {
>  	case TX_STATUS_SUCCESS:
> @@ -4315,7 +4318,7 @@ static inline __le32 iwl_dma_addr2rbd_pt
>   * also updates the memory address in the firmware to reference the new
>   * target buffer.
>   */
> -int iwl_rx_queue_restock(struct iwl_priv *priv)
> +static int iwl_rx_queue_restock(struct iwl_priv *priv)
>  {
>  	struct iwl_rx_queue *rxq = &priv->rxq;
>  	struct list_head *element;
> @@ -4405,7 +4408,7 @@ void iwl_rx_replenish(void *data)
>   * This free routine walks the list of POOL entries and if SKB is set to
>   * non NULL it is unmapped and freed
>   */
> -void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
> +static void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
>  {
>  	int i;
>  	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
> @@ -4651,7 +4654,7 @@ static void iwl_rx_handle(struct iwl_pri
>  	iwl_rx_queue_restock(priv);
>  }
>  
> -int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
> +static int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
>  				  struct iwl_tx_queue *txq)
>  {
>  	u32 reg = 0;
> Index: linux-2.6/drivers/net/wireless/iwlwifi/iwlwifi.h
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwlwifi.h	2007-10-12 10:58:56.000000000 +0200
> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwlwifi.h	2007-10-12 11:07:09.000000000 +0200
> @@ -87,7 +87,6 @@ extern int iwl_param_mode;
>  extern int iwl_param_disable;
>  extern int iwl_param_antenna;
>  extern int iwl_param_hwcrypto;
> -extern int iwl_param_qos_enable;
>  extern int iwl_param_queues_num;
>  
>  enum iwl_antenna {
> @@ -580,7 +579,6 @@ struct iwl_driver_hw_info {
>  struct iwl_addsta_cmd;
>  extern int iwl_send_add_station(struct iwl_priv *priv,
>  				struct iwl_addsta_cmd *sta, u8 flags);
> -extern const char *iwl_get_tx_fail_reason(u32 status);
>  extern u8 iwl_add_station(struct iwl_priv *priv, const u8 *bssid,
>  			  int is_ap, u8 flags);
>  extern int iwl_is_network_packet(struct iwl_priv *priv,
> @@ -597,8 +595,6 @@ static inline void iwl_report_frame(stru
>  				    struct ieee80211_hdr *header,
>  				    int group100) {}
>  #endif
> -extern int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
> -					 struct iwl_tx_queue *txq);
>  extern void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
>  					   struct iwl_rx_mem_buffer *rxb,
>  					   void *data, short len,
> @@ -606,7 +602,6 @@ extern void iwl_handle_data_packet_monit
>  					   u16 phy_flags);
>  extern int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr
>  			       *header);
> -extern void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
>  extern int iwl_rx_queue_alloc(struct iwl_priv *priv);
>  extern void iwl_rx_queue_reset(struct iwl_priv *priv,
>  			       struct iwl_rx_queue *rxq);
> @@ -614,15 +609,10 @@ extern int iwl_calc_db_from_ratio(int si
>  extern int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm);
>  extern int iwl_tx_queue_init(struct iwl_priv *priv,
>  			     struct iwl_tx_queue *txq, int count, u32 id);
> -extern int iwl_rx_queue_restock(struct iwl_priv *priv);
>  extern void iwl_rx_replenish(void *data);
>  extern void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
>  extern int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
>  			    const void *data);
> -extern int __must_check iwl_send_cmd_async(struct iwl_priv *priv,
> -		struct iwl_host_cmd *cmd);
> -extern int __must_check iwl_send_cmd_sync(struct iwl_priv *priv,
> -		struct iwl_host_cmd *cmd);
>  extern int __must_check iwl_send_cmd(struct iwl_priv *priv,
>  		struct iwl_host_cmd *cmd);
>  extern unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
> @@ -634,7 +624,9 @@ extern int iwl_send_statistics_request(s
>  extern void iwl_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
>  				   u32 decrypt_res,
>  				   struct ieee80211_rx_status *stats);
> +#if IWL == 4965
>  extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
> +#endif
>  
>  extern const u8 BROADCAST_ADDR[ETH_ALEN];
>  
> @@ -672,7 +664,6 @@ extern void iwl_hw_cancel_deferred_work(
>  extern int iwl_hw_rxq_stop(struct iwl_priv *priv);
>  extern int iwl_hw_set_hw_setting(struct iwl_priv *priv);
>  extern int iwl_hw_nic_init(struct iwl_priv *priv);
> -extern void iwl_hw_card_show_info(struct iwl_priv *priv);
>  extern int iwl_hw_nic_stop_master(struct iwl_priv *priv);
>  extern void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
>  extern void iwl_hw_txq_ctx_stop(struct iwl_priv *priv);
> @@ -709,5 +700,7 @@ extern int iwl4965_get_temperature(const
>  extern u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
>  
>  extern int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel);
> +#if IWL == 4965
>  extern int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
>  #endif
> +#endif
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
