Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZKQQFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZKQQFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZKQQFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:05:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33571 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbZKQQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:05:00 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] twl4030: Fix warning
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Date: Tue, 17 Nov 2009 15:48:47 +0000
Message-ID: <20091117154841.3941.35813.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mfd/twl4030-irq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index fb194fe..c78b5ad 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -728,7 +728,8 @@ int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 		goto fail_rqirq;
 	}
 
-	task = kthread_run(twl4030_irq_thread, (void *)irq_num, "twl4030-irq");
+	task = kthread_run(twl4030_irq_thread, (void *)(long)irq_num,
+								"twl4030-irq");
 	if (IS_ERR(task)) {
 		pr_err("twl4030: could not create irq %d thread!\n", irq_num);
 		status = PTR_ERR(task);

