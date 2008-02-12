Return-Path: <linux-kernel-owner+w=401wt.eu-S1763710AbYBLQ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763710AbYBLQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbYBLQ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:29:15 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54296 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757AbYBLQ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:29:14 -0500
Message-Id: <20080212162921.679551774@bull.net>
References: <20080212161340.200976067@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 12 Feb 2008 17:13:45 +0100
From: pierre.peiffer@bull.net
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-mm1 5/8] (resend) IPC/semaphores: remove one unused parameter from semctl_down()
Content-Disposition: inline; filename=ipc_semctl_down_remove_unused_parameter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Peiffer <pierre.peiffer@bull.net>

semctl_down() takes one unused parameter: semnum.
This patch proposes to get rid of it.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 ipc/sem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/ipc/sem.c
===================================================================
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -880,8 +880,8 @@ static inline unsigned long copy_semid_f
  * to be held in write mode.
  * NOTE: no locks must be held, the rw_mutex is taken inside this function.
  */
-static int semctl_down(struct ipc_namespace *ns, int semid, int semnum,
-		int cmd, int version, union semun arg)
+static int semctl_down(struct ipc_namespace *ns, int semid,
+		       int cmd, int version, union semun arg)
 {
 	struct sem_array *sma;
 	int err;
@@ -972,7 +972,7 @@ asmlinkage long sys_semctl (int semid, i
 		return err;
 	case IPC_RMID:
 	case IPC_SET:
-		err = semctl_down(ns,semid,semnum,cmd,version,arg);
+		err = semctl_down(ns, semid, cmd, version, arg);
 		return err;
 	default:
 		return -EINVAL;

-- 
Pierre Peiffer
