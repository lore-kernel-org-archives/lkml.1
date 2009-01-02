Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbZABKmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbZABKmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbZABKlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:40 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:45028 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbZABKlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:36 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: mvme147 core - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:19 +0100
Message-Id: <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mvme147/config.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index b72f079..100baaa 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -114,8 +114,9 @@ static irqreturn_t mvme147_timer_int (int irq, void *dev_id)
 void mvme147_sched_init (irq_handler_t timer_routine)
 {
 	tick_handler = timer_routine;
-	request_irq (PCC_IRQ_TIMER1, mvme147_timer_int,
-		IRQ_FLG_REPLACE, "timer 1", NULL);
+	if (request_irq(PCC_IRQ_TIMER1, mvme147_timer_int, IRQ_FLG_REPLACE,
+			"timer 1", NULL))
+		pr_err("Couldn't register timer interrupt\n");
 
 	/* Init the clock with a value */
 	/* our clock goes off every 6.25us */
-- 
1.5.6.5

