Return-Path: <linux-kernel-owner+w=401wt.eu-S1422803AbXDRKIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422803AbXDRKIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422801AbXDRKIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:08:32 -0400
Received: from mx0.karneval.cz ([81.27.192.123]:14867 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422800AbXDRKIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:08:31 -0400
Message-id: <52729630993628431@karneval.cz>
In-reply-to: <2428225437641930190@karneval.cz>
Subject: [PATCH 11/11] Char: cyclades, allow DEBUG_SHIRQ
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:08:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, allow DEBUG_SHIRQ

Test if base addr is non-null in ISR to prove the card has been correctly
initialized. This is needed for DEBUG_SHIRQ for example.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 71c2e9b72594f69e4e226006206ffa74b55c1642
tree 0134ea3532474f2c7bc2deabcf453b83f0747e5f
parent 73621a789a0482299242ea61c971af6b5f8b828a
author Jiri Slaby <jirislaby@gmail.com> Wed, 18 Apr 2007 11:59:22 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 18 Apr 2007 11:59:22 +0200

 drivers/char/cyclades.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 5a9e7d6..5d6559e 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1444,6 +1444,10 @@ static irqreturn_t cyy_interrupt(int irq, void *dev_id)
 	card_base_addr = cinfo->base_addr;
 	index = cinfo->bus_index;
 
+	/* card was not initialized yet (e.g. DEBUG_SHIRQ) */
+	if (unlikely(card_base_addr == NULL))
+		return IRQ_HANDLED;
+
 	/* This loop checks all chips in the card.  Make a note whenever
 	   _any_ chip had some work to do, as this is considered an
 	   indication that there will be more to do.  Only when no chip
