Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbZCXT5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbZCXT5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbZCXT5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:57:11 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56772 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbZCXT5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:57:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
Date: Tue, 24 Mar 2009 16:00:28 -0400
From: Jody McIntyre <scjody@sun.com>
Subject: [PATCH] Documentation / sample code fixes for tracepoints
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Message-id: <20090324200027.GH8294@clouds>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the tracepoint documentation to refer to "tracepoint-sample" instead of
"tracepoint-example" to match what actually exists; fix the directory,
and clarify how to compile.

Change every instance of "example" in the sample tracepoint code to "sample"
for consistency.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: linux-2.6/Documentation/tracepoints.txt
===================================================================
--- linux-2.6.orig/Documentation/tracepoints.txt
+++ linux-2.6/Documentation/tracepoints.txt
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
Index: linux-2.6/samples/tracepoints/tracepoint-sample.c
===================================================================
--- linux-2.6.orig/samples/tracepoints/tracepoint-sample.c
+++ linux-2.6/samples/tracepoints/tracepoint-sample.c
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
@@ -32,25 +32,25 @@ static struct file_operations mark_ops =
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
