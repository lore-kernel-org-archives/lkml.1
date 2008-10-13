Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYJMVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYJMVvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYJMVvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:51:35 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:34614 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbYJMVve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:51:34 -0400
Message-Id: <20081013215130.342077797@de.ibm.com>
References: <20081013215007.634620563@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 23:50:08 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: rusty@rustcorp.com.au
Cc: jens.axboe@oracle.com, mingo@elte.hu, akpm@linux-foundation.org,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC v2 1/6] Call init_workqueues before pre smp initcalls.
Content-Disposition: inline; filename=001_workqueue_init.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

This allows to create workqueues from within the context of
a pre smp initcall (aka early_initcall).

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -767,8 +767,6 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
-	/* drivers will send hotplug events */
-	init_workqueues();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -852,6 +850,8 @@ static int __init kernel_init(void * unu
 
 	cad_pid = task_pid(current);
 
+	init_workqueues();
+
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();

-- 
