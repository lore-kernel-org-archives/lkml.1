Return-Path: <linux-kernel-owner+w=401wt.eu-S936201AbXFFWKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936201AbXFFWKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935160AbXFFWJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:09:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30654 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbXFFWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:09:50 -0400
Date: Wed, 6 Jun 2007 15:09:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] schedstats: fix printk format
Message-Id: <20070606150929.6422177f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings for schedstats:

fs/proc/base.c:309: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'
fs/proc/base.c:309: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'long long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22-rc4-mm1.orig/fs/proc/base.c
+++ linux-2.6.22-rc4-mm1/fs/proc/base.c
@@ -303,7 +303,7 @@ static int proc_pid_wchan(struct task_st
  */
 static int proc_pid_schedstat(struct task_struct *task, char *buffer)
 {
-	return sprintf(buffer, "%lu %lu %lu\n",
+	return sprintf(buffer, "%llu %llu %lu\n",
 			task->sched_info.cpu_time,
 			task->sched_info.run_delay,
 			task->sched_info.pcnt);
