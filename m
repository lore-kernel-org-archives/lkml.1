Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZCJC5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZCJC5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZCJC5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:57:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:42835 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbZCJC5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:57:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,333,1233561600"; 
   d="asc'?scan'208";a="496442383"
Subject: [PATCH -v2 1/3] kexec x86_64: Fix kexec x86 coding style
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jPalLdk7cx4gJEUZXQCo"
Date: Tue, 10 Mar 2009 10:56:57 +0800
Message-Id: <1236653817.24215.131.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jPalLdk7cx4gJEUZXQCo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Fix some coding style issue for kexec x86.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/machine_kexec_32.c   |   17 ++++++++++-------
 arch/x86/kernel/machine_kexec_64.c   |   15 ++++++++-------
 arch/x86/kernel/relocate_kernel_32.S |   24 ++++++++++++++++--------
 arch/x86/kernel/relocate_kernel_64.S |   24 ++++++++++++++++--------
 4 files changed, 50 insertions(+), 30 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -14,12 +14,12 @@
 #include <linux/ftrace.h>
 #include <linux/suspend.h>
 #include <linux/gfp.h>
+#include <linux/io.h>
=20
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
-#include <asm/io.h>
 #include <asm/apic.h>
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
@@ -63,7 +63,7 @@ static void load_segments(void)
 		"\tmovl %%eax,%%fs\n"
 		"\tmovl %%eax,%%gs\n"
 		"\tmovl %%eax,%%ss\n"
-		::: "eax", "memory");
+		: : : "eax", "memory");
 #undef STR
 #undef __STR
 }
@@ -205,7 +205,8 @@ void machine_kexec(struct kimage *image)
=20
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC
-		/* We need to put APICs in legacy mode so that we can
+		/*
+		 * We need to put APICs in legacy mode so that we can
 		 * get timer interrupts in second kernel. kexec/kdump
 		 * paths already have calls to disable_IO_APIC() in
 		 * one form or other. kexec jump path also need
@@ -227,7 +228,8 @@ void machine_kexec(struct kimage *image)
 		page_list[PA_SWAP_PAGE] =3D (page_to_pfn(image->swap_page)
 						<< PAGE_SHIFT);
=20
-	/* The segment registers are funny things, they have both a
+	/*
+	 * The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
 	 * set to a specific selector, the invisible part is loaded
 	 * with from a table in memory.  At no other time is the
@@ -237,11 +239,12 @@ void machine_kexec(struct kimage *image)
 	 * segments, before I zap the gdt with an invalid value.
 	 */
 	load_segments();
-	/* The gdt & idt are now invalid.
+	/*
+	 * The gdt & idt are now invalid.
 	 * If you want to load them you must set up your own idt & gdt.
 	 */
