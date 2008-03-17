Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYCQQfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYCQQfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYCQQez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:34:55 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:17241 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYCQQey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:34:54 -0400
Message-ID: <47DE9DA7.1090805@hp.com>
Date: Mon, 17 Mar 2008 12:34:47 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, npiggin@suse.de, dgc@sgi.com
Subject: [Patch (block.git) 1/2] Add irqsave to spinlocks in call function
 single interrupt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 kernel/smp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 852abd3..7232e1c 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -24,12 +24,13 @@ void __cpuinit generic_init_call_single_data(void)
 void generic_smp_call_function_single_interrupt(void)
 {
 	struct call_single_queue *q;
+	unsigned long flags;
 	LIST_HEAD(list);
 
 	q = &__get_cpu_var(call_single_queue);
-	spin_lock(&q->lock);
+	spin_lock_irqsave(&q->lock, flags);
 	list_replace_init(&q->list, &list);
-	spin_unlock(&q->lock);
+	spin_unlock_irqrestore(&q->lock, flags);
 
 	while (!list_empty(&list)) {
 		struct call_single_data *data;
-- 
1.5.2.5

