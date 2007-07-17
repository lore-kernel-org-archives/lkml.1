Return-Path: <linux-kernel-owner+w=401wt.eu-S936384AbXGQUp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936384AbXGQUp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935673AbXGQUmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:42:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934201AbXGQUmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:42:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Resend][PATCH 9/9] PM: Rename hibernation_ops to platform_hibernation_ops
Date: Tue, 17 Jul 2007 22:48:58 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Len Brown <len.brown@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>
References: <200707172236.28895.rjw@sisk.pl>
In-Reply-To: <200707172236.28895.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172248.59290.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Rename 'struct hibernation_ops' to 'struct platform_hibernation_ops' in analogy
with 'struct platform_suspend_ops'.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/acpi/sleep/main.c |    2 +-
 include/linux/suspend.h   |    8 ++++----
 kernel/power/disk.c       |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.22-git5/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.22-git5.orig/drivers/acpi/sleep/main.c
+++ linux-2.6.22-git5/drivers/acpi/sleep/main.c
@@ -251,7 +251,7 @@ static void acpi_hibernation_restore_cle
 	acpi_hw_enable_all_runtime_gpes();
 }
 
-static struct hibernation_ops acpi_hibernation_ops = {
+static struct platform_hibernation_ops acpi_hibernation_ops = {
 	.start = acpi_hibernation_start,
 	.pre_snapshot = acpi_hibernation_prepare,
 	.finish = acpi_hibernation_finish,
Index: linux-2.6.22-git5/include/linux/suspend.h
===================================================================
--- linux-2.6.22-git5.orig/include/linux/suspend.h
+++ linux-2.6.22-git5/include/linux/suspend.h
@@ -126,7 +126,7 @@ extern void drain_local_pages(void);
 extern void mark_free_pages(struct zone *zone);
 
 /**
- * struct hibernation_ops - hibernation platform support
+ * struct platform_hibernation_ops - hibernation platform support
  *
  * The methods in this structure allow a platform to override the default
  * mechanism of shutting down the machine during a hibernation transition.
@@ -163,7 +163,7 @@ extern void mark_free_pages(struct zone 
  *	Called right after the nonboot CPUs have been enabled and before
  *	thawing devices (runs with IRQs on).
  */
-struct hibernation_ops {
+struct platform_hibernation_ops {
 	int (*start)(void);
 	int (*pre_snapshot)(void);
 	void (*finish)(void);
@@ -190,14 +190,14 @@ extern void swsusp_set_page_free(struct 
 extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 
-extern void hibernation_set_ops(struct hibernation_ops *ops);
+extern void hibernation_set_ops(struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 #else /* CONFIG_SOFTWARE_SUSPEND */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
 
-static inline void hibernation_set_ops(struct hibernation_ops *ops) {}
+static inline void hibernation_set_ops(struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
 #endif /* CONFIG_SOFTWARE_SUSPEND */
 
Index: linux-2.6.22-git5/kernel/power/disk.c
===================================================================
--- linux-2.6.22-git5.orig/kernel/power/disk.c
+++ linux-2.6.22-git5/kernel/power/disk.c
@@ -45,14 +45,14 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-struct hibernation_ops *hibernation_ops;
+struct platform_hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
  * @ops: the hibernation operations to use in subsequent hibernation transitions
  */
 
-void hibernation_set_ops(struct hibernation_ops *ops)
+void hibernation_set_ops(struct platform_hibernation_ops *ops)
 {
 	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
 	    && ops->prepare && ops->enter && ops->pre_restore
