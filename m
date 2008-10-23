Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYJWCL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYJWCL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbYJWCIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:37 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753744AbYJWCI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:28 -0400
Message-Id: <20081023020828.097703000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:35 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/35] cpumask: add cpumask_copy()
Content-Disposition: inline; filename=cpumask:cpus_copy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since cpumasks are to become pointers to undefined structs, we need to
replace assignments.  Also, dynamically allocated ones will eventually
be nr_cpu_ids bits (<= NR_CPUS), so assignment is a definite no-no.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/cpumask.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -64,6 +64,8 @@
  * int next_cpu(cpu, mask)		Next cpu past 'cpu', or NR_CPUS
  * int next_cpu_nr(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
  *
+ * void cpumask_copy(dmask, smask)	dmask = smask
+ *
  * size_t cpumask_size()		Length of cpumask in bytes.
  * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
  *					(can be used as an lvalue)
@@ -350,6 +352,12 @@ static inline void cpumask_fold(struct c
 	bitmap_fold(dstp->bits, origp->bits, sz, NR_CPUS);
 }
 
+static inline void cpumask_copy(struct cpumask *dstp,
+				const struct cpumask *srcp)
+{
+	bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), NR_CPUS);
+}
+
 /*
  * Special-case data structure for "single bit set only" constant CPU masks.
  *

-- 
