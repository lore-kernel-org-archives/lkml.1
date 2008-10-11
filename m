Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYJKGnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYJKGnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYJKGho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:44 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45163 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbYJKGhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:38 -0400
Date: Sat, 11 Oct 2008 02:36:39 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 79/85] ACPI osl: Debug interface used for error message cleanup
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <072ef9562ff32527613760685445ceba050be476.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/osl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 235a138..e93e077 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -729,8 +729,7 @@ acpi_status acpi_os_execute(acpi_execute_type type,
 	INIT_WORK(&dpc->work, acpi_os_execute_deferred);
 	queue = (type == OSL_NOTIFY_HANDLER) ? kacpi_notify_wq : kacpid_wq;
 	if (!queue_work(queue, &dpc->work)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-			  "Call to queue_work() failed.\n"));
+		printk(KERN_ERR "Call to queue_work() failed.\n");
 		status = AE_ERROR;
 		kfree(dpc);
 	}
-- 
1.5.5.1

