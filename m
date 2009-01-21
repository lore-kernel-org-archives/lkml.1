Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbZAUNGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbZAUNGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 08:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZAUNGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 08:06:41 -0500
Received: from aun.it.uu.se ([130.238.12.36]:62560 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbZAUNGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 08:06:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18807.7643.368198.582428@harpo.it.uu.se>
Date: Wed, 21 Jan 2009 14:06:35 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: Unneeded assignment to tsk in recent x86 change
In-Reply-To: <5787cf470901210432l5327e48el94c53c8fb7fd6d1d@mail.gmail.com>
References: <5787cf470901210432l5327e48el94c53c8fb7fd6d1d@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uros Bizjak writes:
 > Hello!
 > 
 > Impact: Cleanup.
 > 
 > Remove unneeded assignment to tsk in recent x86 change [1].
 > 
 > [1]: http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=d737c7649e2f7bdaa8760a9205dffaa45c117f20
 > 
 > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
 > 
 > Patch vs. tip/master.
 > 
 > Uros.
 > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
 > index 93a563b..621e9b3 100644
 > --- a/arch/x86/mm/fault.c
 > +++ b/arch/x86/mm/fault.c
 > @@ -421,7 +421,6 @@ static noinline void pgtable_bad(struct pt_regs *regs,
 >  	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
 >  	       tsk->comm, address);
 >  	dump_pagetable(address);
 > -	tsk = current;
 >  	tsk->thread.cr2 = address;
 >  	tsk->thread.trap_no = 14;
 >  	tsk->thread.error_code = error_code;

this bit is ok, clearly *tsk is valid and == current before the assignment

 > @@ -795,13 +794,12 @@ asmlinkage
 >  void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 >  {
 >  	unsigned long address;
 > -	struct task_struct *tsk;
 > +	struct task_struct *tsk = current;
 >  	struct mm_struct *mm;
 >  	struct vm_area_struct *vma;
 >  	int write;
 >  	int fault;
 >  
 > -	tsk = current;
 >  	mm = tsk->mm;
 >  	prefetchw(&mm->mmap_sem);

but this is neither a fix nor IMO a cleanup (it's inconsistent with
the other variables in that function)
