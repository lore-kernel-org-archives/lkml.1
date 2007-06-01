Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbXFAU4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbXFAU4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764100AbXFAUzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:55:55 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:46912 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763791AbXFAUzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:55:54 -0400
Date: Fri, 1 Jun 2007 21:55:51 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix problem with IA64 make allnoconfig
Message-ID: <20070601205551.GA31325@skynet.ie>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070601164204.GA25049@skynet.ie> <20070601100004.1e72654d.akpm@linux-foundation.org> <20070601185013.GA13126@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070601185013.GA13126@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IA64 fails to build with allnoconfig due to an error in the !CONFIG_SMP
case. Ths following patch fixes it and should be considered a fix to
rework-ptep_set_access_flags-and-fix-sun4c.patch.

allmodconfig and defconfig tests are still running.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.22-rc3-mm1-clean/include/asm-ia64/pgtable.h linux-2.6.22-rc3-mm1-ia64fix/include/asm-ia64/pgtable.h
--- linux-2.6.22-rc3-mm1-clean/include/asm-ia64/pgtable.h	2007-06-01 09:24:39.000000000 +0100
+++ linux-2.6.22-rc3-mm1-ia64fix/include/asm-ia64/pgtable.h	2007-06-01 19:44:48.000000000 +0100
@@ -546,8 +546,8 @@ extern void lazy_mmu_prot_update (pte_t 
 # define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
 ({										\
 	int __changed = !pte_same(*(__ptep), __entry);				\
-	if (__changed) {							\
-		ptep_establish(__vma, __addr, __ptep, __entry)			\
+	if (__changed)							\
+		ptep_establish(__vma, __addr, __ptep, __entry);			\
 	__changed;								\
 })
 #endif
