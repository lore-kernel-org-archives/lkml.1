Return-Path: <linux-kernel-owner+w=401wt.eu-S1161149AbXCGBmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161149AbXCGBmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161151AbXCGBmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:42:11 -0500
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:38463 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161149AbXCGBmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:42:09 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: [PATCH] [RSDL-mm 2/5] sched: remove sleepavg from proc
Date: Wed, 7 Mar 2007 12:27:17 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1519
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703071227.18151.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the sleep_avg field from proc output as it will be removed from the
task_struct.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 fs/proc/array.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.21-rc2-mm2/fs/proc/array.c
===================================================================
--- linux-2.6.21-rc2-mm2.orig/fs/proc/array.c	2007-03-07 11:21:15.000000000 +1100
+++ linux-2.6.21-rc2-mm2/fs/proc/array.c	2007-03-07 11:22:59.000000000 +1100
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
