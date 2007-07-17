Return-Path: <linux-kernel-owner+w=401wt.eu-S936239AbXGQUnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936239AbXGQUnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934168AbXGQUmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:42:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50051 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764327AbXGQUmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:42:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Resend][PATCH 7/9] PM: Make suspend_ops static
Date: Tue, 17 Jul 2007 22:46:45 +0200
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
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707172246.46937.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The variable suspend_ops representing the set of global platform-specific
suspend-related operations, used by the PM core, need not be exported outside of
kernel/power/main.c .  Make it static.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 include/linux/suspend.h |    2 --
 kernel/power/main.c     |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.22-git5/include/linux/suspend.h
===================================================================
--- linux-2.6.22-git5.orig/include/linux/suspend.h
+++ linux-2.6.22-git5/include/linux/suspend.h
@@ -77,8 +77,6 @@ struct platform_suspend_ops {
 	void (*finish)(void);
 };
 
-extern struct platform_suspend_ops *suspend_ops;
-
 #ifdef CONFIG_PM
 /**
  * suspend_set_ops - set platform dependent suspend operations
Index: linux-2.6.22-git5/kernel/power/main.c
===================================================================
--- linux-2.6.22-git5.orig/kernel/power/main.c
+++ linux-2.6.22-git5/kernel/power/main.c
@@ -30,7 +30,7 @@ BLOCKING_NOTIFIER_HEAD(pm_chain_head);
 
 DEFINE_MUTEX(pm_mutex);
 
-struct platform_suspend_ops *suspend_ops;
+static struct platform_suspend_ops *suspend_ops;
 
 /**
  *	suspend_set_ops - Set the global suspend method table.

