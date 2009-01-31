Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZAaOgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZAaOgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZAaOf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:35:59 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:54145 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZAaOf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=J9RO0zpvW07zEtjScEqbILZkbENDIs7ffJxa67Moob8GByBOThdItQnaMdEnh7D+k9
         9f5wGgg3hCNyWDUfK3Y8G+9/dITHgUgN2yVw7DvRgA8qW+Qo40/QV76tSrLIx3ERaptD
         SXJLW5cjuLJmfLwdonyHQrX2ep69xpJkaDcCw=
Message-ID: <498461C7.4050901@gmail.com>
Date: Sat, 31 Jan 2009 15:35:51 +0100
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: Re: [PATCH -mmotm] mm: unify some pmd_*() functions fix for m68k
 sun3
References: <1233266297-12995-1-git-send-email-righi.andrea@gmail.com> <Pine.LNX.4.64.0901301902140.23582@anakin>
In-Reply-To: <Pine.LNX.4.64.0901301902140.23582@anakin>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-30 19:02, Geert Uytterhoeven wrote:
> On Thu, 29 Jan 2009, Andrea Righi wrote:
>> sun3_defconfig fails with:
>>
>>     CC      mm/memory.o
>>   mm/memory.c: In function 'free_pmd_range':
>>   mm/memory.c:176: error: implicit declaration of function '__pmd_free_tlb'
>>   mm/memory.c: In function '__pmd_alloc':
>>   mm/memory.c:2903: error: implicit declaration of function 'pmd_alloc_one_bug'
>>   mm/memory.c:2903: warning: initialization makes pointer from integer without a cast
>>   mm/memory.c:2917: error: implicit declaration of function 'pmd_free'
>>   make[3]: *** [mm/memory.o] Error 1
>>
>> Add the missing include.
>>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
>> ---
>>  include/asm-m68k/sun3_pgalloc.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/asm-m68k/sun3_pgalloc.h b/include/asm-m68k/sun3_pgalloc.h
>> index 0fe28fc..399d280 100644
>> --- a/include/asm-m68k/sun3_pgalloc.h
>> +++ b/include/asm-m68k/sun3_pgalloc.h
>> @@ -11,6 +11,7 @@
>>  #define _SUN3_PGALLOC_H
>>  
>>  #include <asm/tlb.h>
>> +#include <asm-generic/pgtable-nopmd.h>
> 
> Which makes it worse:
> 
>   CC      arch/m68k/kernel/traps.o
> In file included from include/asm-generic/pgtable-nopmd.h:6,
>                  from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopud.h:17:1: warning: "PUD_SIZE" redefined
> In file included from arch/m68k/include/asm/pgtable_mm.h:4,
>                  from arch/m68k/include/asm/pgtable.h:4,
>                  from include/linux/mm.h:40,
>                  from arch/m68k/kernel/traps.c:24:
> include/asm-generic/4level-fixup.h:7:1: warning: this is the location of the previous definition
> In file included from include/asm-generic/pgtable-nopmd.h:6,
>                  from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopud.h:18:1: warning: "PUD_MASK" redefined
> In file included from arch/m68k/include/asm/pgtable_mm.h:4,
>                  from arch/m68k/include/asm/pgtable.h:4,
>                  from include/linux/mm.h:40,
>                  from arch/m68k/kernel/traps.c:24:
> include/asm-generic/4level-fixup.h:8:1: warning: this is the location of the previous definition
> In file included from include/asm-generic/pgtable-nopmd.h:6,
>                  from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopud.h:29:1: warning: "pud_ERROR" redefined
> In file included from arch/m68k/include/asm/pgtable_mm.h:4,
>                  from arch/m68k/include/asm/pgtable.h:4,
>                  from include/linux/mm.h:40,
>                  from arch/m68k/kernel/traps.c:24:
> include/asm-generic/4level-fixup.h:22:1: warning: this is the location of the previous definition
> In file included from include/asm-generic/pgtable-nopmd.h:6,
>                  from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopud.h:43:1: warning: "pud_val" redefined
> In file included from arch/m68k/include/asm/pgtable_mm.h:4,
>                  from arch/m68k/include/asm/pgtable.h:4,
>                  from include/linux/mm.h:40,
>                  from arch/m68k/kernel/traps.c:24:
> include/asm-generic/4level-fixup.h:24:1: warning: this is the location of the previous definition
> In file included from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopmd.h:20:1: warning: "PMD_SHIFT" redefined
> In file included from arch/m68k/include/asm/pgtable.h:4,
>                  from include/linux/mm.h:40,
>                  from arch/m68k/kernel/traps.c:24:
> arch/m68k/include/asm/pgtable_mm.h:33:1: warning: this is the location of the previous definition
> In file included from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopmd.h:34:1: warning: "pmd_ERROR" redefined
> In file included from arch/m68k/include/asm/pgtable_mm.h:132,
>                  from arch/m68k/include/asm/pgtable.h:4,
>                  from include/linux/mm.h:40,
>                  from arch/m68k/kernel/traps.c:24:
> arch/m68k/include/asm/sun3_pgtable.h:157:1: warning: this is the location of the previous definition
> In file included from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopmd.h:36:1: warning: "pud_populate" redefined
> In file included from arch/m68k/include/asm/pgtable_mm.h:4,
>                  from arch/m68k/include/asm/pgtable.h:4,
>                  from include/linux/mm.h:40,
>                  from arch/m68k/kernel/traps.c:24:
> include/asm-generic/4level-fixup.h:25:1: warning: this is the location of the previous definition
> In file included from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopmd.h:49:1: warning: "pmd_val" redefined
> In file included from arch/m68k/include/asm/page.h:4,
>                  from arch/m68k/include/asm/thread_info_mm.h:5,
>                  from arch/m68k/include/asm/thread_info.h:4,
>                  from include/linux/thread_info.h:55,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/seqlock.h:29,
>                  from include/linux/time.h:8,
>                  from include/linux/timex.h:56,
>                  from include/linux/sched.h:54,
>                  from arch/m68k/kernel/traps.c:21:
> arch/m68k/include/asm/page_mm.h:97:1: warning: this is the location of the previous definition
> In file included from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopmd.h:50:1: warning: "__pmd" redefined
> In file included from arch/m68k/include/asm/page.h:4,
>                  from arch/m68k/include/asm/thread_info_mm.h:5,
>                  from arch/m68k/include/asm/thread_info.h:4,
>                  from include/linux/thread_info.h:55,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/seqlock.h:29,
>                  from include/linux/time.h:8,
>                  from include/linux/timex.h:56,
>                  from include/linux/sched.h:54,
>                  from arch/m68k/kernel/traps.c:21:
> arch/m68k/include/asm/page_mm.h:102:1: warning: this is the location of the previous definition
> In file included from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopmd.h:52:1: warning: "pud_page" redefined
> In file included from arch/m68k/include/asm/pgtable_mm.h:4,
>                  from arch/m68k/include/asm/pgtable.h:4,
>                  from include/linux/mm.h:40,
>                  from arch/m68k/kernel/traps.c:24:
> include/asm-generic/4level-fixup.h:26:1: warning: this is the location of the previous definition
> In file included from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopmd.h:53:1: warning: "pud_page_vaddr" redefined
> In file included from arch/m68k/include/asm/pgtable_mm.h:4,
>                  from arch/m68k/include/asm/pgtable.h:4,
>                  from include/linux/mm.h:40,
>                  from arch/m68k/kernel/traps.c:24:
> include/asm-generic/4level-fixup.h:27:1: warning: this is the location of the previous definition
> In file included from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> arch/m68k/include/asm/sun3_pgalloc.h:22:1: warning: "pmd_alloc_one" redefined
> In file included from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopmd.h:65:1: warning: this is the location of the previous definition
> In file included from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> arch/m68k/include/asm/sun3_pgalloc.h:93:1: warning: "pgd_populate" redefined
> In file included from include/asm-generic/pgtable-nopmd.h:6,
>                  from arch/m68k/include/asm/sun3_pgalloc.h:14,
>                  from arch/m68k/include/asm/pgalloc_mm.h:12,
>                  from arch/m68k/include/asm/pgalloc.h:4,
>                  from arch/m68k/kernel/traps.c:38:
> include/asm-generic/pgtable-nopud.h:31:1: warning: this is the location of the previous definition
> In file included from include/asm-generic/pgtable-nopmd.h:7,
>                  from arch/m68k/include/asm/sun3_pgalloc.h:15,
>                  from arch/m68k/include/asm/pgalloc_mm.h:13,
>                  from arch/m68k/include/asm/pgalloc.h:5,
>                  from arch/m68k/kernel/traps.c:39:
> include/asm-generic/pgtable-nopud.h:13: error: conflicting types for 'pgd_t'
> arch/m68k/include/asm/page_mm.h:92: error: previous declaration of 'pgd_t' was here
> include/asm-generic/pgtable-nopud.h:25: error: conflicting types for 'pgd_none'
> arch/m68k/include/asm/sun3_pgtable.h:149: error: previous definition of 'pgd_none' was here
> include/asm-generic/pgtable-nopud.h:26: error: conflicting types for 'pgd_bad'
> arch/m68k/include/asm/sun3_pgtable.h:150: error: previous definition of 'pgd_bad' was here
> include/asm-generic/pgtable-nopud.h:27: error: conflicting types for 'pgd_present'
> arch/m68k/include/asm/sun3_pgtable.h:151: error: previous definition of 'pgd_present' was here
> include/asm-generic/pgtable-nopud.h:28: error: conflicting types for 'pgd_clear'
> arch/m68k/include/asm/sun3_pgtable.h:152: error: previous definition of 'pgd_clear' was here
> include/asm-generic/pgtable-nopud.h:38: error: expected ')' before '*' token
> In file included from arch/m68k/include/asm/sun3_pgalloc.h:15,
>                  from arch/m68k/include/asm/pgalloc_mm.h:13,
>                  from arch/m68k/include/asm/pgalloc.h:5,
>                  from arch/m68k/kernel/traps.c:39:
> include/asm-generic/pgtable-nopmd.h:18: error: conflicting types for 'pmd_t'
> arch/m68k/include/asm/page_mm.h:91: error: previous declaration of 'pmd_t' was here
> include/asm-generic/pgtable-nopmd.h:30: error: expected identifier or '(' before numeric constant
> include/asm-generic/pgtable-nopmd.h:31: error: expected identifier or '(' before numeric constant
> include/asm-generic/pgtable-nopmd.h:32: error: expected identifier or '(' before numeric constant
> include/asm-generic/pgtable-nopmd.h:33: error: redefinition of 'pgd_clear'
> include/asm-generic/pgtable-nopud.h:28: error: previous definition of 'pgd_clear' was here
> include/asm-generic/pgtable-nopmd.h:45: error: conflicting types for 'pmd_offset'
> arch/m68k/include/asm/sun3_pgtable.h:201: error: previous definition of 'pmd_offset' was here
> make[3]: *** [arch/m68k/kernel/traps.o] Error 1
> 
> Gr{oetje,eeting}s,
> 
> 						Geert

