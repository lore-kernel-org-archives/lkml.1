Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbZKVMrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbZKVMrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZKVMrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:47:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35036 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZKVMrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=CIdbpjEXKSqWhGmOa7S2zTNpzi++gds6eSdElZipP+b6WtjngEmJ6G1qBvug2JLmsP
         m6r7mE11UKacdLL7r6Lwur1UHpouq/M5g3ILgYYDg+Ibb4bkJaVMkffMfZmGJhtQ7UUA
         5Y81hR3bZznaYAvGcT/ZBfHMZzMnKb0JfNqiQ=
Message-ID: <4B0932C8.90208@gmail.com>
Date: Sun, 22 Nov 2009 13:47:04 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: rt2x00 Users List <users@host1.serialmonkey.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] ieee80211_tx_status: headroom too small
References: <30353c3d0911201730n4682ff7dy8225d475599eb9bb@mail.gmail.com>	 <4B0806EC.3050201@gmail.com> <30353c3d0911212309i20c9b9d3y821b508d8f1c81a4@mail.gmail.com>
In-Reply-To: <30353c3d0911212309i20c9b9d3y821b508d8f1c81a4@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050404050107090801040009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050404050107090801040009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/22/09 08:09, David Ellingsworth wrote:
> On Sat, Nov 21, 2009 at 10:27 AM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> On 11/21/09 02:30, David Ellingsworth wrote:
>>> Wasn't sure where to send this, but with the latest 2.6.32-rc8-wl
>>> kernel built from the wireless-testing repository I'm getting a number
>>> of "ieee80211_tx_status: headroom too small" errors in my syslog. I'm
>>> using the rt61pci driver in conjunction with hostap as a wpa2 secured
>>> access point. The relevant information about my card from lspci is:
>>>
>>> 01:08.0 0280: 1814:0301
>>>         Subsystem: 1458:e934
>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
>>> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>         Latency: 64, Cache Line Size: 128 bytes
>>>         Interrupt: pin A routed to IRQ 18
>>>         Region 0: Memory at fe6f0000 (32-bit, non-prefetchable) [size=32K]
>>>         Capabilities: [40] Power Management version 2
>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>>         Kernel driver in use: rt61pci
>>>
>>> If you need any other information, I'll be happy to provide it.
>>>
>>
>> Hi David,
>>
>> This seems to be caused by the rt2x00 driver not properly declaring its alignment
>> maneuvring space properly, and thus it doesn't leave enough headroom left for
>> copying to the monitor interface.
>>
>> Can you check whether the attached patch fixes the issue for you?
>> Note: patch looks a bit bigger than it actually is due to indenting cleanups.
>>
> 
> Gertjan,
> 
> I haven't really been able to test this. The kernel version I was
> using at the time was 2.6.32-rc7-wl and not 2.6.32-rc8-wl. I'm rather
> certain the patch will resolve the issue, but I've been unable to get
> my wireless card to function properly with the latest 2.6.32-rc8-wl
> master branch. I'm not entirely sure what changed since two days ago,
> but I know the following:
> 
> 1. 2.6.32-rc8 from Linus' master branch works fine but still exhibits
> this issue. However, this patch will not apply on top of 2.6.32-rc8.
> 
> 2. 2.6.32-rc7-wl(11/19/2009) worked fine with the exception of the
> above mentioned error. Unable to test patch since I pulled all the
> recent modifications down.
> 3. 2.6.32-rc8-wl does not work at all for me, but patch does apply.
> 
> I'm not entirely sure what the differences are between Linus' master
> branch of 2.6.32-rc8 and the current 2.6.32-rc8-wl tree are or what
> changes have been made on the wireless-testing master branch in the
> last couple of days that are preventing me from fully testing this
> patch.
> 
> With the current wireless-testing master branch, 2.6.32-rc8-wl, with
> and without the patch I can associate and authenticate with my AP but
> am unable to do anything else. Any attempt to establish a wireless
> connection thus dies while trying to obtain an ip address via DHCP.
> Sadly, no errors are logged indicating what the cause of this problem
> might be. Given that I've only seen these errors after establishing a
> wireless connection, it's a little difficult for me to test without
> being able to transmit any data.
> 
> I don't know if it's worth the effort or not, but if this patch were
> re-based against Linus' master branch I might be able to test it since
> my AP at least works with 2.6.32-rc8.

