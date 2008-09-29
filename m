Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYI2SEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYI2SEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYI2SC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:02:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36437 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753949AbYI2SCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:51 -0400
Message-Id: <20080929180250.562940000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:02:53 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 03/31] cpumask: remove min from first_cpu/next_cpu
Content-Disposition: inline; filename=remove-min
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

--- masklongs.orig/lib/cpumask.c
+++ masklongs/lib/cpumask.c
@@ -5,21 +5,20 @@
 
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