Another include hell... :( mmh.. what happens if we move the unified
pmd_* functions in a different file? something like the following.

Thanks for testing!
-Andrea

---
mm: unify some pmd_*() functions and move them in a distinct include

Use a distinct include file for unified pmd_* functions to resolve
potential include hell conditions.

Also fix a build error on m68k/sun3 architecture.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 arch/m68k/include/asm/sun3_pgalloc.h          |    2 +-
 include/asm-generic/pgtable-nopmd-functions.h |   48 +++++++++++++++++++++++++
 include/asm-generic/pgtable-nopmd.h           |   41 +--------------------
 3 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/arch/m68k/include/asm/sun3_pgalloc.h b/arch/m68k/include/asm/sun3_pgalloc.h
index 399d280..dc97411 100644
--- a/arch/m68k/include/asm/sun3_pgalloc.h
+++ b/arch/m68k/include/asm/sun3_pgalloc.h
@@ -10,8 +10,8 @@
 #ifndef _SUN3_PGALLOC_H
 #define _SUN3_PGALLOC_H
 
+#include <asm-generic/pgtable-nopmd-functions.h>
 #include <asm/tlb.h>
-#include <asm-generic/pgtable-nopmd.h>
 
 /* FIXME - when we get this compiling */
 /* erm, now that it's compiling, what do we do with it? */
diff --git a/include/asm-generic/pgtable-nopmd-functions.h b/include/asm-generic/pgtable-nopmd-functions.h
new file mode 100644
index 0000000..67338ae
--- /dev/null
+++ b/include/asm-generic/pgtable-nopmd-functions.h
@@ -0,0 +1,48 @@
+#ifndef _PGTABLE_NOPMD_FUNCTIONS_H
+#define _PGTABLE_NOPMD_FUNCTIONS_H
+
+#ifndef __ASSEMBLY__
+
+struct mm_struct;
+struct mmu_gather;
+
+/*
+ * allocating and freeing a pmd is trivial: the 1-entry pmd is
+ * inside the pud, so has no extra memory associated with it.
+ * (In the PAE case we free the pmds as part of the pgd.)
+ */
+#ifndef pmd_alloc_one
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	return NULL;
+}
+#define pmd_alloc_one pmd_alloc_one
+#endif
+static inline pmd_t *pmd_alloc_one_bug(struct mm_struct *mm, unsigned long addr)
+{
+	BUG();
+	return (pmd_t *)(2);
+}
+#ifndef pmd_free
+static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
+{
+}
+#define pmd_free pmd_free
+#endif
+#ifndef __pmd_free_tlb
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
+{
+}
+#define __pmd_free_tlb __pmd_free_tlb
+#endif
+#ifndef pmd_addr_end
+static inline unsigned long pmd_addr_end(unsigned long addr, unsigned long end)
+{
+	return end;
+}
+#define pmd_addr_end pmd_addr_end
+#endif
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _PGTABLE_NOPMD_H */
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index b132d69..dafeaf7 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -4,10 +4,9 @@
 #ifndef __ASSEMBLY__
 
 #include <asm-generic/pgtable-nopud.h>
