Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXDDVq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXDDVq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXDDVqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:46:33 -0400
Received: from mx0.karneval.cz ([81.27.192.15]:58560 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752142AbXDDVqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:46:30 -0400
Message-id: <25307199761334218148@karneval.cz>
In-reply-to: <16309194841640222796@karneval.cz>
Subject: [PATCH 4/5] Char: cyclades, remove volatiles
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed,  4 Apr 2007 23:45:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, remove volatiles

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit fc6aa32bd302fb7dbd1dcc7c5829b0cb27a79ce6
tree a958d622a33f0dd499f072f44bcdd121b771b921
parent d4e20e52c6084cff971d5b696c6eeac5ca2f9f48
author Jiri Slaby <jirislaby@gmail.com> Mon, 26 Mar 2007 18:03:30 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 27 Mar 2007 14:45:40 +0200

 drivers/char/cyclades.c |   52 +++++++++++++++++++++++------------------------
 1 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 0e530cb..70d5a39 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -967,7 +967,7 @@ do_softint(struct work_struct *work)
  */
 static int cyy_issue_cmd(void __iomem * base_addr, u_char cmd, int index)
 {
-	volatile int i;
+	unsigned int i;
 
 	/* Check to see that the previous command has completed */
 	for (i = 0; i < 100; i++) {
@@ -1043,7 +1043,7 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 {
 	struct cyclades_port *info;
 	struct tty_struct *tty;
-	volatile int char_count;
+	int char_count;
 	int i, j, len, mdm_change, mdm_status, outch;
 	int save_xir, channel, save_car;
 	char data;
@@ -1551,20 +1551,19 @@ cyz_issue_cmd(struct cyclades_card *cinfo,
 }				/* cyz_issue_cmd */
 
 static void
-cyz_handle_rx(struct cyclades_port *info,
-		volatile struct CH_CTRL __iomem * ch_ctrl,
-		volatile struct BUF_CTRL __iomem * buf_ctrl)
+cyz_handle_rx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
+		struct BUF_CTRL __iomem *buf_ctrl)
 {
 	struct cyclades_card *cinfo = &cy_card[info->card];
 	struct tty_struct *tty = info->tty;
-	volatile int char_count;
+	int char_count;
 	int len;
 #ifdef BLOCKMOVE
 	int small_count;
 #else
 	char data;
 #endif
-	volatile __u32 rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
+	__u32 rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
 
 	rx_get = new_rx_get = readl(&buf_ctrl->rx_get);
 	rx_put = readl(&buf_ctrl->rx_put);
@@ -1648,18 +1647,17 @@ cyz_handle_rx(struct cyclades_port *info,
 }
 
 static void
-cyz_handle_tx(struct cyclades_port *info,
-		volatile struct CH_CTRL __iomem * ch_ctrl,
-		volatile struct BUF_CTRL __iomem * buf_ctrl)
+cyz_handle_tx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
+		struct BUF_CTRL __iomem *buf_ctrl)
 {
 	struct cyclades_card *cinfo = &cy_card[info->card];
 	struct tty_struct *tty = info->tty;
 	char data;
-	volatile int char_count;
+	int char_count;
 #ifdef BLOCKMOVE
 	int small_count;
 #endif
-	volatile __u32 tx_put, tx_get, tx_bufsize, tx_bufaddr;
+	__u32 tx_put, tx_get, tx_bufsize, tx_bufaddr;
 
 	if (info->xmit_cnt <= 0)	/* Nothing to transmit */
 		return;
@@ -1739,11 +1737,11 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 {
 	struct tty_struct *tty;
 	struct cyclades_port *info;
-	static volatile struct FIRM_ID __iomem *firm_id;
-	static volatile struct ZFW_CTRL __iomem *zfw_ctrl;
-	static volatile struct BOARD_CTRL __iomem *board_ctrl;
-	static volatile struct CH_CTRL __iomem *ch_ctrl;
-	static volatile struct BUF_CTRL __iomem *buf_ctrl;
+	static struct FIRM_ID __iomem *firm_id;
+	static struct ZFW_CTRL __iomem *zfw_ctrl;
+	static struct BOARD_CTRL __iomem *board_ctrl;
+	static struct CH_CTRL __iomem *ch_ctrl;
+	static struct BUF_CTRL __iomem *buf_ctrl;
 	__u32 channel;
 	__u8 cmd;
 	__u32 param;
@@ -1900,11 +1898,11 @@ static void cyz_poll(unsigned long arg)
 	struct cyclades_card *cinfo;
 	struct cyclades_port *info;
 	struct tty_struct *tty;
-	static volatile struct FIRM_ID *firm_id;
-	static volatile struct ZFW_CTRL *zfw_ctrl;
-	static volatile struct BOARD_CTRL *board_ctrl;
-	static volatile struct CH_CTRL *ch_ctrl;
-	static volatile struct BUF_CTRL *buf_ctrl;
+	static struct FIRM_ID *firm_id;
+	static struct ZFW_CTRL *zfw_ctrl;
+	static struct BOARD_CTRL *board_ctrl;
+	static struct CH_CTRL *ch_ctrl;
+	static struct BUF_CTRL *buf_ctrl;
 	unsigned long expires = jiffies + HZ;
 	int card, port;
 
@@ -3003,12 +3001,12 @@ static int cy_chars_in_buffer(struct tty_struct *tty)
 		return info->xmit_cnt;
 #ifdef Z_EXT_CHARS_IN_BUFFER
 	} else {
-		static volatile struct FIRM_ID *firm_id;
-		static volatile struct ZFW_CTRL *zfw_ctrl;
-		static volatile struct CH_CTRL *ch_ctrl;
-		static volatile struct BUF_CTRL *buf_ctrl;
+		static struct FIRM_ID *firm_id;
+		static struct ZFW_CTRL *zfw_ctrl;
+		static struct CH_CTRL *ch_ctrl;
+		static struct BUF_CTRL *buf_ctrl;
 		int char_count;
-		volatile __u32 tx_put, tx_get, tx_bufsize;
+		__u32 tx_put, tx_get, tx_bufsize;
 
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		zfw_ctrl = cy_card[card].base_addr +
