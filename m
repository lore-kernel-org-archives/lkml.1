Return-Path: <linux-kernel-owner+w=401wt.eu-S1765562AbZDHOD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765562AbZDHOD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZDHODL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:03:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44795 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758AbZDHODI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:03:08 -0400
X-Sasl-enc: fiuGzCcofLlFOinNvgEasXgCcc0v4JnIsDZO6fnv18so 1239199386
Message-ID: <49DCAE97.8040602@fastmail.fm>
Date: Wed, 08 Apr 2009 15:03:03 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com>
In-Reply-To: <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed patch

Thanks,

Jack

--

x86: Remove void casts

From: Jack Stone <jwjstone@fastmail.fm>

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---

 arch/x86/kernel/machine_kexec_64.c |    8 ++++----
 arch/x86/kernel/microcode_amd.c    |    2 +-
 arch/x86/mm/init_32.c              |    4 ++--
 arch/x86/mm/init_64.c              |   10 +++++-----
 arch/x86/mm/pageattr.c             |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c
b/arch/x86/kernel/machine_kexec_64.c
index 89cea4d..1c5b3c9 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -33,7 +33,7 @@ static int init_one_level2_page(struct kimage *image,
pgd_t *pgd,
         page = kimage_alloc_control_pages(image, 0);
         if (!page)
             goto out;
-        pud = (pud_t *)page_address(page);
+        pud = page_address(page);
         memset(pud, 0, PAGE_SIZE);
         set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
     }
@@ -42,7 +42,7 @@ static int init_one_level2_page(struct kimage *image,
pgd_t *pgd,
         page = kimage_alloc_control_pages(image, 0);
         if (!page)
             goto out;
-        pmd = (pmd_t *)page_address(page);
+        pmd = page_address(page);
         memset(pmd, 0, PAGE_SIZE);
         set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
     }
@@ -84,7 +84,7 @@ static int init_level3_page(struct kimage *image,
pud_t *level3p,
             result = -ENOMEM;
             goto out;
         }
-        level2p = (pmd_t *)page_address(page);
+        level2p = page_address(page);
         init_level2_page(level2p, addr);
         set_pud(level3p++, __pud(__pa(level2p) | _KERNPG_TABLE));
         addr += PUD_SIZE;
@@ -117,7 +117,7 @@ static int init_level4_page(struct kimage *image,
pgd_t *level4p,
             result = -ENOMEM;
             goto out;
         }
-        level3p = (pud_t *)page_address(page);
+        level3p = page_address(page);
         result = init_level3_page(image, level3p, addr, last_addr);
         if (result)
             goto out;
diff --git a/arch/x86/kernel/microcode_amd.c
b/arch/x86/kernel/microcode_amd.c
index 453b579..8624d69 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -239,7 +239,7 @@ static int install_equiv_cpu_table(const u8 *buf)
         return 0;
     }
 
-    equiv_cpu_table = (struct equiv_cpu_entry *) vmalloc(size);
+    equiv_cpu_table = vmalloc(size);
     if (!equiv_cpu_table) {
         printk(KERN_ERR "microcode: failed to allocate "
                "equivalent CPU table\n");
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 749559e..64f1a30 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -89,7 +89,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
         if (after_bootmem)
             pmd_table = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
         else
-            pmd_table = (pmd_t *)alloc_low_page();
+            pmd_table = alloc_low_page();
         paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
         set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
         pud = pud_offset(pgd, 0);
@@ -121,7 +121,7 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
                 page_table =
                 (pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
         } else
-            page_table = (pte_t *)alloc_low_page();
+            page_table = alloc_low_page();
 
         paravirt_alloc_pte(&init_mm, __pa(page_table) >> PAGE_SHIFT);
         set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1753e80..bd08334 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -164,7 +164,7 @@ static __ref void *spp_getpage(void)
 static pud_t *fill_pud(pgd_t *pgd, unsigned long vaddr)
 {
     if (pgd_none(*pgd)) {
-        pud_t *pud = (pud_t *)spp_getpage();
+        pud_t *pud = spp_getpage();
         pgd_populate(&init_mm, pgd, pud);
         if (pud != pud_offset(pgd, 0))
             printk(KERN_ERR "PAGETABLE BUG #00! %p <-> %p\n",
@@ -176,7 +176,7 @@ static pud_t *fill_pud(pgd_t *pgd, unsigned long vaddr)
 static pmd_t *fill_pmd(pud_t *pud, unsigned long vaddr)
 {
     if (pud_none(*pud)) {
-        pmd_t *pmd = (pmd_t *) spp_getpage();
+        pmd_t *pmd = spp_getpage();
         pud_populate(&init_mm, pud, pmd);
         if (pmd != pmd_offset(pud, 0))
             printk(KERN_ERR "PAGETABLE BUG #01! %p <-> %p\n",
@@ -188,7 +188,7 @@ static pmd_t *fill_pmd(pud_t *pud, unsigned long vaddr)
 static pte_t *fill_pte(pmd_t *pmd, unsigned long vaddr)
 {
     if (pmd_none(*pmd)) {
-        pte_t *pte = (pte_t *) spp_getpage();
+        pte_t *pte = spp_getpage();
         pmd_populate_kernel(&init_mm, pmd, pte);
         if (pte != pte_offset_kernel(pmd, 0))
             printk(KERN_ERR "PAGETABLE BUG #02!\n");
@@ -264,13 +264,13 @@ static void __init __init_extra_mapping(unsigned
long phys, unsigned long size,
     for (; size; phys += PMD_SIZE, size -= PMD_SIZE) {
         pgd = pgd_offset_k((unsigned long)__va(phys));
         if (pgd_none(*pgd)) {
-            pud = (pud_t *) spp_getpage();
+            pud = spp_getpage();
             set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE |
                         _PAGE_USER));
         }
         pud = pud_offset(pgd, (unsigned long)__va(phys));
         if (pud_none(*pud)) {
-            pmd = (pmd_t *) spp_getpage();
+            pmd = spp_getpage();
             set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE |
                         _PAGE_USER));
         }
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d71e1b6..41ee1db 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -490,7 +490,7 @@ static int split_large_page(pte_t *kpte, unsigned
long address)
     if (tmp != kpte)
         goto out_unlock;
 
-    pbase = (pte_t *)page_address(base);
+    pbase = page_address(base);
     paravirt_alloc_pte(&init_mm, page_to_pfn(base));
     ref_prot = pte_pgprot(pte_clrhuge(*kpte));
     /*
