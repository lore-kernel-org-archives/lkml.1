Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYCLRd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYCLRd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYCLRcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:32:25 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:55358 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbYCLRcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:32:22 -0400
Message-Id: <20080312173216.861331041@de.ibm.com>
References: <20080312173155.703966894@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Mar 2008 18:31:58 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/10] sched: add exported arch_reinit_sched_domains() to header file.
Content-Disposition: inline; filename=103-nodes-export.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Needed so it can be called from outside of sched.c.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/linux/sched.h |    4 ++++
 kernel/sched.c        |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: quilt-2.6/include/linux/sched.h
===================================================================
--- quilt-2.6.orig/include/linux/sched.h
+++ quilt-2.6/include/linux/sched.h
@@ -791,6 +791,10 @@ struct sched_domain {
 
 extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new);
 
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+extern int arch_reinit_sched_domains(void);
+#endif
+
 #endif	/* CONFIG_SMP */
 
 /*
Index: quilt-2.6/kernel/sched.c
===================================================================
--- quilt-2.6.orig/kernel/sched.c
+++ quilt-2.6/kernel/sched.c
@@ -6917,7 +6917,7 @@ match2:
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-static int arch_reinit_sched_domains(void)
+int arch_reinit_sched_domains(void)
 {
 	int err;
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

