Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZGVDIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZGVDIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbZGVDI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:08:26 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:4992 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbZGVDIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:08:22 -0400
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, trivial@kernel.org
Subject: [PATCH 4/7] [drivers] ARRAY_SIZE changes
Date: Tue, 21 Jul 2009 22:02:30 -0500
Message-ID: <1248231753-8344-5-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248231753-8344-4-git-send-email-sgayda2@uiuc.edu>
References: <1248231753-8344-1-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-2-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-3-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-4-git-send-email-sgayda2@uiuc.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes were a direct result of using a semantic patch
More information can be found at http://www.emn.fr/x-info/coccinelle/

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 drivers/ata/sata_mv.c                        |    2 +-
 drivers/infiniband/hw/ipath/ipath_intr.c     |    4 +---
 drivers/media/dvb/frontends/au8522_decoder.c |    6 ++----
 drivers/mtd/lpddr/qinfo_probe.c              |    2 +-
 drivers/mtd/maps/solutionengine.c            |    2 +-
 drivers/net/s6gmac.c                         |    2 +-
 drivers/net/wireless/prism54/oid_mgt.c       |    5 ++---
 drivers/pcmcia/i82365.c                      |    2 +-
 drivers/serial/68328serial.c                 |    6 +++---
 drivers/usb/gadget/ci13xxx_udc.c             |    2 +-
 drivers/zorro/names.c                        |    2 +-
 11 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 23714ae..a661151 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2192,7 +2192,7 @@ static unsigned int mv_qc_issue_fis(struct ata_queued_cmd *qc)
 	int err = 0;
 
 	ata_tf_to_fis(&qc->tf, link->pmp, 1, (void *)fis);
-	err = mv_send_fis(ap, fis, sizeof(fis) / sizeof(fis[0]));
+	err = mv_send_fis(ap, fis, ARRAY_SIZE(fis));
 	if (err)
 		return err;
 
diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index 6c21b4b..2d41bcf 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -207,9 +207,7 @@ void ipath_format_hwerrors(u64 hwerrs,
 			   char *msg, size_t msgl)
 {
 	int i;
-	const int glen =
-	    sizeof(ipath_generic_hwerror_msgs) /
-	    sizeof(ipath_generic_hwerror_msgs[0]);
+	const int glen = ARRAY_SIZE(ipath_generic_hwerror_msgs);
 
 	for (i=0; i<glen; i++) {
 		if (hwerrs & ipath_generic_hwerror_msgs[i].mask) {
diff --git a/drivers/media/dvb/frontends/au8522_decoder.c b/drivers/media/dvb/frontends/au8522_decoder.c
index 9e9a755..41453bc 100644
--- a/drivers/media/dvb/frontends/au8522_decoder.c
+++ b/drivers/media/dvb/frontends/au8522_decoder.c
@@ -96,8 +96,7 @@ struct au8522_register_config filter_coef[] = {
 	{AU8522_FILTER_COEF_R42D, {0x01, 0x34, 0x01, 0x01, 0x34, 0x34, 0x34} },
 
 };
-#define NUM_FILTER_COEF (sizeof(filter_coef)\
-			 / sizeof(struct au8522_register_config))
+#define NUM_FILTER_COEF ARRAY_SIZE(filter_coef)
 
 
 /* Registers 0x060b through 0x0652 are the LP Filter coefficients
@@ -179,8 +178,7 @@ struct au8522_register_config lpfilter_coef[] = {
 	{0x0651, {0x40, 0x40} },
 	{0x0652, {0x01, 0x01} },
 };
-#define NUM_LPFILTER_COEF (sizeof(lpfilter_coef)\
-			   / sizeof(struct au8522_register_config))
+#define NUM_LPFILTER_COEF ARRAY_SIZE(lpfilter_coef)
 
 static inline struct au8522_state *to_state(struct v4l2_subdev *sd)
 {
diff --git a/drivers/mtd/lpddr/qinfo_probe.c b/drivers/mtd/lpddr/qinfo_probe.c
index 79bf40f..4129bca 100644
--- a/drivers/mtd/lpddr/qinfo_probe.c
+++ b/drivers/mtd/lpddr/qinfo_probe.c
@@ -57,7 +57,7 @@ static struct qinfo_query_info qinfo_array[] = {
 
 static long lpddr_get_qinforec_pos(struct map_info *map, char *id_str)
 {
-	int qinfo_lines = sizeof(qinfo_array)/sizeof(struct qinfo_query_info);
+	int qinfo_lines = ARRAY_SIZE(qinfo_array);
 	int i;
 	int bankwidth = map_bankwidth(map) * 8;
 	int major, minor;
diff --git a/drivers/mtd/maps/solutionengine.c b/drivers/mtd/maps/solutionengine.c
index 0eb41d9..7ad9496 100644
--- a/drivers/mtd/maps/solutionengine.c
+++ b/drivers/mtd/maps/solutionengine.c
@@ -99,7 +99,7 @@ static int __init init_soleng_maps(void)
 		printk(KERN_NOTICE "Using configured partition at 0x%08x.\n",
 		       CONFIG_MTD_SUPERH_RESERVE);
 		parsed_parts = superh_se_partitions;
-		nr_parts = sizeof(superh_se_partitions)/sizeof(*parsed_parts);
+		nr_parts = ARRAY_SIZE(superh_se_partitions);
 	}
 #endif /* CONFIG_MTD_SUPERH_RESERVE */
 
diff --git a/drivers/net/s6gmac.c b/drivers/net/s6gmac.c
index 5345e47..cc541f8 100644
--- a/drivers/net/s6gmac.c
+++ b/drivers/net/s6gmac.c
@@ -937,7 +937,7 @@ static struct net_device_stats *s6gmac_stats(struct net_device *dev)
 	do {
 		unsigned long flags;
 		spin_lock_irqsave(&pd->lock, flags);
-		for (i = 0; i < sizeof(pd->stats) / sizeof(unsigned long); i++)
+		for (i = 0; i < ARRAY_SIZE(pd->stats); i++)
 			pd->stats[i] =
 				pd->carry[i] << (S6_GMAC_STAT_SIZE_MIN - 1);
 		s6gmac_stats_collect(pd, &statinf[0][0]);
diff --git a/drivers/net/wireless/prism54/oid_mgt.c b/drivers/net/wireless/prism54/oid_mgt.c
index 1187e61..6d094ba 100644
--- a/drivers/net/wireless/prism54/oid_mgt.c
+++ b/drivers/net/wireless/prism54/oid_mgt.c
@@ -692,7 +692,6 @@ mgt_update_addr(islpci_private *priv)
 	return ret;
 }
 
-#define VEC_SIZE(a) ARRAY_SIZE(a)
 
 int
 mgt_commit(islpci_private *priv)
@@ -703,10 +702,10 @@ mgt_commit(islpci_private *priv)
 	if (islpci_get_state(priv) < PRV_STATE_INIT)
 		return 0;
 
-	rvalue = mgt_commit_list(priv, commit_part1, VEC_SIZE(commit_part1));
+	rvalue = mgt_commit_list(priv, commit_part1, ARRAY_SIZE(commit_part1));
 
 	if (priv->iw_mode != IW_MODE_MONITOR)
-		rvalue |= mgt_commit_list(priv, commit_part2, VEC_SIZE(commit_part2));
+		rvalue |= mgt_commit_list(priv, commit_part2, ARRAY_SIZE(commit_part2));
 
 	u = OID_INL_MODE;
 	rvalue |= mgt_commit_list(priv, &u, 1);
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 40d4953..892b0a2 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -227,7 +227,7 @@ static pcic_t pcic[] = {
     { "VIA VT83C469", IS_CIRRUS|IS_VIA },
 };
 
-#define PCIC_COUNT	(sizeof(pcic)/sizeof(pcic_t))
+#define PCIC_COUNT	ARRAY_SIZE(pcic)
 
 /*====================================================================*/
 
diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index d935b2d..50af3e8 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -153,7 +153,7 @@ static int baud_table[] = {
 	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
 	9600, 19200, 38400, 57600, 115200, 0 };
 
-#define BAUD_TABLE_SIZE (sizeof(baud_table)/sizeof(baud_table[0]))
+#define BAUD_TABLE_SIZE ARRAY_SIZE(baud_table)
 
 /* Sets or clears DTR/RTS on the requested line */
 static inline void m68k_rtsdtr(struct m68k_serial *ss, int set)
@@ -1406,10 +1406,10 @@ static void m68328_set_baud(void)
 	USTCNT = ustcnt & ~USTCNT_TXEN;
 
 again:
-	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
+	for (i = 0; i < BAUD_TABLE_SIZE; i++)
 		if (baud_table[i] == m68328_console_baud)
 			break;
-	if (i >= sizeof(baud_table) / sizeof(baud_table[0])) {
+	if (i >= BAUD_TABLE_SIZE) {
 		m68328_console_baud = 9600;
 		goto again;
 	}
diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index c7cb87a..3374619 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -1223,7 +1223,7 @@ static ssize_t show_registers(struct device *dev,
 	}
 
 	spin_lock_irqsave(udc->lock, flags);
-	k = hw_register_read(dump, sizeof(dump)/sizeof(u32));
+	k = hw_register_read(dump, ARRAY_SIZE(dump));
 	spin_unlock_irqrestore(udc->lock, flags);
 
 	for (i = 0; i < k; i++) {
diff --git a/drivers/zorro/names.c b/drivers/zorro/names.c
index e8517c3..09c516b 100644
--- a/drivers/zorro/names.c
+++ b/drivers/zorro/names.c
@@ -54,7 +54,7 @@ static struct zorro_manuf_info __initdata zorro_manuf_list[] = {
 #include "devlist.h"
 };
 
-#define MANUFS (sizeof(zorro_manuf_list)/sizeof(struct zorro_manuf_info))
+#define MANUFS ARRAY_SIZE(zorro_manuf_list)
 
 void __init zorro_name_device(struct zorro_dev *dev)
 {
-- 
1.6.3.3

