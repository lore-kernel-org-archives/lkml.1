Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386Ab0ADKs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0ADKs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353Ab0ADKsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:48:25 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40501 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0ADKsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:48:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com, nhorman@tuxdriver.com,
       mingo@elte.hu
Subject: [PATCH 2/3] resource: move kernel function inside __KERNEL__
Date: Mon,  4 Jan 2010 11:48:14 +0100
Message-Id: <1262602095-17591-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <4B41C750.9080305@gmail.com>
References: <4B41C750.9080305@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is an internal function. Move it inside __KERNEL__ ifdef, along
with task_struct declaration.

Then we get:
--- /usr/include/linux/resource.h       2009-09-14 15:09:29.000000000 +0200
+++ usr/include/linux/resource.h       2010-01-04 11:30:54.000000000 +0100
@@ -3,8 +3,6 @@

 #include <linux/time.h>

-struct task_struct;
-
 /*
  * Resource control/accounting header file for linux
  */
@@ -70,6 +68,5 @@
  */
 #include <asm/resource.h>

-int getrusage(struct task_struct *p, int who, struct rusage *ru);

 #endif

***********

include/linux/Kbuild is untouched, since unifdef is run even on
headers-y nowadays.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/resource.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/resource.h b/include/linux/resource.h
index 40fc7e6..f1e914e 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -3,8 +3,6 @@
 
 #include <linux/time.h>
 
-struct task_struct;
-
 /*
  * Resource control/accounting header file for linux
  */
@@ -70,6 +68,12 @@ struct rlimit {
  */
 #include <asm/resource.h>
 
+#ifdef __KERNEL__
+
+struct task_struct;
+
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
 
+#endif /* __KERNEL__ */
+
 #endif
-- 
1.6.5.7

