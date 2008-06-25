Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYFYLCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYFYLCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbYFYLBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:01:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56329 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYFYLBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:01:45 -0400
Date: Wed, 25 Jun 2008 12:25:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, jirislaby@gmail.com,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linville@tuxdriver.com
Subject: Small cleanups
Message-ID: <20080625102553.GA2648@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Small whitespace cleanups for wireless drivers

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit ac537c3b8a8dda4adcbf7810c4b86474e054f48c
tree d638e3fbcb6d6c35109661f908d84cb81df95322
parent 7f80fda409c75b32b46a06b371fe504805188395
author Pavel <pavel@amd.ucw.cz> Wed, 25 Jun 2008 12:23:00 +0200
committer Pavel <pavel@amd.ucw.cz> Wed, 25 Jun 2008 12:23:00 +0200

 drivers/net/wireless/airo.c     |   41 +++++++++++++++++----------------------
 drivers/net/wireless/ath5k/hw.c |    4 ++--
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 32019fb..329be62 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -85,10 +85,10 @@ #endif /* CONFIG_PCI */
 
 /* Include Wireless Extension definition and check version - Jean II */
 #include <linux/wireless.h>
-#define WIRELESS_SPY		// enable iwspy support
-#include <net/iw_handler.h>	// New driver API
+#define WIRELESS_SPY		/* enable iwspy support */
+#include <net/iw_handler.h>	/* New driver API */
 
-#define CISCO_EXT		// enable Cisco extensions
+#define CISCO_EXT		/* enable Cisco extensions */
 #ifdef CISCO_EXT
 #include <linux/delay.h>
 #endif
@@ -281,7 +281,7 @@ MODULE_PARM_DESC(proc_perm, "The permiss
 /* This is a kind of sloppy hack to get this information to OUT4500 and
    IN4500.  I would be extremely interested in the situation where this
    doesn't work though!!! */
-static int do8bitIO = 0;
+static int do8bitIO /* = 0 */;
 
 /* Return codes */
 #define SUCCESS 0
@@ -398,8 +398,8 @@ #define RIDSIZE 2048
 #define MAXTXQ 64
 
 /* BAP selectors */
-#define BAP0 0 // Used for receiving packets
-#define BAP1 2 // Used for xmiting packets and working with RIDS
+#define BAP0 0 /* Used for receiving packets */
+#define BAP1 2 /* Used for xmiting packets and working with RIDS */
 
 /* Flags */
 #define COMMAND_BUSY 0x8000
@@ -5530,11 +5530,13 @@ static int airo_pci_suspend(struct pci_d
 	Cmd cmd;
 	Resp rsp;
 
-	if ((ai->APList == NULL) &&
-		(ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL)) == NULL)
+	if (!ai->APList)
+		ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL);
+	if (!ai->APList)
 		return -ENOMEM;
-	if ((ai->SSID == NULL) &&
-		(ai->SSID = kmalloc(sizeof(SsidRid), GFP_KERNEL)) == NULL)
+	if (!ai->SSID)
+		ai->SSID = kmalloc(sizeof(SsidRid), GFP_KERNEL);
+	if (!ai->SSID)
 		return -ENOMEM;
 	readAPListRid(ai, ai->APList);
 	readSsidRid(ai, ai->SSID);
@@ -5545,7 +5547,7 @@ static int airo_pci_suspend(struct pci_d
 	disable_MAC(ai, 0);
 	netif_device_detach(dev);
 	ai->power = state;
-	cmd.cmd=HOSTSLEEP;
+	cmd.cmd = HOSTSLEEP;
 	issuecommand(ai, &cmd, &rsp);
 
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
@@ -5575,7 +5577,7 @@ static int airo_pci_resume(struct pci_de
 		msleep(100);
 	}
 
-	set_bit (FLAG_COMMIT, &ai->flags);
+	set_bit(FLAG_COMMIT, &ai->flags);
 	disable_MAC(ai, 0);
         msleep(200);
 	if (ai->SSID) {
@@ -5602,9 +5604,6 @@ #endif
 static int __init airo_init_module( void )
 {
 	int i;
-#if 0
-	int have_isa_dev = 0;
-#endif
 
 	airo_entry = create_proc_entry("driver/aironet",
 				       S_IFDIR | airo_perm,
@@ -5615,15 +5614,11 @@ #endif
 		airo_entry->gid = proc_gid;
 	}
 
-	for( i = 0; i < 4 && io[i] && irq[i]; i++ ) {
+	for (i = 0; i < 4 && io[i] && irq[i]; i++) {
 		airo_print_info("", "Trying to configure ISA adapter at irq=%d "
 			"io=0x%x", irq[i], io[i] );
 		if (init_airo_card( irq[i], io[i], 0, NULL ))
-#if 0
-			have_isa_dev = 1;
-#else
 			/* do nothing */ ;
-#endif
 	}
 
 #ifdef CONFIG_PCI
@@ -5669,7 +5664,7 @@ #endif
 
 static u8 airo_rssi_to_dbm (tdsRssiEntry *rssi_rid, u8 rssi)
 {
-	if( !rssi_rid )
+	if (!rssi_rid)
 		return 0;
 
 	return (0x100 - rssi_rid[rssi].rssidBm);
@@ -5679,10 +5674,10 @@ static u8 airo_dbm_to_pct (tdsRssiEntry 
 {
 	int i;
 
-	if( !rssi_rid )
+	if (!rssi_rid)
 		return 0;
 
-	for( i = 0; i < 256; i++ )
+	for (i = 0; i < 256; i++)
 		if (rssi_rid[i].rssidBm == dbm)
 			return rssi_rid[i].rssipct;
 
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 77990b5..c6d12c5 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -31,14 +31,14 @@ #include "reg.h"
 #include "base.h"
 #include "debug.h"
 
-/*Rate tables*/
+/* Rate tables */
 static const struct ath5k_rate_table ath5k_rt_11a = AR5K_RATES_11A;
 static const struct ath5k_rate_table ath5k_rt_11b = AR5K_RATES_11B;
 static const struct ath5k_rate_table ath5k_rt_11g = AR5K_RATES_11G;
 static const struct ath5k_rate_table ath5k_rt_turbo = AR5K_RATES_TURBO;
 static const struct ath5k_rate_table ath5k_rt_xr = AR5K_RATES_XR;
 
-/*Prototypes*/
+/* Prototypes */
 static int ath5k_hw_nic_reset(struct ath5k_hw *, u32);
 static int ath5k_hw_nic_wakeup(struct ath5k_hw *, int, bool);
 static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
