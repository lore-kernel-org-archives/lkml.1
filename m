Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZJVQOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZJVQOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZJVQOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:14:33 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:51142 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZJVQOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:14:33 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "gregkh@suse.de" <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: hv: Fix null pointer error after vmbus loading
Thread-Topic: [PATCH] Staging: hv: Fix null pointer error after vmbus loading
Thread-Index: AcpTMryvJOXgSvmwQ7G9Z23WlySKzg==
Date: Thu, 22 Oct 2009 16:14:31 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72180B3E1E@TK5EX14MBXC126.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Fix null pointer error after vmbus loading.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 582318f..11431cc 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -538,9 +538,10 @@ static int vmbus_child_device_register(struct hv_device *root_device_obj,
 		   child_device_ctx);
 
 	/* Make sure we are not registered already */
-	if (strlen(dev_name(&child_device_ctx->device)) != 0) {
+	if (dev_name(&child_device_ctx->device) != NULL &&
+	    strlen(dev_name(&child_device_ctx->device)) != 0) {
 		DPRINT_ERR(VMBUS_DRV,
-			   "child device (%p) already registered - busid %s",
+			   "child device (%p) already registered - device name: %s",
 			   child_device_ctx,
 			   dev_name(&child_device_ctx->device));

