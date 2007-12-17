Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbXLQQAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbXLQQAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbXLQQAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:00:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54649 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbXLQQAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:00:44 -0500
Date: Mon, 17 Dec 2007 17:00:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: make pda's cpunumber and nodenumber unsigned
Message-ID: <20071217160016.GA30958@elte.hu>
References: <47610530.76E4.0078.0@novell.com> <20071217132619.GB1870@elte.hu> <476689AF.76E4.0078.0@novell.com> <20071217145317.GD16604@elte.hu> <20071217153445.GB7882@cvg.cvg>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20071217153445.GB7882@cvg.cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Hi, I've tried to make a one ;) It's over last (today synced) linus 
> tree.

thanks, applied :-)

Some small details: i had to hand-apply your patch to the x86.git#mm 
tree (see the instructions below how to fetch that tree). It's best (for 
us maintainers) if you send such cleanup patches against that tree, to 
reduce patch collision risk. I have attached the final merged patch 
further below.

just in case you are on the lookout for other cleanup targets, i've 
attached the "code-quality" script that gives us the mechanic code 
quality metric of any file or tree. For example, it nicely shows the 
cleanup effects of your patch on the pda.h file:

                                      errors   lines of code   errors/KLOC
include/asm-x86/pda.h  [before]           23             133         172.9
include/asm-x86/pda.h  [after]             1             133           7.5

if you want to pick cleanup targets from the x86 tree, do something like 
this:

  code-quality `find arch/x86 include/asm-x86/ -name '*.c'` | tee quality.txt

  sort -n -k 4 quality.txt

Warning: some files are very hard to clean up. Ask on lkml if unsure.

The current code quality of arch/x86/ (as of x86.git#mm) is:

  $ code-quality arch/x86/
                                        errors   lines of code   errors/KLOC
  arch/x86/                               4277          117235          36.4

And the long term goal is to achieve the output of:

  code-quality kernel/sched*.[ch]

/me runs and hides ;-)

	Ingo

----->
 git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
 cd linux-2.6.git
 git-branch x86
 git-checkout x86
 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

(do subsequent pulls via "git-pull --force", as we frequently rebase the
git tree. NOTE: this might override your own local changes, so do this
only if you dont mind about losing thse changes in that tree.)


--------------->
Subject: x86: clean up include/asm-x86/pda.h
From: Cyrill Gorcunov <gorcunov@gmail.com>

clean up include/asm-x86/pda.h, as suggested by checkpatch.pl.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/pda.h |   70 +++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

Index: linux-x86.q/include/asm-x86/pda.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pda.h
+++ linux-x86.q/include/asm-x86/pda.h
@@ -7,15 +7,15 @@
 #include <linux/cache.h>
 #include <asm/page.h>
 
