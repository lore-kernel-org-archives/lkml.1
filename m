Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbZFAU6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbZFAU6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbZFAU6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:58:04 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:36769 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZFAU6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:58:02 -0400
Subject: Re: fishy code in arch/x86/kernel/tsc.c:time_cpufreq_notifier()
From: Jon Masters <jonathan@jonmasters.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090601163914.GA6098@infradead.org>
References: <20090601142104.GA15907@infradead.org>
	 <20090601162955.GA15237@redhat.com>  <20090601163914.GA6098@infradead.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 01 Jun 2009 16:56:58 -0400
Message-Id: <1243889818.31439.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 12:39 -0400, Christoph Hellwig wrote:
> On Mon, Jun 01, 2009 at 12:29:55PM -0400, Dave Jones wrote:
> > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> > index d57de05..78c54ea 100644
> > --- a/arch/x86/kernel/tsc.c
> > +++ b/arch/x86/kernel/tsc.c
> > @@ -631,17 +631,15 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
> >  				void *data)
> >  {
> >  	struct cpufreq_freqs *freq = data;
> > -	unsigned long *lpj, dummy;
> > +	unsigned long *lpj;
> >  
> >  	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
> >  		return 0;
> >  
> > -	lpj = &dummy;
> > -	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> > +	lpj = &boot_cpu_data.loops_per_jiffy;
> >  #ifdef CONFIG_SMP
> > +	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> >  		lpj = &cpu_data(freq->cpu).loops_per_jiffy;
> > -#else
> > -	lpj = &boot_cpu_data.loops_per_jiffy;
> >  #endif
> 
> This makes the code look a lot more sane and should fix the potential
> issue.

Tiny niggle that you wind up setting lpj (loops per jiffy) twice if
you're on SMP and have CPUFREQ_CONST_LOOPS.

Jon.


