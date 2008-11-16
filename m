Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYKPMVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYKPMVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYKPMVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:21:12 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:57930 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYKPMVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:21:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=ib7rbgdnDY/DGsTqP9xwDv2maDVIRgYvT0ImlaVjsBJ6nrwlUXxEtwkC1wfjXrtI+X
         rv1p+T2vdPxagVyhpWfjsJDuAM7hx3TX/bnOfsWgDvHGDIbNfqq68qDTzTkaA0ta86UJ
         LTBep2SCEpb/0XfF40TWiMG4gwqxaLAZG2xZ0=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       qhfeng.kernel@gmail.com
Subject: [PATCH] samples: mark {static|__init|__exit} for {init|exit}
 functions 
Date: Sun, 16 Nov 2008 20:20:56 +0800
User-Agent: sniper-patch-carrier/1.05
Message-ID: <49201032.0c486e0a.0f62.684c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these (init|exit) functions is called from
other functions which is outside the kernel module 
mechanism or kernel itself, so mark them as 
{static|__init|__exit}.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/samples/firmware_class/firmware_sample_driver.c b/samples/firmware_class/firmware_sample_driver.c
index 11114f3..219a298 100644
--- a/samples/firmware_class/firmware_sample_driver.c
+++ b/samples/firmware_class/firmware_sample_driver.c
@@ -100,7 +100,7 @@ static void sample_probe_async(void)
 		       " request_firmware_nowait failed\n");
 }
 
-static int sample_init(void)
+static int __init sample_init(void)
 {
 	device_initialize(&ghost_device);
 	/* since there is no real hardware insertion I just call the
diff --git a/samples/kobject/kobject-example.c b/samples/kobject/kobject-example.c
index 08d0d3f..8d9b55a 100644
--- a/samples/kobject/kobject-example.c
+++ b/samples/kobject/kobject-example.c
@@ -101,7 +101,7 @@ static struct attribute_group attr_group = {
 
 static struct kobject *example_kobj;
 
-static int example_init(void)
+static int __init example_init(void)
 {
 	int retval;
 
@@ -126,7 +126,7 @@ static int example_init(void)
 	return retval;
 }
 
-static void example_exit(void)
+static void __exit example_exit(void)
 {
 	kobject_put(example_kobj);
 }
diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index 7395c0b..45b7d56 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -229,7 +229,7 @@ static void destroy_foo_obj(struct foo_obj *foo)
 	kobject_put(&foo->kobj);
 }
 
-static int example_init(void)
+static int __init example_init(void)
 {
 	/*
 	 * Create a kset with the name of "kset_example",
@@ -264,7 +264,7 @@ foo_error:
 	return -EINVAL;
 }
 
-static void example_exit(void)
+static void __exit example_exit(void)
 {
 	destroy_foo_obj(baz_obj);
 	destroy_foo_obj(bar_obj);
diff --git a/samples/markers/marker-example.c b/samples/markers/marker-example.c
index e90dc5d..e9cd9c0 100644
--- a/samples/markers/marker-example.c
+++ b/samples/markers/marker-example.c
@@ -30,7 +30,7 @@ static struct file_operations mark_ops = {
 	.open = my_open,
 };
 
-static int example_init(void)
+static int __init example_init(void)
 {
 	printk(KERN_ALERT "example init\n");
 	pentry_example = proc_create("marker-example", 0444, NULL, &mark_ops);
@@ -39,7 +39,7 @@ static int example_init(void)
 	return 0;
 }
 
-static void example_exit(void)
+static void __exit example_exit(void)
 {
 	printk(KERN_ALERT "example exit\n");
 	remove_proc_entry("marker-example", NULL);
diff --git a/samples/tracepoints/tracepoint-probe-sample.c b/samples/tracepoints/tracepoint-probe-sample.c
index 55abfdd..f48ec17 100644
--- a/samples/tracepoints/tracepoint-probe-sample.c
+++ b/samples/tracepoints/tracepoint-probe-sample.c
@@ -28,7 +28,7 @@ static void probe_subsys_eventb(void)
 	printk(KERN_INFO "Event B is encountered\n");
 }
 
-int __init tp_sample_trace_init(void)
+static int __init tp_sample_trace_init(void)
 {
 	int ret;
 
@@ -42,7 +42,7 @@ int __init tp_sample_trace_init(void)
 
 module_init(tp_sample_trace_init);
 
-void __exit tp_sample_trace_exit(void)
+static void __exit tp_sample_trace_exit(void)
 {
 	unregister_trace_subsys_eventb(probe_subsys_eventb);
 	unregister_trace_subsys_event(probe_subsys_event);
diff --git a/samples/tracepoints/tracepoint-probe-sample2.c b/samples/tracepoints/tracepoint-probe-sample2.c
index 5e9fcf4..d882537 100644
--- a/samples/tracepoints/tracepoint-probe-sample2.c
+++ b/samples/tracepoints/tracepoint-probe-sample2.c
@@ -18,7 +18,7 @@ static void probe_subsys_event(struct inode *inode, struct file *file)
 		inode->i_ino);
 }
 
-int __init tp_sample_trace_init(void)
+static int __init tp_sample_trace_init(void)
 {
 	int ret;
 
@@ -30,7 +30,7 @@ int __init tp_sample_trace_init(void)
 
 module_init(tp_sample_trace_init);
 
-void __exit tp_sample_trace_exit(void)
+static void __exit tp_sample_trace_exit(void)
 {
 	unregister_trace_subsys_event(probe_subsys_event);
 }
diff --git a/samples/tracepoints/tracepoint-sample.c b/samples/tracepoints/tracepoint-sample.c
index 4ae4b7f..ef51419 100644
--- a/samples/tracepoints/tracepoint-sample.c
+++ b/samples/tracepoints/tracepoint-sample.c
@@ -29,7 +29,7 @@ static struct file_operations mark_ops = {
 	.open = my_open,
 };
 
-static int example_init(void)
+static int __init example_init(void)
 {
 	printk(KERN_ALERT "example init\n");
 	pentry_example = proc_create("tracepoint-example", 0444, NULL,
@@ -39,7 +39,7 @@ static int example_init(void)
 	return 0;
 }
 
-static void example_exit(void)
+static void __exit example_exit(void)
 {
 	printk(KERN_ALERT "example exit\n");
 	remove_proc_entry("tracepoint-example", NULL);

