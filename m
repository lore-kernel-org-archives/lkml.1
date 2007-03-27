Return-Path: <linux-kernel-owner+w=401wt.eu-S933941AbXC0CKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbXC0CKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 22:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933936AbXC0CKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 22:10:13 -0400
Received: from mail11.syd.optusnet.com.au ([211.29.132.192]:56421 "EHLO
	mail11.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933941AbXC0CKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 22:10:11 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][ 2/5] sched: remove sleepavg from proc
Date: Tue, 27 Mar 2007 13:09:51 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703271209.51267.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the sleep_avg field from proc output as it will be removed from the
task_struct.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
---

 fs/proc/array.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.21-rc5-sd/fs/proc/array.c
===================================================================
--- linux-2.6.21-rc5-sd.orig/fs/proc/array.c	2007-03-26 11:03:31.000000000 +1000
+++ linux-2.6.21-rc5-sd/fs/proc/array.c	2007-03-27 11:52:55.000000000 +1000
@@ -165,7 +165,6 @@ static inline char * task_state(struct t
 	rcu_read_lock();
 	buffer += sprintf(buffer,
 		"State:\t%s\n"
-		"SleepAVG:\t%lu%%\n"
 		"Tgid:\t%d\n"
 		"Pid:\t%d\n"
 		"PPid:\t%d\n"
@@ -173,7 +172,6 @@ static inline char * task_state(struct t
 		"Uid:\t%d\t%d\t%d\t%d\n"
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
-		(p->sleep_avg/1024)*100/(1020000000/1024),
 	       	p->tgid, p->pid,
 	       	pid_alive(p) ? rcu_dereference(p->real_parent)->tgid : 0,
 		pid_alive(p) && p->ptrace ? rcu_dereference(p->parent)->pid : 0,

-- 
-ck
