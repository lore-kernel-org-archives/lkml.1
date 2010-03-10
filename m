Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0CJLh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:37:27 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36376 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab0CJLhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:37:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TZiVFElCj8JJ18wST+PDn6Eg95B4pb6zvbcsARXncz2rZZhkda1+I7ctAo8wFmia4v
         lmVZfaXRJfqrP9YW4HZnPPwTZLK0YmjDFdG+hpQdYFqcDn+3fJyp/yUstkRiN4J5eQ2a
         hfrUjoyCXbn0oJoIJu3NrSPYwMSoJOaichrLQ=
From: John D Sheehan <john.d.sheehan@gmail.com>
To: gregkh@suse.de, davem@davemloft.net, jpirko@redhat.com,
       linville@tuxdriver.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       John Sheehan <john.d.sheehan@gmail.com>
Subject: [PATCH] Staging: arlan: fix errors reported by checkpatch.pl tool
Date: Wed, 10 Mar 2010 11:36:52 +0000
Message-Id: <1268221012-20457-1-git-send-email-john.d.sheehan@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sheehan <john.d.sheehan@gmail.com>

fix all but one of the errors reported by checkpatch.pl tool.
Errors included wayward braces, white space issues(trailing
and prohibited), C99 issues, and foo* issues

Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
---
 drivers/staging/arlan/arlan-main.c |  935 ++++++++++++++++--------------------
 1 files changed, 409 insertions(+), 526 deletions(-)

diff --git a/drivers/staging/arlan/arlan-main.c b/drivers/staging/arlan/arlan-main.c
index 88fdd53..58deb96 100644
--- a/drivers/staging/arlan/arlan-main.c
+++ b/drivers/staging/arlan/arlan-main.c
@@ -80,15 +80,14 @@ static  int 	arlan_open(struct net_device *dev);
 static  netdev_tx_t arlan_tx(struct sk_buff *skb, struct net_device *dev);
 static  irqreturn_t arlan_interrupt(int irq, void *dev_id);
 static  int 	arlan_close(struct net_device *dev);
-static  struct net_device_stats *
-		arlan_statistics		(struct net_device *dev);
-static  void 	arlan_set_multicast		(struct net_device *dev);
-static  int 	arlan_hw_tx			(struct net_device* dev, char *buf, int length );
-static  int	arlan_hw_config			(struct net_device * dev);
-static  void 	arlan_tx_done_interrupt		(struct net_device * dev, int status);
-static  void	arlan_rx_interrupt		(struct net_device * dev, u_char rxStatus, u_short, u_short);
-static  void	arlan_process_interrupt		(struct net_device * dev);
-static	void	arlan_tx_timeout		(struct net_device *dev);
+static  struct net_device_stats *arlan_statistics(struct net_device *dev);
+static  void 	arlan_set_multicast(struct net_device *dev);
+static  int 	arlan_hw_tx(struct net_device *dev, char *buf, int length);
+static  int	arlan_hw_config(struct net_device *dev);
+static  void 	arlan_tx_done_interrupt(struct net_device *dev, int status);
+static  void	arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short, u_short);
+static  void	arlan_process_interrupt(struct net_device *dev);
+static	void	arlan_tx_timeout(struct net_device *dev);
 
 static inline long us2ticks(int us)
 {
@@ -102,14 +101,14 @@ static inline long us2ticks(int us)
 	struct timeval timev;\
 	do_gettimeofday(&timev);\
 		if (arlan_entry_debug || arlan_entry_and_exit_debug)\
-			printk("--->>>" name " %ld " "\n",((long int) timev.tv_sec * 1000000 + timev.tv_usec));\
+			printk("--->>>" name " %ld " "\n", ((long int) timev.tv_sec * 1000000 + timev.tv_usec));\
 	}
 #define ARLAN_DEBUG_EXIT(name) \
 	{\
 	struct timeval timev;\
 	do_gettimeofday(&timev);\
 		if (arlan_exit_debug || arlan_entry_and_exit_debug)\
-			printk("<<<---" name " %ld " "\n",((long int) timev.tv_sec * 1000000 + timev.tv_usec) );\
+			printk("<<<---" name " %ld " "\n", ((long int) timev.tv_sec * 1000000 + timev.tv_usec));\
 	}
 #else
 #define ARLAN_DEBUG_ENTRY(name)
@@ -118,8 +117,8 @@ static inline long us2ticks(int us)
 
 
 #define arlan_interrupt_ack(dev)\
