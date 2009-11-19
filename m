Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZKSJBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZKSJBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbZKSJBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:01:33 -0500
Received: from ozlabs.org ([203.10.76.45]:46639 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180AbZKSJBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:01:32 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911191931.36749.rusty@rustcorp.com.au>
Date: Thu, 19 Nov 2009 19:31:36 +1030
Subject: [PATCH 6/6] cpumask: reduce cpumask_size
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now we're sure noone is using old cpumask operators, nor *cpumask, we can
allocate less bits safely.  This reduces the memory usage of off-stack
cpumasks when CONFIG_CPUMASK_OFFSTACK=y but we don't have NR_CPUS actual
cpus.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/cpumask.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -1014,13 +1014,11 @@ static inline int cpulist_parse(const ch
 /**
  * cpumask_size - size to allocate for a 'struct cpumask' in bytes
  *
- * This will eventually be a runtime variable, depending on nr_cpu_ids.
+ * This can be a runtime variable, depending on nr_cpu_ids.
  */
 static inline size_t cpumask_size(void)
 {
-	/* FIXME: Once all cpumask assignments are eliminated, this
-	 * can be nr_cpumask_bits */
-	return BITS_TO_LONGS(NR_CPUS) * sizeof(long);
+	return BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long);
 }
 
 /*

