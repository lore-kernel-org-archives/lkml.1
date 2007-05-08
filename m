Return-Path: <linux-kernel-owner+w=401wt.eu-S967013AbXEHUlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967013AbXEHUlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933865AbXEHUll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:41:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44853 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933223AbXEHUlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:41:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] swsusp: Use reasonable default for hibernation_mode
Date: Tue, 8 May 2007 22:46:16 +0200
User-Agent: KMail/1.9.5
Cc: Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
References: <200705041132.32227.rjw@sisk.pl> <200705051550.53436.rjw@sisk.pl> <1178538404.7261.16.camel@johannes.berg>
In-Reply-To: <1178538404.7261.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705082246.17166.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make sure that hibernation_mode is set to a reasonable value by default.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.21/kernel/power/disk.c
===================================================================
--- linux-2.6.21.orig/kernel/power/disk.c	2007-05-06 14:40:12.000000000 +0200
+++ linux-2.6.21/kernel/power/disk.c	2007-05-08 22:12:02.000000000 +0200
@@ -30,8 +30,6 @@ char resume_file[256] = CONFIG_PM_STD_PA
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 
-static int hibernation_mode;
-
 enum {
 	HIBERNATION_INVALID,
 	HIBERNATION_PLATFORM,
@@ -45,6 +43,8 @@ enum {
 #define HIBERNATION_MAX (__HIBERNATION_AFTER_LAST-1)
 #define HIBERNATION_FIRST (HIBERNATION_INVALID + 1)
 
+static int hibernation_mode = HIBERNATION_SHUTDOWN;
+
 struct hibernation_ops *hibernation_ops;
 
 /**
@@ -60,6 +60,11 @@ void hibernation_set_ops(struct hibernat
 	}
 	mutex_lock(&pm_mutex);
 	hibernation_ops = ops;
+	if (ops)
+		hibernation_mode = HIBERNATION_PLATFORM;
+	else if (hibernation_mode == HIBERNATION_PLATFORM)
+		hibernation_mode = HIBERNATION_SHUTDOWN;
+
 	mutex_unlock(&pm_mutex);
 }
 
