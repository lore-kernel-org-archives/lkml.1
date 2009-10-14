Return-Path: <linux-kernel-owner+w=401wt.eu-S932683AbZJNNOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbZJNNOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760778AbZJNNOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:14:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:57443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760747AbZJNNOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:14:40 -0400
Date: Wed, 14 Oct 2009 13:13:09 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, lihong.hi@gmail.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       paulus@samba.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091014105039.GA22670@uhli>
References: <20091014105039.GA22670@uhli>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, perf_event: Rename 'performance counter interrupt'
Message-ID: <tip-89ccf465abe6b20d804a63ae20307970c441369d@git.kernel.org>
Git-Commit-ID: 89ccf465abe6b20d804a63ae20307970c441369d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 13:13:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89ccf465abe6b20d804a63ae20307970c441369d
Gitweb:     http://git.kernel.org/tip/89ccf465abe6b20d804a63ae20307970c441369d
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Wed, 14 Oct 2009 18:50:39 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 14:37:24 +0200

x86, perf_event: Rename 'performance counter interrupt'

In 'cdd6c482c9ff9c55475ee7392ec8f672eddb7be6', we renamed
Performance Counters -> Performance Events.

The name showed up in /proc/interrupts also needs a change. I use
PMI (Performance monitoring interrupt) here, since it is the
official name used in Intel's documents.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091014105039.GA22670@uhli>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3912061..86fb2c8 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -63,10 +63,10 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
 	seq_printf(p, "  Spurious interrupts\n");
-	seq_printf(p, "%*s: ", prec, "CNT");
+	seq_printf(p, "%*s: ", prec, "PMI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
-	seq_printf(p, "  Performance counter interrupts\n");
+	seq_printf(p, "  Performance monitoring interrupts\n");
 	seq_printf(p, "%*s: ", prec, "PND");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_pending_irqs);
