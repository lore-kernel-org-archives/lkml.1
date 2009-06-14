Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbZFNRFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbZFNRFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 13:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZFNRFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 13:05:48 -0400
Received: from vm1.die-welt.net ([84.246.122.34]:51224 "EHLO chi.die-welt.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752436AbZFNRFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 13:05:47 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jun 2009 13:05:47 EDT
From: Evgeni Golov <sargentd@die-welt.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeni Golov <sargentd@die-welt.net>
Subject: [PATCH 1/2] get_task_comm: use strlcpy instead of strncpy
Date: Sun, 14 Jun 2009 18:57:47 +0200
Message-Id: <1244998668-27078-1-git-send-email-sargentd@die-welt.net>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it's used in set_task_comm too and as far as I understand it should
be used everywhere.

Signed-off-by: Evgeni Golov <sargentd@die-welt.net>
---
 fs/exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e639957..6f1eeb8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -913,7 +913,7 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
 {
 	/* buf must be at least sizeof(tsk->comm) in size */
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, sizeof(tsk->comm));
+	strlcpy(buf, tsk->comm, sizeof(tsk->comm));
 	task_unlock(tsk);
 	return buf;
 }
-- 
1.6.3.1

