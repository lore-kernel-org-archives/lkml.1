Return-Path: <linux-kernel-owner+w=401wt.eu-S935080AbXLTP2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080AbXLTP2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbXLTPVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:21:37 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:62518 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434AbXLTPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:13 -0500
Message-Id: <20071220152110.514200108@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:19:59 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Michael Holzheu <holzheu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 34/47] Load disabled wait psw instead of stopping cpu on halt.
Content-Disposition: inline; filename=133-disabled-wait.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/ipl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: quilt-2.6/arch/s390/kernel/ipl.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/ipl.c
+++ quilt-2.6/arch/s390/kernel/ipl.c
@@ -1087,8 +1087,12 @@ static struct shutdown_action vmcmd_acti
 
 static void stop_run(struct shutdown_trigger *trigger)
 {
-	signal_processor(smp_processor_id(), sigp_stop_and_store_status);
-	for (;;);
+	if (strcmp(trigger->name, ON_PANIC_STR) == 0)
+		disabled_wait((unsigned long) __builtin_return_address(0));
+	else {
+		signal_processor(smp_processor_id(), sigp_stop);
+		for (;;);
+	}
 }
 
 static struct shutdown_action stop_action = {SHUTDOWN_ACTION_STOP_STR,

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

