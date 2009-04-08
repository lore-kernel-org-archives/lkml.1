Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbZDHQMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbZDHQMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933744AbZDHQK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:10:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:55429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933401AbZDHQKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:10:54 -0400
Date: Wed, 8 Apr 2009 16:10:13 GMT
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, jbeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49C98DEA.8060208@jp.fujitsu.com>
References: <49C98DEA.8060208@jp.fujitsu.com>
Subject: [tip:perfcounters/core] x86: smarten /proc/interrupts output for new counters
Message-ID: <tip-7333a8003cdc0470e8c0ae8b949cbc44f3165ff3@git.kernel.org>
Git-Commit-ID: 7333a8003cdc0470e8c0ae8b949cbc44f3165ff3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:10:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7333a8003cdc0470e8c0ae8b949cbc44f3165ff3
Gitweb:     http://git.kernel.org/tip/7333a8003cdc0470e8c0ae8b949cbc44f3165ff3
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 25 Mar 2009 10:50:34 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:04:32 +0200

x86: smarten /proc/interrupts output for new counters

Now /proc/interrupts of tip tree has new counters:

  CNT: Performance counter interrupts

Format change of output, as like that by commit:

  commit 7a81d9a7da03d2f27840d659f97ef140d032f609
  x86: smarten /proc/interrupts output

should be applied to these new counters too.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49C98DEA.8060208@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d465487..dccaaa8 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -63,7 +63,7 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
 	seq_printf(p, "  Spurious interrupts\n");
-	seq_printf(p, "CNT: ");
+	seq_printf(p, "%*s: ", prec, "CNT");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance counter interrupts\n");
