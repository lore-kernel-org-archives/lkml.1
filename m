Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbYDQBVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbYDQBVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbYDQBI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:27 -0400
Received: from sous-sol.org ([216.99.217.87]:58928 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbYDQBI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:26 -0400
Message-Id: <20080417010350.654976705@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:06 -0700
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
Subject: SPARC64: Fix __get_cpu_var in preemption-enabled area.
Content-Disposition: inline; filename=sparc64-fix-__get_cpu_var-in-preemption-enabled-area.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Upstream commit: 69072f6e8e4bd4799d2a54e4ff8771d0657512c1

Reported by Mariusz Kozlowski.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/sparc64/mm/tlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/sparc64/mm/tlb.c
+++ b/arch/sparc64/mm/tlb.c
@@ -23,10 +23,11 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 
 void flush_tlb_pending(void)
 {
-	struct mmu_gather *mp = &__get_cpu_var(mmu_gathers);
+	struct mmu_gather *mp;
 
 	preempt_disable();
 
+	mp = &__get_cpu_var(mmu_gathers);
 	if (mp->tlb_nr) {
 		flush_tsb_user(mp);
 

-- 
