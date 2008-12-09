Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbYLICCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbYLICCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 21:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYLICCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 21:02:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:22891 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYLICCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 21:02:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=RtkFtER/bjXLNoTzBW/NTAps1Wx9J46ml/fbYCjs1Sipx7BFn2i+MiPYBeuWH4CyrE
         5v10v8mixrVEX+o6ZEXzp4cgMsyfaTd/wq/Wqcloe2xOmGzN8gSUXo6rcggFinlODxJt
         tpN8eY3XZuVVQnBsrKuASJpeTpAg5L2QDou9c=
Date: Tue, 9 Dec 2008 05:02:27 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memory: use uninitialized_var() macro for suppressing
	gcc warnings
Message-ID: <20081209020227.GA23948@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uninitialized_var() macro was introduced in 94909914
(Add unitialized_var() macro for suppressing gcc warnings)

mm/memory.c:1485: warning: 'ptl' may be used uninitialized in this function
mm/memory.c:561: warning: 'dst_ptl' may be used uninitialized in this function

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 mm/memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index fc031d6..5610a45 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -558,7 +558,7 @@ static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		unsigned long addr, unsigned long end)
 {
 	pte_t *src_pte, *dst_pte;
-	spinlock_t *src_ptl, *dst_ptl;
+	spinlock_t *src_ptl, *uninitialized_var(dst_ptl);
 	int progress = 0;
 	int rss[2];
 
@@ -1482,7 +1482,7 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
 			unsigned long pfn, pgprot_t prot)
 {
 	pte_t *pte;
-	spinlock_t *ptl;
+	spinlock_t *uninitialized_var(ptl);
 
 	pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
 	if (!pte)
