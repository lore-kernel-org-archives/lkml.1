Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbYACLAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbYACLAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYACLAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:00:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37504 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbYACLAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:00:43 -0500
Date: Thu, 3 Jan 2008 12:00:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [20/20] x86: Print which shared library/executable
	faulted in segfault etc. messages
Message-ID: <20080103110034.GG29194@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005016.4DA4C14D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005016.4DA4C14D40@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> They now look like
> 
> hal-resmgr[13791]: segfault at 3c rip 2b9c8caec182 rsp 7fff1e825d30 
> error 4 in libacl.so.1.1.0[2b9c8caea000+6000]
> 
> This makes it easier to pinpoint bugs to specific libraries.

yep, that's really useful.

I think the patch needs one more iteration though:

> And printing the offset into a mapping also always allows to find the 
> correct fault point in a library even with randomized mappings. Previously
> there was no way to actually find the correct code address inside
> the randomized mapping.
> 
> Relies on earlier patch to shorten the printk formats.
> 
> They are often now longer than 80 characters, but I think that's worth 
> it.

why not make it multi-line? that way the %lx hack wouldnt be needed 
either.

> +void print_vma_addr(char *prefix, unsigned long ip)
> +{
> +	struct mm_struct *mm = current->mm;
> +	struct vm_area_struct *vma;
> +	down_read(&mm->mmap_sem);
> +	vma = find_vma(mm, ip);

grumble. Proper CodingStyle please.

> +		if (buf) {
> +			char *p, *s;
> +			p = d_path(f->f_dentry, f->f_vfsmnt, buf, PAGE_SIZE);

this one too.

> +	if (show_unhandled_signals && printk_ratelimit()) {
> +		printk("%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
>  	       me->comm,me->pid,where,frame,regs->ip,regs->sp,regs->orig_ax);

and this.

	Ingo
