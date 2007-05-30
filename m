Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbXE3IBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbXE3IBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXE3IAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:00:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXE3IAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:00:54 -0400
Date: Wed, 30 May 2007 03:59:02 -0400
From: Bill Nottingham <notting@redhat.com>
To: netdev@vger.kernel.org
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net: fix comparisons of unsigned < 0
Message-ID: <20070530075902.GA29118@nostromo.devel.redhat.com>
Mail-Followup-To: netdev@vger.kernel.org, jgarzik@pobox.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent gcc versions emit warnings when unsigned variables are compared < 0 or >= 0.

Signed-off-by: Bill Nottingham <notting@redhat.com>

---
 mlx4/qp.c               |    3 +--
 netxen/netxen_nic_niu.c |    6 +++---
 tulip/de2104x.c         |    1 -
 3 files changed, 4 insertions(+), 6 deletions(-)

diff -ru linux-2.6.21-old/drivers/net/mlx4/qp.c linux-2.6.21/drivers/net/mlx4/qp.c
--- linux-2.6.21-old/drivers/net/mlx4/qp.c	2007-05-30 02:52:53.000000000 -0400
+++ linux-2.6.21/drivers/net/mlx4/qp.c	2007-05-30 02:18:33.000000000 -0400
@@ -113,8 +113,7 @@
 	struct mlx4_cmd_mailbox *mailbox;
 	int ret = 0;
 
-	if (cur_state < 0 || cur_state >= MLX4_QP_NUM_STATE ||
-	    new_state < 0 || cur_state >= MLX4_QP_NUM_STATE ||
+	if (cur_state >= MLX4_QP_NUM_STATE || cur_state >= MLX4_QP_NUM_STATE ||
 	    !op[cur_state][new_state])
 		return -EINVAL;
 
diff -ru linux-2.6.21-old/drivers/net/netxen/netxen_nic_niu.c linux-2.6.21/drivers/net/netxen/netxen_nic_niu.c
--- linux-2.6.21-old/drivers/net/netxen/netxen_nic_niu.c	2007-05-30 02:52:53.000000000 -0400
+++ linux-2.6.21/drivers/net/netxen/netxen_nic_niu.c	2007-05-30 02:20:02.000000000 -0400
@@ -728,7 +728,7 @@
 	__u32 mac_cfg0;
 	u32 port = physical_port[adapter->portnum];
 
-	if ((port < 0) || (port > NETXEN_NIU_MAX_GBE_PORTS))
+	if (port > NETXEN_NIU_MAX_GBE_PORTS)
 		return -EINVAL;
 	mac_cfg0 = 0;
 	netxen_gb_soft_reset(mac_cfg0);
@@ -761,7 +761,7 @@
 	__u32 reg;
 	u32 port = physical_port[adapter->portnum];
 
-	if ((port < 0) || (port > NETXEN_NIU_MAX_GBE_PORTS))
+	if (port > NETXEN_NIU_MAX_GBE_PORTS)
 		return -EINVAL;
 
 	/* save previous contents */
@@ -898,7 +898,7 @@
 	__u32 reg;
 	u32 port = physical_port[adapter->portnum];
 
-	if ((port < 0) || (port > NETXEN_NIU_MAX_XG_PORTS))
+	if (port > NETXEN_NIU_MAX_XG_PORTS)
 		return -EINVAL;
 
 	if (netxen_nic_hw_read_wx(adapter,
diff -ru linux-2.6.21-old/drivers/net/tulip/de2104x.c linux-2.6.21/drivers/net/tulip/de2104x.c
--- linux-2.6.21-old/drivers/net/tulip/de2104x.c	2007-05-30 02:52:53.000000000 -0400
+++ linux-2.6.21/drivers/net/tulip/de2104x.c	2007-05-30 02:20:44.000000000 -0400
@@ -785,7 +785,6 @@
 
 	de->tx_head = NEXT_TX(entry);
 
-	BUG_ON(TX_BUFFS_AVAIL(de) < 0);
 	if (TX_BUFFS_AVAIL(de) == 0)
 		netif_stop_queue(dev);
 
