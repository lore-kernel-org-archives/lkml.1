Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0BXIra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:47:30 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:45804 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0BXIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:44:53 -0500
Message-Id: <20100224084451.692379800@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 09:44:52 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 22/32] [PATCH] use kprobes_built_in() in mm/fault code
References: <20100224084430.193562869@de.ibm.com>
Content-Disposition: inline; filename=121-kprobes_built_in.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Use kprobes_built_in() to avoid ifdefs like most other architectures do.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/mm/fault.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: quilt-2.6/arch/s390/mm/fault.c
===================================================================
--- quilt-2.6.orig/arch/s390/mm/fault.c	2010-02-24 09:44:26.000000000 +0100
+++ quilt-2.6/arch/s390/mm/fault.c	2010-02-24 09:44:27.000000000 +0100
@@ -60,15 +60,13 @@
 {
 	int ret = 0;
 
-#ifdef CONFIG_KPROBES
 	/* kprobe_running() needs smp_processor_id() */
-	if (!user_mode(regs)) {
+	if (kprobes_built_in() && !user_mode(regs)) {
 		preempt_disable();
 		if (kprobe_running() && kprobe_fault_handler(regs, 14))
 			ret = 1;
 		preempt_enable();
 	}
-#endif
 	return ret;
 }
 

