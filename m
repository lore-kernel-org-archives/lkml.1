Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbZCMNHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbZCMNHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZCMNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:07:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:36670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZCMNHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:07:01 -0400
Date: Fri, 13 Mar 2009 13:06:25 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.188032328@chello.nl>
References: <20090313112301.188032328@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: x86: fix 32-bit irq_period assumption
Message-ID: <tip-c1c159de20d96a5505dfc0337ca7169a088ebd64@git.kernel.org>
Git-Commit-ID: c1c159de20d96a5505dfc0337ca7169a088ebd64
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:06:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1c159de20d96a5505dfc0337ca7169a088ebd64
Gitweb:     http://git.kernel.org/tip/c1c159de20d96a5505dfc0337ca7169a088ebd64
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:28 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 14:02:42 +0100

perf_counter: x86: fix 32-bit irq_period assumption

No need to assume the irq_period is 32bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112301.188032328@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 155bc3c..1cedc34 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -449,7 +449,7 @@ __hw_perf_counter_set_period(struct perf_counter *counter,
 			     struct hw_perf_counter *hwc, int idx)
 {
 	s64 left = atomic64_read(&hwc->period_left);
-	s32 period = hwc->irq_period;
+	s64 period = hwc->irq_period;
 	int err;
 
 	/*
