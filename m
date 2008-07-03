Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbYGCHJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbYGCHJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYGCG57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47146 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYGCEPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 00:15:55 -0400
Date: Thu, 3 Jul 2008 14:15:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Introduce new cpu_mask APIs
Message-Id: <20080703141550.de7f8f22.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In linux-next there is a commit ("x86: Add performance variants of cpumask
operators") which, as part of the 4096 cpu support work adds some new
APIs for dealing with cpu masks.  Add thrivial versions of these now
so that subsystems can update in a timely manner and avoid conflicts in
linux-next and the next merge window.

Cc: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/cpumask.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 5df3db5..c24875b 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -353,6 +353,10 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
 #endif /* NR_CPUS */
 
+#define next_cpu_nr(n, src)		next_cpu(n, src)
+#define cpus_weight_nr(cpumask)		cpus_weight(cpumask)
+#define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
+
 /*
  * The following particular system cpumasks and operations manage
  * possible, present and online cpus.  Each of them is a fixed size
-- 
1.5.6

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
