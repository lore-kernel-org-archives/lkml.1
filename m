Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbXK1AgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbXK1AgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760524AbXK1AeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:34:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46464 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723AbXK1AeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:34:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 6/7] Suspend: Use common prefix in messages
Date: Wed, 28 Nov 2007 01:30:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711280113.36941.rjw@sisk.pl>
In-Reply-To: <200711280113.36941.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711280130.25369.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make suspend messages start with one common prefix "PM: ".

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -227,7 +227,7 @@ static int suspend_enter(suspend_state_t
 	BUG_ON(!irqs_disabled());
 
 	if ((error = device_power_down(PMSG_SUSPEND))) {
-		printk(KERN_ERR "Some devices failed to power down\n");
+		printk(KERN_ERR "PM: Some devices failed to power down\n");
 		goto Done;
 	}
 
@@ -261,7 +261,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_console();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error) {
-		printk(KERN_ERR "Some devices failed to suspend\n");
+		printk(KERN_ERR "PM: Some devices failed to suspend\n");
 		goto Resume_console;
 	}
 
@@ -344,7 +344,7 @@ static int enter_state(suspend_state_t s
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
-	printk("Syncing filesystems ... ");
+	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
 	printk("done.\n");
 

