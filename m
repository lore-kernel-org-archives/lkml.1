Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYBKOYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYBKOYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYBKOYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:24:13 -0500
Received: from mail.suse.de ([195.135.220.2]:48596 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbYBKOYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:24:12 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] [6/8] Account overlapped mappings in end_pfn_map
Date: Mon, 11 Feb 2008 15:24:05 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, ying.huang@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
References: <200802111034.764275766@suse.de> <200802111427.16288.ak@suse.de> <1202739391.6247.13.camel@lappy>
In-Reply-To: <1202739391.6247.13.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111524.05852.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 15:16:31 Peter Zijlstra wrote:
> 
> On Mon, 2008-02-11 at 14:27 +0100, Andi Kleen wrote:
> 
> > Ok patch with hungarized variables appended.
> 
> > -static void __meminit
> > +static unsigned long __meminit
> >  phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end)
> >  {
> > +	unsigned long true_end;
> >  	pmd_t *pmd = pmd_offset(pud, 0);
> >  	spin_lock(&init_mm.page_table_lock);
> > -	phys_pmd_init(pmd, address, end);
> > +	true_end = phys_pmd_init(pmd, address, end);
> >  	spin_unlock(&init_mm.page_table_lock);
> >  	__flush_tlb_all();
> > +	return true_end;
> >  }
> 
> Just for the record, Hungarian notation would have it like:
> 
>   ulTrueEnd

_pfn is variant of hungarian notation (just postfix instead of prefix); 
that is why I referred to it. 

Admittedly it was a little unfair pun with Ingo, but he really 
asked for it  in this case :-)


> http://en.wikipedia.org/wiki/Hungarian_notation
> 
> And the kernel doesn't do that, to wit (from Documentation/CodingStyle):
> 
>  Linus Torvalds (against systems Hungarian): Encoding the type of a
> function into the name (so-called Hungarian notation) is brain damaged -
> the compiler knows the types anyway and can check those, and it only
> confuses the programmer.

xxx_pfn is exactly that. 

BTW Coding style also recommends to use short variable names inside 
functions. Ingo asked me actually to violate that:

"
LOCAL variable names should be short, and to the point.  If you have
some random integer loop counter, it should probably be called "i".
Calling it "loop_counter" is non-productive, if there is no chance of it
being mis-understood.  Similarly, "tmp" can be just about any type of
variable that is used to hold a temporary value.
"

I used r for result in this case which is 100% conform to coding style.

-Andi (trying to exit this thread) 
