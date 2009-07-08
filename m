Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZGHVBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZGHVBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbZGHVA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:00:58 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60644 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZGHVA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:00:56 -0400
Date: Wed, 8 Jul 2009 16:37:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2009-07-08
Message-ID: <20090708203745.GK4253@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here is a collection of bug fixes, build fixes, and minor hardware
enablement patches intended for 2.6.31.  I don't think there is anything
controversial.

Please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 0ca1b08eba627b4245efd0f71b55a062bf163777:
  David S. Miller (1):
        Revert "p54: Use SKB list handling helpers instead of by-hand code."

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Andrey Yurovsky (1):
      mac80211: fix allocation in mesh_queue_preq

Clyde McPherson (2):
      b43: Add support for 4318E
      ssb: Add support for 4318E

Hin-Tak Leung (1):
      zd1211rw: adding SONY IFU-WLM2 (054c:0257) as a zd1211b device

Jaswinder Singh Rajput (1):
      includecheck fix: include/linux, rfkill.h

Jay Sternberg (1):
      Atheros Kconfig needs to be dependent on WLAN_80211

Jiri Slaby (1):
      Wireless: nl80211, fix lock imbalance

Johannes Berg (4):
      hp-wmi: fix rfkill bug
      cfg80211: fix refcount leak
      mac80211_hwsim: avoid NULL access
      mac80211: fix docbook

Larry Finger (2):
      b43/b43legacy: fix radio LED initialization
      p54: tx refused but queue active

Luciano Coelho (1):
      mac80211: minstrel: avoid accessing negative indices in rix_to_ndx()

Pascal Terjan (1):
      zd1211rw: 07b8:6001 is a ZD1211B

Samuel Ortiz (1):
      iwmc3200wifi: add Kconfig help

Vasanthakumar Thiagarajan (1):
      ath9k: Fix leak in tx descriptor

 Documentation/DocBook/mac80211.tmpl        |    2 --
 drivers/net/wireless/ath/Kconfig           |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c      |    9 ++++++++-
 drivers/net/wireless/b43/b43.h             |    1 +
 drivers/net/wireless/b43/main.c            |    7 +++++--
 drivers/net/wireless/b43/pcmcia.c          |    1 +
 drivers/net/wireless/b43legacy/b43legacy.h |    1 +
 drivers/net/wireless/b43legacy/main.c      |    7 +++++--
 drivers/net/wireless/iwmc3200wifi/Kconfig  |    9 +++++++++
 drivers/net/wireless/mac80211_hwsim.c      |    1 +
 drivers/net/wireless/p54/p54common.c       |    5 +++--
 drivers/net/wireless/zd1211rw/zd_usb.c     |    3 ++-
 drivers/platform/x86/hp-wmi.c              |    2 +-
 drivers/ssb/pcmcia.c                       |    6 ++++--
 include/linux/rfkill.h                     |    1 -
 net/mac80211/mesh_hwmp.c                   |    2 +-
 net/mac80211/rc80211_minstrel.c            |    5 ++++-
 net/wireless/nl80211.c                     |    1 +
 net/wireless/scan.c                        |    1 -
 19 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/Documentation/DocBook/mac80211.tmpl b/Documentation/DocBook/mac80211.tmpl
index e369866..f3f37f1 100644
--- a/Documentation/DocBook/mac80211.tmpl
+++ b/Documentation/DocBook/mac80211.tmpl
@@ -184,8 +184,6 @@ usage should require reading the full document.
 !Finclude/net/mac80211.h ieee80211_ctstoself_get
 !Finclude/net/mac80211.h ieee80211_ctstoself_duration
 !Finclude/net/mac80211.h ieee80211_generic_frame_duration
-!Finclude/net/mac80211.h ieee80211_get_hdrlen_from_skb
-!Finclude/net/mac80211.h ieee80211_hdrlen
 !Finclude/net/mac80211.h ieee80211_wake_queue
 !Finclude/net/mac80211.h ieee80211_stop_queue
 !Finclude/net/mac80211.h ieee80211_wake_queues
diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index d26e7b4..eb0337c 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,5 +1,6 @@
 config ATH_COMMON
 	tristate "Atheros Wireless Cards"
