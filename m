Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbXEYMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbXEYMF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXEYMFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:05:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXEYMFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:05:21 -0400
From: Andi Kleen <ak@suse.de>
To: mingo@elte.hu, Thomas Gleixner <tglx@linutronix.de>, johnstul@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Remove clockevents_{release,request}_device
Date: Fri, 25 May 2007 14:04:22 +0200
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251404.23035.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Not called by anything in tree.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.22-rc2-clock/kernel/time/clockevents.c
===================================================================
--- linux-2.6.22-rc2-clock.orig/kernel/time/clockevents.c
+++ linux-2.6.22-rc2-clock/kernel/time/clockevents.c
@@ -205,47 +205,6 @@ void clockevents_exchange_device(struct 
 }
 
 /**
- * clockevents_request_device
- */
-struct clock_event_device *clockevents_request_device(unsigned int features,
-						      cpumask_t cpumask)
-{
-	struct clock_event_device *cur, *dev = NULL;
-	struct list_head *tmp;
-
-	spin_lock(&clockevents_lock);
-
-	list_for_each(tmp, &clockevent_devices) {
-		cur = list_entry(tmp, struct clock_event_device, list);
-
-		if ((cur->features & features) == features &&
-		    cpus_equal(cpumask, cur->cpumask)) {
-			if (!dev || dev->rating < cur->rating)
-				dev = cur;
-		}
-	}
-
-	clockevents_exchange_device(NULL, dev);
-
-	spin_unlock(&clockevents_lock);
-
-	return dev;
-}
-
-/**
- * clockevents_release_device
- */
-void clockevents_release_device(struct clock_event_device *dev)
-{
-	spin_lock(&clockevents_lock);
-
-	clockevents_exchange_device(dev, NULL);
-	clockevents_notify_released();
-
-	spin_unlock(&clockevents_lock);
-}
-
-/**
  * clockevents_notify - notification about relevant events
  */
 void clockevents_notify(unsigned long reason, void *arg)
