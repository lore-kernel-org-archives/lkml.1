Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbZDIJkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbZDIJkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbZDIJkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:40:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbZDIJkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:40:40 -0400
Subject: [PATCH] mm: move the scan_unevictable_pages sysctl to the vm table
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       "lee.schermerhorn" <lee.schermerhorn@hp.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Apr 2009 11:42:13 +0200
Message-Id: <1239270133.7647.213.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: mm: move the scan_unevictable_pages sysctl to the vm table
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Apr 09 11:38:45 CEST 2009

vm knobs should go in the vm table. Probably too late for randomize_va_space
though.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sysctl.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -914,16 +914,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_UNEVICTABLE_LRU
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "scan_unevictable_pages",
-		.data		= &scan_unevictable_pages,
-		.maxlen		= sizeof(scan_unevictable_pages),
-		.mode		= 0644,
-		.proc_handler	= &scan_unevictable_handler,
-	},
-#endif
 #ifdef CONFIG_SLOW_WORK
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -1324,6 +1314,16 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_UNEVICTABLE_LRU
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "scan_unevictable_pages",
+		.data		= &scan_unevictable_pages,
+		.maxlen		= sizeof(scan_unevictable_pages),
+		.mode		= 0644,
+		.proc_handler	= &scan_unevictable_handler,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt

