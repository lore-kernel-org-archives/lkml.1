Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYKUKly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYKUKly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYKUKlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:41:46 -0500
Received: from ozlabs.org ([203.10.76.45]:56352 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbYKUKlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:41:46 -0500
To: James Bottomley <James.Bottomley@hansenpartnership.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:11:42 +1030
Subject: [PATCH 3/3] percpu: fix percpu accessors to potentially !cpu_possible() cpus: x86 voyager
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811212111.43149.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: CPU iterator bugfixes

Percpu areas are only allocated for possible cpus.  In general, you
shouldn't access random cpu's percpu areas.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- test-compile.orig/arch/x86/mach-voyager/voyager_smp.c
+++ test-compile/arch/x86/mach-voyager/voyager_smp.c
@@ -1223,7 +1223,7 @@ int setup_profiling_timer(unsigned int m
 	 * new values until the next timer interrupt in which they do process
 	 * accounting.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;


