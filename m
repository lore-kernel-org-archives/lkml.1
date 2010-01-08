Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323Ab0AHSah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0AHSah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829Ab0AHSag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:30:36 -0500
Received: from [206.15.93.42] ([206.15.93.42]:28752 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752612Ab0AHSag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:30:36 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, iss_storagedev@hp.com
Subject: [PATCH] drivers/block: Remove unnecessary cast
Date: Fri, 8 Jan 2010 11:22:33 -0700
Cc: chirag.kantharia@hp.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001081122.33749.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/block: Remove unnecessary cast.

The struct seq_file 'private' member is a void *, the cast is not needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chirag Kantharia <chirag.kantharia@hp.com>

---

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index ce1fa92..bd85fb8 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6458,7 +6458,7 @@ static const struct file_operations dac960_proc_fops = {
 
 static int dac960_initial_status_proc_show(struct seq_file *m, void *v)
 {
-	DAC960_Controller_T *Controller = (DAC960_Controller_T *)m->private;
+	DAC960_Controller_T *Controller = m->private;
 	seq_printf(m, "%.*s", Controller->InitialStatusLength, Controller->CombinedStatusBuffer);
 	return 0;
 }
@@ -6478,7 +6478,7 @@ static const struct file_operations dac960_initial_status_proc_fops = {
 
 static int dac960_current_status_proc_show(struct seq_file *m, void *v)
 {
-  DAC960_Controller_T *Controller = (DAC960_Controller_T *) m->private;
+  DAC960_Controller_T *Controller = m->private;
   unsigned char *StatusMessage =
     "No Rebuild or Consistency Check in Progress\n";
   int ProgressMessageLength = strlen(StatusMessage);
@@ -6524,7 +6524,7 @@ static const struct file_operations dac960_current_status_proc_fops = {
 
 static int dac960_user_command_proc_show(struct seq_file *m, void *v)
 {
-	DAC960_Controller_T *Controller = (DAC960_Controller_T *)m->private;
+	DAC960_Controller_T *Controller = m->private;
 
 	seq_printf(m, "%.*s", Controller->UserStatusLength, Controller->UserStatusBuffer);
 	return 0;
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 6422651..9bcef1a 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -228,7 +228,7 @@ static void __init ida_procinit(int i)
 static int ida_proc_show(struct seq_file *m, void *v)
 {
 	int i, ctlr;
-	ctlr_info_t *h = (ctlr_info_t*)m->private;
+	ctlr_info_t *h = m->private;
 	drv_info_t *drv;
 #ifdef CPQ_PROC_PRINT_QUEUES
 	cmdlist_t *c;
