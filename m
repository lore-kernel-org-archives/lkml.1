Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZFQR2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZFQR2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZFQR2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:28:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:42093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758846AbZFQR2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:28:14 -0400
Date: Wed, 17 Jun 2009 17:27:44 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: x86: Set the period in the intel overflow handler
Message-ID: <tip-60f916dee612130c9977a8edd4abee98334202ba@git.kernel.org>
Git-Commit-ID: 60f916dee612130c9977a8edd4abee98334202ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 17:27:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60f916dee612130c9977a8edd4abee98334202ba
Gitweb:     http://git.kernel.org/tip/60f916dee612130c9977a8edd4abee98334202ba
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 15 Jun 2009 19:00:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 19:23:52 +0200

perf_counter: x86: Set the period in the intel overflow handler

Commit 9e350de37ac960 ("perf_counter: Accurate period data")
missed a spot, which caused all Intel-PMU samples to have a
period of 0.

This broke auto-freq sampling.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index e8c68a5..ce1ae3f 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1224,6 +1224,8 @@ again:
 		if (!intel_pmu_save_and_restart(counter))
 			continue;
 
+		data.period = counter->hw.last_period;
+
 		if (perf_counter_overflow(counter, 1, &data))
 			intel_pmu_disable_counter(&counter->hw, bit);
 	}
