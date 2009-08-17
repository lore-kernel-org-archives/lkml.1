Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZHQJoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZHQJoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZHQJoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:44:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38733 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbZHQJn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:43:59 -0400
Date: Mon, 17 Aug 2009 05:43:01 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Amerigo Wang <amwang@redhat.com>,
       Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Message-Id: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>
Subject: [Patch] proc: drop write permission on 'timer_list' and 'slabinfo'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


/proc/timer_list and /proc/slabinfo are not supposed to be written,
so there should be no write permissions on it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: David Rientjes <rientjes@google.com>

---
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index a999b92..fddd69d 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -286,7 +286,7 @@ static int __init init_timer_list_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("timer_list", 0644, NULL, &timer_list_fops);
+	pe = proc_create("timer_list", 0444, NULL, &timer_list_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;
diff --git a/mm/slab.c b/mm/slab.c
index 7b5d4de..a19e4be 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4473,7 +4473,7 @@ static const struct file_operations proc_slabstats_operations = {
 
 static int __init slab_proc_init(void)
 {
-	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
+	proc_create("slabinfo",S_IRUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
 #ifdef CONFIG_DEBUG_SLAB_LEAK
 	proc_create("slab_allocators", 0, NULL, &proc_slabstats_operations);
 #endif
diff --git a/mm/slub.c b/mm/slub.c
index b9f1491..aba2c1b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4726,7 +4726,7 @@ static const struct file_operations proc_slabinfo_operations = {
 
 static int __init slab_proc_init(void)
 {
-	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
+	proc_create("slabinfo",S_IRUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
 	return 0;
 }
 module_init(slab_proc_init);
