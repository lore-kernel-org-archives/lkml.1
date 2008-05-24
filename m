Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbYEXRHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbYEXRHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbYEXRGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:06:01 -0400
Received: from sing.entic.net ([208.64.63.147]:52546 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626AbYEXRGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:06:00 -0400
Message-Id: <200805241637.m4OGbBVo006252@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Date: Sat, 24 May 2008 13:23:04 +0200
Subject: [PATCH 2/4] ipc/sem.c: remove unused entries from struct sem_queue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sem_queue.sma and sem_queue.id were never used, the attached
patch removes them.

Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/sem.h |    2 --
 ipc/sem.c           |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 6a1af1b..87756ef 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -107,8 +107,6 @@ struct sem_queue {
 	struct sem_undo *	undo;	 /* undo structure */
 	int    			pid;	 /* process id of requesting process */
 	int    			status;	 /* completion status of operation */
-	struct sem_array *	sma;	 /* semaphore array for operations */
-	int			id;	 /* internal sem id */
 	struct sembuf *		sops;	 /* array of pending operations */
 	int			nsops;	 /* number of operations */
 	int			alter;   /* does the operation alter the array? */
diff --git a/ipc/sem.c b/ipc/sem.c
index 211632e..8cd96f1 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1160,12 +1160,10 @@ asmlinkage long sys_semtimedop(int semid, struct sembuf __user *tsops,
 	 * task into the pending queue and go to sleep.
 	 */
 		
-	queue.sma = sma;
 	queue.sops = sops;
 	queue.nsops = nsops;
 	queue.undo = un;
 	queue.pid = task_tgid_vnr(current);
-	queue.id = semid;
 	queue.alter = alter;
 	if (alter)
 		append_to_queue(sma ,&queue);
-- 
1.5.4.1

