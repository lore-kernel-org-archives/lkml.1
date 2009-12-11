Return-Path: <linux-kernel-owner+w=401wt.eu-S935085AbZLKXmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935085AbZLKXmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934957AbZLKXmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:42:00 -0500
Received: from kroah.org ([198.145.64.141]:50429 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762817AbZLKX2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@linux.vnet.ibm.com>,
       Scott Kilau <Scott.Kilau@digi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/58] jsm: removing the field jsm_board->intr_count
Date: Fri, 11 Dec 2009 15:27:51 -0800
Message-Id: <1260574122-10676-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitão <leitao@linux.vnet.ibm.com>

Currently there is a field in the jsm_board structure to cont
the number of interrupt that the card recevived, but it's not
working properly when the IRQ line is shared, and also nowhere
else this field is used. So, This patch is removing it.

Signed-off-by: Breno Leitão <leitao@linux.vnet.ibm.com>
Cc: Scott Kilau <Scott.Kilau@digi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.5.5

