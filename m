Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYACXdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYACXdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYACXdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:33:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:24414 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYACXdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:33:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=AOQIlRnXjECwDCKCFiUWd2CbFBpb25IVuT/vMsmG2Ga8gYzuEL3UlqiGbQ08yhCyXuhHqF9JwSmZv9HjoyHNGHCfRV+g9nlLjxoolyd/Uoq/+0la1iNrm1FFV4LLy94XcCLSAf5vrluDsJ1AB+QKlq6GV9b27mUC39sEnkLmFTI=
Date: Fri, 4 Jan 2008 00:32:53 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: mingo@elte.hu, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] This patch to profile.c fixes a few errors reported by
 checkpatch.pl
Message-ID: <20080104003253.7a7309d8@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 25 errors, 13 warnings, 602 lines checked

After:
total: 3 errors, 13 warnings, 602 lines checked


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
Ingo, I'm sending this patch to you since according to git shortlog -e
you are the most active modifier of this file


 kernel/profile.c |   70 +++++++++++++++++++++++++++---------------------------
 1 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 5e95330..c99153b 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -52,7 +52,7 @@ static DEFINE_PER_CPU(int, cpu_profile_flip);
 static DEFINE_MUTEX(profile_flip_mutex);
 #endif /* CONFIG_SMP */
 
-static int __init profile_setup(char * str)
+static int __init profile_setup(char *str)
 {
 	static char __initdata schedstr[] = "schedule";
 	static char __initdata sleepstr[] = "sleep";
@@ -104,27 +104,27 @@ __setup("profile=", profile_setup);
 
 void __init profile_init(void)
 {
-	if (!prof_on) 
+	if (!prof_on)
 		return;
- 
+
 	/* only text is profiled */
 	prof_len = (_etext - _stext) >> prof_shift;
 	prof_buffer = alloc_bootmem(prof_len*sizeof(atomic_t));
 }
 
 /* Profile event notifications */
- 
+
 #ifdef CONFIG_PROFILING
- 
+
 static BLOCKING_NOTIFIER_HEAD(task_exit_notifier);
 static ATOMIC_NOTIFIER_HEAD(task_free_notifier);
 static BLOCKING_NOTIFIER_HEAD(munmap_notifier);
- 
-void profile_task_exit(struct task_struct * task)
+
+void profile_task_exit(struct task_struct *task)
 {
 	blocking_notifier_call_chain(&task_exit_notifier, 0, task);
 }
- 
+
 int profile_handoff_task(struct task_struct * task)
 {
 	int ret;
@@ -137,48 +137,48 @@ void profile_munmap(unsigned long addr)
 	blocking_notifier_call_chain(&munmap_notifier, 0, (void *)addr);
 }
 
-int task_handoff_register(struct notifier_block * n)
+int task_handoff_register(struct notifier_block *n)
 {
 	return atomic_notifier_chain_register(&task_free_notifier, n);
 }
 
-int task_handoff_unregister(struct notifier_block * n)
+int task_handoff_unregister(struct notifier_block *n)
 {
 	return atomic_notifier_chain_unregister(&task_free_notifier, n);
 }
 
-int profile_event_register(enum profile_type type, struct notifier_block * n)
+int profile_event_register(enum profile_type type, struct notifier_block *n)
 {
 	int err = -EINVAL;
- 
+
 	switch (type) {
-		case PROFILE_TASK_EXIT:
-			err = blocking_notifier_chain_register(
-					&task_exit_notifier, n);
-			break;
-		case PROFILE_MUNMAP:
-			err = blocking_notifier_chain_register(
-					&munmap_notifier, n);
-			break;
+	case PROFILE_TASK_EXIT:
+		err = blocking_notifier_chain_register(
+				&task_exit_notifier, n);
+		break;
+	case PROFILE_MUNMAP:
+		err = blocking_notifier_chain_register(
+				&munmap_notifier, n);
+		break;
 	}
- 
+
 	return err;
 }
 
- 
-int profile_event_unregister(enum profile_type type, struct notifier_block * n)
+
+int profile_event_unregister(enum profile_type type, struct notifier_block *n)
 {
 	int err = -EINVAL;
- 
+
 	switch (type) {
-		case PROFILE_TASK_EXIT:
-			err = blocking_notifier_chain_unregister(
-					&task_exit_notifier, n);
-			break;
-		case PROFILE_MUNMAP:
-			err = blocking_notifier_chain_unregister(
-					&munmap_notifier, n);
-			break;
+	case PROFILE_TASK_EXIT:
+		err = blocking_notifier_chain_unregister(
+				&task_exit_notifier, n);
+		break;
+	case PROFILE_MUNMAP:
+		err = blocking_notifier_chain_unregister(
+				&munmap_notifier, n);
+		break;
 	}
 
 	return err;
@@ -475,7 +475,7 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
 	ssize_t read;
-	char * pnt;
+	char *pnt;
 	unsigned int sample_step = 1 << prof_shift;
 
 	profile_flip_buffers();
@@ -486,12 +486,12 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	read = 0;
 
 	while (p < sizeof(unsigned int) && count > 0) {
-		if (put_user(*((char *)(&sample_step)+p),buf))
+		if (put_user(*((char *)(&sample_step)+p), buf))
 			return -EFAULT;
 		buf++; p++; count--; read++;
 	}
 	pnt = (char *)prof_buffer + p - sizeof(atomic_t);
-	if (copy_to_user(buf,(void *)pnt,count))
+	if (copy_to_user(buf, (void *)pnt, count))
 		return -EFAULT;
 	read += count;
 	*ppos += read;
-- 
1.5.4.rc2.17.g257f

