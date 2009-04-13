Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZDMU2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZDMU2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZDMU2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:28:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:55424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZDMU2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:28:37 -0400
Date: Mon, 13 Apr 2009 20:18:54 GMT
From: tip-bot for Luis Henriques <henrix@sapo.pt>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, henrix@sapo.pt, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, henrix@sapo.pt, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090413192449.GA3920@hades.domain.com>
References: <20090413192449.GA3920@hades.domain.com>
Subject: [tip:perfcounters/core] perf_counter: fix alignment in /proc/interrupts
Message-ID: <tip-0f3fd87ce43727d6b8573191ce89e874533b1429@git.kernel.org>
Git-Commit-ID: 0f3fd87ce43727d6b8573191ce89e874533b1429
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Apr 2009 20:18:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f3fd87ce43727d6b8573191ce89e874533b1429
Gitweb:     http://git.kernel.org/tip/0f3fd87ce43727d6b8573191ce89e874533b1429
Author:     Luis Henriques <henrix@sapo.pt>
AuthorDate: Mon, 13 Apr 2009 20:24:50 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Apr 2009 22:16:51 +0200

perf_counter: fix alignment in /proc/interrupts

Trivial fix on columns alignment in /proc/interrupts file.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090413192449.GA3920@hades.domain.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index dccaaa8..849cfab 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -67,7 +67,7 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance counter interrupts\n");
-	seq_printf(p, "PND: ");
+	seq_printf(p, "%*s: ", prec, "PND");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_pending_irqs);
 	seq_printf(p, "  Performance pending work\n");
