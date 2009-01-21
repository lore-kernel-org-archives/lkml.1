Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZAUVOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZAUVOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 16:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZAUVOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 16:14:02 -0500
Received: from aun.it.uu.se ([130.238.12.36]:37128 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZAUVOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 16:14:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18807.36883.413974.491276@harpo.it.uu.se>
Date: Wed, 21 Jan 2009 22:13:55 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: Unneeded assignment to tsk in recent x86 change
In-Reply-To: <49777DF5.1080107@gmail.com>
References: <5787cf470901210432l5327e48el94c53c8fb7fd6d1d@mail.gmail.com>
	<18807.7643.368198.582428@harpo.it.uu.se>
	<49777DF5.1080107@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uros Bizjak writes:
 > Mikael Pettersson wrote:
 > 
 > >  > Impact: Cleanup.
 > >  > 
 > >  > Remove unneeded assignment to tsk in recent x86 change [1].
 > >  
 > >
 > >  > @@ -795,13 +794,12 @@ asmlinkage
 > >  >  void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 > >  >  {
 > >  >  	unsigned long address;
 > >  > -	struct task_struct *tsk;
 > >  > +	struct task_struct *tsk = current;
 > >  >  	struct mm_struct *mm;
 > >  >  	struct vm_area_struct *vma;
 > >  >  	int write;
 > >  >  	int fault;
 > >  >  
 > >  > -	tsk = current;
 > >  >  	mm = tsk->mm;
 > >  >  	prefetchw(&mm->mmap_sem);
 > >
 > > but this is neither a fix nor IMO a cleanup (it's inconsistent with
 > > the other variables in that function)
 > >   
 > 
 > Hm, I'm not sure I see the inconsistency here. Care to explain this 
 > inconsistency in a couple of words?

You're initialising some variables in their declarations, and some
using assignments at the start of the procedure body. In particular,
for some reason you don't initialise 'mm' in its declaration even
though you could do so for consistency with 'tsk'.

However, I'm strongly in favour of separating declarations and
initialisations (esp. ones that need actual computations), so
rather than subjecting 'mm' to the treatment you gave 'tsk',
just leave the code alone.
