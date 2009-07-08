Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZGHV4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZGHV4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbZGHV4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:56:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4123 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZGHV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:56:42 -0400
Subject: [PATCH] arch/blackfin/kernel/traps.c: Add visually separating
 newlines to printks
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <8bd0f97a0907061336p1a6e5113o4407ff28684310a2@mail.gmail.com>
References: <4A4C3410.8080704@kernel.org>
	 <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
	 <1246513356.28915.62.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain>
	 <1246556320.28915.92.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain>
	 <1246910740.4643.10.camel@Joe-Laptop.home>
	 <8bd0f97a0907061323j3480fa61sa7f44d71819a076d@mail.gmail.com>
	 <alpine.LFD.2.01.0907061332040.3210@localhost.localdomain>
	 <8bd0f97a0907061336p1a6e5113o4407ff28684310a2@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 14:55:22 -0700
Message-Id: <1247090122.25028.21.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 16:36 -0400, Mike Frysinger wrote:
> On Mon, Jul 6, 2009 at 16:33, Linus Torvalds wrote:
> > On Mon, 6 Jul 2009, Mike Frysinger wrote:
> >> >  #ifdef CONFIG_DEBUG_VERBOSE
> >> > -       printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
> >> > +       printk(KERN_EMERG "Double Fault\n");
> >> dropped a newline.  we've largely made sure the newlines and such were
> >> as we want in the output ... in this case, it is not a matter of
> >> adding a newline where one did not exist before
> > Note that the 'printk' itself will add a required newline these days.
> > If you do want the empty line, it should look like
> >        printk(KERN_EMERG "\nDouble Fault\n");
> yes, the newlines here were explicit, not follow up to previous ones
> missing lines.  i ignored the ones Joe (correctly) dropped due to
> appending rather than explicit spacing.

Commit ad361c9884e809340f6daca80d56a9e9c871690a dropped some
arguably useful newlines from printks unnecessarily.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 8a1caf2..598d42f 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -212,7 +212,7 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
 	console_verbose();
 	oops_in_progress = 1;
 #ifdef CONFIG_DEBUG_VERBOSE
-	printk(KERN_EMERG "Double Fault\n");
+	printk(KERN_EMERG "\nDouble Fault\n");
 #ifdef CONFIG_DEBUG_DOUBLEFAULT_PRINT
 	if (((long)fp->seqstat &  SEQSTAT_EXCAUSE) == VEC_UNCOV) {
 		unsigned int cpu = smp_processor_id();
@@ -590,7 +590,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 
 		if (oops_in_progress) {
 			/* Dump the current kernel stack */
-			verbose_printk(KERN_NOTICE "Kernel Stack\n");
+			verbose_printk(KERN_NOTICE "\nKernel Stack\n");
 			show_stack(current, NULL);
 			print_modules();
 #ifndef CONFIG_ACCESS_CHECK
@@ -1009,7 +1009,7 @@ void dump_bfin_process(struct pt_regs *fp)
 			verbose_printk(KERN_NOTICE "invalid mm\n");
 	} else
 		verbose_printk(KERN_NOTICE
-			       "No Valid process in current context\n");
+			       "\nNo Valid process in current context\n");
 #endif
 }
 
@@ -1184,7 +1184,7 @@ unlock:
 		verbose_printk(KERN_NOTICE "ICPLB_FAULT_ADDR: %s\n", buf);
 	}
 
-	verbose_printk(KERN_NOTICE "PROCESSOR STATE:\n");
+	verbose_printk(KERN_NOTICE "\nPROCESSOR STATE:\n");
 	verbose_printk(KERN_NOTICE " R0 : %08lx    R1 : %08lx    R2 : %08lx    R3 : %08lx\n",
 		fp->r0, fp->r1, fp->r2, fp->r3);
 	verbose_printk(KERN_NOTICE " R4 : %08lx    R5 : %08lx    R6 : %08lx    R7 : %08lx\n",


