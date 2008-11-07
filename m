Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYKGVZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYKGVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYKGVZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:25:17 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:29661 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYKGVZQ (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:25:16 -0500
Subject: [PATCH][RT] Trivial: Correctly dereference when clearing unused
	variable
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: RT Users List <linux-rt-users@vger.kernel.org>
Cc: LKML <Linux-kernel@vger.kernel.org>, Tony Jones <tonyj@suse.de>
Content-Type: text/plain
Organization: The Big Corporation
Date: Fri, 07 Nov 2008 13:19:42 -0800
Message-Id: <1226092782.5685.11.camel@dd>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Sven-Thorsten Dietrich <sdietrich@suse.de>
Subject:  Correctly dereference flags when clearing unused variable.

Its probably unsafe to set the flags pointer to 0, since this will oops,
if it is dereferenced elsewhere for some odd reason. 

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>

---
 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -170,7 +170,7 @@ static inline void __lock_cpu_pcp(unsign
 {
 #ifdef CONFIG_PREEMPT_RT
 	spin_lock(&__get_cpu_lock(pcp_locks, cpu));
-	flags = 0;
+	*flags = 0;
 #else
 	local_irq_save(*flags);
 #endif
@@ -180,7 +180,7 @@ static inline void lock_cpu_pcp(unsigned
 {
 #ifdef CONFIG_PREEMPT_RT
 	(void)get_cpu_var_locked(pcp_locks, this_cpu);
-	flags = 0;
+	*flags = 0;
 #else
 	local_irq_save(*flags);
 	*this_cpu = smp_processor_id();


