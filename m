Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYIFBGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYIFBGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 21:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYIFBFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 21:05:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:27220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbYIFBFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 21:05:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,343,1217833200"; 
   d="scan'208";a="436263625"
Message-Id: <20080906010448.419375000@intel.com>
References: <20080906010214.229910000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 05 Sep 2008 18:02:15 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [RFC 1/4] x86: HPET_MSI change IRQ affinity in process context when it is disabled
Content-Disposition: inline; filename=set_affinity_for_disabled_irqs_tip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the IRQ affinity in the process context when the IRQ is disabled.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 kernel/irq/manage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: tip/kernel/irq/manage.c
===================================================================
--- tip.orig/kernel/irq/manage.c	2008-09-05 09:13:51.000000000 -0700
+++ tip/kernel/irq/manage.c	2008-09-05 09:28:01.000000000 -0700
@@ -87,10 +87,11 @@ int irq_set_affinity(unsigned int irq, c
 		return -EINVAL;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PCNTXT) {
+	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&desc->lock, flags);
+		desc->affinity = cpumask;
 		desc->chip->set_affinity(irq, cpumask);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	} else

-- 

