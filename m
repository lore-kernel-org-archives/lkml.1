Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbXK1Aed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbXK1Aed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759373AbXK1AeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:34:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46450 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771AbXK1AeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:34:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/7] Suspend: Fix compilation warning for CONFIG_SUSPEND unset
Date: Wed, 28 Nov 2007 01:15:19 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711280113.36941.rjw@sisk.pl>
In-Reply-To: <200711280113.36941.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711280115.19936.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the new suspend debug facility code depend on CONFIG_SUSPEND,
as appropriate, to remove the compiler warning printed when CONFIG_PM is set
and CONFIG_SUSPEND is not set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -52,6 +52,8 @@ int pm_notifier_call_chain(unsigned long
 
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_SUSPEND
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
@@ -125,9 +127,6 @@ power_attr(pm_test);
 static inline int suspend_test(int level) { return 0; }
 #endif /* !CONFIG_PM_DEBUG */
 
-
-#ifdef CONFIG_SUSPEND
-
 /* This is just an arbitrary number */
 #define FREE_PAGE_NUMBER (100)
 

