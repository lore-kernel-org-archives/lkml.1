Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab0CLJzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:55:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:53801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab0CLJza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:55:30 -0500
Date: Fri, 12 Mar 2010 09:54:58 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100311184328.GA21433@sgi.com>
References: <20100311184328.GA21433@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, UV: Fix target_cpus() in x2apic_uv_x.c
Message-ID: <tip-8447b360a3897bdfb0677107564d1dd9ab6e63be@git.kernel.org>
Git-Commit-ID: 8447b360a3897bdfb0677107564d1dd9ab6e63be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Mar 2010 09:54:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8447b360a3897bdfb0677107564d1dd9ab6e63be
Gitweb:     http://git.kernel.org/tip/8447b360a3897bdfb0677107564d1dd9ab6e63be
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Thu, 11 Mar 2010 12:43:29 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Mar 2010 10:19:29 +0100

x86, UV: Fix target_cpus() in x2apic_uv_x.c

target_cpu() should initially target all cpus, not just cpu 0.
Otherwise systems with lots of disks can exhaust the interrupt
vectors on cpu 0 if a large number of disks are discovered
before the irq balancer is running.

Note: UV code only...

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100311184328.GA21433@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 21db3cb..af0ca80 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -114,11 +114,9 @@ EXPORT_SYMBOL_GPL(uv_possible_blades);
 unsigned long sn_rtc_cycles_per_second;
 EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
 static const struct cpumask *uv_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
