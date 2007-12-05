Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbXLETOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbXLETOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXLETO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:14:29 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:60913 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbXLETO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=V7Gg0pj7d+HYoGhrDZlM15LG4/Bl4Ji6U5BlUm4Yds6XqYyDk4g2EHzHTOyUxc1FlIIo07AFh0LslQWbCRhwTTbyrEqApQljSt6djXYw9W2/H9tP6Jge+3GqcOly3wmEAVB2D1sjfvSm80hflj1GT83AgpRIucrwOonoKfFjlJA=
From: Denis Cheng <crquan@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/20] crypto/async_tx/async_tx.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu,  6 Dec 2007 03:10:48 +0800
Message-Id: <1196881848-18778-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 crypto/async_tx/async_tx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index bc18cbb..f39777f 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -57,8 +57,7 @@ static struct chan_ref_percpu *channel_table[DMA_TX_TYPE_END];
  */
 static spinlock_t async_tx_lock;
 
-static struct list_head
-async_tx_master_list = LIST_HEAD_INIT(async_tx_master_list);
+static LIST_HEAD(async_tx_master_list);
 
 /* async_tx_issue_pending_all - start all transactions on all channels */
 void async_tx_issue_pending_all(void)
-- 
1.5.3.4

