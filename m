Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbZLKETQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbZLKETQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZLKETO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:19:14 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56454 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbZLKETO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:19:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=NJdGZqNahvQTtQqBAAERH8gLDL7qM7hsNahiGIfg10yOOxfsf+ohBpCxMPeCA1oTqw
         ty5iepZzYb+ihOhomM9oLLjNlPdv8TdQfzJSeuzPD7HpYRtTbzFqH3AlmhjsVxiqsCrf
         sQYM8O9lAakch6GOp+GvzMjGH46KlL8zCnEzg=
MIME-Version: 1.0
From: XingChao Wang <wxc200@gmail.com>
Date: Fri, 11 Dec 2009 12:17:50 +0800
Message-ID: <fd6b62c10912102017g56b8651aj2b8cbe569b0f90a6@mail.gmail.com>
Subject: check_preempt_tick() check vruntime mistake?
To: kernel list <linux-kernel@vger.kernel.org>
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,peter,

When check_preempt_tick() selects next leftmost sched_entity,it
calculates delta vruntime of curr and leftmost entity, then compares
it with ideal_runtime. But ideal_runtime is real-time type, need
convert it to virtual-time ,right?

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 37087a7..9b903d4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -840,7 +840,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct
sched_entity *curr)
                struct sched_entity *se = __pick_next_entity(cfs_rq);
                s64 delta = curr->vruntime - se->vruntime;

-               if (delta > ideal_runtime)
+               if (delta > calc_delta_fair(ideal_runtime, curr))
                        resched_task(rq_of(cfs_rq)->curr);
        }
 }

thanks
--wang xingchao