+	depends on WLAN_80211
 	depends on ATH5K || ATH9K || AR9170_USB
 
 source "drivers/net/wireless/ath/ath5k/Kconfig"
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b61a071..4ccf48e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -355,7 +355,14 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		}
 
 		if (bf_next == NULL) {
-			INIT_LIST_HEAD(&bf_head);
+			/*
+			 * Make sure the last desc is reclaimed if it
+			 * not a holding desc.
+			 */
+			if (!bf_last->bf_stale)
+				list_move_tail(&bf->list, &bf_head);
+			else
+				INIT_LIST_HEAD(&bf_head);
 		} else {
 			ASSERT(!list_empty(bf_q));
 			list_move_tail(&bf->list, &bf_head);
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index f580c28..4044806 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -648,6 +648,7 @@ struct b43_wl {
 	u8 nr_devs;
 
 	bool radiotap_enabled;
+	bool radio_enabled;
 
 	/* The beacon we are currently using (AP or IBSS mode).
 	 * This beacon stuff is protected by the irq_lock. */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 6456afe..e71c8d9 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3497,8 +3497,8 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (phy->ops->set_rx_antenna)
 		phy->ops->set_rx_antenna(dev, antenna);
 
-	if (!!conf->radio_enabled != phy->radio_on) {
-		if (conf->radio_enabled) {
+	if (wl->radio_enabled != phy->radio_on) {
+		if (wl->radio_enabled) {
 			b43_software_rfkill(dev, false);
 			b43info(dev->wl, "Radio turned on by software\n");
 			if (!dev->radio_hw_enable) {
@@ -4339,6 +4339,7 @@ static int b43_op_start(struct ieee80211_hw *hw)
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
 	wl->beacon_templates_virgin = 1;
+	wl->radio_enabled = 1;
 
 	mutex_lock(&wl->mutex);
 
@@ -4378,6 +4379,7 @@ static void b43_op_stop(struct ieee80211_hw *hw)
 	if (b43_status(dev) >= B43_STAT_STARTED)
 		b43_wireless_core_stop(dev);
 	b43_wireless_core_exit(dev);
+	wl->radio_enabled = 0;
 	mutex_unlock(&wl->mutex);
 
 	cancel_work_sync(&(wl->txpower_adjust_work));
@@ -4560,6 +4562,7 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 		B43_WARN_ON(1);
 
 	dev->phy.gmode = have_2ghz_phy;
+	dev->phy.radio_on = 1;
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
 	b43_wireless_core_reset(dev, tmp);
 
diff --git a/drivers/net/wireless/b43/pcmcia.c b/drivers/net/wireless/b43/pcmcia.c
index 3cfc303..6c3a749 100644
--- a/drivers/net/wireless/b43/pcmcia.c
+++ b/drivers/net/wireless/b43/pcmcia.c
@@ -35,6 +35,7 @@
 
 static /*const */ struct pcmcia_device_id b43_pcmcia_tbl[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x448),
+	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x476),
 	PCMCIA_DEVICE_NULL,
 };
 
diff --git a/drivers/net/wireless/b43legacy/b43legacy.h b/drivers/net/wireless/b43legacy/b43legacy.h
index 77fda14..038baa8 100644
--- a/drivers/net/wireless/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/b43legacy/b43legacy.h
@@ -607,6 +607,7 @@ struct b43legacy_wl {
 	u8 nr_devs;
 
 	bool radiotap_enabled;
+	bool radio_enabled;
 
 	/* The beacon we are currently using (AP or IBSS mode).
 	 * This beacon stuff is protected by the irq_lock. */
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index e5136fb..c4973c1 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2689,8 +2689,8 @@ static int b43legacy_op_dev_config(struct ieee80211_hw *hw,
 	/* Antennas for RX and management frame TX. */
 	b43legacy_mgmtframe_txantenna(dev, antenna_tx);
 
-	if (!!conf->radio_enabled != phy->radio_on) {
-		if (conf->radio_enabled) {
+	if (wl->radio_enabled != phy->radio_on) {
+		if (wl->radio_enabled) {
 			b43legacy_radio_turn_on(dev);
 			b43legacyinfo(dev->wl, "Radio turned on by software\n");
 			if (!dev->radio_hw_enable)
@@ -3441,6 +3441,7 @@ static int b43legacy_op_start(struct ieee80211_hw *hw)
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
 	wl->beacon_templates_virgin = 1;
+	wl->radio_enabled = 1;
 
 	mutex_lock(&wl->mutex);
 
@@ -3479,6 +3480,7 @@ static void b43legacy_op_stop(struct ieee80211_hw *hw)
 	if (b43legacy_status(dev) >= B43legacy_STAT_STARTED)
 		b43legacy_wireless_core_stop(dev);
 	b43legacy_wireless_core_exit(dev);
+	wl->radio_enabled = 0;
 	mutex_unlock(&wl->mutex);
 }
 
@@ -3620,6 +3622,7 @@ static int b43legacy_wireless_core_attach(struct b43legacy_wldev *dev)
 		have_bphy = 1;
 
 	dev->phy.gmode = (have_gphy || have_bphy);
+	dev->phy.radio_on = 1;
 	tmp = dev->phy.gmode ? B43legacy_TMSLOW_GMODE : 0;
 	b43legacy_wireless_core_reset(dev, tmp);
 
diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index 1eccb6d..030401d 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -4,6 +4,15 @@ config IWM
 	depends on CFG80211
 	select WIRELESS_EXT
 	select FW_LOADER
+	help
+	  The Intel Wireless Multicomm 3200 hardware is a combo
+	  card with GPS, Bluetooth, WiMax and 802.11 radios. It
+	  runs over SDIO and is typically found on Moorestown
+	  based platform. This driver takes care of the 802.11
+	  part, which is a fullmac one.
+
+	  If you choose to build it as a module, it'll be called
+	  iwmc3200wifi.ko.
 
 config IWM_DEBUG
 	bool "Enable full debugging output in iwmc3200wifi"
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e789c6e..a111bda 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -418,6 +418,7 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 			continue;
 
 		if (!data2->started || !hwsim_ps_rx_ok(data2, skb) ||
+		    !data->channel || !data2->channel ||
 		    data->channel->center_freq != data2->channel->center_freq ||
 		    !(data->group & data2->group))
 			continue;
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 48d81d9..22ca122 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -912,13 +912,14 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 		}
 
 		__skb_unlink(entry, &priv->tx_queue);
-		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
 		frame_len = entry->len;
 		entry_hdr = (struct p54_hdr *) entry->data;
 		entry_data = (struct p54_tx_data *) entry_hdr->data;
-		priv->tx_stats[entry_data->hw_queue].len--;
+		if (priv->tx_stats[entry_data->hw_queue].len)
+			priv->tx_stats[entry_data->hw_queue].len--;
 		priv->stats.dot11ACKFailureCount += payload->tries - 1;
+		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
 		/*
 		 * Frames in P54_QUEUE_FWSCAN and P54_QUEUE_BEACON are
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 14a19ba..0e6e446 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -38,7 +38,6 @@ static struct usb_device_id usb_ids[] = {
 	/* ZD1211 */
 	{ USB_DEVICE(0x0ace, 0x1211), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0ace, 0xa211), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x126f, 0xa006), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0df6, 0x9071), .driver_info = DEVICE_ZD1211 },
@@ -61,6 +60,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
+	{ USB_DEVICE(0x054c, 0x0257), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0ace, 0xb215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
@@ -87,6 +87,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0df6, 0x0036), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 4ac2311..ca50856 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -171,7 +171,7 @@ static int hp_wmi_tablet_state(void)
 static int hp_wmi_set_block(void *data, bool blocked)
 {
 	unsigned long b = (unsigned long) data;
-	int query = BIT(b + 8) | ((!!blocked) << b);
+	int query = BIT(b + 8) | ((!blocked) << b);
 
 	return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, query);
 }
diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index fbfadba..d288608 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -678,7 +678,8 @@ int ssb_pcmcia_get_invariants(struct ssb_bus *bus,
 			sprom->board_rev = tuple.TupleData[1];
 			break;
 		case SSB_PCMCIA_CIS_PA:
-			GOTO_ERROR_ON(tuple.TupleDataLen != 9,
+			GOTO_ERROR_ON((tuple.TupleDataLen != 9) &&
+				      (tuple.TupleDataLen != 10),
 				      "pa tpl size");
 			sprom->pa0b0 = tuple.TupleData[1] |
 				 ((u16)tuple.TupleData[2] << 8);
@@ -718,7 +719,8 @@ int ssb_pcmcia_get_invariants(struct ssb_bus *bus,
 			sprom->antenna_gain.ghz5.a3 = tuple.TupleData[1];
 			break;
 		case SSB_PCMCIA_CIS_BFLAGS:
-			GOTO_ERROR_ON(tuple.TupleDataLen != 3,
+			GOTO_ERROR_ON((tuple.TupleDataLen != 3) &&
+				      (tuple.TupleDataLen != 5),
 				      "bfl tpl size");
 			sprom->boardflags_lo = tuple.TupleData[1] |
 					 ((u16)tuple.TupleData[2] << 8);
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index e73e242..2ce2983 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -99,7 +99,6 @@ enum rfkill_user_states {
 #undef RFKILL_STATE_UNBLOCKED
 #undef RFKILL_STATE_HARD_BLOCKED
 
-#include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 003cb47..f49ef28 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -637,7 +637,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
 
-	preq_node = kmalloc(sizeof(struct mesh_preq_queue), GFP_KERNEL);
+	preq_node = kmalloc(sizeof(struct mesh_preq_queue), GFP_ATOMIC);
 	if (!preq_node) {
 		printk(KERN_DEBUG "Mesh HWMP: could not allocate PREQ node\n");
 		return;
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index b218b98..37771ab 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -66,7 +66,7 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
 	for (i = rix; i >= 0; i--)
 		if (mi->r[i].rix == rix)
 			break;
-	WARN_ON(mi->r[i].rix != rix);
+	WARN_ON(i < 0);
 	return i;
 }
 
@@ -181,6 +181,9 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			break;
 
 		ndx = rix_to_ndx(mi, ar[i].idx);
+		if (ndx < 0)
+			continue;
+
 		mi->r[ndx].attempts += ar[i].count;
 
 		if ((i != IEEE80211_TX_MAX_RATES - 1) && (ar[i + 1].idx < 0))
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 241bddd..43bdb13 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -447,6 +447,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 
 	rdev = __cfg80211_drv_from_info(info);
 	if (IS_ERR(rdev)) {
+		mutex_unlock(&cfg80211_mutex);
 		result = PTR_ERR(rdev);
 		goto unlock;
 	}
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index e95b638..f8e71b3 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -366,7 +366,6 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 	found = rb_find_bss(dev, res);
 
 	if (found) {
-		kref_get(&found->ref);
 		found->pub.beacon_interval = res->pub.beacon_interval;
 		found->pub.tsf = res->pub.tsf;
 		found->pub.signal = res->pub.signal;
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
