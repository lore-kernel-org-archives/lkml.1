Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbZHKMBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbZHKMBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZHKL7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:59:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:35438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbZHKL7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:59:31 -0400
Date: Tue, 11 Aug 2009 11:33:55 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter, x86: Fix lapic printk message
Message-ID: <tip-3c581a7f94542341bf0da496a226b44ac63521a8@git.kernel.org>
Git-Commit-ID: 3c581a7f94542341bf0da496a226b44ac63521a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 11 Aug 2009 11:33:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c581a7f94542341bf0da496a226b44ac63521a8
Gitweb:     http://git.kernel.org/tip/3c581a7f94542341bf0da496a226b44ac63521a8
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 11 Aug 2009 10:47:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 Aug 2009 10:58:25 +0200

perf_counter, x86: Fix lapic printk message

Instead of this garbled bootup on UP Pentium-M systems:

[    0.015048] Performance Counters:
[    0.016004] no Local APIC, try rebooting with lapicno PMU driver, software counters only.

Print:

[    0.015050] Performance Counters:
[    0.016004] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.017003] no PMU driver, software counters only.

Cf: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index a7aa8f9..40e233a 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1590,7 +1590,7 @@ static int p6_pmu_init(void)
 	}
 
 	if (!cpu_has_apic) {
-		pr_info("no Local APIC, try rebooting with lapic");
+		pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
 		return -ENODEV;
 	}
 
