Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZGZIYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZGZIYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZGZIYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:24:19 -0400
Received: from www.tglx.de ([62.245.132.106]:34128 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZGZIYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:24:16 -0400
Message-Id: <20090726081554.817021042@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [Patch RFC 12/37] ibmphp-hpc: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=driver-pci-hotplug-ibmphp-hpc-sema-share-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex"es is non obvious and probably a completion
in some places. Make them semaphores.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/hotplug/ibmphp_hpc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/drivers/pci/hotplug/ibmphp_hpc.c
===================================================================
--- linux-2.6-tip.orig/drivers/pci/hotplug/ibmphp_hpc.c
+++ linux-2.6-tip/drivers/pci/hotplug/ibmphp_hpc.c
@@ -132,8 +132,8 @@ void __init ibmphp_hpc_initvars (void)
 	debug ("%s - Entry\n", __func__);
 
 	mutex_init(&sem_hpcaccess);
-	init_MUTEX (&semOperations);
-	init_MUTEX_LOCKED (&sem_exit);
+	semaphore_init(&semOperations);
+	semaphore_init_locked(&sem_exit);
 	to_debug = 0;
 
 	debug ("%s - Exit\n", __func__);


