Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYKUKjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYKUKjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbYKUKjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:39:06 -0500
Received: from ozlabs.org ([203.10.76.45]:56274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYKUKjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:39:04 -0500
To: Hirokazu Takata <takata@linux-m32r.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:09:01 +1030
Subject: [PATCH 1/3] percpu: fix percpu accessors to potentially !cpu_possible() cpus: m32r
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811212109.01479.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: CPU iterator bugfixes

Percpu areas are only allocated for possible cpus.  In general, you
shouldn't access random cpu's percpu areas.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 arch/m32r/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- test-compile.orig/arch/m32r/kernel/smpboot.c
+++ test-compile/arch/m32r/kernel/smpboot.c
@@ -598,7 +598,7 @@ int setup_profiling_timer(unsigned int m
 	 * accounting. At that time they also adjust their APIC timers
 	 * accordingly.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;


