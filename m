Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYACCJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYACCJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 21:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYACCJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 21:09:22 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:9921 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYACCJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 21:09:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XsWDllB+7YzgG6MnjPy148ymdcczz0MrtRmlV2Jxya7LvxzhuRokjAH1ji4L92lrZmU+E7vMIXIVvGHQVFci7RtPuljX+wb6yJdJ8tRZ/JwS0XRxrEPtoOAPjgT6le5PkI7klab0mcjedKqQnsZSgGth88Vm/8t3VCn9XAClR8Q=
Subject: Re: [PATCH] x86: fault_{32|64}.c unify do_page_fault
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080103014550.GA7377@martell.zuzino.mipt.ru>
References: <1199322063.6323.72.camel@brick>
	 <20080103014550.GA7377@martell.zuzino.mipt.ru>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 18:09:18 -0800
Message-Id: <1199326158.6323.87.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-03 at 04:45 +0300, Alexey Dobriyan wrote:
> On Wed, Jan 02, 2008 at 05:01:02PM -0800, Harvey Harrison wrote:
> > Begin to unify do_page_fault(), easy code movement first.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > Ingo, similar to the kprobes unification patches I did, it gets a bit
> > uglier before it gets better ;-)
> > 
> >  arch/x86/mm/fault_32.c |   38 +++++++++++++++++++++++++++++---------
> >  arch/x86/mm/fault_64.c |   23 ++++++++++++++++++-----
> >  2 files changed, 47 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
> > index b1893eb..051a4ec 100644
> > --- a/arch/x86/mm/fault_32.c
> > +++ b/arch/x86/mm/fault_32.c
> > @@ -375,19 +375,26 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  	struct mm_struct *mm;
> >  	struct vm_area_struct *vma;
> >  	unsigned long address;
> > -	int write, si_code;
> > -	int fault;
> > +	int write, fault;
> > +#ifdef CONFIG_x86_64
> 
> There is no such thing as CONFIG_x86_64 .

My apologies, testing/compiling on X86_32 here.

> 
> Do you seriously think code is getting better and more readable because
> of this liberal #ifdef sprinkling in every possible direction?
> 

Well, this of course is not the end of the road, but it makes it
obvious where the differences between 32/64 bit lie and allows
further cleanups to unify these areas over time.  This is meant as
a no functionality change path at first.....and it does point out that
for the most part the files are _very_ similar to each other.

So my plan for now was to move forward with no functional changes and
esentially ifdef or reorder code until we get to identical fault_32/64.c
which then gets moved to a single fault.c

Then the cleanups happen in one place in one file and it should be easy
to audit the series at the end.  But for further patches I'll wait until
the series is further along and tested before submitting.  This was how
the kprobes unification went and I think it works fairly well this way.

But, if the end result is too ugly, it won't bother me at all if it
doesn't go in.

Harvey