David,

OK. Find attached the patch ported to Linus' tree. It should apply to
any version of Linus' tree after 2.6.32-rc8.
I think it is good to get real confirmation that the patch behaves
as expected.

---
Gertjan.
 


--------------050404050107090801040009
Content-Type: text/plain;
 name="align_fix_linus_tree.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="align_fix_linus_tree.diff"

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 798f625..7a8b2c4 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1431,7 +1431,8 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 			       IEEE80211_HW_SIGNAL_DBM |
 			       IEEE80211_HW_SUPPORTS_PS |
 			       IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
+	    					RT2X00_ALIGN_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1622,20 +1623,21 @@ static const struct data_queue_desc rt2400pci_queue_atim = {
 };
 
 static const struct rt2x00_ops rt2400pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 1,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2400pci_queue_rx,
-	.tx		= &rt2400pci_queue_tx,
-	.bcn		= &rt2400pci_queue_bcn,
-	.atim		= &rt2400pci_queue_atim,
-	.lib		= &rt2400pci_rt2x00_ops,
-	.hw		= &rt2400pci_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 1,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= 0,
+	.rx			= &rt2400pci_queue_rx,
+	.tx			= &rt2400pci_queue_tx,
+	.bcn			= &rt2400pci_queue_bcn,
+	.atim			= &rt2400pci_queue_atim,
+	.lib			= &rt2400pci_rt2x00_ops,
+	.hw			= &rt2400pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2400pci_rt2x00debug,
+	.debugfs		= &rt2400pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 2e872ac..0baa5a7 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1732,7 +1732,8 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 			       IEEE80211_HW_SUPPORTS_PS |
 			       IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
+	    					RT2X00_ALIGN_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1921,20 +1922,21 @@ static const struct data_queue_desc rt2500pci_queue_atim = {
 };
 
 static const struct rt2x00_ops rt2500pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 1,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2500pci_queue_rx,
-	.tx		= &rt2500pci_queue_tx,
-	.bcn		= &rt2500pci_queue_bcn,
-	.atim		= &rt2500pci_queue_atim,
-	.lib		= &rt2500pci_rt2x00_ops,
-	.hw		= &rt2500pci_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 1,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= 0,
+	.rx			= &rt2500pci_queue_rx,
+	.tx			= &rt2500pci_queue_tx,
+	.bcn			= &rt2500pci_queue_bcn,
+	.atim			= &rt2500pci_queue_atim,
+	.lib			= &rt2500pci_rt2x00_ops,
+	.hw			= &rt2500pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2500pci_rt2x00debug,
+	.debugfs		= &rt2500pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 22dd6d9..1416f32 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1788,7 +1788,7 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1956,20 +1956,21 @@ static const struct data_queue_desc rt2500usb_queue_atim = {
 };
 
 static const struct rt2x00_ops rt2500usb_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 1,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2500usb_queue_rx,
-	.tx		= &rt2500usb_queue_tx,
-	.bcn		= &rt2500usb_queue_bcn,
-	.atim		= &rt2500usb_queue_atim,
-	.lib		= &rt2500usb_rt2x00_ops,
-	.hw		= &rt2500usb_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 1,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXD_DESC_SIZE,
+	.rx			= &rt2500usb_queue_rx,
+	.tx			= &rt2500usb_queue_tx,
+	.bcn			= &rt2500usb_queue_bcn,
+	.atim			= &rt2500usb_queue_atim,
+	.lib			= &rt2500usb_rt2x00_ops,
+	.hw			= &rt2500usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2500usb_rt2x00debug,
+	.debugfs		= &rt2500usb_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9fe770f..19298ef 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2509,7 +2509,8 @@ static int rt2800usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
+						RT2X00_L2PAD_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2852,19 +2853,20 @@ static const struct data_queue_desc rt2800usb_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt2800usb_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 8,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt2800usb_queue_rx,
-	.tx		= &rt2800usb_queue_tx,
-	.bcn		= &rt2800usb_queue_bcn,
-	.lib		= &rt2800usb_rt2x00_ops,
-	.hw		= &rt2800usb_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 8,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
+	.rx			= &rt2800usb_queue_rx,
+	.tx			= &rt2800usb_queue_tx,
+	.bcn			= &rt2800usb_queue_bcn,
+	.lib			= &rt2800usb_rt2x00_ops,
+	.hw			= &rt2800usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt2800usb_rt2x00debug,
+	.debugfs		= &rt2800usb_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 27bc6b7..a71962e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -112,6 +112,12 @@
 	(  ((unsigned long)((__skb)->data + (__header))) & 3 )
 
 /*
+ * Constants for extra TX headroom for alignment purposes.
+ */
+#define RT2X00_ALIGN_SIZE	4
+#define RT2X00_L2PAD_SIZE	8
+
+/*
  * Standard timing and size defines.
  * These values should follow the ieee80211 specifications.
  */
