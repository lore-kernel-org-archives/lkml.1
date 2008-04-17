Return-Path: <linux-kernel-owner+w=401wt.eu-S933524AbYDQBVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524AbYDQBVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbYDQBIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:32 -0400
Received: from sous-sol.org ([216.99.217.87]:58933 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758820AbYDQBIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:30 -0400
Message-Id: <20080417010351.154726361@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: SPARC64: flush_ptrace_access() needs preemption disable.
Content-Disposition: inline; filename=sparc64-flush_ptrace_access-needs-preemption-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Upstream commit: f6a843d939ade435e060d580f5c56d958464f8a5

Based upon a report by Mariusz Kozlowski.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/sparc64/kernel/ptrace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/sparc64/kernel/ptrace.c
+++ b/arch/sparc64/kernel/ptrace.c
@@ -127,6 +127,8 @@ void flush_ptrace_access(struct vm_area_
 	if (tlb_type == hypervisor)
 		return;
 
+	preempt_disable();
+
 #ifdef DCACHE_ALIASING_POSSIBLE
 	/* If bit 13 of the kernel address we used to access the
 	 * user page is the same as the virtual address that page
@@ -165,6 +167,8 @@ void flush_ptrace_access(struct vm_area_
 		for (; start < end; start += icache_line_size)
 			flushi(start);
 	}
+
+	preempt_enable();
 }
 
 asmlinkage void do_ptrace(struct pt_regs *regs)

-- 
