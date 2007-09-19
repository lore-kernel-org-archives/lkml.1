Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbXISN7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbXISN7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 09:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXISN7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 09:59:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbXISN7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 09:59:33 -0400
Date: Wed, 19 Sep 2007 22:59:16 +0900 (JST)
Message-Id: <20070919.225916.47218290.jet@gyve.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fixing signness of parameters in scsi module
From: Masatake YAMATO <jet@gyve.org>
X-Mailer: Mew version 5.2 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In scsi module I've found some inconsistency between variable type
used in module_param_named and type passed to module_param_named as an
argument. Especially the inconsistency of `max_scsi_luns' parameter is
a bit serious because the description text says "last scsi LUN (should
be between 1 and 2^32-1)". 


I'm not on the mailing list. so please put my address
to cc: of your reply.

Signed-off-by: Masatake YAMATO <jet@gyve.org>


diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1bd92b9..f6d7552 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -83,7 +83,7 @@ #else
 static unsigned int max_scsi_luns = 1;
 #endif
 
-module_param_named(max_luns, max_scsi_luns, int, S_IRUGO|S_IWUSR);
+module_param_named(max_luns, max_scsi_luns, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
 
@@ -96,14 +96,14 @@ MODULE_PARM_DESC(max_luns,
  */
 static unsigned int max_scsi_report_luns = 511;
 
-module_param_named(max_report_luns, max_scsi_report_luns, int, S_IRUGO|S_IWUSR);
+module_param_named(max_report_luns, max_scsi_report_luns, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
 		 " between 1 and 16384)");
 
 static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
 
-module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR);
+module_param_named(inq_timeout, scsi_inq_timeout, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(inq_timeout, 
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 5. Some non-compliant devices need more.");
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index b03aa85..61ca8cd 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -370,7 +370,7 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_
  */
 static unsigned int fc_dev_loss_tmo = 60;		/* seconds */
 
-module_param_named(dev_loss_tmo, fc_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
+module_param_named(dev_loss_tmo, fc_dev_loss_tmo, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(dev_loss_tmo,
 		 "Maximum number of seconds that the FC transport should"
 		 " insulate the loss of a remote port. Once this value is"
