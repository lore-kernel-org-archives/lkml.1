Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZILDoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZILDoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 23:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZILDoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 23:44:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:55162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbZILDoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 23:44:20 -0400
Date: Sat, 12 Sep 2009 05:47:47 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/fpu for v2.6.32
Message-ID: <20090912054747.730d4abe@infradead.org>
In-Reply-To: <alpine.LNX.2.00.0909112318190.31018@swampdragon.chaosbits.net>
References: <20090911194432.GA29736@elte.hu>
	<alpine.LNX.2.00.0909112318190.31018@swampdragon.chaosbits.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 23:30:42 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> 
> Hi Ingo,
> 
> First of all, I want to say that I have no real objections to the
> patch what-so-ever. The following is merely to satisfy my own
> personal curiosity - and I'm sure you have better things to do than
> satisfy my curiosity, so if you want to ignore me; feel free :-)
> 
> On Fri, 11 Sep 2009, Ingo Molnar wrote:
> 
> [...]
> > +	bool preload_fpu;
> >  
> >  	/* never put a printk in __switch_to... printk() calls
> > wake_up*() indirectly */ 
> > -	__unlazy_fpu(prev_p);
> > +	/*
> > +	 * If the task has used fpu the last 5 timeslices, just do
> > a full
> > +	 * restore of the math state immediately to avoid the
> > trap; the
> > +	 * chances of needing FPU soon are obviously high now
> > +	 */
> > +	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter
> > > 5; 
> > +	__unlazy_fpu(prev_p);
> >  
> [...]
> > +	 * If the task has used fpu the last 5 timeslices, just do
> > a full
> > +	 * restore of the math state immediately to avoid the
> > trap; the
> > +	 * chances of needing FPU soon are obviously high now
> > +	 */
> > +	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter
> > > 5; 
> 
> I'm wondering about two things:
> 

(btw this is not new code)

> 1) Where did that magic constant "5" come from?

from me running a bunch of experiments noticing that tasks that do 5
do on average many more. Could it be 4? Perhaps. 

> Is there some fundamental thing about CPU's, cache layout,
> scheduling, benchmarks or something else that I just don't know that
> makes 5 the magic "right number"?  Why not 2, 3, 9 or 42?

At some point *a* number must be taken. That is currently 5.
Show us that any other number is better and we'll switch ;-)




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
