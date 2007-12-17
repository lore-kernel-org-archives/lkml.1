Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbXLQPfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbXLQPfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbXLQPe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:34:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:59487 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbXLQPe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bgftBFwKl+7i8CTjSsTG5WScnb2ZAWxeVNPe43fmFuvj1CpJw78rYHXxNWQRZn92DBNQJJswVCq1hX7/K/FhP6UOPpef0mYJJbc2k0jlqC1EZ1r2B6RCVaUZNqr03v1NiE87POy5r5ykzTsVgUAJyErKW/8KRafwap4Pz0dx2jE=
Date: Mon, 17 Dec 2007 18:34:45 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: make pda's cpunumber and nodenumber unsigned
Message-ID: <20071217153445.GB7882@cvg.cvg>
References: <47610530.76E4.0078.0@novell.com> <20071217132619.GB1870@elte.hu> <476689AF.76E4.0078.0@novell.com> <20071217145317.GD16604@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217145317.GD16604@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Dec 17, 2007 at 03:53:17PM +0100]
| 
| * Jan Beulich <jbeulich@novell.com> wrote:
| 
| > > good catch! Applied your patch to x86.git - queued it up for 
| > > v2.6.25. I bet there are tons of other instances where we use signed 
| > > instead of unsigned and get worse code generation.
| > 
| > Yes, definitely. This patch was kind of a testing one whether this is 
| > a welcome change. As it appears to be, I'll probably produce more as I 
| > run into respective cases.
| 
| they are definitely welcome! Especially when fields are also used in 
| integer multiplications or divisions then the cost of signedness can be 
| quite significant. We regularly do such int -> uint sweeps in the 
| scheduler code and it's a great code size reductor.
| 
| Btw., a sidenote: if you are touching files that you care about, and if 
| you've got a few spare cycles, you might also want to take a look at 
| checkpatch.pl output:
| 
|  $ scripts/checkpatch.pl --file include/asm-x86/pda.h
|  ...
|  total: 23 errors, 1 warnings, 133 lines checked
| 
| as it might have a few low hanging fruits ripe for cleanup ;-)
| 
| 	Ingo
| 

Hi, I've tried to make a one ;) It's over last (today synced) linus tree.

		Cyrill
---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86: cleanup pda.h to fulfil checkpatch

---

Checkpatch still does complain about
	if (0) { T__ tmp__; tmp__ = (val)
I'm not sure if we need this line at all.

 include/asm-x86/pda.h |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/asm-x86/pda.h b/include/asm-x86/pda.h
index 35962bb..00410ec 100644
--- a/include/asm-x86/pda.h
+++ b/include/asm-x86/pda.h
@@ -7,14 +7,14 @@
 #include <linux/cache.h>
 #include <asm/page.h>
 
-/* Per processor datastructure. %gs points to it while the kernel runs */ 
+/* Per processor datastructure. %gs points to it while the kernel runs */
 struct x8664_pda {
 	struct task_struct *pcurrent;	/* 0  Current process */
 	unsigned long data_offset;	/* 8 Per cpu data offset from linker
 					   address */
 	unsigned long kernelstack;  /* 16 top of kernel stack for current */
 	unsigned long oldrsp; 	    /* 24 user rsp for system call */
-        int irqcount;		    /* 32 Irq nesting counter. Starts with -1 */
+	int irqcount;		    /* 32 Irq nesting counter. Starts with -1 */
 	int cpunumber;		    /* 36 Logical CPU number */
 #ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
@@ -43,10 +43,10 @@ extern struct x8664_pda boot_cpu_pda[];
 
 #define cpu_pda(i) (_cpu_pda[i])
 
-/* 
+/*
  * There is no fast way to get the base address of the PDA, all the accesses
  * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
- */ 
+ */
 extern void __bad_pda_field(void) __attribute__((noreturn));
 
 /*
@@ -57,7 +57,7 @@ extern struct x8664_pda _proxy_pda;
 
 #define pda_offset(field) offsetof(struct x8664_pda, field)
 
-#define pda_to_op(op,field,val) do {		\
+#define pda_to_op(op, field, val) do {		\
 	typedef typeof(_proxy_pda.field) T__;	\
 	if (0) { T__ tmp__; tmp__ = (val); }	/* type checking */ \
 	switch (sizeof(_proxy_pda.field)) {	\
@@ -66,7 +66,7 @@ extern struct x8664_pda _proxy_pda;
 		    "+m" (_proxy_pda.field) :	\
 		    "ri" ((T__)val),		\
 		    "i"(pda_offset(field))); 	\
- 		break;				\
+		break;				\
 	case 4:					\
 		asm(op "l %1,%%gs:%c2" : 	\
 		    "+m" (_proxy_pda.field) :	\
@@ -79,15 +79,15 @@ extern struct x8664_pda _proxy_pda;
 		    "ri" ((T__)val),		\
 		    "i"(pda_offset(field))); 	\
 		break;				\
-       default: 				\
+	default: 				\
 		__bad_pda_field();		\
-       }					\
-       } while (0)
+	}					\
+	} while (0)
 
 #define pda_from_op(op,field) ({		\
 	typeof(_proxy_pda.field) ret__;		\
 	switch (sizeof(_proxy_pda.field)) {	\
-       	case 2:					\
+	case 2:					\
 		asm(op "w %%gs:%c1,%0" : 	\
 		    "=r" (ret__) :		\
 		    "i" (pda_offset(field)), 	\
@@ -99,25 +99,25 @@ extern struct x8664_pda _proxy_pda;
 		    "i" (pda_offset(field)), 	\
 		    "m" (_proxy_pda.field)); 	\
 		 break;				\
-       case 8:					\
+	case 8:					\
 		asm(op "q %%gs:%c1,%0":		\
 		    "=r" (ret__) :		\
 		    "i" (pda_offset(field)), 	\
 		    "m" (_proxy_pda.field)); 	\
 		 break;				\
-       default: 				\
+	default: 				\
 		__bad_pda_field();		\
        }					\
        ret__; })
 
-#define read_pda(field) pda_from_op("mov",field)
-#define write_pda(field,val) pda_to_op("mov",field,val)
-#define add_pda(field,val) pda_to_op("add",field,val)
-#define sub_pda(field,val) pda_to_op("sub",field,val)
-#define or_pda(field,val) pda_to_op("or",field,val)
+#define read_pda(field)		pda_from_op("mov", field)
+#define write_pda(field, val)	pda_to_op("mov", field, val)
+#define add_pda(field, val)	pda_to_op("add", field, val)
+#define sub_pda(field, val)	pda_to_op("sub", field, val)
+#define or_pda(field, val)	pda_to_op("or", field, val)
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
-#define test_and_clear_bit_pda(bit,field) ({		\
+#define test_and_clear_bit_pda(bit, field) ({		\
 	int old__;						\
 	asm volatile("btr %2,%%gs:%c3\n\tsbbl %0,%0"		\
 	    : "=r" (old__), "+m" (_proxy_pda.field) 		\
