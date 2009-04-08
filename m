Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbZDHCLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbZDHCLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 22:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZDHCKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 22:10:50 -0400
Received: from mail.kolorific.com ([61.63.28.39]:36455 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbZDHCKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 22:10:49 -0400
Date: Wed, 8 Apr 2009 10:10:38 +0800
From: "figo.zhang" <figo.zhang@kolorific.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]kernel/sched_fair.c: task_new_fair() have call update_curr()
 twice
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20090408021038.2D1A4F50054@mail.kolorific.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The task_new_fair() will call update_curr() twice, one is in
task_new_fair(), and other one in
enqueue_task_fair()->enqueue_entity(), they do the same,  so  it
should be need one time.

Signed-off-by: figo.zhang <figo.zhang@kolorific.com>


diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3816f21..d5913bb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1713,7 +1713,7 @@ static void task_new_fair(struct rq *rq, struct
task_struct *p) 
 	sched_info_queued(p);
 
-	update_curr(cfs_rq);
+
 	place_entity(cfs_rq, se, 1);
 
 	/* 'curr' will be NULL if the child belongs to a different
group */
