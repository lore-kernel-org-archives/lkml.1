Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYLWEZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYLWEZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 23:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbYLWEZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 23:25:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:35861 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbYLWEZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 23:25:03 -0500
Message-ID: <495067E9.9000904@kernel.org>
Date: Mon, 22 Dec 2008 20:24:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparseirq: set lock_class for legacy irq when sparse_irq
 is selected
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix

that is used to call init_one_irq_desc, after we use static one directly, that line
need to be duplicated too.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/handle.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -146,6 +146,7 @@ void __init early_irq_init(void)
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy[i];
+		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 
 		irq_desc_ptrs[i] = desc + i;
 	}
