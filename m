Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbZFQIsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbZFQIsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbZFQIsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:48:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:57325 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932666AbZFQIsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:48:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19mrb4Kc/NmmZY85JGtxbGNzXNf4frSvi/QtCJuwj
	9TF8pJw6IRR4X4
Subject: [patch 2/2] Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK
 scheduling policy flag, fourth try
From: Mike Galbraith <efault@gmx.de>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1245228361.18329.6.camel@marge.simson.net>
References: <20090615152714.GA29092@tango.0pointer.de>
	 <1245143108.6038.10.camel@marge.simson.net>
	 <20090616164742.GA21385@tango.0pointer.de>
	 <1245228361.18329.6.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 10:48:02 +0200
Message-Id: <1245228482.27326.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 50f3ff67c7fbcd37f0a135113ecd56f724d9b081
Author: Mike Galbraith <efault@gmx.de>
Date:   Wed Jun 17 10:30:19 2009 +0200

    sched: Add SCHED_RESET_ON_FORK functionality for nice < 0 tasks.
    
    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Lennart Poettering <mzxreary@0pointer.de>
    LKML-Reference: <new-submission>
---
 kernel/sched.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3c27e44..fe31c2d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2627,6 +2627,11 @@ void sched_fork(struct task_struct *p, int clone_flags)
 		if (p->normal_prio < DEFAULT_PRIO)
 			p->prio = DEFAULT_PRIO;
 
+		if (PRIO_TO_NICE(p->static_prio) < 0) {
+			p->static_prio = NICE_TO_PRIO(0);
+			set_load_weight(p);
+		}
+
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
 		 * fulfilled its duty:


