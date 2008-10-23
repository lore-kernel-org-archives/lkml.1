Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYJWCKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYJWCKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbYJWCIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43362 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752738AbYJWCI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:27 -0400
Message-Id: <20081023020827.323462000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:31 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/35] cpumask: remove min from first_cpu/next_cpu From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:remove-min.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like this has been here forever, but I can't see why:
find_first_bit and find_next_bit both return >= NR_CPUS on failure.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 lib/cpumask.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.28.orig/lib/cpumask.c
+++ linux-2.6.28/lib/cpumask.c
@@ -5,13 +5,13 @@
 
 int __first_cpu(const cpumask_t *srcp)
 {
-	return min_t(int, NR_CPUS, find_first_bit(srcp->bits, NR_CPUS));
+	return find_first_bit(srcp->bits, NR_CPUS);
 }
 EXPORT_SYMBOL(__first_cpu);
 
 int __next_cpu(int n, const cpumask_t *srcp)
 {
-	return min_t(int, NR_CPUS, find_next_bit(srcp->bits, NR_CPUS, n+1));
+	return find_next_bit(srcp->bits, NR_CPUS, n+1);
 }
 EXPORT_SYMBOL(__next_cpu);
 
@@ -27,8 +27,7 @@ EXPORT_SYMBOL(cpumask_next_and);
 #if NR_CPUS > 64
 int __next_cpu_nr(int n, const cpumask_t *srcp)
 {
-	return min_t(int, nr_cpu_ids,
-				find_next_bit(srcp->bits, nr_cpu_ids, n+1));
+	return find_next_bit(srcp->bits, nr_cpu_ids, n+1);
 }
 EXPORT_SYMBOL(__next_cpu_nr);
 #endif

-- 
