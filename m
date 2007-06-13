Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbXFMVa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbXFMVa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXFMV3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:29:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48331 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbXFMV3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:29:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Date: Wed, 13 Jun 2007 16:20:53 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl>
In-Reply-To: <200706131551.51336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131620.54338.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The suspend and resume support in struct device_type (include/linux/device.h)
is not used anywhere.  It is also undocumented, so it can be removed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/resume.c  |    5 -----
 drivers/base/power/suspend.c |    7 -------
 include/linux/device.h       |    2 --
 3 files changed, 14 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/resume.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
@@ -41,11 +41,6 @@ int resume_device(struct device * dev)
 		error = dev->bus->resume(dev);
 	}
 
-	if (!error && dev->type && dev->type->resume) {
-		dev_dbg(dev,"resuming\n");
-		error = dev->type->resume(dev);
-	}
-
 	if (!error && dev->class && dev->class->resume) {
 		dev_dbg(dev,"class resume\n");
 		error = dev->class->resume(dev);
Index: linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/suspend.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
@@ -79,13 +79,6 @@ int suspend_device(struct device * dev, 
 		suspend_report_result(dev->class->suspend, error);
 	}
 
-	if (!error && dev->type && dev->type->suspend
-	    && !dev->power.power_state.event) {
-		suspend_device_dbg(dev, state, "type ");
-		error = dev->type->suspend(dev, state);
-		suspend_report_result(dev->type->suspend, error);
-	}
-
 	if (!error && dev->bus && dev->bus->suspend
 	    && !dev->power.power_state.event) {
 		suspend_device_dbg(dev, state, "");
Index: linux-2.6.22-rc4-mm2/include/linux/device.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/device.h
+++ linux-2.6.22-rc4-mm2/include/linux/device.h
@@ -340,8 +340,6 @@ struct device_type {
 	int (*uevent)(struct device *dev, char **envp, int num_envp,
 		      char *buffer, int buffer_size);
 	void (*release)(struct device *dev);
-	int (*suspend)(struct device * dev, pm_message_t state);
-	int (*resume)(struct device * dev);
 };
 
 /* interface for exporting device attributes */

