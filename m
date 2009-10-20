Return-Path: <linux-kernel-owner+w=401wt.eu-S1751664AbZJTEnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbZJTEnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZJTEnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:43:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZJTEnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:43:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Make warning in suspend_test_finish() less likely to happen
Date: Tue, 20 Oct 2009 06:45:02 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc4-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910200645.02384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Increase TEST_SUSPEND_SECONDS to 10 so the warning in
suspend_test_finish() doesn't annoy the users of slower systems so
much.

Also, make the warning print the suspend-resume cycle time, so
that we know why the warning actually triggered.

Patch prepared during the hacking session at the Kernel Summit in
Tokyo.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/suspend_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/suspend_test.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend_test.c
+++ linux-2.6/kernel/power/suspend_test.c
@@ -19,7 +19,7 @@
  * The time it takes is system-specific though, so when we test this
  * during system bootup we allow a LOT of time.
  */
-#define TEST_SUSPEND_SECONDS	5
+#define TEST_SUSPEND_SECONDS	10
 
 static unsigned long suspend_test_start_time;
 
@@ -49,7 +49,8 @@ void suspend_test_finish(const char *lab
 	 * has some performance issues.  The stack dump of a WARN_ON
 	 * is more likely to get the right attention than a printk...
 	 */
-	WARN(msec > (TEST_SUSPEND_SECONDS * 1000), "Component: %s\n", label);
+	WARN(msec > (TEST_SUSPEND_SECONDS * 1000),
+	     "Component: %s, time: %u\n", label, msec);
 }
 
 /*
