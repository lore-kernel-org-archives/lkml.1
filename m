Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYGPQqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYGPQqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbYGPQpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:45:52 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56418 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969AbYGPQpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:45:52 -0400
Date: Wed, 16 Jul 2008 19:45:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>, lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix sh ptep_get_and_clear breakage
Message-ID: <20080716164540.GF17329@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1ea0704e0da65b2b46f9142ff1391163aac24060
(mm: add a ptep_modify_prot transaction abstraction)
triggered on sh build errors like the following:

<--  snip  -->

...
  CC      arch/sh/mm/pg-sh4.o
cc1: warnings being treated as errors
include2/asm/pgtable.h:139: error: 'ptep_get_and_clear' declared inline after being called
include2/asm/pgtable.h:139: error: previous declaration of 'ptep_get_and_clear' was here
make[2]: *** [arch/sh/mm/pg-sh4.o] Error 1

<--  snip  -->

Since there's no good reason for marking these global functions as 
"inline" this patch therefore removes the inline's.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sh/mm/pg-sh4.c    |    2 +-
 arch/sh/mm/pg-sh7705.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

c11efb5cb7b6455f6478b3f300c96b7a6778450c 
diff --git a/arch/sh/mm/pg-sh4.c b/arch/sh/mm/pg-sh4.c
index 8c7a9ca..38870e0 100644
--- a/arch/sh/mm/pg-sh4.c
+++ b/arch/sh/mm/pg-sh4.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL(copy_user_highpage);
 /*
  * For SH-4, we have our own implementation for ptep_get_and_clear
  */
-inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
 
diff --git a/arch/sh/mm/pg-sh7705.c b/arch/sh/mm/pg-sh7705.c
index 7f885b7..eaf2514 100644
--- a/arch/sh/mm/pg-sh7705.c
+++ b/arch/sh/mm/pg-sh7705.c
@@ -118,7 +118,7 @@ void copy_user_page(void *to, void *from, unsigned long address, struct page *pg
  * For SH7705, we have our own implementation for ptep_get_and_clear
  * Copied from pg-sh4.c
  */
-inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
 
