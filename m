Return-Path: <linux-kernel-owner+w=401wt.eu-S1946645AbXBIQk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946645AbXBIQk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946663AbXBIQk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:40:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51750 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946645AbXBIQkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:40:16 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] trivial s2io annotations
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HFYnH-0006sQ-PP@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:40:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/s2io.c |    2 +-
 drivers/net/s2io.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 639fbc0..8646b64 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -7298,7 +7298,7 @@ static void update_L3L4_header(struct s2io_nic *sp, struct lro *lro)
 {
 	struct iphdr *ip = lro->iph;
 	struct tcphdr *tcp = lro->tcph;
-	u16 nchk;
+	__sum16 nchk;
 	struct stat_block *statinfo = sp->mac_control.stats_info;
 	DBG_PRINT(INFO_DBG,"%s: Been here...\n", __FUNCTION__);
 
diff --git a/drivers/net/s2io.h b/drivers/net/s2io.h
index a5e1a51..0de0c65 100644
--- a/drivers/net/s2io.h
+++ b/drivers/net/s2io.h
@@ -727,12 +727,12 @@ struct lro {
 	struct iphdr	*iph;
 	struct tcphdr	*tcph;
 	u32		tcp_next_seq;
-	u32		tcp_ack;
+	__be32		tcp_ack;
 	int		total_len;
 	int		frags_len;
 	int		sg_num;
 	int		in_use;
-	u16		window;
+	__be16		window;
 	u32		cur_tsval;
 	u32		cur_tsecr;
 	u8		saw_ts;
@@ -1005,7 +1005,7 @@ static int s2io_set_swapper(struct s2io_nic * sp);
 static void s2io_card_down(struct s2io_nic *nic);
 static int s2io_card_up(struct s2io_nic *nic);
 static int get_xena_rev_id(struct pci_dev *pdev);
-static int wait_for_cmd_complete(void *addr, u64 busy_bit);
+static int wait_for_cmd_complete(void __iomem *addr, u64 busy_bit);
 static int s2io_add_isr(struct s2io_nic * sp);
 static void s2io_rem_isr(struct s2io_nic * sp);
 
-- 
1.5.0-rc2.GIT

