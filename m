Return-Path: <linux-kernel-owner+w=401wt.eu-S1759843AbYBOUN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbYBOUN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYBOUNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:13:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbYBOUNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:13:17 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, andrew.grover@intel.com,
       paul.s.diefenbaugh@intel.com, linux@brodo.de,
       anil.s.keshavamurthy@intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH] use ACPI_DEBUG_PRINT instead of printk
Date: Fri, 15 Feb 2008 18:07:01 -0200
Message-Id: <1203106021-11038-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1203106021-11038-1-git-send-email-gcosta@redhat.com>
References: <1203106021-11038-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency, use ACPI_DEBUG_PRINT instead of printk
in acpi_processor_hotplug_notify() for BUS_CHECK and DEVICE_CHECK
events

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 drivers/acpi/processor_core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 923fddb..673fb92 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -890,9 +890,10 @@ acpi_processor_hotplug_notify(acpi_handl
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		printk("Processor driver received %s event\n",
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+		"Processor driver received %s event\n",
 		       (event == ACPI_NOTIFY_BUS_CHECK) ?
-		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
+		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK"));
 
 		if (!is_processor_present(handle))
 			break;
-- 
1.4.2