-        clearClearInterrupt(dev);\
-        setClearInterrupt(dev);
+		clearClearInterrupt(dev);\
+		setClearInterrupt(dev);
 
 static inline int arlan_drop_tx(struct net_device *dev)
 {
@@ -127,18 +126,15 @@ static inline int arlan_drop_tx(struct net_device *dev)
 
 	dev->stats.tx_errors++;
 	if (priv->Conf->tx_delay_ms)
-	{
 		priv->tx_done_delayed = jiffies + priv->Conf->tx_delay_ms * HZ / 1000 + 1;
-	}
-	else
-	{
+	else {
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_TX;
 		TXHEAD(dev).offset = 0;
 		TXTAIL(dev).offset = 0;
 		priv->txLast = 0;
 		priv->bad = 0;
 		if (!priv->under_reset && !priv->under_config)
-			netif_wake_queue (dev);
+			netif_wake_queue(dev);
 	}
 	return 1;
 }
@@ -169,13 +165,11 @@ int arlan_command(struct net_device *dev, int command_p)
 		if (time_after(jiffies, priv->lastReset + 5 * HZ))
 			priv->waiting_command_mask &= ~ARLAN_COMMAND_RESET;
 
-	if (priv->waiting_command_mask & ARLAN_COMMAND_INT_ACK)
-	{
+	if (priv->waiting_command_mask & ARLAN_COMMAND_INT_ACK) {
 		arlan_interrupt_ack(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_INT_ACK;
 	}
-	if (priv->waiting_command_mask & ARLAN_COMMAND_INT_ENABLE)
-	{
+	if (priv->waiting_command_mask & ARLAN_COMMAND_INT_ENABLE) {
 		setInterruptEnable(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_INT_ENABLE;
 	}
@@ -185,12 +179,10 @@ int arlan_command(struct net_device *dev, int command_p)
 
 	/* Check cards status and waiting */
 
-	if (priv->waiting_command_mask & (ARLAN_COMMAND_LONG_WAIT_NOW | ARLAN_COMMAND_WAIT_NOW))
-	{
-		while (priv->waiting_command_mask & (ARLAN_COMMAND_LONG_WAIT_NOW | ARLAN_COMMAND_WAIT_NOW))
-		{
+	if (priv->waiting_command_mask & (ARLAN_COMMAND_LONG_WAIT_NOW | ARLAN_COMMAND_WAIT_NOW)) {
+		while (priv->waiting_command_mask & (ARLAN_COMMAND_LONG_WAIT_NOW | ARLAN_COMMAND_WAIT_NOW)) {
 			if (READSHMB(arlan->resetFlag) ||
-				READSHMB(arlan->commandByte))	/* || 
+				READSHMB(arlan->commandByte))	/* ||
 								   (readControlRegister(dev) & ARLAN_ACCESS))
 								 */
 				udelay(40);
@@ -199,27 +191,20 @@ int arlan_command(struct net_device *dev, int command_p)
 
 			udelayed++;
 
-			if (priv->waiting_command_mask & ARLAN_COMMAND_LONG_WAIT_NOW)
-			{
-				if (udelayed * 40 > 1000000)
-				{
+			if (priv->waiting_command_mask & ARLAN_COMMAND_LONG_WAIT_NOW) {
+				if (udelayed * 40 > 1000000) {
 					printk(KERN_ERR "%s long wait too long \n", dev->name);
 					priv->waiting_command_mask |= ARLAN_COMMAND_RESET;
 					break;
 				}
-			}
-			else if (priv->waiting_command_mask & ARLAN_COMMAND_WAIT_NOW)
-			{
-				if (udelayed * 40 > 1000)
-				{
+			} else if (priv->waiting_command_mask & ARLAN_COMMAND_WAIT_NOW) {
+				if (udelayed * 40 > 1000) {
 					printk(KERN_ERR "%s short wait too long \n", dev->name);
 					goto bad_end;
 				}
 			}
 		}
-	}
-	else
-	{
+	} else {
 		i = 0;
 		while ((READSHMB(arlan->resetFlag) ||
 			READSHMB(arlan->commandByte)) &&
@@ -230,9 +215,7 @@ int arlan_command(struct net_device *dev, int command_p)
 		if ((READSHMB(arlan->resetFlag) ||
 			READSHMB(arlan->commandByte)) &&
 			!(priv->waiting_command_mask & ARLAN_COMMAND_RESET))
-		{
 			goto card_busy_end;
-		}
 	}
 	if (priv->waiting_command_mask & ARLAN_COMMAND_RESET)
 		priv->under_reset = 1;
@@ -241,55 +224,43 @@ int arlan_command(struct net_device *dev, int command_p)
 
 	/* Issuing command */
 	arlan_lock_card_access(dev);
-	if (priv->waiting_command_mask & ARLAN_COMMAND_POWERUP)
-	{
-	//     if (readControlRegister(dev) & (ARLAN_ACCESS && ARLAN_POWER))
+	if (priv->waiting_command_mask & ARLAN_COMMAND_POWERUP) {
+		/* if (readControlRegister(dev) & (ARLAN_ACCESS && ARLAN_POWER)) */
 		setPowerOn(dev);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_POWERUP;
 		priv->waiting_command_mask |= ARLAN_COMMAND_RESET;
 		priv->card_polling_interval = HZ / 10;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_ACTIVATE)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_ACTIVATE) {
 		WRITESHMB(arlan->commandByte, ARLAN_COM_ACTIVATE);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_ACTIVATE;
 		priv->card_polling_interval = HZ / 10;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_RX_ABORT)
-	{
-		if (priv->rx_command_given)
-		{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_RX_ABORT) {
+		if (priv->rx_command_given) {
 			WRITESHMB(arlan->commandByte, ARLAN_COM_RX_ABORT);
 			arlan_interrupt_lancpu(dev);
 			priv->rx_command_given = 0;
 		}
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_RX_ABORT;
 		priv->card_polling_interval = 1;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_TX_ABORT)
-	{
-		if (priv->tx_command_given)
-		{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_TX_ABORT) {
+		if (priv->tx_command_given) {
 			WRITESHMB(arlan->commandByte, ARLAN_COM_TX_ABORT);
 			arlan_interrupt_lancpu(dev);
 			priv->tx_command_given = 0;
 		}
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_TX_ABORT;
 		priv->card_polling_interval = 1;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_RESET)
-	{
-		priv->under_reset=1;
-		netif_stop_queue (dev);
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_RESET) {
+		priv->under_reset = 1;
+		netif_stop_queue(dev);
 
 		arlan_drop_tx(dev);
 		if (priv->tx_command_given || priv->rx_command_given)
-		{
 			printk(KERN_ERR "%s: Reset under tx or rx command \n", dev->name);
-		}
-		netif_stop_queue (dev);
+
+		netif_stop_queue(dev);
 		if (arlan_debug & ARLAN_DEBUG_RESET)
 			printk(KERN_ERR "%s: Doing chip reset\n", dev->name);
 		priv->lastReset = jiffies;
@@ -303,11 +274,9 @@ int arlan_command(struct net_device *dev, int command_p)
 		priv->card_polling_interval = HZ / 4;
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_RESET;
 		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK;
-//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RENABLE; 
-//		priv->waiting_command_mask |= ARLAN_COMMAND_RX;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RACK)
-	{
+		/* priv->waiting_command_mask |= ARLAN_COMMAND_INT_RENABLE; */
+		/* priv->waiting_command_mask |= ARLAN_COMMAND_RX; */
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RACK) {
 		clearHardwareReset(dev);
 		clearClearInterrupt(dev);
 		setClearInterrupt(dev);
@@ -316,126 +285,94 @@ int arlan_command(struct net_device *dev, int command_p)
 		priv->waiting_command_mask |= ARLAN_COMMAND_CONF;
 		priv->under_config = 1;
 		priv->under_reset = 0;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RENABLE)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_INT_RENABLE) {
 		setInterruptEnable(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_INT_RENABLE;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF) {
 		if (priv->tx_command_given || priv->rx_command_given)
-		{
 			printk(KERN_ERR "%s: Reset under tx or rx command \n", dev->name);
-		}
+
 		arlan_drop_tx(dev);
 		setInterruptEnable(dev);
 		arlan_hw_config(dev);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_CONF;
 		priv->card_polling_interval = HZ / 10;
-//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK;   
-//		priv->waiting_command_mask |= ARLAN_COMMAND_INT_ENABLE; 
+		/* priv->waiting_command_mask |= ARLAN_COMMAND_INT_RACK; */
+		/* priv->waiting_command_mask |= ARLAN_COMMAND_INT_ENABLE; */
 		priv->waiting_command_mask |= ARLAN_COMMAND_CONF_WAIT;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF_WAIT)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_CONF_WAIT) {
 		if (READSHMB(arlan->configuredStatusFlag) != 0 &&
-			READSHMB(arlan->diagnosticInfo) == 0xff)
-		{
+			READSHMB(arlan->diagnosticInfo) == 0xff) {
 			priv->waiting_command_mask &= ~ARLAN_COMMAND_CONF_WAIT;
 			priv->waiting_command_mask |= ARLAN_COMMAND_RX;
 			priv->waiting_command_mask |= ARLAN_COMMAND_TBUSY_CLEAR;
 			priv->card_polling_interval = HZ / 10;
 			priv->tx_command_given = 0;
 			priv->under_config = 0;
-		}
-		else
-		{
+		} else {
 			priv->card_polling_interval = 1;
 			if (arlan_debug & ARLAN_DEBUG_TIMING)
 				printk(KERN_ERR "configure delayed \n");
 		}
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_RX)
-	{
-		if (!registrationBad(dev))
-		{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_RX) {
+		if (!registrationBad(dev)) {
 			setInterruptEnable(dev);
 			memset_io(arlan->commandParameter, 0, 0xf);
 			WRITESHMB(arlan->commandByte, ARLAN_COM_INT | ARLAN_COM_RX_ENABLE);
 			WRITESHMB(arlan->commandParameter[0], conf->rxParameter);
 			arlan_interrupt_lancpu(dev);
-			priv->rx_command_given = 0; // mnjah, bad
+			priv->rx_command_given = 0; /* mnjah, bad */
 			priv->waiting_command_mask &= ~ARLAN_COMMAND_RX;
 			priv->card_polling_interval = 1;
-		}
-		else
+		} else
 			priv->card_polling_interval = 2;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_TBUSY_CLEAR)
-	{
-		if ( !registrationBad(dev) &&
-		     (netif_queue_stopped(dev) || !netif_running(dev)) )
-			{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_TBUSY_CLEAR) {
+		if (!registrationBad(dev) &&
+		     (netif_queue_stopped(dev) || !netif_running(dev))) {
 				priv->waiting_command_mask &= ~ARLAN_COMMAND_TBUSY_CLEAR;
-				netif_wake_queue (dev);
+				netif_wake_queue(dev);
 			}
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_TX)
-	{
-		if (!test_and_set_bit(0, (void *) &priv->tx_command_given))
-		{
-			if (time_after(jiffies, 
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_TX) {
+		if (!test_and_set_bit(0, (void *) &priv->tx_command_given)) {
+			if (time_after(jiffies,
 				       priv->tx_last_sent + us2ticks(conf->rx_tweak1))
 			    || time_before(jiffies,
-					   priv->last_rx_int_ack_time + us2ticks(conf->rx_tweak2)))
-			{
+					   priv->last_rx_int_ack_time + us2ticks(conf->rx_tweak2))) {
 				setInterruptEnable(dev);
 				memset_io(arlan->commandParameter, 0, 0xf);
 				WRITESHMB(arlan->commandByte, ARLAN_COM_TX_ENABLE | ARLAN_COM_INT);
 				memcpy_toio(arlan->commandParameter, &TXLAST(dev), 14);
-//				for ( i=1 ; i < 15 ; i++) printk("%02x:",READSHMB(arlan->commandParameter[i]));
+				/* for ( i=1 ; i < 15 ; i++) printk("%02x:",READSHMB(arlan->commandParameter[i])); */
 				priv->tx_last_sent = jiffies;
 				arlan_interrupt_lancpu(dev);
 				priv->tx_command_given = 1;
 				priv->waiting_command_mask &= ~ARLAN_COMMAND_TX;
 				priv->card_polling_interval = 1;
-			}
-			else
-			{
+			} else {
 				priv->tx_command_given = 0;
 				priv->card_polling_interval = 1;
 			}
-		} 
-		else if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
+		} else if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
 			printk(KERN_ERR "tx command when tx chain locked \n");
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_NOOPINT)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_NOOPINT) {
 		{
 			WRITESHMB(arlan->commandByte, ARLAN_COM_NOP | ARLAN_COM_INT);
 		}
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_NOOPINT;
 		priv->card_polling_interval = HZ / 3;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_NOOP)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_NOOP) {
 		WRITESHMB(arlan->commandByte, ARLAN_COM_NOP);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_NOOP;
 		priv->card_polling_interval = HZ / 3;
-	}
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_SLOW_POLL)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_SLOW_POLL) {
 		WRITESHMB(arlan->commandByte, ARLAN_COM_GOTO_SLOW_POLL);
 		arlan_interrupt_lancpu(dev);
 		priv->waiting_command_mask &= ~ARLAN_COMMAND_SLOW_POLL;
 		priv->card_polling_interval = HZ / 3;
-	} 
-	else if (priv->waiting_command_mask & ARLAN_COMMAND_POWERDOWN)
-	{
+	} else if (priv->waiting_command_mask & ARLAN_COMMAND_POWERDOWN) {
 		setPowerOff(dev);
 		if (arlan_debug & ARLAN_DEBUG_CARD_STATE)
 			printk(KERN_WARNING "%s: Arlan Going Standby\n", dev->name);
@@ -478,10 +415,8 @@ static inline void arlan_command_process(struct net_device *dev)
 	struct arlan_private *priv = netdev_priv(dev);
 
 	int times = 0;
-	while (priv->waiting_command_mask && times < 8)
-	{
-		if (priv->waiting_command_mask)
-		{
+	while (priv->waiting_command_mask && times < 8) {
+		if (priv->waiting_command_mask) {
 			if (arlan_command(dev, 0))
 				break;
 			times++;
@@ -500,24 +435,17 @@ static inline void arlan_retransmit_now(struct net_device *dev)
 
 
 	ARLAN_DEBUG_ENTRY("arlan_retransmit_now");
-	if (TXLAST(dev).offset == 0)
-	{
-		if (TXHEAD(dev).offset)
-		{
+	if (TXLAST(dev).offset == 0) {
+		if (TXHEAD(dev).offset) {
 			priv->txLast = 0;
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_DEBUG "TX buff switch to head \n");
-
-		}
-		else if (TXTAIL(dev).offset)
-		{
+		} else if (TXTAIL(dev).offset) {
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_DEBUG "TX buff switch to tail \n");
 			priv->txLast = 1;
-		}
-		else
+		} else
 			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) printk(KERN_ERR "ReTransmit buff empty");
-		netif_wake_queue (dev);
+		netif_wake_queue(dev);
 		return;
-
 	}
 	arlan_command(dev, ARLAN_COMMAND_TX);
 
@@ -540,78 +468,71 @@ static void arlan_registration_timer(unsigned long data)
 	long lostTime = ((long)jiffies - (long)priv->registrationLastSeen)
 			* (1000/HZ);
 
-	if (registrationBad(dev))
-	{
+	if (registrationBad(dev)) {
 		priv->registrationLostCount++;
 		if (lostTime > 7000 && lostTime < 7200)
-		{
 			printk(KERN_NOTICE "%s registration Lost \n", dev->name);
-		}
+
 		if (lostTime / priv->reRegisterExp > 2000)
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_CONF);
 		if (lostTime / (priv->reRegisterExp) > 3500)
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
 		if (priv->reRegisterExp < 400)
 			priv->reRegisterExp += 2;
-		if (lostTime > 7200)
-		{
+		if (lostTime > 7200) {
 			next_tick = HZ;
 			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
 		}
-	}
-	else
-	{
+	} else {
 		if (priv->Conf->registrationMode && lostTime > 10000 &&
-			priv->registrationLostCount)
-		{
+			priv->registrationLostCount) {
 			printk(KERN_NOTICE "%s registration is back after %ld milliseconds\n",
 			       dev->name, lostTime);
 		}
 		priv->registrationLastSeen = jiffies;
 		priv->registrationLostCount = 0;
 		priv->reRegisterExp = 1;
-		if (!netif_running(dev) )
+		if (!netif_running(dev))
 			netif_wake_queue(dev);
-		if (time_after(priv->tx_last_sent,priv->tx_last_cleared) &&
-		    time_after(jiffies, priv->tx_last_sent * 5*HZ) ){
-			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);		
+		if (time_after(priv->tx_last_sent, priv->tx_last_cleared) &&
+		    time_after(jiffies, priv->tx_last_sent * 5*HZ)) {
+			arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
 			priv->tx_last_cleared = jiffies;
 		}
 	}
 
 
-	if (!registrationBad(dev) && priv->ReTransmitRequested)
-	{
+	if (!registrationBad(dev) && priv->ReTransmitRequested) {
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 			printk(KERN_ERR "Retransmit from timer \n");
 		priv->ReTransmitRequested = 0;
 		arlan_retransmit_now(dev);
 	}
+
 	if (!registrationBad(dev) &&
 		time_after(jiffies, priv->tx_done_delayed) &&
-		priv->tx_done_delayed != 0)
-	{
+		priv->tx_done_delayed != 0) {
 		TXLAST(dev).offset = 0;
+
 		if (priv->txLast)
 			priv->txLast = 0;
 		else if (TXTAIL(dev).offset)
 			priv->txLast = 1;
-		if (TXLAST(dev).offset)
-		{
+		if (TXLAST(dev).offset) {
 			arlan_retransmit_now(dev);
 			dev->trans_start = jiffies;
 		}
+
 		if (!(TXHEAD(dev).offset && TXTAIL(dev).offset))
-		{
-			netif_wake_queue (dev);
-		}
+			netif_wake_queue(dev);
+
 		priv->tx_done_delayed = 0;
 		bh_mark_needed = 1;
 	}
+
 	if (bh_mark_needed)
-	{
-		netif_wake_queue (dev);
-	}
+		netif_wake_queue(dev);
+
 	arlan_process_interrupt(dev);
 
 	if (next_tick < priv->card_polling_interval)
@@ -672,8 +593,7 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 		tailStarts = 0x800 - (((TXTAIL(dev).offset - offsetof(struct arlan_shmem, txBuffer)) / 64) + 2) * 64;
 
 
-	if (!TXHEAD(dev).offset && length < tailStarts)
-	{
+	if (!TXHEAD(dev).offset && length < tailStarts) {
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 			printk(KERN_ERR "TXHEAD insert, tailStart %d\n", tailStarts);
 
@@ -687,9 +607,7 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 		TXHEAD(dev).routing = conf->txRouting;
 		TXHEAD(dev).scrambled = conf->txScrambled;
 		memcpy_toio((char __iomem *)arlan + TXHEAD(dev).offset, buf + ARLAN_FAKE_HDR_LEN, TXHEAD(dev).length);
-	}
-	else if (!TXTAIL(dev).offset && length < (0x800 - headEnds))
-	{
+	} else if (!TXTAIL(dev).offset && length < (0x800 - headEnds)) {
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 			printk(KERN_ERR "TXTAIL insert, headEnd %d\n", headEnds);
 
@@ -703,10 +621,8 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 		TXTAIL(dev).routing = conf->txRouting;
 		TXTAIL(dev).scrambled = conf->txScrambled;
 		memcpy_toio(((char __iomem *)arlan + TXTAIL(dev).offset), buf + ARLAN_FAKE_HDR_LEN, TXTAIL(dev).length);
-	}
-	else
-	{
-		netif_stop_queue (dev);
+	} else {
+		netif_stop_queue(dev);
 		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
 			printk(KERN_ERR "TX TAIL & HEAD full, return, tailStart %d headEnd %d\n", tailStarts, headEnds);
 		return -1;
@@ -715,26 +631,23 @@ static int arlan_hw_tx(struct net_device *dev, char *buf, int length)
 	priv->out_bytes10 += length;
 	if (conf->measure_rate < 1)
 		conf->measure_rate = 1;
-	if (time_after(jiffies, priv->out_time + conf->measure_rate * HZ))
-	{
+	if (time_after(jiffies, priv->out_time + conf->measure_rate * HZ)) {
 		conf->out_speed = priv->out_bytes / conf->measure_rate;
 		priv->out_bytes = 0;
 		priv->out_time = jiffies;
 	}
-	if (time_after(jiffies, priv->out_time10 + conf->measure_rate * 10*HZ))
-	{
+
+	if (time_after(jiffies, priv->out_time10 + conf->measure_rate * 10*HZ)) {
 		conf->out_speed10 = priv->out_bytes10 / (10 * conf->measure_rate);
 		priv->out_bytes10 = 0;
 		priv->out_time10 = jiffies;
 	}
-	if (TXHEAD(dev).offset && TXTAIL(dev).offset)
-	{
-		netif_stop_queue (dev);
-		return 0;
-	}
-	else
-		netif_start_queue (dev);
 
+	if (TXHEAD(dev).offset && TXTAIL(dev).offset) {
+		netif_stop_queue(dev);
+		return 0;
+	} else
+		netif_start_queue(dev);
 
 	IFDEBUG(ARLAN_DEBUG_HEADER_DUMP)
 		printk(KERN_WARNING "%s Transmit t %2x:%2x:%2x:%2x:%2x:%2x f %2x:%2x:%2x:%2x:%2x:%2x \n", dev->name,
@@ -817,11 +730,11 @@ static int arlan_hw_config(struct net_device *dev)
 	WRITESHMB(arlan->commandByte, ARLAN_COM_INT | ARLAN_COM_CONF);	/* do configure */
 	memset_io(arlan->commandParameter, 0, 0xf);	/* 0xf */
 	memset_io(arlan->commandParameter + 1, 0, 2);
-	if (conf->writeEEPROM)
-	{
-		  memset_io(arlan->commandParameter, conf->writeEEPROM, 1);
-//		conf->writeEEPROM=0;
+	if (conf->writeEEPROM) {
+		memset_io(arlan->commandParameter, conf->writeEEPROM, 1);
+		/* conf->writeEEPROM=0; */
 	}
+
 	if (conf->registrationMode && conf->registrationInterrupts)
 		memset_io(arlan->commandParameter + 3, 1, 1);
 	else
@@ -847,47 +760,46 @@ static int arlan_read_card_configuration(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_read_card_configuration");
 
-	if (radioNodeId == radioNodeIdUNKNOWN)
-	{
+
+	if (radioNodeId == radioNodeIdUNKNOWN) {
+		/* multiline macro, cannot remove braces */
 		READSHM(conf->radioNodeId, arlan->radioNodeId, u_short);
-	}
-	else
+	} else
 		conf->radioNodeId = radioNodeId;
-		
-	if (SID == SIDUNKNOWN)
-	{
+
+	if (SID == SIDUNKNOWN) {
+		/* multiline macro, cannot remove braces */
 		READSHM(conf->SID, arlan->SID, u_int);
-	}
-	else conf->SID = SID;
-		
-	if (spreadingCode == spreadingCodeUNKNOWN)
-	{
-		  READSHM(conf->spreadingCode, arlan->spreadingCode, u_char);
-	}
-	else
+	} else
+		conf->SID = SID;
+
+	if (spreadingCode == spreadingCodeUNKNOWN) {
+		/* multiline macro, cannot remove braces */
+		READSHM(conf->spreadingCode, arlan->spreadingCode, u_char);
+	} else
 		conf->spreadingCode = spreadingCode;
-		
-	if (channelSet == channelSetUNKNOWN)
-	{
+
+	if (channelSet == channelSetUNKNOWN) {
+		/* multiline macro, cannot remove braces */
 		READSHM(conf->channelSet, arlan->channelSet, u_char);
-	}
-	else conf->channelSet = channelSet;
+	} else
+		conf->channelSet = channelSet;
 
-	if (channelNumber == channelNumberUNKNOWN)
-	{
+	if (channelNumber == channelNumberUNKNOWN) {
+		/* multiline macro, cannot remove braces */
 		READSHM(conf->channelNumber, arlan->channelNumber, u_char);
-	}
-	else conf->channelNumber = channelNumber;
-	
+	} else
+		conf->channelNumber = channelNumber;
+
 	READSHM(conf->scramblingDisable, arlan->scramblingDisable, u_char);
 	READSHM(conf->txAttenuation, arlan->txAttenuation, u_char);
-	
-	if (systemId == systemIdUNKNOWN)
-	{
+
+	if (systemId == systemIdUNKNOWN) {
+		/* multiline macro, cannot remove braces */
 		READSHM(conf->systemId, arlan->systemId, u_int);
-	} 
-	else conf->systemId = systemId;
-	
+	} else
+		conf->systemId = systemId;
+
 	READSHM(conf->maxDatagramSize, arlan->maxDatagramSize, u_short);
 	READSHM(conf->maxFrameSize, arlan->maxFrameSize, u_short);
 	READSHM(conf->maxRetries, arlan->maxRetries, u_char);
@@ -895,18 +807,18 @@ static int arlan_read_card_configuration(struct net_device *dev)
 	READSHM(conf->priority, arlan->priority, u_char);
 	READSHM(conf->rootOrRepeater, arlan->rootOrRepeater, u_char);
 
-	if (SID == SIDUNKNOWN)
-	{
+	if (SID == SIDUNKNOWN) {
+		/* multiline macro, cannot remove braces */
 		  READSHM(conf->SID, arlan->SID, u_int);
-	}
-	else conf->SID = SID;
-	
-	if (registrationMode == registrationModeUNKNOWN)
-	{
+	} else
+		conf->SID = SID;
+
+	if (registrationMode == registrationModeUNKNOWN) {
+		/* multiline macro, cannot remove braces */
 		  READSHM(conf->registrationMode, arlan->registrationMode, u_char);
-	}
-	else conf->registrationMode = registrationMode;
-	
+	} else
+		conf->registrationMode = registrationMode;
+
 	READSHM(conf->registrationFill, arlan->registrationFill, u_char);
 	READSHM(conf->localTalkAddress, arlan->localTalkAddress, u_char);
 	READSHM(conf->codeFormat, arlan->codeFormat, u_char);
@@ -921,16 +833,16 @@ static int arlan_read_card_configuration(struct net_device *dev)
 	READSHM(conf->headerSize, arlan->headerSize, u_short);
 	READSHM(conf->hardwareType, arlan->hardwareType, u_char);
 	READSHM(conf->radioType, arlan->radioModule, u_char);
-	
+
 	if (conf->radioType == 0)
 		conf->radioType = 0xc;
 
 	WRITESHM(arlan->configStatus, 0xA5, u_char);
 	READSHM(tlx415, arlan->configStatus, u_char);
-	
+
 	if (tlx415 != 0xA5)
 		printk(KERN_INFO "%s tlx415 chip \n", dev->name);
-	
+
 	conf->txClear = 0;
 	conf->txRetries = 1;
 	conf->txRouting = 1;
@@ -973,7 +885,7 @@ static int __init arlan_check_fingerprint(unsigned long memaddr)
 	ARLAN_DEBUG_ENTRY("arlan_check_fingerprint");
 
 	if (!request_mem_region(paddr, ARLAN_SHMEM_SIZE, "arlan")) {
-		// printk(KERN_WARNING "arlan: memory region %lx excluded from probing \n",paddr);
+		/* printk(KERN_WARNING "arlan: memory region %lx excluded from probing \n",paddr); */
 		return -ENODEV;
 	}
 
@@ -981,12 +893,12 @@ static int __init arlan_check_fingerprint(unsigned long memaddr)
 	tempBuf[30] = 0;
 
 	/* check for card at this address */
-	if (0 != strncmp(tempBuf, probeText, 29)){
- 		release_mem_region(paddr, ARLAN_SHMEM_SIZE);
+	if (0 != strncmp(tempBuf, probeText, 29)) {
+		release_mem_region(paddr, ARLAN_SHMEM_SIZE);
 		return -ENODEV;
 	}
 
-//   printk(KERN_INFO "arlan found at 0x%x \n",memaddr);
+	/* printk(KERN_INFO "arlan found at 0x%x \n",memaddr); */
 	ARLAN_DEBUG_EXIT("arlan_check_fingerprint");
 
 	return 0;
@@ -1054,7 +966,7 @@ static int __init arlan_setup_device(struct net_device *dev, int num)
 	dev->tx_queue_len = tx_queue_len;
 	dev->netdev_ops = &arlan_netdev_ops;
 	dev->watchdog_timeo = 3*HZ;
-	
+
 	ap->irq_test_done = 0;
 	ap->Conf = &arlan_conf[num];
 
@@ -1065,7 +977,7 @@ static int __init arlan_setup_device(struct net_device *dev, int num)
 
 	err = register_netdev(dev);
 	if (err) {
-		release_mem_region(virt_to_phys((void *) dev->mem_start), 
+		release_mem_region(virt_to_phys((void *) dev->mem_start),
 			   ARLAN_SHMEM_SIZE);
 		free_netdev(dev);
 		return err;
@@ -1075,7 +987,7 @@ static int __init arlan_setup_device(struct net_device *dev, int num)
 	return 0;
 }
 
-static int __init arlan_probe_here(struct net_device *dev, 
+static int __init arlan_probe_here(struct net_device *dev,
 				   unsigned long memaddr)
 {
 	struct arlan_private *ap = netdev_priv(dev);
@@ -1085,15 +997,15 @@ static int __init arlan_probe_here(struct net_device *dev,
 	if (arlan_check_fingerprint(memaddr))
 		return -ENODEV;
 
-	printk(KERN_NOTICE "%s: Arlan found at %llx, \n ", dev->name, 
-	       (u64) virt_to_phys((void*)memaddr));
+	printk(KERN_NOTICE "%s: Arlan found at %llx, \n ", dev->name,
+	       (u64) virt_to_phys((void *)memaddr));
 
 	ap->card = (void *) memaddr;
 	dev->mem_start = memaddr;
 	dev->mem_end = memaddr + ARLAN_SHMEM_SIZE-1;
 
-	if (dev->irq < 2)
-	{
+	if (dev->irq < 2) {
+		/* multiline macro, cannot remove braces */
 		READSHM(dev->irq, ap->card->irqLevel, u_char);
 	} else if (dev->irq == 2)
 		dev->irq = 9;
@@ -1114,14 +1026,12 @@ static int arlan_open(struct net_device *dev)
 	ARLAN_DEBUG_ENTRY("arlan_open");
 
 	ret = request_irq(dev->irq, &arlan_interrupt, 0, dev->name, dev);
-	if (ret)
-	{
+	if (ret) {
 		printk(KERN_ERR "%s: unable to get IRQ %d .\n",
 			dev->name, dev->irq);
 		return ret;
 	}
 
-
 	priv->bad = 0;
 	priv->lastReset = 0;
 	priv->reset = 0;
@@ -1131,14 +1041,14 @@ static int arlan_open(struct net_device *dev)
 	priv->interrupt_processing_active = 0;
 	spin_lock_init(&priv->lock);
 
-	netif_start_queue (dev);
+	netif_start_queue(dev);
 
 	priv->registrationLostCount = 0;
 	priv->registrationLastSeen = jiffies;
 	priv->txLast = 0;
 	priv->tx_command_given = 0;
 	priv->rx_command_given = 0;
-	
+
 	priv->reRegisterExp = 1;
 	priv->tx_last_sent = jiffies - 1;
 	priv->tx_last_cleared = jiffies;
@@ -1159,13 +1069,13 @@ static int arlan_open(struct net_device *dev)
 }
 
 
-static void arlan_tx_timeout (struct net_device *dev)
+static void arlan_tx_timeout(struct net_device *dev)
 {
 	printk(KERN_ERR "%s: arlan transmit timed out, kernel decided\n", dev->name);
 	/* Try to restart the adaptor. */
 	arlan_command(dev, ARLAN_COMMAND_CLEAN_AND_RESET);
-	// dev->trans_start = jiffies;
-	// netif_start_queue (dev);
+	/* dev->trans_start = jiffies; */
+	/* netif_start_queue (dev); */
 }
 
 
@@ -1175,13 +1085,13 @@ static netdev_tx_t arlan_tx(struct sk_buff *skb, struct net_device *dev)
 	unsigned char *buf;
 
 	ARLAN_DEBUG_ENTRY("arlan_tx");
-	
+
 	length = ETH_ZLEN < skb->len ? skb->len : ETH_ZLEN;
 	buf = skb->data;
 
 	if (length + 0x12 > 0x800) {
 		printk(KERN_ERR "TX RING overflow \n");
-		netif_stop_queue (dev);
+		netif_stop_queue(dev);
 	}
 
 	if (arlan_hw_tx(dev, buf, length) == -1)
@@ -1197,7 +1107,7 @@ static netdev_tx_t arlan_tx(struct sk_buff *skb, struct net_device *dev)
 
 bad_end:
 	arlan_process_interrupt(dev);
-	netif_stop_queue (dev);
+	netif_stop_queue(dev);
 	ARLAN_DEBUG_EXIT("arlan_tx");
 	return NETDEV_TX_BUSY;
 }
@@ -1229,9 +1139,8 @@ static inline void arlan_queue_retransmit(struct net_device *dev)
 	ARLAN_DEBUG_ENTRY("arlan_queue_retransmit");
 
 	if (DoNotWaitReTransmitCrap(dev))
-	{
-		  arlan_drop_tx(dev);
-	} else
+		arlan_drop_tx(dev);
+	else
 		priv->ReTransmitRequested++;
 
 	ARLAN_DEBUG_EXIT("arlan_queue_retransmit");
@@ -1245,14 +1154,11 @@ static inline void RetryOrFail(struct net_device *dev)
 
 	if (priv->retransmissions > priv->Conf->retries ||
 	    DoNotReTransmitCrap(dev))
-	{
 		arlan_drop_tx(dev);
-	}
 	else if (priv->bad <= priv->Conf->fastReTransCount)
-	{
 		arlan_retransmit_now(dev);
-	}
-	else arlan_queue_retransmit(dev);
+	else
+		arlan_queue_retransmit(dev);
 
 	ARLAN_DEBUG_EXIT("RetryOrFail");
 }
@@ -1266,131 +1172,126 @@ static void arlan_tx_done_interrupt(struct net_device *dev, int status)
 
 	priv->tx_last_cleared = jiffies;
 	priv->tx_command_given = 0;
-	switch (status)
+	switch (status) {
+	case 1:
 	{
-		case 1:
-		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
-				printk("arlan intr: transmit OK\n");
-			dev->stats.tx_packets++;
-			priv->bad = 0;
-			priv->reset = 0;
-			priv->retransmissions = 0;
-			if (priv->Conf->tx_delay_ms)
-			{
-				priv->tx_done_delayed = jiffies + (priv->Conf->tx_delay_ms * HZ) / 1000 + 1;
-			}
-			else
-			{
-				TXLAST(dev).offset = 0;
-				if (priv->txLast)
-					priv->txLast = 0;
-				else if (TXTAIL(dev).offset)
-					priv->txLast = 1;
-				if (TXLAST(dev).offset)
-				{
-					arlan_retransmit_now(dev);
-					dev->trans_start = jiffies;
-				}
-				if (!TXHEAD(dev).offset || !TXTAIL(dev).offset)
-				{
-					netif_wake_queue (dev);
-				}
+		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
+			printk("arlan intr: transmit OK\n");
+		dev->stats.tx_packets++;
+		priv->bad = 0;
+		priv->reset = 0;
+		priv->retransmissions = 0;
+		if (priv->Conf->tx_delay_ms)
+			priv->tx_done_delayed = jiffies + (priv->Conf->tx_delay_ms * HZ) / 1000 + 1;
+		else {
+			TXLAST(dev).offset = 0;
+			if (priv->txLast)
+				priv->txLast = 0;
+			else if (TXTAIL(dev).offset)
+				priv->txLast = 1;
+
+			if (TXLAST(dev).offset) {
+				arlan_retransmit_now(dev);
+				dev->trans_start = jiffies;
 			}
-		}
-		break;
-		
-		case 2:
-		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
-				printk("arlan intr: transmit timed out\n");
-			priv->bad += 1;
-			//arlan_queue_retransmit(dev);
-			RetryOrFail(dev);
-		}
-		break;
 
-		case 3:
-		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
-				printk("arlan intr: transmit max retries\n");
-			priv->bad += 1;
-			priv->reset = 0;
-			//arlan_queue_retransmit(dev);
-			RetryOrFail(dev);
+			if (!TXHEAD(dev).offset || !TXTAIL(dev).offset)
+				netif_wake_queue(dev);
 		}
-		break;
-		
-		case 4:
-		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
-				printk("arlan intr: transmit aborted\n");
-			priv->bad += 1;
-			arlan_queue_retransmit(dev);
-			//RetryOrFail(dev);
-		}
-		break;
+	}
+	break;
 
-		case 5:
-		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
-				printk("arlan intr: transmit not registered\n");
-			priv->bad += 1;
-			//debug=101;
-			arlan_queue_retransmit(dev);
-		}
-		break;
+	case 2:
+	{
+		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
+			printk("arlan intr: transmit timed out\n");
+		priv->bad += 1;
+		/* arlan_queue_retransmit(dev); */
+		RetryOrFail(dev);
+	}
+	break;
 
-		case 6:
-		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN) 
-				printk("arlan intr: transmit destination full\n");
-			priv->bad += 1;
-			priv->reset = 0;
-			//arlan_drop_tx(dev);
-			arlan_queue_retransmit(dev);
-		}
-		break;
+	case 3:
+	{
+		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
+			printk("arlan intr: transmit max retries\n");
+		priv->bad += 1;
+		priv->reset = 0;
+		/* arlan_queue_retransmit(dev); */
+		RetryOrFail(dev);
+	}
+	break;
 
-		case 7:
-		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
-				printk("arlan intr: transmit unknown ack\n");
-			priv->bad += 1;
-			priv->reset = 0;
-			arlan_queue_retransmit(dev);
-		}
-		break;
-		
-		case 8:
-		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
-				printk("arlan intr: transmit dest mail box full\n");
-			priv->bad += 1;
-			priv->reset = 0;
-			//arlan_drop_tx(dev);
-			arlan_queue_retransmit(dev);
-		}
-		break;
+	case 4:
+	{
+		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
+			printk("arlan intr: transmit aborted\n");
+		priv->bad += 1;
+		arlan_queue_retransmit(dev);
+		/* RetryOrFail(dev); */
+	}
+	break;
 
-		case 9:
-		{
-			IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
-				printk("arlan intr: transmit root dest not reg.\n");
-			priv->bad += 1;
-			priv->reset = 1;
-			//arlan_drop_tx(dev);
-			arlan_queue_retransmit(dev);
-		}
-		break;
+	case 5:
+	{
+		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
+			printk("arlan intr: transmit not registered\n");
+		priv->bad += 1;
+		/* debug=101; */
+		arlan_queue_retransmit(dev);
+	}
+	break;
 
-		default:
-		{
-			printk(KERN_ERR "arlan intr: transmit status unknown\n");
-			priv->bad += 1;
-			priv->reset = 1;
-			arlan_drop_tx(dev);
-		}
+	case 6:
+	{
+		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
+			printk("arlan intr: transmit destination full\n");
+		priv->bad += 1;
+		priv->reset = 0;
+		/* arlan_drop_tx(dev); */
+		arlan_queue_retransmit(dev);
+	}
+	break;
+
+	case 7:
+	{
+		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
+			printk("arlan intr: transmit unknown ack\n");
+		priv->bad += 1;
+		priv->reset = 0;
+		arlan_queue_retransmit(dev);
+	}
+	break;
+
+	case 8:
+	{
+		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
+			printk("arlan intr: transmit dest mail box full\n");
+		priv->bad += 1;
+		priv->reset = 0;
+		/* arlan_drop_tx(dev); */
+		arlan_queue_retransmit(dev);
+	}
+	break;
+
+	case 9:
+	{
+		IFDEBUG(ARLAN_DEBUG_TX_CHAIN)
+			printk("arlan intr: transmit root dest not reg.\n");
+		priv->bad += 1;
+		priv->reset = 1;
+		/* arlan_drop_tx(dev); */
+		arlan_queue_retransmit(dev);
+	}
+	break;
+
+	default:
+	{
+		printk(KERN_ERR "arlan intr: transmit status unknown\n");
+		priv->bad += 1;
+		priv->reset = 1;
+		arlan_drop_tx(dev);
+	}
 	}
 
 	ARLAN_DEBUG_EXIT("arlan_tx_done_interrupt");
@@ -1408,134 +1309,126 @@ static void arlan_rx_interrupt(struct net_device *dev, u_char rxStatus, u_short
 
 
 	ARLAN_DEBUG_ENTRY("arlan_rx_interrupt");
-	// by spec,   not                WRITESHMB(arlan->rxStatus,0x00);
-	// prohibited here              arlan_command(dev, ARLAN_COMMAND_RX);
+	/* by spec,   not                WRITESHMB(arlan->rxStatus,0x00); */
+	/* prohibited here              arlan_command(dev, ARLAN_COMMAND_RX); */
 
-	if (pkt_len < 10 || pkt_len > 2048)
-	{
+	if (pkt_len < 10 || pkt_len > 2048) {
 		printk(KERN_WARNING "%s: got too short or long packet, len %d \n", dev->name, pkt_len);
 		return;
 	}
-	if (rxOffset + pkt_len > 0x2000)
-	{
+	if (rxOffset + pkt_len > 0x2000) {
 		printk("%s: got too long packet, len %d offset %x\n", dev->name, pkt_len, rxOffset);
 		return;
 	}
+
 	priv->in_bytes += pkt_len;
 	priv->in_bytes10 += pkt_len;
 	if (conf->measure_rate < 1)
 		conf->measure_rate = 1;
-	if (time_after(jiffies, priv->in_time + conf->measure_rate * HZ))
-	{
+	if (time_after(jiffies, priv->in_time + conf->measure_rate * HZ)) {
 		conf->in_speed = priv->in_bytes / conf->measure_rate;
 		priv->in_bytes = 0;
 		priv->in_time = jiffies;
 	}
-	if (time_after(jiffies, priv->in_time10 + conf->measure_rate * 10*HZ))
-	{
+	if (time_after(jiffies, priv->in_time10 + conf->measure_rate * 10*HZ)) {
 		conf->in_speed10 = priv->in_bytes10 / (10 * conf->measure_rate);
 		priv->in_bytes10 = 0;
 		priv->in_time10 = jiffies;
 	}
 	DEBUGSHM(1, "arlan rcv pkt rxStatus= %d ", arlan->rxStatus, u_char);
-	switch (rxStatus)
+	switch (rxStatus) {
+	case 1:
+	case 2:
+	case 3:
 	{
-		case 1:
-		case 2:
-		case 3:
-		{
-			/* Malloc up new buffer. */
-			struct sk_buff *skb;
+		/* Malloc up new buffer. */
+		struct sk_buff *skb;
 
-			DEBUGSHM(50, "arlan recv pkt offs=%d\n", arlan->rxOffset, u_short);
-			DEBUGSHM(1, "arlan rxFrmType = %d \n", arlan->rxFrmType, u_char);
-			DEBUGSHM(1, KERN_INFO "arlan rx scrambled = %d \n", arlan->scrambled, u_char);
+		DEBUGSHM(50, "arlan recv pkt offs=%d\n", arlan->rxOffset, u_short);
+		DEBUGSHM(1, "arlan rxFrmType = %d \n", arlan->rxFrmType, u_char);
+		DEBUGSHM(1, KERN_INFO "arlan rx scrambled = %d \n", arlan->scrambled, u_char);
 
-			/* here we do multicast filtering to avoid slow 8-bit memcopy */
+		/* here we do multicast filtering to avoid slow 8-bit memcopy */
 #ifdef ARLAN_MULTICAST
-			if (!(dev->flags & IFF_ALLMULTI) &&
-				!(dev->flags & IFF_PROMISC) &&
-				!netdev_mc_empty(dev))
-			{
-				char hw_dst_addr[6];
-				struct dev_mc_list *dmi;
-				int i;
-
-				memcpy_fromio(hw_dst_addr, arlan->ultimateDestAddress, 6);
-				if (hw_dst_addr[0] == 0x01)
-				{
-					if (mdebug)
-						if (hw_dst_addr[1] == 0x00)
-							printk(KERN_ERR "%s mcast 0x0100 \n", dev->name);
-						else if (hw_dst_addr[1] == 0x40)
-							printk(KERN_ERR "%s m/bcast 0x0140 \n", dev->name);
-					netdev_for_each_mc_entry(dmi, dev) {
-						if (arlan_debug & ARLAN_DEBUG_HEADER_DUMP)
-							printk(KERN_ERR "%s mcl %pM\n",
-							       dev->name, dmi->dmi_addr);
-						for (i = 0; i < 6; i++)
-							if (dmi->dmi_addr[i] != hw_dst_addr[i])
-								break;
-						if (i == 6)
+		if (!(dev->flags & IFF_ALLMULTI) &&
+			!(dev->flags & IFF_PROMISC) &&
+			!netdev_mc_empty(dev)) {
+			char hw_dst_addr[6];
+			struct dev_mc_list *dmi;
+			int i;
+
+			memcpy_fromio(hw_dst_addr, arlan->ultimateDestAddress, 6);
+			if (hw_dst_addr[0] == 0x01) {
+				if (mdebug)
+					if (hw_dst_addr[1] == 0x00)
+						printk(KERN_ERR "%s mcast 0x0100 \n", dev->name);
+					else if (hw_dst_addr[1] == 0x40)
+						printk(KERN_ERR "%s m/bcast 0x0140 \n", dev->name);
+				netdev_for_each_mc_entry(dmi, dev) {
+					if (arlan_debug & ARLAN_DEBUG_HEADER_DUMP)
+						printk(KERN_ERR "%s mcl %pM\n",
+						       dev->name, dmi->dmi_addr);
+					for (i = 0; i < 6; i++)
+						if (dmi->dmi_addr[i] != hw_dst_addr[i])
 							break;
-					}
-					/* we reach here if multicast filtering is on and packet 
-					 * is multicast and not for receive */
-					goto end_of_interrupt;
+					if (i == 6)
+						break;
 				}
+				/* we reach here if multicast filtering is on and packet */
+				/* is multicast and not for receive */
+				goto end_of_interrupt;
 			}
-#endif				// ARLAN_MULTICAST
-			/* multicast filtering ends here */
-			pkt_len += ARLAN_FAKE_HDR_LEN;
-
-			skb = dev_alloc_skb(pkt_len + 4);
-			if (skb == NULL)
-			{
-				printk(KERN_ERR "%s: Memory squeeze, dropping packet.\n", dev->name);
-				dev->stats.rx_dropped++;
-				break;
-			}
-			skb_reserve(skb, 2);
-			skbtmp = skb_put(skb, pkt_len);
+		}
+#endif	/* ARLAN_MULTICAST */
+		/* multicast filtering ends here */
+		pkt_len += ARLAN_FAKE_HDR_LEN;
+
+		skb = dev_alloc_skb(pkt_len + 4);
+		if (skb == NULL) {
+			printk(KERN_ERR "%s: Memory squeeze, dropping packet.\n", dev->name);
+			dev->stats.rx_dropped++;
+			break;
+		}
+		skb_reserve(skb, 2);
+		skbtmp = skb_put(skb, pkt_len);
 
-			memcpy_fromio(skbtmp + ARLAN_FAKE_HDR_LEN, ((char __iomem *) arlan) + rxOffset, pkt_len - ARLAN_FAKE_HDR_LEN);
-			memcpy_fromio(skbtmp, arlan->ultimateDestAddress, 6);
-			memcpy_fromio(skbtmp + 6, arlan->rxSrc, 6);
-			WRITESHMB(arlan->rxStatus, 0x00);
-			arlan_command(dev, ARLAN_COMMAND_RX);
+		memcpy_fromio(skbtmp + ARLAN_FAKE_HDR_LEN, ((char __iomem *) arlan) + rxOffset, pkt_len - ARLAN_FAKE_HDR_LEN);
+		memcpy_fromio(skbtmp, arlan->ultimateDestAddress, 6);
+		memcpy_fromio(skbtmp + 6, arlan->rxSrc, 6);
+		WRITESHMB(arlan->rxStatus, 0x00);
+		arlan_command(dev, ARLAN_COMMAND_RX);
 
-			IFDEBUG(ARLAN_DEBUG_HEADER_DUMP)
-			{
-				char immedDestAddress[6];
-				char immedSrcAddress[6];
-				memcpy_fromio(immedDestAddress, arlan->immedDestAddress, 6);
-				memcpy_fromio(immedSrcAddress, arlan->immedSrcAddress, 6);
-
-				printk(KERN_WARNING "%s t %pM f %pM imd %pM ims %pM\n",
-				       dev->name, skbtmp,
-				       &skbtmp[6],
-				       immedDestAddress,
-				       immedSrcAddress);
-			}
-			skb->protocol = eth_type_trans(skb, dev);
-			IFDEBUG(ARLAN_DEBUG_HEADER_DUMP)
-				if (skb->protocol != 0x608 && skb->protocol != 0x8)
-				{
-					for (i = 0; i <= 22; i++)
-						printk("%02x:", (u_char) skbtmp[i + 12]);
-					printk(KERN_ERR "\n");
-					printk(KERN_WARNING "arlan kernel pkt type trans %x \n", skb->protocol);
-				}
-			netif_rx(skb);
-			dev->stats.rx_packets++;
-			dev->stats.rx_bytes += pkt_len;
+		IFDEBUG(ARLAN_DEBUG_HEADER_DUMP)
+		{
+			char immedDestAddress[6];
+			char immedSrcAddress[6];
+			memcpy_fromio(immedDestAddress, arlan->immedDestAddress, 6);
+			memcpy_fromio(immedSrcAddress, arlan->immedSrcAddress, 6);
+
+			printk(KERN_WARNING "%s t %pM f %pM imd %pM ims %pM\n",
+			       dev->name, skbtmp,
+			       &skbtmp[6],
+			       immedDestAddress,
+			       immedSrcAddress);
 		}
+		skb->protocol = eth_type_trans(skb, dev);
+		IFDEBUG(ARLAN_DEBUG_HEADER_DUMP)
+			if (skb->protocol != 0x608 && skb->protocol != 0x8) {
+				for (i = 0; i <= 22; i++)
+					printk("%02x:", (u_char) skbtmp[i + 12]);
+				printk(KERN_ERR "\n");
+				printk(KERN_WARNING "arlan kernel pkt type trans %x \n", skb->protocol);
+			}
+		netif_rx(skb);
+		dev->stats.rx_packets++;
+		dev->stats.rx_bytes += pkt_len;
+	}
+	break;
+
+	default:
+		printk(KERN_ERR "arlan intr: received unknown status\n");
+		dev->stats.rx_crc_errors++;
 		break;
-		
-		default:
-			printk(KERN_ERR "arlan intr: received unknown status\n");
-			dev->stats.rx_crc_errors++;
-			break;
 	}
 	ARLAN_DEBUG_EXIT("arlan_rx_interrupt");
 }
@@ -1552,30 +1445,26 @@ static void arlan_process_interrupt(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_process_interrupt");
 
-	if (test_and_set_bit(0, (void *) &priv->interrupt_processing_active))
-	{
+	if (test_and_set_bit(0, (void *) &priv->interrupt_processing_active)) {
 		if (arlan_debug & ARLAN_DEBUG_CHAIN_LOCKS)
 			printk(KERN_ERR "interrupt chain reentering \n");
 		goto end_int_process;
 	}
 	while ((rxStatus || txStatus || priv->interrupt_ack_requested)
-			&& (interrupt_count < 5))
-	{
+			&& (interrupt_count < 5)) {
 		if (rxStatus)
 			priv->last_rx_int_ack_time = jiffies;
 
 		arlan_command(dev, ARLAN_COMMAND_INT_ACK);
 		arlan_command(dev, ARLAN_COMMAND_INT_ENABLE);
-		
+
 		IFDEBUG(ARLAN_DEBUG_INTERRUPT)
 			printk(KERN_ERR "%s:  got IRQ rx %x tx %x comm %x rxOff %x rxLen %x \n",
 					dev->name, rxStatus, txStatus, READSHMB(arlan->commandByte),
 					rxOffset, pkt_len);
 
-		if (rxStatus == 0 && txStatus == 0)
-		{
-			if (priv->irq_test_done)
-			{
+		if (rxStatus == 0 && txStatus == 0) {
+			if (priv->irq_test_done) {
 				if (!registrationBad(dev))
 					IFDEBUG(ARLAN_DEBUG_INTERRUPT) printk(KERN_ERR "%s unknown interrupt(nop? regLost ?) reason tx %d rx %d ",
 										    dev->name, txStatus, rxStatus);
@@ -1587,35 +1476,35 @@ static void arlan_process_interrupt(struct net_device *dev)
 			priv->interrupt_ack_requested = 0;
 			goto ends;
 		}
-		if (txStatus != 0)
-		{
+
+		if (txStatus != 0) {
 			WRITESHMB(arlan->txStatus, 0x00);
 			arlan_tx_done_interrupt(dev, txStatus);
 			goto ends;
 		}
-		if (rxStatus == 1 || rxStatus == 2)
-		{		/* a packet waiting */
+
+		if (rxStatus == 1 || rxStatus == 2) {
+			/* a packet waiting */
 			arlan_rx_interrupt(dev, rxStatus, rxOffset, pkt_len);
 			goto ends;
 		}
-		if (rxStatus > 2 && rxStatus < 0xff)
-		{
+
+		if (rxStatus > 2 && rxStatus < 0xff) {
 			WRITESHMB(arlan->rxStatus, 0x00);
 			printk(KERN_ERR "%s unknown rxStatus reason tx %d rx %d ",
 				dev->name, txStatus, rxStatus);
 			goto ends;
 		}
-		if (rxStatus == 0xff)
-		{
+
+		if (rxStatus == 0xff) {
 			WRITESHMB(arlan->rxStatus, 0x00);
 			arlan_command(dev, ARLAN_COMMAND_RX);
 			if (registrationBad(dev))
 				netif_device_detach(dev);
-			if (!registrationBad(dev))
-			{
+			if (!registrationBad(dev)) {
 				priv->registrationLastSeen = jiffies;
 				if (!netif_queue_stopped(dev) && !priv->under_reset && !priv->under_config)
-					netif_wake_queue (dev);
+					netif_wake_queue(dev);
 			}
 			goto ends;
 		}
@@ -1657,7 +1546,7 @@ static irqreturn_t arlan_interrupt(int irq, void *dev_id)
 		priv->interrupt_ack_requested++;
 
 	arlan_process_interrupt(dev);
-	
+
 	priv->irq_test_done = 1;
 
 	ARLAN_DEBUG_EXIT("arlan_interrupt");
@@ -1687,7 +1576,7 @@ static int arlan_close(struct net_device *dev)
 }
 
 #ifdef ARLAN_DEBUGGING
-static long alignLong(volatile u_char * ptr)
+static long alignLong(volatile u_char *ptr)
 {
 	long ret;
 	memcpy_fromio(&ret, (void *) ptr, 4);
@@ -1740,16 +1629,13 @@ static void arlan_set_multicast(struct net_device *dev)
 
 	ARLAN_DEBUG_ENTRY("arlan_set_multicast");
 
-	if (dev->flags & IFF_PROMISC)
-	{
+	if (dev->flags & IFF_PROMISC) {
 		unsigned char recMode;
 		READSHM(recMode, arlan->receiveMode, u_char);
 		conf->receiveMode = (ARLAN_RCV_PROMISC | ARLAN_RCV_CONTROL);
 		if (conf->receiveMode != recMode)
 			board_conf_needed = 1;
-	}
-	else
-	{
+	} else {
 		/* turn off promiscuous mode  */
 		unsigned char recMode;
 		READSHM(recMode, arlan->receiveMode, u_char);
@@ -1757,6 +1643,7 @@ static void arlan_set_multicast(struct net_device *dev)
 		if (conf->receiveMode != recMode)
 			board_conf_needed = 1;
 	}
+
 	if (board_conf_needed)
 		arlan_command(dev, ARLAN_COMMAND_CONF);
 
@@ -1775,7 +1662,7 @@ struct net_device * __init arlan_probe(int unit)
 	if (arlans_found == MAX_ARLANS)
 		return ERR_PTR(-ENODEV);
 
-	/* 
+	/*
 	 * Reserve space for local data and a copy of the shared memory
 	 * that is used by the /proc interface.
 	 */
@@ -1787,23 +1674,20 @@ struct net_device * __init arlan_probe(int unit)
 	if (unit >= 0) {
 		sprintf(dev->name, "eth%d", unit);
 		netdev_boot_setup_check(dev);
-		
+
 		if (dev->mem_start) {
 			if (arlan_probe_here(dev, dev->mem_start) == 0)
 				goto found;
 			goto not_found;
 		}
-			
 	}
 
 
-	for (m = (int)phys_to_virt(lastFoundAt) + ARLAN_SHMEM_SIZE; 
-	     m <= (int)phys_to_virt(0xDE000); 
-	     m += ARLAN_SHMEM_SIZE)
-	{
-		if (arlan_probe_here(dev, m) == 0)
-		{
-			lastFoundAt = (int)virt_to_phys((void*)m);
+	for (m = (int)phys_to_virt(lastFoundAt) + ARLAN_SHMEM_SIZE;
+	     m <= (int)phys_to_virt(0xDE000);
+	     m += ARLAN_SHMEM_SIZE) {
+		if (arlan_probe_here(dev, m) == 0) {
+			lastFoundAt = (int)virt_to_phys((void *)m);
 			goto found;
 		}
 	}
@@ -1825,7 +1709,7 @@ struct net_device * __init arlan_probe(int unit)
 	return dev;
 }
 
-#ifdef  MODULE
+#ifdef MODULE
 int __init init_module(void)
 {
 	int i = 0;
@@ -1838,7 +1722,7 @@ int __init init_module(void)
 	for (i = 0; i < MAX_ARLANS; i++) {
 		struct net_device *dev = arlan_probe(i);
 
-		if (IS_ERR(dev)) 
+		if (IS_ERR(dev))
 			return PTR_ERR(dev);
 	}
 	init_arlan_proc();
@@ -1860,14 +1744,13 @@ void __exit cleanup_module(void)
 
 	cleanup_arlan_proc();
 
-	for (i = 0; i < MAX_ARLANS; i++)
-	{
+	for (i = 0; i < MAX_ARLANS; i++) {
 		dev = arlan_device[i];
 		if (dev) {
-			arlan_command(dev, ARLAN_COMMAND_POWERDOWN );
+			arlan_command(dev, ARLAN_COMMAND_POWERDOWN);
 
 			unregister_netdev(dev);
-			release_mem_region(virt_to_phys((void *) dev->mem_start), 
+			release_mem_region(virt_to_phys((void *) dev->mem_start),
 					   ARLAN_SHMEM_SIZE);
 			free_netdev(dev);
 			arlan_device[i] = NULL;
-- 
1.6.3.3

