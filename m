Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbXKJLNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbXKJLNJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 06:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXKJLM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 06:12:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:59913 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbXKJLM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 06:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=T9ijAGuDKQHsCbRfoM76M6fBW+/l0BTx/YbMcFiA7TM+EWZisZhcZ5thECHjyaWacq/zrlJDyAVERJy6oYEks7CIQwkte3wgYlhjuzyLF3AMhnxDnjbdOjl7umk7/7S06KC/cpqGADIPf7UbS7MtYxSpD038NydAQsNnA0RuXjc=
Date: Sat, 10 Nov 2007 12:11:56 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Improve cgroup printks
Message-Id: <20071110121156.a547194e.diegocg@gmail.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I boot with the 'quiet' parameter, I see on the screen:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[   39.036026] Initializing cgroup subsys cpuacct
[   39.036080] Initializing cgroup subsys debug
[   39.036118] Initializing cgroup subsys ns

This patch lowers the priority of those messages, adds a "cgroup: " prefix
to another couple of printks and kills the useless reference to the source file.


Signed-off-by: Diego Calleja <diegocg@gmail.com>

--- 2.6/kernel/cgroup.c.old	2007-11-10 11:35:51.000000000 +0100
+++ 2.6/kernel/cgroup.c	2007-11-10 11:56:46.000000000 +0100
@@ -1,6 +1,4 @@
 /*
- *  kernel/cgroup.c
- *
  *  Generic process-grouping system.
  *
  *  Based originally on the cpuset system, extracted by Paul Menage
@@ -2200,7 +2198,7 @@ static void cgroup_init_subsys(struct cg
 {
 	struct cgroup_subsys_state *css;
 	struct list_head *l;
-	printk(KERN_ERR "Initializing cgroup subsys %s\n", ss->name);
+	printk("Initializing cgroup subsys %s\n", ss->name);
 
 	/* Create the top cgroup state for this subsystem */
 	ss->root = &rootnode;
@@ -2273,7 +2271,7 @@ int __init cgroup_init_early(void)
 		BUG_ON(!ss->create);
 		BUG_ON(!ss->destroy);
 		if (ss->subsys_id != i) {
-			printk(KERN_ERR "Subsys %s id == %d\n",
+			printk(KERN_ERR "cgroup: Subsys %s id == %d\n",
 			       ss->name, ss->subsys_id);
 			BUG();
 		}
@@ -2605,7 +2603,7 @@ int cgroup_clone(struct task_struct *tsk
 	dentry = lookup_one_len(nodename, parent->dentry, strlen(nodename));
 	if (IS_ERR(dentry)) {
 		printk(KERN_INFO
-		       "Couldn't allocate dentry for %s: %ld\n", nodename,
+		       "cgroup: Couldn't allocate dentry for %s: %ld\n", nodename,
 		       PTR_ERR(dentry));
 		ret = PTR_ERR(dentry);
 		goto out_release;
