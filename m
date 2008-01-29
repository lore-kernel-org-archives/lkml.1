Return-Path: <linux-kernel-owner+w=401wt.eu-S932687AbYA2QSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbYA2QSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765857AbYA2QR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:17:59 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44358 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765697AbYA2QR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:17:57 -0500
Message-Id: <20080129161758.154775218@bull.net>
References: <20080129160229.612172683@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 17:02:34 +0100
From: pierre.peiffer@bull.net
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 2.6.24-rc8-mm1 05/15] IPC/semaphores: remove one unused parameter from semctl_down()
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/01/2008 17:26:34,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/01/2008 17:26:36,
	Serialize complete at 29/01/2008 17:26:36
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
@@ -882,8 +882,8 @@ static inline unsigned long copy_semid_f
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
@@ -974,7 +974,7 @@ asmlinkage long sys_semctl (int semid, i
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
