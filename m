Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444AbXCDHEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbXCDHEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 02:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXCDHEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 02:04:12 -0500
Received: from mail17.syd.optusnet.com.au ([211.29.132.198]:60458 "EHLO
	mail17.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbXCDHEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 02:04:11 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: [PATCH] [RSDL 2/6] sched: remove sleepavg from proc
Date: Sun, 4 Mar 2007 18:04:04 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1659
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703041804.04137.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the sleep_avg field from proc output as it will be removed from the
task_struct.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 fs/proc/array.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.20-rsdl/fs/proc/array.c
===================================================================
--- linux-2.6.20-rsdl.orig/fs/proc/array.c	2007-03-04 17:30:25.000000000 +1100
+++ linux-2.6.20-rsdl/fs/proc/array.c	2007-03-04 17:30:30.000000000 +1100
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
