Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYLAIRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYLAIRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYLAIRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:17:23 -0500
Received: from ozlabs.org ([203.10.76.45]:58548 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYLAIRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:17:22 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 18:47:19 +1030
Subject: [PATCH 3/6] cpumask: Use for_each_cpu() in cpumask.h
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011847.19665.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Cleanup, use new API

Convert for_each_possible/online/present_cpu to use for_each_cpu()
not the deprecated for_each_cpu_mask_nr().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpumask.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.orig/include/linux/cpumask.h
+++ linux-2.6/include/linux/cpumask.h
@@ -496,10 +496,6 @@ extern cpumask_t cpu_active_map;
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
-#define for_each_possible_cpu(cpu) for_each_cpu_mask_nr((cpu), 
cpu_possible_map)
-#define for_each_online_cpu(cpu)   for_each_cpu_mask_nr((cpu), 
cpu_online_map)
-#define for_each_present_cpu(cpu)  for_each_cpu_mask_nr((cpu), 
cpu_present_map)
-
 /* These are the new versions of the cpumask operators: passed by pointer.
  * The older versions will be implemented in terms of these, then deleted. */
 #define cpumask_bits(maskp) ((maskp)->bits)
@@ -1053,6 +1049,10 @@ extern const DECLARE_BITMAP(cpu_all_bits
 /* First bits of cpu_bit_bitmap are in fact unset. */
 #define cpu_none_mask to_cpumask(cpu_bit_bitmap[0])
 
+#define for_each_possible_cpu(cpu) for_each_cpu((cpu), cpu_possible_mask)
+#define for_each_online_cpu(cpu)   for_each_cpu((cpu), cpu_online_mask)
+#define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_mask)
+
 /* Wrappers for arch boot code to manipulate normally-constant masks */
 static inline void set_cpu_possible(unsigned int cpu, bool possible)
 {


