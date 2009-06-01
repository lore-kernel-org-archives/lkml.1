Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZFAVyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZFAVyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZFAVvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:51:54 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:57988 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbZFAVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:51:00 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: fishy code in arch/x86/kernel/tsc.c:time_cpufreq_notifier()
Date: Mon, 1 Jun 2009 16:50:58 -0500
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <20090601142104.GA15907@infradead.org> <1243889818.31439.28.camel@localhost.localdomain> <200906011649.38694.lkml@morethan.org>
In-Reply-To: <200906011649.38694.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906011651.00074.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 1 2009, Michael S. Zick wrote:

Just ignore the last - I hit the "send" rather than "discard".

Mike
> On Mon June 1 2009, Jon Masters wrote:
> > On Mon, 2009-06-01 at 12:39 -0400, Christoph Hellwig wrote:
> > > On Mon, Jun 01, 2009 at 12:29:55PM -0400, Dave Jones wrote:
> > > > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> > > > index d57de05..78c54ea 100644
> > > > --- a/arch/x86/kernel/tsc.c
> > > > +++ b/arch/x86/kernel/tsc.c
> > > > @@ -631,17 +631,15 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
> > > >  				void *data)
> > > >  {
> > > >  	struct cpufreq_freqs *freq = data;
> > > > -	unsigned long *lpj, dummy;
> > > > +	unsigned long *lpj;
> > > >  
> > > >  	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
> > > >  		return 0;
> > > >  
> > > > -	lpj = &dummy;
> > > > -	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> > > > +	lpj = &boot_cpu_data.loops_per_jiffy;
> > > >  #ifdef CONFIG_SMP
> > > > +	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> > > >  		lpj = &cpu_data(freq->cpu).loops_per_jiffy;
> > > > -#else
> > > > -	lpj = &boot_cpu_data.loops_per_jiffy;
> > > >  #endif
> > > 
> > > This makes the code look a lot more sane and should fix the potential
> > > issue.
> > 
> > Tiny niggle that you wind up setting lpj (loops per jiffy) twice if
> > you're on SMP and have CPUFREQ_CONST_LOOPS.
> > 
> 
> At least it is consistent. ;)
> You set lpj twice if your not on SMP and have CPUFREG_CONST_LOOPS.
> 
> Mike
> > Jon.
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> 
> 
> 


