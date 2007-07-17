Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbXGQUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbXGQUoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935435AbXGQUml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:42:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50051 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933973AbXGQUmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:42:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Resend][PATCH 6/9] PM: Fix compilation of suspend code if CONFIG_PM is unset
Date: Tue, 17 Jul 2007 22:45:48 +0200
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
Message-Id: <200707172245.49527.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some platforms, particualrly in the ARM tree, require that suspend_set_ops() and
pm_suspend() be defined even if CONFIG_PM is not set.  Make this requirement be
satisfied.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 include/linux/suspend.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.22-git5/include/linux/suspend.h
===================================================================
--- linux-2.6.22-git5.orig/include/linux/suspend.h
+++ linux-2.6.22-git5/include/linux/suspend.h
@@ -79,6 +79,7 @@ struct platform_suspend_ops {
 
 extern struct platform_suspend_ops *suspend_ops;
 
+#ifdef CONFIG_PM
 /**
  * suspend_set_ops - set platform dependent suspend operations
  * @ops: The new suspend operations to set.
@@ -105,6 +106,12 @@ extern void arch_suspend_disable_irqs(vo
 extern void arch_suspend_enable_irqs(void);
 
 extern int pm_suspend(suspend_state_t state);
+#else /* CONFIG_PM */
+#define suspend_valid_only_mem	NULL
+
+static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
+static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
+#endif /* CONFIG_PM */
 
 /* struct pbe is used for creating lists of pages that should be restored
  * atomically during the resume from disk, because the page frames they have