-	set_gdt(phys_to_virt(0),0);
-	set_idt(phys_to_virt(0),0);
+	set_gdt(phys_to_virt(0), 0);
+	set_idt(phys_to_virt(0), 0);
=20
 	/* now call it */
 	image->start =3D relocate_kernel_ptr((unsigned long)image->head,
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -12,11 +12,11 @@
 #include <linux/reboot.h>
 #include <linux/numa.h>
 #include <linux/ftrace.h>
+#include <linux/io.h>
=20
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
-#include <asm/io.h>
=20
 static void init_level2_page(pmd_t *level2p, unsigned long addr)
 {
@@ -83,9 +83,8 @@ static int init_level4_page(struct kimag
 		}
 		level3p =3D (pud_t *)page_address(page);
 		result =3D init_level3_page(image, level3p, addr, last_addr);
-		if (result) {
+		if (result)
 			goto out;
-		}
 		set_pgd(level4p++, __pgd(__pa(level3p) | _KERNPG_TABLE));
 		addr +=3D PGDIR_SIZE;
 	}
@@ -242,7 +241,8 @@ void machine_kexec(struct kimage *image)
 	page_list[PA_TABLE_PAGE] =3D
 	  (unsigned long)__pa(page_address(image->control_code_page));
=20
-	/* The segment registers are funny things, they have both a
+	/*
+	 * The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
 	 * set to a specific selector, the invisible part is loaded
 	 * with from a table in memory.  At no other time is the
@@ -252,11 +252,12 @@ void machine_kexec(struct kimage *image)
 	 * segments, before I zap the gdt with an invalid value.
 	 */
 	load_segments();
-	/* The gdt & idt are now invalid.
+	/*
+	 * The gdt & idt are now invalid.
 	 * If you want to load them you must set up your own idt & gdt.
 	 */
-	set_gdt(phys_to_virt(0),0);
-	set_idt(phys_to_virt(0),0);
+	set_gdt(phys_to_virt(0), 0);
+	set_idt(phys_to_virt(0), 0);
=20
 	/* now call it */
 	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -17,7 +17,8 @@
=20
 #define PTR(x) (x << 2)
=20
-/* control_page + KEXEC_CONTROL_CODE_MAX_SIZE
+/*
+ * control_page + KEXEC_CONTROL_CODE_MAX_SIZE
  * ~ control_page + PAGE_SIZE are used as data storage and stack for
  * jumping back
  */
@@ -76,8 +77,10 @@ relocate_kernel:
 	movl	%eax, CP_PA_SWAP_PAGE(%edi)
 	movl	%ebx, CP_PA_BACKUP_PAGES_MAP(%edi)
=20
-	/* get physical address of control page now */
-	/* this is impossible after page table switch */
+	/*
+	 * get physical address of control page now
+	 * this is impossible after page table switch
+	 */
 	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edi
=20
 	/* switch to new set of page tables */
@@ -97,7 +100,8 @@ identity_mapped:
 	/* store the start address on the stack */
 	pushl   %edx
=20
-	/* Set cr0 to a known state:
+	/*
+	 * Set cr0 to a known state:
 	 *  - Paging disabled
 	 *  - Alignment check disabled
 	 *  - Write protect disabled
@@ -113,7 +117,8 @@ identity_mapped:
 	/* clear cr4 if applicable */
 	testl	%ecx, %ecx
 	jz	1f
-	/* Set cr4 to a known state:
+	/*
+	 * Set cr4 to a known state:
 	 * Setting everything to zero seems safe.
 	 */
 	xorl	%eax, %eax
@@ -132,15 +137,18 @@ identity_mapped:
 	call	swap_pages
 	addl	$8, %esp
=20
-	/* To be certain of avoiding problems with self-modifying code
+	/*
+	 * To be certain of avoiding problems with self-modifying code
 	 * I need to execute a serializing instruction here.
 	 * So I flush the TLB, it's handy, and not processor dependent.
 	 */
 	xorl	%eax, %eax
 	movl	%eax, %cr3
=20
-	/* set all of the registers to known values */
-	/* leave %esp alone */
+	/*
+	 * set all of the registers to known values
+	 * leave %esp alone
+	 */
=20
 	testl	%esi, %esi
 	jnz 1f
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -24,7 +24,8 @@
 	.code64
 	.globl relocate_kernel
 relocate_kernel:
-	/* %rdi indirection_page
+	/*
+	 * %rdi indirection_page
 	 * %rsi page_list
 	 * %rdx start address
 	 */
@@ -33,8 +34,10 @@ relocate_kernel:
 	pushq $0
 	popfq
=20
-	/* get physical address of control page now */
-	/* this is impossible after page table switch */
+	/*
+	 * get physical address of control page now
+	 * this is impossible after page table switch
+	 */
 	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r8
=20
 	/* get physical address of page table now too */
@@ -55,7 +58,8 @@ identity_mapped:
 	/* store the start address on the stack */
 	pushq   %rdx
=20
-	/* Set cr0 to a known state:
+	/*
+	 * Set cr0 to a known state:
 	 *  - Paging enabled
 	 *  - Alignment check disabled
 	 *  - Write protect disabled
@@ -68,7 +72,8 @@ identity_mapped:
 	orl	$(X86_CR0_PG | X86_CR0_PE), %eax
 	movq	%rax, %cr0
=20
-	/* Set cr4 to a known state:
+	/*
+	 * Set cr4 to a known state:
 	 *  - physical address extension enabled
 	 */
 	movq	$X86_CR4_PAE, %rax
@@ -117,7 +122,8 @@ identity_mapped:
 	jmp	0b
 3:
=20
-	/* To be certain of avoiding problems with self-modifying code
+	/*
+	 * To be certain of avoiding problems with self-modifying code
 	 * I need to execute a serializing instruction here.
 	 * So I flush the TLB by reloading %cr3 here, it's handy,
 	 * and not processor dependent.
@@ -125,8 +131,10 @@ identity_mapped:
 	movq	%cr3, %rax
 	movq	%rax, %cr3
=20
-	/* set all of the registers to known values */
-	/* leave %rsp alone */
+	/*
+	 * set all of the registers to known values
+	 * leave %rsp alone
+	 */
=20
 	xorq	%rax, %rax
 	xorq	%rbx, %rbx


--=-jPalLdk7cx4gJEUZXQCo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm11vUACgkQKhFGF+eHlpi93ACfU9Us0NHDyNtW/hhsjEwzym3h
mSAAmwdn1DxyyxQWKcN/2n6ZIHiTN7mp
=TAUq
-----END PGP SIGNATURE-----

--=-jPalLdk7cx4gJEUZXQCo--

