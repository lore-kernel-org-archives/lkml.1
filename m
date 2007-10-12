Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbXJLWii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbXJLWii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580AbXJLWUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:49765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389AbXJLWUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/75] drivers/base/power/: make 2 functions static
Date: Fri, 12 Oct 2007 15:16:38 -0700
Message-Id: <1192227598106-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227593813-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

suspend_device() and resume_device() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/power.h   |    6 ------
 drivers/base/power/resume.c  |    2 +-
 drivers/base/power/suspend.c |    2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 8ba0830..49e64db 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -55,12 +55,6 @@ extern void dpm_sysfs_remove(struct device *);
 
 extern void dpm_resume(void);
 extern void dpm_power_up(void);
-extern int resume_device(struct device *);
-
-/*
- * suspend.c
- */
-extern int suspend_device(struct device *, pm_message_t);
 
 #else /* CONFIG_PM_SLEEP */
 
diff --git a/drivers/base/power/resume.c b/drivers/base/power/resume.c
index 00fd84a..67948ba 100644
--- a/drivers/base/power/resume.c
+++ b/drivers/base/power/resume.c
@@ -20,7 +20,7 @@
  *
  */
 
-int resume_device(struct device * dev)
+static int resume_device(struct device * dev)
 {
 	int error = 0;
 
diff --git a/drivers/base/power/suspend.c b/drivers/base/power/suspend.c
index 26df9b2..204517a 100644
--- a/drivers/base/power/suspend.c
+++ b/drivers/base/power/suspend.c
@@ -54,7 +54,7 @@ suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
  *	@state:	Power state device is entering.
  */
 
-int suspend_device(struct device * dev, pm_message_t state)
+static int suspend_device(struct device * dev, pm_message_t state)
 {
 	int error = 0;
 
-- 
1.5.3.4

