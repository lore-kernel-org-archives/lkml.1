Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbXGQM0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbXGQM0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXGQMZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:25:53 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:29079 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXGQMZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:25:52 -0400
Date: Tue, 17 Jul 2007 16:25:11 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] Fix leaks on /proc/{*/sched,sched_debug,timer_list,timer_stats}
Message-ID: <20070717122511.GD25083@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On every open/close one struct seq_operations leaks.
Kudos to /proc/slab_allocators.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/base.c            |    2 +-
 kernel/sched_debug.c      |    2 +-
 kernel/time/timer_list.c  |    2 +-
 kernel/time/timer_stats.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -926,7 +926,7 @@ static const struct file_operations proc_pid_sched_operations = {
 	.read		= seq_read,
 	.write		= sched_write,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 #endif
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -200,7 +200,7 @@ static struct file_operations sched_debug_fops = {
 	.open		= sched_debug_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init init_sched_debug_procfs(void)
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -267,7 +267,7 @@ static struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init init_timer_list_procfs(void)
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -399,7 +399,7 @@ static struct file_operations tstats_fops = {
 	.read		= seq_read,
 	.write		= tstats_write,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 void __init init_timer_stats(void)

