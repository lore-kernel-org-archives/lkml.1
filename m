Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZCXVeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZCXVeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbZCXVeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:34:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:50422 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZCXVeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:34:14 -0400
Date: Tue, 24 Mar 2009 21:33:30 GMT
From: Jody McIntyre <scjody@sun.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, scjody@sun.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, scjody@sun.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090324200027.GH8294@clouds>
References: <20090324200027.GH8294@clouds>
Subject: [tip:tracing/docs] tracing: Documentation / sample code fixes for tracepoints
Message-ID: <tip-0a5d649018b151cb9331c213a843ac4a3e7e44ab@git.kernel.org>
Git-Commit-ID: 0a5d649018b151cb9331c213a843ac4a3e7e44ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 21:33:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a5d649018b151cb9331c213a843ac4a3e7e44ab
Gitweb:     http://git.kernel.org/tip/0a5d649018b151cb9331c213a843ac4a3e7e44ab
Author:     Jody McIntyre <scjody@sun.com>
AuthorDate: Tue, 24 Mar 2009 16:00:28 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 22:32:12 +0100

tracing: Documentation / sample code fixes for tracepoints

Fix the tracepoint documentation to refer to "tracepoint-sample"
instead of "tracepoint-example" to match what actually exists;
fix the directory, and clarify how to compile.

Change every instance of "example" in the sample tracepoint code
to "sample" for consistency.

Signed-off-by: Jody McIntyre <scjody@sun.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: torvalds@linux-foundation.org
LKML-Reference: <20090324200027.GH8294@clouds>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/tracepoints.txt           |   13 +++++++------
 samples/tracepoints/tracepoint-sample.c |   24 ++++++++++++------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/Documentation/tracepoints.txt b/Documentation/tracepoints.txt
index 4ff43c6..c0e1cee 100644
--- a/Documentation/tracepoints.txt
+++ b/Documentation/tracepoints.txt
@@ -103,13 +103,14 @@ used to export the defined tracepoints.
 
 * Probe / tracepoint example
 
-See the example provided in samples/tracepoints/src
+See the example provided in samples/tracepoints
 
-Compile them with your kernel.
+Compile them with your kernel.  They are built during 'make' (not
+'make modules') when CONFIG_SAMPLE_TRACEPOINTS=m.
 
 Run, as root :
-modprobe tracepoint-example (insmod order is not important)
-modprobe tracepoint-probe-example
-cat /proc/tracepoint-example (returns an expected error)
-rmmod tracepoint-example tracepoint-probe-example
+modprobe tracepoint-sample (insmod order is not important)
+modprobe tracepoint-probe-sample
+cat /proc/tracepoint-sample (returns an expected error)
+rmmod tracepoint-sample tracepoint-probe-sample
 dmesg
diff --git a/samples/tracepoints/tracepoint-sample.c b/samples/tracepoints/tracepoint-sample.c
index 68d5dc0..9cf80a1 100644
--- a/samples/tracepoints/tracepoint-sample.c
+++ b/samples/tracepoints/tracepoint-sample.c
@@ -1,6 +1,6 @@
 /* tracepoint-sample.c
  *
- * Executes a tracepoint when /proc/tracepoint-example is opened.
+ * Executes a tracepoint when /proc/tracepoint-sample is opened.
  *
  * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -16,7 +16,7 @@
 DEFINE_TRACE(subsys_event);
 DEFINE_TRACE(subsys_eventb);
 
-struct proc_dir_entry *pentry_example;
+struct proc_dir_entry *pentry_sample;
 
 static int my_open(struct inode *inode, struct file *file)
 {
@@ -32,25 +32,25 @@ static struct file_operations mark_ops = {
 	.open = my_open,
 };
 
-static int __init example_init(void)
+static int __init sample_init(void)
 {
-	printk(KERN_ALERT "example init\n");
-	pentry_example = proc_create("tracepoint-example", 0444, NULL,
+	printk(KERN_ALERT "sample init\n");
+	pentry_sample = proc_create("tracepoint-sample", 0444, NULL,
 		&mark_ops);
-	if (!pentry_example)
+	if (!pentry_sample)
 		return -EPERM;
 	return 0;
 }
 
-static void __exit example_exit(void)
+static void __exit sample_exit(void)
 {
-	printk(KERN_ALERT "example exit\n");
-	remove_proc_entry("tracepoint-example", NULL);
+	printk(KERN_ALERT "sample exit\n");
+	remove_proc_entry("tracepoint-sample", NULL);
 }
 
-module_init(example_init)
-module_exit(example_exit)
+module_init(sample_init)
+module_exit(sample_exit)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mathieu Desnoyers");
-MODULE_DESCRIPTION("Tracepoint example");
+MODULE_DESCRIPTION("Tracepoint sample");
