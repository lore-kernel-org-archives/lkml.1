Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbXKELqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbXKELqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXKELqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:46:05 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:10329 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbXKELqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:46:01 -0500
Message-Id: <20071105114527.162310000@vnet.ibm.com>
References: <20071105113742.233391000@vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 Nov 2007 12:37:43 +0100
From: swen@vnet.ibm.com
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org,
       Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/6] zfcp: Remove unnecessary eh_bus_reset_handler callback
Content-Disposition: inline; filename=800-zfcp-callback.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The callback function used by zfcp always returns success,
which is an indication for the SCSI midlayer to stop error
handling. Remove the bus_reset callback, since the same
function will be called via the host_reset callback.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: scsi-misc/drivers/s390/scsi/zfcp_scsi.c
===================================================================
--- scsi-misc.orig/drivers/s390/scsi/zfcp_scsi.c
+++ scsi-misc/drivers/s390/scsi/zfcp_scsi.c
@@ -51,7 +51,6 @@ struct zfcp_data zfcp_data = {
 		.queuecommand		= zfcp_scsi_queuecommand,
 		.eh_abort_handler	= zfcp_scsi_eh_abort_handler,
 		.eh_device_reset_handler = zfcp_scsi_eh_device_reset_handler,
-		.eh_bus_reset_handler	= zfcp_scsi_eh_host_reset_handler,
 		.eh_host_reset_handler	= zfcp_scsi_eh_host_reset_handler,
 		.can_queue		= 4096,
 		.this_id		= -1,
@@ -542,7 +541,7 @@ zfcp_task_management_function(struct zfc
 }
 
 /**
- * zfcp_scsi_eh_host_reset_handler - handler for host and bus reset
+ * zfcp_scsi_eh_host_reset_handler - handler for host reset
  */
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
@@ -552,7 +551,7 @@ static int zfcp_scsi_eh_host_reset_handl
 	unit = (struct zfcp_unit*) scpnt->device->hostdata;
 	adapter = unit->port->adapter;
 
-	ZFCP_LOG_NORMAL("host/bus reset because of problems with "
+	ZFCP_LOG_NORMAL("host reset because of problems with "
 			"unit 0x%016Lx\n", unit->fcp_lun);
 
 	zfcp_erp_adapter_reopen(adapter, 0);

-- 
