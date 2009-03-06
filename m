Return-Path: <linux-kernel-owner+w=401wt.eu-S1751522AbZCFJf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbZCFJf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZCFJfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:35:48 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:42098 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZCFJfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:35:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18864.61033.280502.291018@cargo.ozlabs.ibm.com>
Date: Fri, 6 Mar 2009 20:35:37 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] perfcounters/powerpc: fix oops with multiple counters in a group
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix oops-causing bug

This fixes a bug in the powerpc hw_perf_counter_init where the code
didn't initialize ctrs[n] before passing the ctrs array to check_excludes,
leading to possible oopses and other incorrect behaviour.  This fixes it
by initializing ctrs[n] correctly.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Ingo, please pull this series of 3 patches from my perfcounters.git
master branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 arch/powerpc/kernel/perf_counter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 112332d..4fec112 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -633,6 +633,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 			return NULL;
 	}
 	events[n] = ev;
+	ctrs[n] = counter;
 	if (check_excludes(ctrs, n, 1))
 		return NULL;
 	if (power_check_constraints(events, n + 1))
-- 
1.5.6.3

