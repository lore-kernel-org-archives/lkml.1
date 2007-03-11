Return-Path: <linux-kernel-owner+w=401wt.eu-S932889AbXCKEAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbXCKEAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 23:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932945AbXCKEAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 23:00:24 -0500
Received: from mail33.syd.optusnet.com.au ([211.29.132.104]:48565 "EHLO
	mail33.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932889AbXCKEAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 23:00:23 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RSDL-mm 2/7] sched: remove sleepavg from proc
Date: Sun, 11 Mar 2007 15:00:02 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703111500.02539.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Con Kolivas <kernel@kolivas.org>

Remove the sleep_avg field from proc output as it will be removed from the
task_struct.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.21-rc3-mm2/fs/proc/array.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/fs/proc/array.c	2007-03-11 14:47:57.000000000 +1100
+++ linux-2.6.21-rc3-mm2/fs/proc/array.c	2007-03-11 14:47:59.000000000 +1100
@@ -171,7 +171,6 @@ static inline char * task_state(struct t
 
 	buffer += sprintf(buffer,
 		"State:\t%s\n"
-		"SleepAVG:\t%lu%%\n"
 		"Tgid:\t%d\n"
 		"Pid:\t%d\n"
 		"PPid:\t%d\n"
@@ -179,7 +178,6 @@ static inline char * task_state(struct t
 		"Uid:\t%d\t%d\t%d\t%d\n"
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
-		(p->sleep_avg/1024)*100/(1020000000/1024),
 	       	p->tgid, p->pid,
 	       	pid_alive(p) ? rcu_dereference(p->parent)->tgid : 0,
 		tracer_pid,

-- 
-ck
