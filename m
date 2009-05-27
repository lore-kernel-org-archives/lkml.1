Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbZE0UMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbZE0UMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbZE0UMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:12:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbZE0UM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:12:29 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200905271012.668777061@firstfloor.org>
In-Reply-To: <200905271012.668777061@firstfloor.org>
To: fengguang.wu@intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: [PATCH] [2/16] HWPOISON: Export poison flag in /proc/kpageflags
Message-Id: <20090527201227.EAEC41D0286@basil.firstfloor.org>
Date: Wed, 27 May 2009 22:12:27 +0200 (CEST)
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
--- linux.orig/fs/proc/page.c	2009-05-27 21:13:54.000000000 +0200
+++ linux/fs/proc/page.c	2009-05-27 21:14:21.000000000 +0200
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
