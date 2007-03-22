Return-Path: <linux-kernel-owner+w=401wt.eu-S933776AbXCVQC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbXCVQC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbXCVQC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:02:27 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50951 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbXCVQCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:02:25 -0400
Date: Thu, 22 Mar 2007 16:59:25 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386 GDT cleanups: Rename boot_gdt_table to boot_gdt
Message-ID: <20070322165925.3630fce9@frecb000686.frec.bull.fr>
In-Reply-To: <1174555451.2713.139.camel@localhost.localdomain>
References: <1174457426.11680.132.camel@localhost.localdomain>
	<1174458636.11680.143.camel@localhost.localdomain>
	<1174458730.11680.145.camel@localhost.localdomain>
	<1174458938.11680.150.camel@localhost.localdomain>
	<m1aby7c59k.fsf@ebiederm.dsl.xmission.com>
	<1174478153.11680.183.camel@localhost.localdomain>
	<m1wt1abkuo.fsf@ebiederm.dsl.xmission.com>
	<1174521510.2713.61.camel@localhost.localdomain>
	<20070322091031.33a753fe@frecb000686.frec.bull.fr>
	<1174555451.2713.139.camel@localhost.localdomain>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 22/03/2007 17:04:20,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 22/03/2007 17:04:27,
	Serialize complete at 22/03/2007 17:04:27
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Rusty,

On Thu, 22 Mar 2007 20:24:10 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thu, 2007-03-22 at 09:10 +0100, Sébastien Dugué wrote:
> >   Why not take on the opportunity to rename boot_gt_table to boot_gtd,
> > to avoid the duplicate T(able)?
> 
> That's not a bad idea, but IMHO deserves its own patch.
> 
> I look forward to it!
> Rusty.
> 
> 

  Here it is, boot tested on an SMP x86 box.

  Sébastien.



 Rename boot_gdt_table to boot_gdt to avoid the duplicate
T(able).

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>

---
 arch/i386/kernel/head.S       |    9 ++++-----
 arch/i386/kernel/trampoline.S |   12 ++++++------
 2 files changed, 10 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/i386/kernel/head.S
===================================================================
--- linux-2.6.orig/arch/i386/kernel/head.S	2007-03-22 15:09:02.000000000 +0100
+++ linux-2.6/arch/i386/kernel/head.S	2007-03-22 16:14:38.000000000 +0100
@@ -147,8 +147,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
- * we know the trampoline has already loaded the boot_gdt_table GDT
- * for us.
+ * we know the trampoline has already loaded the boot_gdt for us.
  *
  * If cpu hotplug is not supported then this code can go in init section
  * which will be freed later
@@ -588,7 +587,7 @@ fault_msg:
 	.word 0				# 32 bit align gdt_desc.address
 boot_gdt_descr:
 	.word __BOOT_DS+7
-	.long boot_gdt_table - __PAGE_OFFSET
+	.long boot_gdt - __PAGE_OFFSET
 
 	.word 0				# 32-bit align idt_desc.address
 idt_descr:
@@ -602,11 +601,11 @@ ENTRY(early_gdt_descr)
 	.long cpu_gdt_table
 
 /*
- * The boot_gdt_table must mirror the equivalent in setup.S and is
+ * The boot_gdt must mirror the equivalent in setup.S and is
  * used only for booting.
  */
 	.align L1_CACHE_BYTES
-ENTRY(boot_gdt_table)
+ENTRY(boot_gdt)
 	.fill GDT_ENTRY_BOOT_CS,8,0
 	.quad 0x00cf9a000000ffff	/* kernel 4GB code at 0x00000000 */
 	.quad 0x00cf92000000ffff	/* kernel 4GB data at 0x00000000 */
Index: linux-2.6/arch/i386/kernel/trampoline.S
===================================================================
--- linux-2.6.orig/arch/i386/kernel/trampoline.S	2007-03-22 15:09:02.000000000 +0100
+++ linux-2.6/arch/i386/kernel/trampoline.S	2007-03-22 16:13:23.000000000 +0100
@@ -29,7 +29,7 @@
  *
  *	TYPE              VALUE
  *	R_386_32          startup_32_smp
- *	R_386_32          boot_gdt_table
+ *	R_386_32          boot_gdt
  */
 
 #include <linux/linkage.h>
@@ -62,8 +62,8 @@ r_base = .
 	 * to 32 bit.
 	 */
 
-	lidtl	boot_idt - r_base	# load idt with 0, 0
-	lgdtl	boot_gdt - r_base	# load gdt with whatever is appropriate
+	lidtl	boot_idt_descr - r_base	# load idt with 0, 0
+	lgdtl	boot_gdt_descr - r_base	# load gdt with whatever is appropriate
 
 	xor	%ax, %ax
 	inc	%ax		# protected mode (PE) bit
@@ -73,11 +73,11 @@ r_base = .
 
 	# These need to be in the same 64K segment as the above;
 	# hence we don't use the boot_gdt_descr defined in head.S
-boot_gdt:
+boot_gdt_descr:
 	.word	__BOOT_DS + 7			# gdt limit
-	.long	boot_gdt_table-__PAGE_OFFSET	# gdt base
+	.long	boot_gdt - __PAGE_OFFSET	# gdt base
 
-boot_idt:
+boot_idt_descr:
 	.word	0				# idt limit = 0
 	.long	0				# idt base = 0L
 
