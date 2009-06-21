Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZFUV62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZFUV62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 17:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZFUV6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 17:58:21 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:57943 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbZFUV6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 17:58:20 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: isdn@linux-pingi.de
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] ISDN: hisax, fix lock imbalance
Date: Sun, 21 Jun 2009 23:58:21 +0200
Message-Id: <1245621501-26898-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omittted unlocks to 2 functions.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/isdn/hisax/amd7930_fn.c |    1 +
 drivers/isdn/hisax/icc.c        |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hisax/amd7930_fn.c b/drivers/isdn/hisax/amd7930_fn.c
index 341faf5..48f139c 100644
--- a/drivers/isdn/hisax/amd7930_fn.c
+++ b/drivers/isdn/hisax/amd7930_fn.c
@@ -596,6 +596,7 @@ Amd7930_l1hw(struct PStack *st, int pr, void *arg)
 				if (cs->debug & L1_DEB_WARN)
 					debugl1(cs, "Amd7930: l1hw: l2l1 tx_skb exist this shouldn't happen");
 				skb_queue_tail(&cs->sq, skb);
+				spin_unlock_irqrestore(&cs->lock, flags);
 				break;
 			}
 			if (cs->debug & DEB_DLOG_HEX)
diff --git a/drivers/isdn/hisax/icc.c b/drivers/isdn/hisax/icc.c
index 682cac3..fd1aa40 100644
--- a/drivers/isdn/hisax/icc.c
+++ b/drivers/isdn/hisax/icc.c
@@ -470,6 +470,7 @@ ICC_l1hw(struct PStack *st, int pr, void *arg)
 				if (cs->debug & L1_DEB_WARN)
 					debugl1(cs, " l2l1 tx_skb exist this shouldn't happen");
 				skb_queue_tail(&cs->sq, skb);
+				spin_unlock_irqrestore(&cs->lock, flags);
 				break;
 			}
 			if (cs->debug & DEB_DLOG_HEX)
-- 
1.6.3.2

