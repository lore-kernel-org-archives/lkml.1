Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYBIK6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYBIK6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYBIK6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:58:45 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:3253 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYBIK6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:58:44 -0500
Subject: Re: m68knommu compile error
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Adrian Bunk <bunk@kernel.org>
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1202552472.8936.7.camel@localhost>
References: <20080208222516.GC6505@cs181133002.pp.htv.fi>
	 <1202552472.8936.7.camel@localhost>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 09 Feb 2008 11:58:35 +0100
Message-Id: <1202554715.8936.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-09 at 11:21 +0100, Martin Schwidefsky wrote:
> On Sat, 2008-02-09 at 00:25 +0200, Adrian Bunk wrote:
> > Commit 2f569afd9ced9ebec9a6eb3dbf6f83429be0a7b4 breaks m68knommu:
> 
> Does the patch below fixes the problem? I tried to cross compile for
> m68knommu but it seems like you need a special m68k compiler to get it
> compile all the way through. With the patch it did fail with a different
> error, so I assume it is fixed. The problem is that the pgtable_t is
> simply missing for m68knommu, I must have overlooked a reject for one of
> the constant regenerations of the patch to keep up with upstream. Sorry
> about that.

This is a problem for all nommu architectures. The patch fixed all four
of them.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

---
[PATCH] Add pgtable_t to nommu architectures.
    
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
    
The pte_fn_t in include/linux/mm.h make it necessary for all
architecture to define a pgtable_t type, even those that do
not have an mmu.
    
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-blackfin/page.h  |    1 +
 include/asm-h8300/page.h     |    1 +
 include/asm-m68knommu/page.h |    1 +
 include/asm-v850/page.h      |    1 +
 4 files changed, 4 insertions(+)

diff -urpN linux-2.6/include/asm-blackfin/page.h linux-2.6-patched/include/asm-blackfin/page.h
--- linux-2.6/include/asm-blackfin/page.h	2008-02-09 11:46:28.000000000 +0100
+++ linux-2.6-patched/include/asm-blackfin/page.h	2008-02-09 11:46:36.000000000 +0100
@@ -39,6 +39,7 @@ typedef struct {
 typedef struct {
 	unsigned long pgprot;
 } pgprot_t;
+typedef struct page *pgtable_t;
 
 #define pte_val(x)	((x).pte)
 #define pmd_val(x)	((&x)->pmd[0])
diff -urpN linux-2.6/include/asm-h8300/page.h linux-2.6-patched/include/asm-h8300/page.h
--- linux-2.6/include/asm-h8300/page.h	2008-02-09 11:46:28.000000000 +0100
+++ linux-2.6-patched/include/asm-h8300/page.h	2008-02-09 11:46:36.000000000 +0100
@@ -31,6 +31,7 @@ typedef struct { unsigned long pte; } pt
 typedef struct { unsigned long pmd[16]; } pmd_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
 
 #define pte_val(x)	((x).pte)
 #define pmd_val(x)	((&x)->pmd[0])
diff -urpN linux-2.6/include/asm-m68knommu/page.h linux-2.6-patched/include/asm-m68knommu/page.h
--- linux-2.6/include/asm-m68knommu/page.h	2008-02-09 11:46:28.000000000 +0100
+++ linux-2.6-patched/include/asm-m68knommu/page.h	2008-02-09 11:46:36.000000000 +0100
@@ -31,6 +31,7 @@ typedef struct { unsigned long pte; } pt
 typedef struct { unsigned long pmd[16]; } pmd_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
 
 #define pte_val(x)	((x).pte)
 #define pmd_val(x)	((&x)->pmd[0])
diff -urpN linux-2.6/include/asm-v850/page.h linux-2.6-patched/include/asm-v850/page.h
--- linux-2.6/include/asm-v850/page.h	2008-02-09 11:46:29.000000000 +0100
+++ linux-2.6-patched/include/asm-v850/page.h	2008-02-09 11:46:36.000000000 +0100
@@ -57,6 +57,7 @@ typedef struct { unsigned long pte; } pt
 typedef struct { unsigned long pmd; } pmd_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
 
 #define pte_val(x)      ((x).pte)
 #define pmd_val(x)      ((x).pmd)


