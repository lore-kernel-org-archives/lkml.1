Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094Ab0AEAer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab0AEAer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162Ab0AEAen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:43 -0500
Received: from kroah.org ([198.145.64.141]:34097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab0AEAel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/97] sched: Select_task_rq_fair() must honour SD_LOAD_BALANCE
Date: Mon,  4 Jan 2010 16:32:20 -0800
Message-Id: <1262651630-7354-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit e4f4288842ee12747e10c354d72be7d424c0b627 upstream.

We should skip !SD_LOAD_BALANCE domains.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.653578430@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_fair.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5488a5d..199228b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1374,6 +1374,9 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 
 	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
+		if (!(tmp->flags & SD_LOAD_BALANCE))
+			continue;
+
 		/*
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
-- 
1.6.6

