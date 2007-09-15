Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbXIOTFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbXIOTFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXIOTFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:05:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49394 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXIOTFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:05:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] Hibernation: Resume consoles if hibernation_platform_enter fails
Date: Sat, 15 Sep 2007 21:17:39 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709152117.40581.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[This is a fix on top of
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch]
---
From: Rafael J. Wysocki <rjw@sisk.pl>

If hibernation_platform_enter() fails, consoles should be resumed so that
diagnostic information related to the failure is available to the user.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc6/kernel/power/disk.c
===================================================================
--- linux-2.6.23-rc6.orig/kernel/power/disk.c
+++ linux-2.6.23-rc6/kernel/power/disk.c
@@ -293,7 +293,7 @@ int hibernation_platform_enter(void)
 	suspend_console();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error)
-		return error;
+		goto Resume_console;
 
 	error = hibernation_ops->prepare();
 	if (error)
@@ -320,6 +320,8 @@ int hibernation_platform_enter(void)
 	hibernation_ops->finish();
  Resume_devices:
 	device_resume();
+ Resume_console:
+	resume_console();
 	return error;
 }
 
