Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZCJFMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZCJFMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZCJFLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:34 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:28246 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZCJFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LXZTfDCRr0rwJ5Z2NXWFrBfOjgPYSthSLzUIqdjcZyfb1WZ7oN7a5wQkOB/T2OmdLD
         gpaXr8WDTDDzA8LsDBNcC55dJyXP0UOmuUWr443dj8yOmWvwAr5JLPAUe5QpwON78pMY
         CZIbZEm/GnV1N64y+IeK49aRr3pA2M3ZGfapY=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 03/25] [net] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:28 -0500
Message-Id: <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/net/atl1e/atl1e_main.c    |    3 +--
 drivers/net/chelsio/sge.c         |    3 +--
 drivers/net/ixgb/ixgb_osdep.h     |    2 +-
 drivers/net/pppol2tp.c            |    3 +--
 drivers/net/wireless/ath9k/core.h |    6 +-----
 5 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c
index bb9094d..d089550 100644
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -1794,8 +1794,7 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 			memcpy(use_tpd, tpd, sizeof(struct atl1e_tpd_desc));
 
 			tx_buffer = atl1e_get_tx_buffer(adapter, use_tpd);
-			if (tx_buffer->skb)
-				BUG();
+			BUG_ON(tx_buffer->skb);
 
 			tx_buffer->skb = NULL;
 			tx_buffer->length =
diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
index d984b79..e60f610 100644
--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -1149,8 +1149,7 @@ static inline void write_tx_desc(struct cmdQ_e *e, dma_addr_t mapping,
 				 unsigned int len, unsigned int gen,
 				 unsigned int eop)
 {
-	if (unlikely(len > SGE_TX_DESC_MAX_PLEN))
-		BUG();
+	BUG_ON(len > SGE_TX_DESC_MAX_PLEN);
 	e->addr_lo = (u32)mapping;
 	e->addr_hi = (u64)mapping >> 32;
 	e->len_gen = V_CMD_LEN(len) | V_CMD_GEN1(gen);
diff --git a/drivers/net/ixgb/ixgb_osdep.h b/drivers/net/ixgb/ixgb_osdep.h
index d92e72b..371a6be 100644
--- a/drivers/net/ixgb/ixgb_osdep.h
+++ b/drivers/net/ixgb/ixgb_osdep.h
@@ -40,7 +40,7 @@
 #include <linux/sched.h>
 
 #undef ASSERT
-#define ASSERT(x)	if (!(x)) BUG()
+#define ASSERT(x)	BUG_ON(!(x))
 #define MSGOUT(S, A, B)	printk(KERN_DEBUG S "\n", A, B)
 
 #ifdef DBG
diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
index f1a9467..97959b3 100644
--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -1222,8 +1222,7 @@ static void pppol2tp_tunnel_closeall(struct pppol2tp_tunnel *tunnel)
 	struct pppol2tp_session *session;
 	struct sock *sk;
 
-	if (tunnel == NULL)
-		BUG();
+	BUG_ON(tunnel == NULL);
 
 	PRINTK(tunnel->debug, PPPOL2TP_MSG_CONTROL, KERN_INFO,
 	       "%s: closing all sessions...\n", tunnel->name);
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 4ca2aed..d310c68 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -52,11 +52,7 @@ struct ath_node;
 
 #define A_MAX(a, b) ((a) > (b) ? (a) : (b))
 
-#define ASSERT(exp) do {			\
-		if (unlikely(!(exp))) {		\
-			BUG();			\
-		}				\
-	} while (0)
+#define ASSERT(exp) BUG_ON(!(exp));
 
 #define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
-- 
1.6.1.3

