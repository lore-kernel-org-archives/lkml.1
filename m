Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbYD3WGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbYD3WGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932870AbYD3WDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:03:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624AbYD3WDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Vdzc1JTjX3L0r7uCm9XEAOBThWUaYicpZ5x6SGKIM1viBh/u5ES7JgUpQyrd/pFJbSf58Em7hkSd/EEDI7ECaBrZFqZ9q6KUZt705m2zrT9i3Txn1aUsTH+9cPQA/ZviEKNODsqSA5tmp8iit1bjvcErPCyqXJ8x4BiDt/2N3Xg=
Subject: [PATCH 07/10] net: fix returning void-valued expression warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:03:43 -0700
Message-Id: <1209593023.24729.117.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/8390.c:37:2: warning: returning void-valued expression
drivers/net/bnx2.c:1635:3: warning: returning void-valued expression
drivers/net/xen-netfront.c:1806:2: warning: returning void-valued expression
net/ipv4/tcp_hybla.c:105:3: warning: returning void-valued expression
net/ipv4/tcp_vegas.c:171:3: warning: returning void-valued expression
net/ipv4/tcp_veno.c:123:3: warning: returning void-valued expression
net/sysctl_net.c:85:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/8390.c         |    2 +-
 drivers/net/bnx2.c         |    6 ++++--
 drivers/net/xen-netfront.c |    2 +-
 net/ipv4/tcp_hybla.c       |    6 ++++--
 net/ipv4/tcp_vegas.c       |    6 ++++--
 net/ipv4/tcp_veno.c        |    6 ++++--
 net/sysctl_net.c           |    2 +-
 7 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/8390.c b/drivers/net/8390.c
index a499e86..dc5d258 100644
--- a/drivers/net/8390.c
+++ b/drivers/net/8390.c
@@ -34,7 +34,7 @@ struct net_device *__alloc_ei_netdev(int size)
 
 void NS8390_init(struct net_device *dev, int startp)
 {
-	return __NS8390_init(dev, startp);
+	__NS8390_init(dev, startp);
 }
 
 EXPORT_SYMBOL(ei_open);
diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index 15853be..8613879 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -1631,8 +1631,10 @@ bnx2_set_default_remote_link(struct bnx2 *bp)
 static void
 bnx2_set_default_link(struct bnx2 *bp)
 {
-	if (bp->phy_flags & BNX2_PHY_FLAG_REMOTE_PHY_CAP)
-		return bnx2_set_default_remote_link(bp);
+	if (bp->phy_flags & BNX2_PHY_FLAG_REMOTE_PHY_CAP) {
+		bnx2_set_default_remote_link(bp);
+		return;
+	}
 
 	bp->autoneg = AUTONEG_SPEED | AUTONEG_FLOW_CTRL;
 	bp->req_line_speed = 0;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index e62018a..8bddff1 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1803,7 +1803,7 @@ static void __exit netif_exit(void)
 	if (is_initial_xendomain())
 		return;
 
-	return xenbus_unregister_driver(&netfront);
+	xenbus_unregister_driver(&netfront);
 }
 module_exit(netif_exit);
 
diff --git a/net/ipv4/tcp_hybla.c b/net/ipv4/tcp_hybla.c
index 44618b6..bfcbd14 100644
--- a/net/ipv4/tcp_hybla.c
+++ b/net/ipv4/tcp_hybla.c
@@ -101,8 +101,10 @@ static void hybla_cong_avoid(struct sock *sk, u32 ack, u32 in_flight)
 	if (!tcp_is_cwnd_limited(sk, in_flight))
 		return;
 
-	if (!ca->hybla_en)
-		return tcp_reno_cong_avoid(sk, ack, in_flight);
+	if (!ca->hybla_en) {
+		tcp_reno_cong_avoid(sk, ack, in_flight);
+		return;
+	}
 
 	if (ca->rho == 0)
 		hybla_recalc_param(sk);
diff --git a/net/ipv4/tcp_vegas.c b/net/ipv4/tcp_vegas.c
index 0e1a8c9..14504da 100644
--- a/net/ipv4/tcp_vegas.c
+++ b/net/ipv4/tcp_vegas.c
@@ -167,8 +167,10 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 in_flight)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct vegas *vegas = inet_csk_ca(sk);
 
-	if (!vegas->doing_vegas_now)
-		return tcp_reno_cong_avoid(sk, ack, in_flight);
+	if (!vegas->doing_vegas_now) {
+		tcp_reno_cong_avoid(sk, ack, in_flight);
+		return;
+	}
 
 	/* The key players are v_beg_snd_una and v_beg_snd_nxt.
 	 *
diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index 2bf618a..d08b2e8 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -119,8 +119,10 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 in_flight)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct veno *veno = inet_csk_ca(sk);
 
-	if (!veno->doing_veno_now)
-		return tcp_reno_cong_avoid(sk, ack, in_flight);
+	if (!veno->doing_veno_now) {
+		tcp_reno_cong_avoid(sk, ack, in_flight);
+		return;
+	}
 
 	/* limited by applications */
 	if (!tcp_is_cwnd_limited(sk, in_flight))
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index 665e856..b4f0525 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -82,6 +82,6 @@ EXPORT_SYMBOL_GPL(register_net_sysctl_table);
 
 void unregister_net_sysctl_table(struct ctl_table_header *header)
 {
-	return unregister_sysctl_table(header);
+	unregister_sysctl_table(header);
 }
 EXPORT_SYMBOL_GPL(unregister_net_sysctl_table);
-- 
1.5.5.1.305.g7c84


