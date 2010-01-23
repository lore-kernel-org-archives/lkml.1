Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665Ab0AWOrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab0AWOrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 09:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205Ab0AWOrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 09:47:11 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:37205 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab0AWOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 09:47:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mRs32yrzuQWRppBFLXMo6c57e/3t/a/kuubqOAFfXdAjv3HE91szYsAXRsjINNqBqp
         YRCOPOoU5DDkO+Arlb7Q/hnxMC1wH/Lm88X2PopEB0jmjdAc16cSPFiPdUf+Zp51Ev2i
         YscXJBesWxavzRQG+t8+T2a4kDHMo+036smyM=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/1] kernel/exit.c: fix shadows sparse warning.
Date: Sat, 23 Jan 2010 09:46:33 -0500
Message-Id: <9695506b784c54436f40b4c21ce2d7e6965b7aee.1264257828.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.1.383.g5a9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/exit.c:1183:26: warning: symbol 'status' shadows an earlier one
kernel/exit.c:1173:21: originally declared here

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 kernel/exit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 546774a..2e72b3f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1180,7 +1180,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
 	if (unlikely(wo->wo_flags & WNOWAIT)) {
 		int exit_code = p->exit_code;
-		int why, status;
+		int why;
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
-- 
1.6.6.1.383.g5a9f