+#include <asm-generic/pgtable-nopmd-functions.h>
 #include <asm/bug.h>
 
-struct mm_struct;
-
 #define __PAGETABLE_PMD_FOLDED
 
 /*
@@ -52,44 +51,6 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
 #define pud_page(pud)				(pmd_page((pmd_t){ pud }))
 #define pud_page_vaddr(pud)			(pmd_page_vaddr((pmd_t){ pud }))
 
-/*
- * allocating and freeing a pmd is trivial: the 1-entry pmd is
- * inside the pud, so has no extra memory associated with it.
- * (In the PAE case we free the pmds as part of the pgd.)
- */
-#ifndef pmd_alloc_one
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	return NULL;
-}
-#define pmd_alloc_one pmd_alloc_one
-#endif
-static inline pmd_t *pmd_alloc_one_bug(struct mm_struct *mm, unsigned long addr)
-{
-	BUG();
-	return (pmd_t *)(2);
-}
-#ifndef pmd_free
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-}
-#define pmd_free pmd_free
-#endif
-#ifndef __pmd_free_tlb
-struct mmu_gather;
-static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
-{
-}
-#define __pmd_free_tlb __pmd_free_tlb
-#endif
-#ifndef pmd_addr_end
-static inline unsigned long pmd_addr_end(unsigned long addr, unsigned long end)
-{
-	return end;
-}
-#define pmd_addr_end pmd_addr_end
-#endif
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _PGTABLE_NOPMD_H */

