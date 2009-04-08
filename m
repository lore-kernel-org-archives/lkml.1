Return-Path: <linux-kernel-owner+w=401wt.eu-S934090AbZDHQMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbZDHQMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933836AbZDHQLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:11:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:55433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933886AbZDHQLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:11:01 -0400
Date: Wed, 8 Apr 2009 16:10:24 GMT
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
Subject: [tip:x86/urgent] x86: smarten /proc/interrupts output for new counters
Message-ID: <tip-59d138120d18930ba9a5466662d45a2bd2223455@git.kernel.org>
Git-Commit-ID: 59d138120d18930ba9a5466662d45a2bd2223455
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:10:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59d138120d18930ba9a5466662d45a2bd2223455
Gitweb:     http://git.kernel.org/tip/59d138120d18930ba9a5466662d45a2bd2223455
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 25 Mar 2009 10:50:34 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:06:07 +0200

x86: smarten /proc/interrupts output for new counters

Now /proc/interrupts of tip tree has new counters:

  PLT: Platform interrupts

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
index 3aaf7b9..c3fe010 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -65,7 +65,7 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "  Spurious interrupts\n");
 #endif
 	if (generic_interrupt_extension) {
-		seq_printf(p, "PLT: ");
+		seq_printf(p, "%*s: ", prec, "PLT");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", irq_stats(j)->generic_irqs);
 		seq_printf(p, "  Platform interrupts\n");
