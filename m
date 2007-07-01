Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbXGAU1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbXGAU1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbXGAUXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:23:16 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46891 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759305AbXGAUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:23:13 -0400
Date: Sun, 1 Jul 2007 22:23:36 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [-mm patch] kernel/power/main.c: make code static
Message-ID: <20070701202336.GV10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
> +pm-reduce-code-duplication-between-mainc-and-userc.patch
>...
>  PM updates
>...


Some code can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/pm.h   |    1 -
 kernel/power/main.c  |    4 ++--
 kernel/power/power.h |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc6-mm1/kernel/power/power.h.old	2007-07-01 00:21:34.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/power/power.h	2007-07-01 00:21:41.000000000 +0200
@@ -177,7 +177,6 @@
 				unsigned int, char *);
 
 /* kernel/power/main.c */
-extern int suspend_enter(suspend_state_t state);
 extern int suspend_devices_and_enter(suspend_state_t state);
 extern struct blocking_notifier_head pm_chain_head;
 
--- linux-2.6.22-rc6-mm1/include/linux/pm.h.old	2007-07-01 00:22:53.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/linux/pm.h	2007-07-01 00:23:04.000000000 +0200
@@ -138,7 +138,6 @@
  * @pm_ops: The new power management operations to set.
  */
 extern void pm_set_ops(struct pm_ops *pm_ops);
-extern struct pm_ops *pm_ops;
 extern int pm_suspend(suspend_state_t state);
 
 extern int pm_valid_only_mem(suspend_state_t state);
--- linux-2.6.22-rc6-mm1/kernel/power/main.c.old	2007-07-01 00:21:49.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/power/main.c	2007-07-01 00:23:11.000000000 +0200
@@ -31,7 +31,7 @@
 
 DEFINE_MUTEX(pm_mutex);
 
-struct pm_ops *pm_ops;
+static struct pm_ops *pm_ops;
 
 /**
  *	pm_set_ops - Set the global power method table. 
@@ -127,7 +127,7 @@
  *
  *	This function should be called after devices have been suspended.
  */
-int suspend_enter(suspend_state_t state)
+static int suspend_enter(suspend_state_t state)
 {
 	int error = 0;
 