@@ -579,6 +585,7 @@ struct rt2x00_ops {
 	const unsigned int eeprom_size;
 	const unsigned int rf_size;
 	const unsigned int tx_queues;
+	const unsigned int extra_tx_headroom;
 	const struct data_queue_desc *rx;
 	const struct data_queue_desc *tx;
 	const struct data_queue_desc *bcn;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 577029e..2ec9c14 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -103,7 +103,7 @@ void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	 * is also mapped to the DMA so it can be used for transfering
 	 * additional descriptor information to the hardware.
 	 */
-	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_push(skb, rt2x00dev->ops->extra_tx_headroom);
 
 	skbdesc->skb_dma =
 	    dma_map_single(rt2x00dev->dev, skb->data, skb->len, DMA_TO_DEVICE);
@@ -111,7 +111,7 @@ void rt2x00queue_map_txskb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	/*
 	 * Restore data pointer to original location again.
 	 */
-	skb_pull(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_pull(skb, rt2x00dev->ops->extra_tx_headroom);
 
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
 }
@@ -133,7 +133,7 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 		 * by the driver, but it was actually mapped to DMA.
 		 */
 		dma_unmap_single(rt2x00dev->dev, skbdesc->skb_dma,
-				 skb->len + rt2x00dev->hw->extra_tx_headroom,
+				 skb->len + rt2x00dev->ops->extra_tx_headroom,
 				 DMA_TO_DEVICE);
 		skbdesc->flags &= ~SKBDESC_DMA_MAPPED_TX;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b20e3ea..7b6f056 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2545,7 +2545,8 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom +
+	    					RT2X00_ALIGN_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2787,19 +2788,20 @@ static const struct data_queue_desc rt61pci_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt61pci_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 4,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt61pci_queue_rx,
-	.tx		= &rt61pci_queue_tx,
-	.bcn		= &rt61pci_queue_bcn,
-	.lib		= &rt61pci_rt2x00_ops,
-	.hw		= &rt61pci_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 4,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= 0,
+	.rx			= &rt61pci_queue_rx,
+	.tx			= &rt61pci_queue_tx,
+	.bcn			= &rt61pci_queue_bcn,
+	.lib			= &rt61pci_rt2x00_ops,
+	.hw			= &rt61pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt61pci_rt2x00debug,
+	.debugfs		= &rt61pci_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 14e7bb2..9f733e1 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2068,7 +2068,7 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2305,19 +2305,20 @@ static const struct data_queue_desc rt73usb_queue_bcn = {
 };
 
 static const struct rt2x00_ops rt73usb_ops = {
-	.name		= KBUILD_MODNAME,
-	.max_sta_intf	= 1,
-	.max_ap_intf	= 4,
-	.eeprom_size	= EEPROM_SIZE,
-	.rf_size	= RF_SIZE,
-	.tx_queues	= NUM_TX_QUEUES,
-	.rx		= &rt73usb_queue_rx,
-	.tx		= &rt73usb_queue_tx,
-	.bcn		= &rt73usb_queue_bcn,
-	.lib		= &rt73usb_rt2x00_ops,
-	.hw		= &rt73usb_mac80211_ops,
+	.name			= KBUILD_MODNAME,
+	.max_sta_intf		= 1,
+	.max_ap_intf		= 4,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXD_DESC_SIZE,
+	.rx			= &rt73usb_queue_rx,
+	.tx			= &rt73usb_queue_tx,
+	.bcn			= &rt73usb_queue_bcn,
+	.lib			= &rt73usb_rt2x00_ops,
+	.hw			= &rt73usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs	= &rt73usb_rt2x00debug,
+	.debugfs		= &rt73usb_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 

--------------050404050107090801040009--
