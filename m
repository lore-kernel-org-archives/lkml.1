Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZI2SRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZI2SRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZI2SRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:17:44 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:57187 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbZI2SRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:17:00 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Scott.Kilau@digi.com, greg@kroah.com
Subject: [PATCH 5/5] jsm: removing the field jsm_board->intr_count
Date: Tue, 29 Sep 2009 15:16:59 -0300
Message-Id: <d70374f8f613a22d94ddd5003a1542eac026aeb9.1254247209.git.leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is a field in the jsm_board structure to cont
the number of interrupt that the card recevived, but it's not
working properly when the IRQ line is shared, and also nowhere
else this field is used. So, This patch is removing it.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm.h     |    1 -
 drivers/serial/jsm/jsm_neo.c |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/jsm/jsm.h b/drivers/serial/jsm/jsm.h
index 484c927..38a509c 100644
--- a/drivers/serial/jsm/jsm.h
+++ b/drivers/serial/jsm/jsm.h
@@ -138,7 +138,6 @@ struct jsm_board
 	u32		nasync;		/* Number of ports on card */
 
 	u32		irq;		/* Interrupt request number */
-	u64		intr_count;	/* Count of interrupts */
 
 	u64		membase;	/* Start of base memory of the card */
 	u64		membase_end;	/* End of base memory of the card */
diff --git a/drivers/serial/jsm/jsm_neo.c b/drivers/serial/jsm/jsm_neo.c
index bee3727..7960d96 100644
--- a/drivers/serial/jsm/jsm_neo.c
+++ b/drivers/serial/jsm/jsm_neo.c
@@ -1117,8 +1117,6 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 	unsigned long lock_flags2;
 	int outofloop_count = 0;
 
-	brd->intr_count++;
-
 	/* Lock out the slow poller from running on this board. */
 	spin_lock_irqsave(&brd->bd_intr_lock, lock_flags);
 
-- 
1.6.0.4

