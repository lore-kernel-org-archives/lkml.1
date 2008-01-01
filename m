Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbYAACA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbYAACA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbYAACAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:00:17 -0500
Received: from fmailhost05.isp.att.net ([204.127.217.105]:49546 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYAACAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:00:16 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 05/26] atl1: print debug info if rrd error
Date: Mon, 31 Dec 2007 19:59:43 -0600
Message-Id: <1199152804-3889-6-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Add some debug dev_printks if we encounter a bad receive return descriptor.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 239641f..262d3ca 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -1127,7 +1127,26 @@ static void atl1_intr_rx(struct atl1_adapter *adapter)
 		if (likely(rrd->xsz.valid)) {	/* packet valid */
 chk_rrd:
 			/* check rrd status */
-			if (likely(rrd->num_buf == 1))
+			if (rrd->num_buf != 1) {
+				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
+					"rx_buf_len = %d\n",
+					adapter->rx_buffer_len);
+				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
+					"RRD num_buf = %d\n",
+					rrd->num_buf);
+				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
+					"RRD pkt_len = %d\n",
+					rrd->xsz.xsum_sz.pkt_size);
+				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
+					"RRD pkt_flg = 0x%08X\n",
+					rrd->pkt_flg);
+				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
+					"RRD err_flg = 0x%08X\n",
+					rrd->err_flg);
+				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
+					"RRD vlan_tag = 0x%08X\n",
+					rrd->vlan_tag);
+			} else
 				goto rrd_ok;
 
 			/* rrd seems to be bad */
-- 
1.5.3.3

