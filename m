Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYGMX5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYGMX5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 19:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYGMX5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 19:57:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:46124 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbYGMX5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 19:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xGGZu3mn2oDaBm1RZeoRgjWQieo7rUgk82vXyHHeTCyUKr2nqy5DEXOkPEMnc8tbob
         NVxuHVunFhvB9oa0yE9d224VnrX1N/yJ0VnukqSMKKKPVwdUVlTOkM3Tn8IYO8dZZQYG
         BBb4H9Opbwgo9lSZWK1jfObvHWxxhC6Osp3hE=
Message-ID: <48f7fe350807131657v4b95340ajfaaacbb04eefa21f@mail.gmail.com>
Date: Sun, 13 Jul 2008 19:57:37 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Performance Question: BUG_ON vs. WARN_ON_ONCE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was porting the -rt branch to the latest -mm kernel and encountered
a bug. The
replace-bugon-by-warn-on.patch patch make the following change:

diff --git a/18f7d025bb2e5762fd4063cce0b6e2342475c55c:arch/x86/mm/highmem_32.c
b/db090b52f9d2f9088a4ff9bce530e3c234c8e3af:arch/x86/mm/highmem_32.c
index 165c871ba9af0211e0c939e0bc2212750d4bf39f..402ecdd04d7818fd24e921c94b698faa19383b71
100644
--- a/18f7d025bb2e5762fd4063cce0b6e2342475c55c:arch/x86/mm/highmem_32.c
+++ b/db090b52f9d2f9088a4ff9bce530e3c234c8e3af:arch/x86/mm/highmem_32.c
@@ -84,7 +84,7 @@ void *kmap_atomic_prot(struct page *page, enum
km_type type, pgprot_t prot)

 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	BUG_ON(!pte_none(*(kmap_pte-idx)));
+	WARN_ON_ONCE(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
 	arch_flush_lazy_mmu_mode();

However, this causes the kernel to crash or oops under certain loads.
Reverting this change makes the error go away. Is there any sort of
performance difference between BUG_ON and WARN_ON_ONCE, I figure the
change was for a reason so I am wondering what will result from this
change. Any info would be appreciated.

-Ryan
