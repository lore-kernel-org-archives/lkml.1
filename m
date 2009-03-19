Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZCSNEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZCSNEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZCSNEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:04:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:42037 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbZCSNEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:04:07 -0400
Date: Thu, 19 Mar 2009 13:03:25 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
Subject: [tip:cpus4096] cpumask: remove cpumask allocation from idle_balance, fix
Message-ID: <tip-8c083f081d0014057901c68a0a3e0f8ca7ac8d23@git.kernel.org>
Git-Commit-ID: 8c083f081d0014057901c68a0a3e0f8ca7ac8d23
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Mar 2009 13:03:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c083f081d0014057901c68a0a3e0f8ca7ac8d23
Gitweb:     http://git.kernel.org/tip/8c083f081d0014057901c68a0a3e0f8ca7ac8d23
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Thu, 19 Mar 2009 15:22:20 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Mar 2009 13:49:44 +0100

cpumask: remove cpumask allocation from idle_balance, fix

Impact: fix boot crash

Fix typo in the size calculation.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 48862d4..11dd527 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8297,7 +8297,7 @@ void __init sched_init(void)
 	alloc_size *= 2;
 #endif
 #ifdef CONFIG_CPUMASK_OFFSTACK
-	alloc_size *= num_possible_cpus() * cpumask_size();
+	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
 	/*
 	 * As sched_init() is called before page_alloc is setup,
