Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbZE2Vgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbZE2Vgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZE2Vfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:35:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60562 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZE2Vfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:35:40 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200905291135.124267638@firstfloor.org>
In-Reply-To: <200905291135.124267638@firstfloor.org>
To: fengguang.wu@intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: [PATCH] [2/16] HWPOISON: Export poison flag in /proc/kpageflags
Message-Id: <20090529213527.79A6E1D0290@basil.firstfloor.org>
Date: Fri, 29 May 2009 23:35:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Fengguang Wu <fengguang.wu@intel.com>

Export the new poison flag in /proc/kpageflags. Poisoned pages are moderately
interesting even for administrators, so export them here. Also useful
for debugging.

AK: I extracted this out of a larger patch from Fengguang Wu.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/proc/page.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/fs/proc/page.c
===================================================================
--- linux.orig/fs/proc/page.c	2009-05-29 23:32:10.000000000 +0200
+++ linux/fs/proc/page.c	2009-05-29 23:32:10.000000000 +0200
@@ -79,6 +79,7 @@
 #define KPF_WRITEBACK  8
 #define KPF_RECLAIM    9
 #define KPF_BUDDY     10
+#define KPF_HWPOISON  11
 
 #define kpf_copy_bit(flags, dstpos, srcpos) (((flags >> srcpos) & 1) << dstpos)
 
@@ -118,6 +119,9 @@
 			kpf_copy_bit(kflags, KPF_WRITEBACK, PG_writeback) |
 			kpf_copy_bit(kflags, KPF_RECLAIM, PG_reclaim) |
 			kpf_copy_bit(kflags, KPF_BUDDY, PG_buddy);
+#ifdef CONFIG_MEMORY_FAILURE
+		uflags |= kpf_copy_bit(kflags, KPF_HWPOISON, PG_hwpoison);
+#endif
 
 		if (put_user(uflags, out++)) {
 			ret = -EFAULT;
