Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbXFSWuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbXFSWuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758799AbXFSWuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:50:23 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:57959 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759454AbXFSWuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:50:19 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 20 Jun 2007 00:49:58 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 5/12] acpi: fix compile error with ACPI && !ACPI_SYSTEM
Message-ID: <20070619224958.GG5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:49:01.0980 (UTC)
 FILETIME=[07EF35C0:01C7B2C4]
X-WSS-ID: 6A66821C23K845754-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error if ACPI && !ACPI_SYSTEM as
bus.c depended on event.c

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/acpi/bus.c   |    2 +-
 drivers/acpi/event.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index e5084ec..b4a9ea5 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -281,7 +281,7 @@ static DEFINE_SPINLOCK(acpi_bus_event_lock);
 LIST_HEAD(acpi_bus_event_list);
 DECLARE_WAIT_QUEUE_HEAD(acpi_bus_event_queue);
 
-extern int event_is_open;
+int event_is_open = 0;
 
 int acpi_bus_generate_event(struct acpi_device *device, u8 type, int data)
 {
diff --git a/drivers/acpi/event.c b/drivers/acpi/event.c
index 3b23562..15886c1 100644
--- a/drivers/acpi/event.c
+++ b/drivers/acpi/event.c
@@ -17,7 +17,7 @@ ACPI_MODULE_NAME("event");
 
 /* Global vars for handling event proc entry */
 static DEFINE_SPINLOCK(acpi_system_event_lock);
-int event_is_open = 0;
+extern int event_is_open;
 extern struct list_head acpi_bus_event_list;
 extern wait_queue_head_t acpi_bus_event_queue;
 
-- 
1.5.0.7




