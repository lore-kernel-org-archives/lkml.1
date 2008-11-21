Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbYKUA3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbYKUA3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 19:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbYKUA3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 19:29:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:4707 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYKUA3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 19:29:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=P/f/6hOCcyG0t2owzed5n27sah0DxKhMah7s2lRoDIuTFqjsZQY3k61rz+rLgqnbfA
         wP29VqI6du2kO9SISMYuVfSufcg4A7etBexj5/mE+9X27h27BBVohGgzc06vzzBzoIaI
         /1a6u45UIh6TZJuXkVUisx7xYEFAOrwOjcZpI=
Date: Fri, 21 Nov 2008 01:30:36 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: update comment for move_task_off_dead_cpu
Message-ID: <20081121003036.GA8124@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Feel free to shorten the log message if this is in excess for the removal
of a single line... I just wanted to provide the context for the change.

:-)


Vegard


>From a827a58adaf864e232d0b398d94a6c8bdacebcd0 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 21 Nov 2008 01:23:20 +0100
Subject: [PATCH] sched: update comment for move_task_off_dead_cpu

This commit:

commit f7b4cddcc5aca03e80e357360c9424dfba5056c2
Author: Oleg Nesterov <oleg@tv-sign.ru>
Date:   Tue Oct 16 23:30:56 2007 -0700

    do CPU_DEAD migrating under read_lock(tasklist) instead of write_lock_irq(ta

    Currently move_task_off_dead_cpu() is called under
    write_lock_irq(tasklist).  This means it can't use task_lock() which is
    needed to improve migrating to take task's ->cpuset into account.

    Change the code to call move_task_off_dead_cpu() with irqs enabled, and
    change migrate_live_tasks() to use read_lock(tasklist).

...forgot to update the comment in front of move_task_off_dead_cpu.

Reference: http://lkml.org/lkml/2008/6/23/135

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/sched.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9b1e793..7ff3e94 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6125,7 +6125,6 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
 
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
- * NOTE: interrupts should be disabled by the caller
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-- 
1.5.6.5

