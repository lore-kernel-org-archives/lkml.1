Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYJWCLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYJWCLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYJWCIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:37 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46598 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753558AbYJWCI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:28 -0400
Message-Id: <20081023020827.910700000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:34 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/35] cpumask: cpumask_size() From: Mike Travis <travis@sgi.com>
Content-Disposition: inline; filename=cpumask:cpumask_size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic allocation of cpumasks requires the size.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -64,6 +64,7 @@
  * int next_cpu(cpu, mask)		Next cpu past 'cpu', or NR_CPUS
  * int next_cpu_nr(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
  *
+ * size_t cpumask_size()		Length of cpumask in bytes.
  * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
  *					(can be used as an lvalue)
  * CPU_MASK_ALL				Initializer - all bits set
@@ -147,6 +148,8 @@ struct cpumask {
 };
 #define cpumask_bits(maskp) ((maskp)->bits)
 
+#define cpumask_size() (BITS_TO_LONGS(NR_CPUS) * sizeof(long))
+
 /* Deprecated. */
 typedef struct cpumask cpumask_t;
 extern cpumask_t _unused_cpumask_arg_;

-- 
