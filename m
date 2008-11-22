Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYKVRkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYKVRkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYKVRgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:36:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58481 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759621AbYKVRgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:36:45 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 21/32] cpuinit fixes in kernel/*
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wPU-0006Zb-LT@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:36:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/cpu.c     |    2 +-
 kernel/profile.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -462,7 +462,7 @@ out:
  * It must be called by the arch code on the new cpu, before the new cpu
  * enables interrupts and before the "boot" cpu returns from __cpu_up().
  */
-void notify_cpu_starting(unsigned int cpu)
+void __cpuinit notify_cpu_starting(unsigned int cpu)
 {
 	unsigned long val = CPU_STARTING;
 
diff --git a/kernel/profile.c b/kernel/profile.c
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -351,7 +351,7 @@ out:
 	put_cpu();
 }
 
-static int __devinit profile_cpu_callback(struct notifier_block *info,
+static int __cpuinit profile_cpu_callback(struct notifier_block *info,
 					unsigned long action, void *__cpu)
 {
 	int node, cpu = (unsigned long)__cpu;
@@ -596,7 +596,7 @@ out_cleanup:
 #define create_hash_tables()			({ 0; })
 #endif
 
-int create_proc_profile(void)
+int __ref create_proc_profile(void) /* false positive from hotcpu_notifier */
 {
 	struct proc_dir_entry *entry;
 
