Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYGVFja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYGVFja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbYGVFZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:15 -0400
Received: from mx1.suse.de ([195.135.220.2]:53963 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198AbYGVFZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 53/79] driver core: remove DEVICE_ID_SIZE define
Date: Mon, 21 Jul 2008 22:19:17 -0700
Message-Id: <1216703983-21448-53-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no such thing as a "device id size" in the driver core, so
remove the define and fix up any users of this odd define in the rest of
the kernel.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/memstick/host/jmb38x_ms.c |    4 ++--
 include/linux/device.h            |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index a054668..4e3bfbc 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -51,7 +51,7 @@ struct jmb38x_ms_host {
 	void __iomem            *addr;
 	spinlock_t              lock;
 	int                     id;
-	char                    host_id[DEVICE_ID_SIZE];
+	char                    host_id[32];
 	int                     irq;
 	unsigned int            block_pos;
 	unsigned long           timeout_jiffies;
@@ -781,7 +781,7 @@ static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
 
 	spin_lock_init(&host->lock);
 	host->id = cnt;
-	snprintf(host->host_id, DEVICE_ID_SIZE, DRIVER_NAME ":slot%d",
+	snprintf(host->host_id, sizeof(host->host_id), DRIVER_NAME ":slot%d",
 		 host->id);
 	host->irq = jm->pdev->irq;
 	host->timeout_jiffies = msecs_to_jiffies(1000);
diff --git a/include/linux/device.h b/include/linux/device.h
index 894fdb2..d24a47f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -25,7 +25,6 @@
 #include <asm/atomic.h>
 #include <asm/device.h>
 
-#define DEVICE_ID_SIZE		32
 #define BUS_ID_SIZE		20
 
 struct device;
-- 
1.5.6.3

