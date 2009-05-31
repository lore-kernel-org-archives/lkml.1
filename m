Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbZEaGoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbZEaGoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZEaGn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:43:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:39079 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716AbZEaGn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:43:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,278,1241420400"; 
   d="scan'208,223";a="695118089"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Nashif, Anas" <anas.nashif@intel.com>,
       "Obara, Marcin" <marcin.obara@intel.com>,
       "knikanth@suse.de" <knikanth@suse.de>
Date: Sun, 31 May 2009 14:43:58 +0800
Subject: [Patch 07/08] Staging: heci - do not print error when
 heci_bh_handler is already on workqueue
Thread-Topic: [Patch 07/08] Staging: heci - do not print error when
 heci_bh_handler is already on workqueue
Thread-Index: AcnhuyzK83u2/FybRCCt+rSmyHsHKQ==
Message-ID: <EADF0A36011179459010BDF5142A457501C9BF2AE6@pdsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 458f7a8efdf0b712c044987a565edc76ec90a85b Mon Sep 17 00:00:00 2001
From: Dongxiao Xu <dongxiao.xu@intel.com>
Date: Sun, 31 May 2009 22:47:14 +0800
Subject: [PATCH] heci: do not print error when heci_bh_handler is already on workqueue.

schedule_work returns 0, if the work is already on the work_queue, else
returns non-zero. Do not print error message if heci_bh_handlerwork was
already on queue.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
---
 drivers/staging/heci/interrupt.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/heci/interrupt.c b/drivers/staging/heci/interrupt.c
index 3a510ed..d97450c 100644
--- a/drivers/staging/heci/interrupt.c
+++ b/drivers/staging/heci/interrupt.c
@@ -103,10 +103,8 @@ irqreturn_t heci_isr_interrupt(int irq, void *dev_id)
 	PREPARE_WORK(&dev->work, heci_bh_handler);
 	DBG("schedule work the heci_bh_handler.\n");
 	err = schedule_work(&dev->work);
-	if (!err) {
-		printk(KERN_ERR "heci: schedule the heci_bh_handler"
-		       " failed error=%x\n", err);
-	}
+	if (!err)
+		DBG("heci_bh_handler was already on the workqueue.\n");
 	return IRQ_HANDLED;
 }
 
@@ -260,10 +258,8 @@ end:
 		PREPARE_WORK(&dev->work, heci_bh_handler);
 		DBG("schedule work the heci_bh_handler.\n");
 		rets = schedule_work(&dev->work);
-		if (!rets) {
-			printk(KERN_ERR "heci: schedule the heci_bh_handler"
-			       " failed error=%x\n", rets);
-		}
+		if (!rets) 
+			DBG("heci_bh_handler was already queued.\n");
 	} else {
 		heci_csr_enable_interrupts(dev);
 	}
-- 
1.6.0.rc1

