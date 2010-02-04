Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab0BDOjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:39:51 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:42208 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab0BDOjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:39:47 -0500
Subject: [PATCH 14/30] hpsa: interrupt pending function should return bool not
	unsigned long
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:42:35 -0600
Message-ID: <20100204144235.10406.70090.stgit@beardog.cce.hp.com>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: interrupt pending function should return bool not unsigned long

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 drivers/scsi/hpsa.h |    8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 82987e1..314854b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2693,7 +2693,7 @@ static inline unsigned long get_next_completion(struct ctlr_info *h)
 	return h->access.command_completed(h);
 }
 
-static inline int interrupt_pending(struct ctlr_info *h)
+static inline bool interrupt_pending(struct ctlr_info *h)
 {
 	return h->access.intr_pending(h);
 }
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index cdac95b..0eab386 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -33,7 +33,7 @@ struct access_method {
 		struct CommandList *c);
 	void (*set_intr_mask)(struct ctlr_info *h, unsigned long val);
 	unsigned long (*fifo_full)(struct ctlr_info *h);
-	unsigned long (*intr_pending)(struct ctlr_info *h);
+	bool (*intr_pending)(struct ctlr_info *h);
 	unsigned long (*command_completed)(struct ctlr_info *h);
 };
 
@@ -233,14 +233,12 @@ static unsigned long SA5_completed(struct ctlr_info *h)
 /*
  *	Returns true if an interrupt is pending..
  */
-static unsigned long SA5_intr_pending(struct ctlr_info *h)
+static bool SA5_intr_pending(struct ctlr_info *h)
 {
 	unsigned long register_value  =
 		readl(h->vaddr + SA5_INTR_STATUS);
 	dev_dbg(&h->pdev->dev, "intr_pending %lx\n", register_value);
-	if (register_value &  SA5_INTR_PENDING)
-		return  1;
-	return 0 ;
+	return register_value & SA5_INTR_PENDING;
 }
 
 

