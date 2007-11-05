Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbXKERPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbXKERPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXKERIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:10 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59531 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757042AbXKERIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:06 -0500
Date: Mon, 5 Nov 2007 18:07:43 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/misc/lkdtm.c: cleanups
Message-ID: <20071105170743.GT12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make needlessly global functions static
- make lkdtm_module_{init,exit}() as __{init,exit}

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/misc/lkdtm.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

58456d59f260985e7dcfbf9e9e78e1a017cb935b 
diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 552b795..c884730 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -129,27 +129,28 @@ module_param(cpoint_count, int, 0644);
 MODULE_PARM_DESC(cpoint_count, " Crash Point Count, number of times the "\
 				"crash point is to be hit to trigger action");
 
-unsigned int jp_do_irq(unsigned int irq)
+static unsigned int jp_do_irq(unsigned int irq)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
 
-irqreturn_t jp_handle_irq_event(unsigned int irq, struct irqaction *action)
+static irqreturn_t jp_handle_irq_event(unsigned int irq,
+				       struct irqaction *action)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
 
-void jp_tasklet_action(struct softirq_action *a)
+static void jp_tasklet_action(struct softirq_action *a)
 {
 	lkdtm_handler();
 	jprobe_return();
 }
 
-void jp_ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
+static void jp_ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 {
 	lkdtm_handler();
 	jprobe_return();
@@ -157,23 +158,24 @@ void jp_ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 
 struct scan_control;
 
-unsigned long jp_shrink_inactive_list(unsigned long max_scan,
-				struct zone *zone, struct scan_control *sc)
+static unsigned long jp_shrink_inactive_list(unsigned long max_scan,
+					     struct zone *zone,
+					     struct scan_control *sc)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
 
-int jp_hrtimer_start(struct hrtimer *timer, ktime_t tim,
-				const enum hrtimer_mode mode)
+static int jp_hrtimer_start(struct hrtimer *timer, ktime_t tim,
+			    const enum hrtimer_mode mode)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
 
-int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
+static int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	lkdtm_handler();
 	jprobe_return();
@@ -270,7 +272,7 @@ void lkdtm_handler(void)
 	}
 }
 
-int lkdtm_module_init(void)
+static int __init lkdtm_module_init(void)
 {
 	int ret;
 
@@ -331,7 +333,7 @@ int lkdtm_module_init(void)
 	return 0;
 }
 
-void lkdtm_module_exit(void)
+static void __exit lkdtm_module_exit(void)
 {
         unregister_jprobe(&lkdtm);
         printk(KERN_INFO "lkdtm : Crash point unregistered\n");

