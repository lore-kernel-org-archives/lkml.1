Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYBIKV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYBIKV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYBIKVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:21:17 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:2623 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYBIKVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:21:16 -0500
Subject: Re: m68knommu compile error
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Adrian Bunk <bunk@kernel.org>
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080208222516.GC6505@cs181133002.pp.htv.fi>
References: <20080208222516.GC6505@cs181133002.pp.htv.fi>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 09 Feb 2008 11:21:12 +0100
Message-Id: <1202552472.8936.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-09 at 00:25 +0200, Adrian Bunk wrote:
> Commit 2f569afd9ced9ebec9a6eb3dbf6f83429be0a7b4 breaks m68knommu:

Does the patch below fixes the problem? I tried to cross compile for
m68knommu but it seems like you need a special m68k compiler to get it
compile all the way through. With the patch it did fail with a different
error, so I assume it is fixed. The problem is that the pgtable_t is
simply missing for m68knommu, I must have overlooked a reject for one of
the constant regenerations of the patch to keep up with upstream. Sorry
about that.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

---
[m68knommu] Add pgtable_t.
    
Fix the compile error:
    
  CC      init/main.o
In file included from include2/asm/uaccess.h:8,
                 from include/linux/poll.h:13,
                 from include/linux/rtc.h:113,
                 from include/linux/efi.h:19,
                 from linux-2.6/init/main.c:43:
include/linux/mm.h:1151:
error: expected declaration specifiers or '...' before 'pgtable_t'
make[2]: *** [init/main.o] Error 1
    
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-m68knommu/page.h |    1 +
 1 file changed, 1 insertion(+)

diff -urpN linux-2.6/include/asm-m68knommu/page.h linux-2.6-patched/include/asm-m68knommu/page.h
--- linux-2.6/include/asm-m68knommu/page.h	2008-02-09 11:15:14.000000000 +0100
+++ linux-2.6-patched/include/asm-m68knommu/page.h	2008-02-09 11:15:21.000000000 +0100
@@ -31,6 +31,7 @@ typedef struct { unsigned long pte; } pt
 typedef struct { unsigned long pmd[16]; } pmd_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
+typedef struct page *pgtable_t;
 
 #define pte_val(x)	((x).pte)
 #define pmd_val(x)	((&x)->pmd[0])


