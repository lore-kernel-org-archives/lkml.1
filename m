Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbXKFQfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbXKFQfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbXKFQe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:34:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47740 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbXKFQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:34:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <cborntra@de.ibm.com>,
       Gerald Schaefer <geraldsc@de.ibm.com>
Subject: [PATCH] s390: cmm - remove unused binary sysctls
Date: Tue, 06 Nov 2007 09:34:18 -0700
Message-ID: <m1tznz72ph.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Heiko Carstens <heiko.carstens@de.ibm.com>

Remove binary sysctls that never worked due to missing strategy functions.

Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/s390/mm/cmm.c     |    3 ---
 include/linux/sysctl.h |    5 -----
 kernel/sysctl_check.c  |    3 ---
 3 files changed, 11 deletions(-)

Index: linux-2.6/arch/s390/mm/cmm.c
===================================================================
--- linux-2.6.orig/arch/s390/mm/cmm.c
+++ linux-2.6/arch/s390/mm/cmm.c
@@ -341,19 +341,16 @@ cmm_timeout_handler(ctl_table *ctl, int 
 
 static struct ctl_table cmm_table[] = {
 	{
-		.ctl_name	= VM_CMM_PAGES,
 		.procname	= "cmm_pages",
 		.mode		= 0644,
 		.proc_handler	= &cmm_pages_handler,
 	},
 	{
-		.ctl_name	= VM_CMM_TIMED_PAGES,
 		.procname	= "cmm_timed_pages",
 		.mode		= 0644,
 		.proc_handler	= &cmm_pages_handler,
 	},
 	{
-		.ctl_name	= VM_CMM_TIMEOUT,
 		.procname	= "cmm_timeout",
 		.mode		= 0644,
 		.proc_handler	= &cmm_timeout_handler,
Index: linux-2.6/include/linux/sysctl.h
===================================================================
--- linux-2.6.orig/include/linux/sysctl.h
+++ linux-2.6/include/linux/sysctl.h
@@ -207,11 +207,6 @@ enum
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
-
-	/* s390 vm cmm sysctls */
-	VM_CMM_PAGES=1111,
-	VM_CMM_TIMED_PAGES=1112,
-	VM_CMM_TIMEOUT=1113,
 };
 
 
Index: linux-2.6/kernel/sysctl_check.c
===================================================================
--- linux-2.6.orig/kernel/sysctl_check.c
+++ linux-2.6/kernel/sysctl_check.c
@@ -140,9 +140,6 @@ static struct trans_ctl_table trans_vm_t
 	{ VM_PANIC_ON_OOM,		"panic_on_oom" },
 	{ VM_VDSO_ENABLED,		"vdso_enabled" },
 	{ VM_MIN_SLAB,			"min_slab_ratio" },
-	{ VM_CMM_PAGES,			"cmm_pages" },
-	{ VM_CMM_TIMED_PAGES,		"cmm_timed_pages" },
-	{ VM_CMM_TIMEOUT,		"cmm_timeout" },
 
 	{}
 };


