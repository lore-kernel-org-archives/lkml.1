Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbXHAVbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbXHAVbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXHAVbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:31:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37191 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbXHAVbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:31:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/3] Freezer: Be more verbose
Date: Wed, 1 Aug 2007 23:30:43 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708012328.23939.rjw@sisk.pl>
In-Reply-To: <200708012328.23939.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708012330.44719.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Increase the freezer's verbosity a bit, so that it's easier to read problem
reports related to it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6.23-rc1/kernel/power/process.c
===================================================================
--- linux-2.6.23-rc1.orig/kernel/power/process.c	2007-07-24 00:13:46.000000000 +0200
+++ linux-2.6.23-rc1/kernel/power/process.c	2007-07-24 00:13:58.000000000 +0200
@@ -227,18 +227,21 @@ int freeze_processes(void)
 {
 	int error;
 
-	printk("Stopping tasks ... ");
+	printk("Freezing user space processes ... ");
 	error = try_to_freeze_tasks(FREEZER_USER_SPACE);
 	if (error)
-		return error;
+		goto Exit;
+	printk("done.\n");
 
+	printk("Freezing remaining freezable tasks ... ");
 	error = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
 	if (error)
-		return error;
-
-	printk("done.\n");
+		goto Exit;
+	printk("done.");
+ Exit:
 	BUG_ON(in_atomic());
-	return 0;
+	printk("\n");
+	return error;
 }
 
 static void thaw_tasks(int thaw_user_space)

