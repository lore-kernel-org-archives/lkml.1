Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbXI0VgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbXI0VgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbXI0VgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:36:12 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:52308 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbXI0VgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:36:11 -0400
Message-ID: <46FC2245.50907@tiscali.nl>
Date: Thu, 27 Sep 2007 23:36:05 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] spin_lock_unlocked cleanups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace some SPIN_LOCK_UNLOCKED with DEFINE_SPINLOCK

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/mips/pci/ops-pmcmsp.c b/arch/mips/pci/ops-pmcmsp.c
index 09fa007..059eade 100644
--- a/arch/mips/pci/ops-pmcmsp.c
+++ b/arch/mips/pci/ops-pmcmsp.c
@@ -206,7 +206,7 @@ static void pci_proc_init(void)
 }
 #endif /* CONFIG_PROC_FS && PCI_COUNTERS */
 
-spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(bpci_lock);
 
 /*****************************************************************************
  *
diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index d5fd390..cd2766e 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -34,7 +34,7 @@
 #include <asm/mmu.h>
 #include <asm/spu.h>
 
-static spinlock_t slice_convert_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(slice_convert_lock);
 
 
 #ifdef DEBUG
diff --git a/drivers/char/watchdog/bfin_wdt.c b/drivers/char/watchdog/bfin_wdt.c
index 309d279..31dc7a6 100644
--- a/drivers/char/watchdog/bfin_wdt.c
+++ b/drivers/char/watchdog/bfin_wdt.c
@@ -71,7 +71,7 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static struct watchdog_info bfin_wdt_info;
 static unsigned long open_check;
 static char expect_close;
-static spinlock_t bfin_wdt_spinlock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(bfin_wdt_spinlock);
 
 /**
  *	bfin_wdt_keepalive - Keep the Userspace Watchdog Alive
diff --git a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
index 98fd985..36c747b 100644
--- a/drivers/ieee1394/ieee1394_core.c
+++ b/drivers/ieee1394/ieee1394_core.c
@@ -488,7 +488,7 @@ void hpsb_selfid_complete(struct hpsb_host *host, int phyid, int isroot)
 	highlevel_host_reset(host);
 }
 
-static spinlock_t pending_packets_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(pending_packets_lock);
 
 /**
  * hpsb_packet_sent - notify core of sending a packet
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 83e76b3..94fd78f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -15,9 +15,9 @@
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
-spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(sysfs_assoc_lock);
 
-static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sysfs_ino_lock);
 static DEFINE_IDA(sysfs_ino_ida);
 
 /**
