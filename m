Return-Path: <linux-kernel-owner+w=401wt.eu-S935052AbYBCBwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935052AbYBCBwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 20:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935754AbYBCBui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 20:50:38 -0500
Received: from fmailhost05.isp.att.net ([204.127.217.105]:41745 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434AbYBCBuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 20:50:25 -0500
X-Originating-IP: [70.157.3.17]
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 08/10] atl1: print debug info if rrd error
Date: Sat,  2 Feb 2008 19:50:10 -0600
Message-Id: <1202003412-4028-8-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202003412-4028-1-git-send-email-jacliburn@bellsouth.net>
References: <1202003412-4028-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some debug printks if we encounter a potentially bad receive
return descriptor.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Acked-by: Chris Snook <csnook@redhat.com>
---
 drivers/net/atlx/atl1.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 51eca23..4e4cb23 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -1144,14 +1144,32 @@ chk_rrd:
 			/* check rrd status */
 			if (likely(rrd->num_buf == 1))
 				goto rrd_ok;
+			else if (netif_msg_rx_err(adapter)) {
+				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
+					"unexpected RRD buffer count\n");
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
+			}
 
 			/* rrd seems to be bad */
 			if (unlikely(i-- > 0)) {
 				/* rrd may not be DMAed completely */
-				if (netif_msg_rx_err(adapter))
-					dev_printk(KERN_DEBUG,
-						&adapter->pdev->dev,
-						"unexpected RRD count\n");
 				udelay(1);
 				goto chk_rrd;
 			}
-- 
1.5.3.8

