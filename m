Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598Ab0A0Uqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0A0Uqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185Ab0A0Uql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:41 -0500
Received: from mail.perches.com ([173.55.12.10]:1540 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab0A0Uqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:34 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 07/13] drivers/block/floppy.c: Use %pf in logging messages
Date: Wed, 27 Jan 2010 12:46:23 -0800
Message-Id: <e98198dd09117cc9cae7be10490c713be9283063.1264624292.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print the function name not the pointer address where useful and possible

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index c1004b8..14fefe2 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -908,7 +908,7 @@ static inline void unlock_fdc(void)
 		DPRINT("FDC access conflict!\n");
 
 	if (do_floppy)
-		DPRINT("device interrupt still active at FDC release: %p!\n",
+		DPRINT("device interrupt still active at FDC release: %pf!\n",
 		       do_floppy);
 	command_status = FD_COMMAND_NONE;
 	spin_lock_irqsave(&floppy_lock, flags);
@@ -1733,7 +1733,7 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 		/* we don't even know which FDC is the culprit */
 		pr_info("DOR0=%x\n", fdc_state[0].dor);
 		pr_info("floppy interrupt on bizarre fdc %d\n", fdc);
-		pr_info("handler=%p\n", handler);
+		pr_info("handler=%pf\n", handler);
 		is_alive(__func__, "bizarre fdc");
 		return IRQ_NONE;
 	}
@@ -1792,7 +1792,7 @@ static void reset_interrupt(void)
 	debugt("reset interrupt:");
 	result();		/* get the status ready for set_fdc */
 	if (FDCS->reset) {
-		pr_info("reset set in interrupt, calling %p\n", cont->error);
+		pr_info("reset set in interrupt, calling %pf\n", cont->error);
 		cont->error();	/* a reset just after a reset. BAD! */
 	}
 	cont->redo();
@@ -1833,7 +1833,7 @@ static void show_floppy(void)
 	pr_info("\n");
 	pr_info("floppy driver state\n");
 	pr_info("-------------------\n");
-	pr_info("now=%lu last interrupt=%lu diff=%lu last called handler=%p\n",
+	pr_info("now=%lu last interrupt=%lu diff=%lu last called handler=%pf\n",
 		jiffies, interruptjiffies, jiffies - interruptjiffies,
 		lasthandler);
 
@@ -1852,13 +1852,13 @@ static void show_floppy(void)
 	pr_info("status=%x\n", fd_inb(FD_STATUS));
 	pr_info("fdc_busy=%lu\n", fdc_busy);
 	if (do_floppy)
-		pr_info("do_floppy=%p\n", do_floppy);
+		pr_info("do_floppy=%pf\n", do_floppy);
 	if (work_pending(&floppy_work))
-		pr_info("floppy_work.func=%p\n", floppy_work.func);
+		pr_info("floppy_work.func=%pf\n", floppy_work.func);
 	if (timer_pending(&fd_timer))
-		pr_info("fd_timer.function=%p\n", fd_timer.function);
+		pr_info("fd_timer.function=%pf\n", fd_timer.function);
 	if (timer_pending(&fd_timeout)) {
-		pr_info("timer_function=%p\n", fd_timeout.function);
+		pr_info("timer_function=%pf\n", fd_timeout.function);
 		pr_info("expires=%lu\n", fd_timeout.expires - jiffies);
 		pr_info("now=%lu\n", jiffies);
 	}
-- 
1.6.6.rc0.57.gad7a