-/* Per processor datastructure. %gs points to it while the kernel runs */ 
+/* Per processor datastructure. %gs points to it while the kernel runs */
 struct x8664_pda {
 	struct task_struct *pcurrent;	/* 0  Current process */
 	unsigned long data_offset;	/* 8 Per cpu data offset from linker
 					   address */
-	unsigned long kernelstack;  /* 16 top of kernel stack for current */
-	unsigned long oldrsp; 	    /* 24 user rsp for system call */
-        int irqcount;		    /* 32 Irq nesting counter. Starts with -1 */
-	unsigned int cpunumber;	    /* 36 Logical CPU number */
+	unsigned long kernelstack;	/* 16 top of kernel stack for current */
+	unsigned long oldrsp;		/* 24 user rsp for system call */
+	int irqcount;			/* 32 Irq nesting counter. Starts -1 */
+	unsigned int cpunumber;		/* 36 Logical CPU number */
 #ifdef CONFIG_CC_STACKPROTECTOR
 	unsigned long stack_canary;	/* 40 stack canary value */
 					/* gcc-ABI: this canary MUST be at
@@ -44,10 +44,10 @@ extern void pda_init(int);
 
 #define cpu_pda(i) (_cpu_pda[i])
 
-/* 
+/*
  * There is no fast way to get the base address of the PDA, all the accesses
  * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
- */ 
+ */
 extern void __bad_pda_field(void) __attribute__((noreturn));
 
 /*
@@ -58,70 +58,70 @@ extern struct x8664_pda _proxy_pda;
 
 #define pda_offset(field) offsetof(struct x8664_pda, field)
 
-#define pda_to_op(op,field,val) do {		\
+#define pda_to_op(op, field, val) do {		\
 	typedef typeof(_proxy_pda.field) T__;	\
 	if (0) { T__ tmp__; tmp__ = (val); }	/* type checking */ \
 	switch (sizeof(_proxy_pda.field)) {	\
 	case 2:					\
-		asm(op "w %1,%%gs:%c2" : 	\
+		asm(op "w %1,%%gs:%c2" :	\
 		    "+m" (_proxy_pda.field) :	\
 		    "ri" ((T__)val),		\
-		    "i"(pda_offset(field))); 	\
- 		break;				\
+		    "i"(pda_offset(field)));	\
+		break;				\
 	case 4:					\
-		asm(op "l %1,%%gs:%c2" : 	\
+		asm(op "l %1,%%gs:%c2" :	\
 		    "+m" (_proxy_pda.field) :	\
 		    "ri" ((T__)val),		\
-		    "i" (pda_offset(field))); 	\
+		    "i" (pda_offset(field)));	\
 		break;				\
 	case 8:					\
-		asm(op "q %1,%%gs:%c2": 	\
+		asm(op "q %1,%%gs:%c2":		\
 		    "+m" (_proxy_pda.field) :	\
 		    "ri" ((T__)val),		\
-		    "i"(pda_offset(field))); 	\
+		    "i"(pda_offset(field)));	\
 		break;				\
-       default: 				\
+	default:				\
 		__bad_pda_field();		\
-       }					\
-       } while (0)
+	}					\
+	} while (0)
 
 #define pda_from_op(op,field) ({		\
 	typeof(_proxy_pda.field) ret__;		\
 	switch (sizeof(_proxy_pda.field)) {	\
-       	case 2:					\
-		asm(op "w %%gs:%c1,%0" : 	\
+	case 2:					\
+		asm(op "w %%gs:%c1,%0" :	\
 		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)), 	\
-		    "m" (_proxy_pda.field)); 	\
+		    "i" (pda_offset(field)),	\
+		    "m" (_proxy_pda.field));	\
 		 break;				\
 	case 4:					\
 		asm(op "l %%gs:%c1,%0":		\
 		    "=r" (ret__):		\
-		    "i" (pda_offset(field)), 	\
-		    "m" (_proxy_pda.field)); 	\
+		    "i" (pda_offset(field)),	\
+		    "m" (_proxy_pda.field));	\
 		 break;				\
-       case 8:					\
+	case 8:					\
 		asm(op "q %%gs:%c1,%0":		\
 		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)), 	\
-		    "m" (_proxy_pda.field)); 	\
+		    "i" (pda_offset(field)),	\
+		    "m" (_proxy_pda.field));	\
 		 break;				\
-       default: 				\
+	default:				\
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
-	    : "=r" (old__), "+m" (_proxy_pda.field) 		\
+	    : "=r" (old__), "+m" (_proxy_pda.field)		\
 	    : "dIr" (bit), "i" (pda_offset(field)) : "memory");	\
 	old__;							\
 })

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=code-quality


SRC=$@

[ "$SRC" = "" ] && { SRC=`q files`; }

FILE=/tmp/1.c

echo "                                      errors   lines of code   errors/KLOC"

for DIR in $SRC; do

  printf "%-35s " $DIR
  find $DIR -name '*.[ch]' | xargs cat > $FILE
  RES=`scripts/checkpatch.pl --file $FILE | grep ^total`

  # echo $RES

  if [ "$RES" != "" ]; then
    ERR=`echo $RES | cut -d' ' -f2`
    WARN=`echo $RES | cut -d' ' -f4`
    LINES=`echo $RES | cut -d' ' -f6`
  else
    ERR=0
    WARN=0
    LINES=`cat $FILE | wc -l`
  fi

  rm -f $FILE

  ERR_KLOC=`( echo "scale=1"; echo "$ERR*1000/$LINES" ) | bc`
  printf "%8s      %10s    %10s\n" $ERR $LINES $ERR_KLOC

done


--T4sUOijqQbZv57TR--
