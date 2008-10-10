Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYJJXAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYJJXAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 19:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759754AbYJJW6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:58:38 -0400
Received: from kroah.org ([198.145.64.141]:54700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752682AbYJJW6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:58:00 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Lior Dotan <liodot@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/23] Staging: SLICOSS: Fix warnings due to static usage
Date: Fri, 10 Oct 2008 15:42:44 -0700
Message-Id: <1223678567-30143-20-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081010224130.GA30117@kroah.com>
References: <20081010224130.GA30117@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lior Dotan <liodot@gmail.com>

Fix a few warning messages that crept in due to conversion of all the
functions to static

Signed-off-by: Lior Dotan <liodot@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/slicoss/slicinc.h |    6 ------
 drivers/staging/slicoss/slicoss.c |    3 ++-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/slicoss/slicinc.h b/drivers/staging/slicoss/slicinc.h
index 610c1ab..71288c4 100644
--- a/drivers/staging/slicoss/slicinc.h
+++ b/drivers/staging/slicoss/slicinc.h
@@ -61,7 +61,6 @@ static void slic_xmit_fail(struct adapter    *adapter,
 			void *cmd,
 			u32           skbtype,
 			u32           status);
-static void slic_xmit_timeout(struct net_device *dev);
 static void slic_config_pci(struct pci_dev *pcidev);
 static struct sk_buff *slic_rcvqueue_getnext(struct adapter *adapter);
 
@@ -90,8 +89,6 @@ static void  slic_cmdq_free(struct adapter *adapter);
 static void  slic_cmdq_reset(struct adapter *adapter);
 static void  slic_cmdq_addcmdpage(struct adapter *adapter, u32 *page);
 static void  slic_cmdq_getdone(struct adapter *adapter);
-static void  slic_cmdq_putdone(struct adapter *adapter,
-						struct slic_hostcmd *cmd);
 static void  slic_cmdq_putdone_irq(struct adapter *adapter,
 						struct slic_hostcmd *cmd);
 static struct slic_hostcmd *slic_cmdq_getfree(struct adapter *adapter);
@@ -103,7 +100,6 @@ static void  slic_rcvqueue_free(struct adapter *adapter);
 static void slic_rcv_handle_error(struct adapter *adapter,
 					struct slic_rcvbuf *rcvbuf);
 static void slic_adapter_set_hwaddr(struct adapter *adapter);
-static void slic_card_halt(struct sliccard *card, struct adapter *adapter);
 static int slic_card_init(struct sliccard *card, struct adapter *adapter);
 static void slic_intagg_set(struct adapter *adapter, u32 value);
 static int  slic_card_download(struct adapter *adapter);
@@ -120,7 +116,6 @@ static void slic_unmap_mmio_space(struct adapter *adapter);
 static void slic_card_cleanup(struct sliccard *card);
 static void slic_init_cleanup(struct adapter *adapter);
 static void slic_soft_reset(struct adapter *adapter);
-static void slic_card_reset(struct adapter *adapter);
 static bool slic_mac_filter(struct adapter *adapter,
 			struct ether_header *ether_frame);
 static void slic_mac_address_config(struct adapter *adapter);
@@ -133,7 +128,6 @@ static void slic_config_set(struct adapter *adapter, bool linkchange);
 static void slic_config_clear(struct adapter *adapter);
 static void slic_config_get(struct adapter *adapter, u32 config,
 			u32 configh);
-static void slic_timer_get_stats(ulong device);
 static void slic_timer_load_check(ulong context);
 static void slic_timer_ping(ulong dev);
 static void slic_assert_fail(void);
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index eb61565..f242477 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3128,6 +3128,7 @@ static int slic_mac_set_address(struct net_device *dev, void *ptr)
  * 50 seconds or whatever STATS_TIMER_INTERVAL is set to.
  *
  */
+#if SLIC_GET_STATS_TIMER_ENABLED
 static void slic_timer_get_stats(ulong dev)
 {
 	struct adapter *adapter;
@@ -3163,7 +3164,7 @@ static void slic_timer_get_stats(ulong dev)
 	    SLIC_SECS_TO_JIFFS(STATS_TIMER_INTERVAL);
 	add_timer(&adapter->statstimer);
 }
-
+#endif
 static void slic_timer_load_check(ulong cardaddr)
 {
 	struct sliccard *card = (struct sliccard *)cardaddr;
-- 
1.6.0.2

