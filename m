Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZILVxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZILVxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 17:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZILVxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 17:53:30 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22327 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbZILVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 17:53:29 -0400
Date: Sat, 12 Sep 2009 23:53:31 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/fpu for v2.6.32
In-Reply-To: <20090912054747.730d4abe@infradead.org>
Message-ID: <alpine.LNX.2.00.0909122352190.23341@swampdragon.chaosbits.net>
References: <20090911194432.GA29736@elte.hu> <alpine.LNX.2.00.0909112318190.31018@swampdragon.chaosbits.net> <20090912054747.730d4abe@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Sep 2009, Arjan van de Ven wrote:

> On Fri, 11 Sep 2009 23:30:42 +0200 (CEST)
> Jesper Juhl <jj@chaosbits.net> wrote:
> 
> > 
> > Hi Ingo,
> > 
> > First of all, I want to say that I have no real objections to the
> > patch what-so-ever. The following is merely to satisfy my own
> > personal curiosity - and I'm sure you have better things to do than
> > satisfy my curiosity, so if you want to ignore me; feel free :-)
> > 
> > On Fri, 11 Sep 2009, Ingo Molnar wrote:
> > 
> > [...]
> > > +	bool preload_fpu;
> > >  
> > >  	/* never put a printk in __switch_to... printk() calls
> > > wake_up*() indirectly */ 
> > > -	__unlazy_fpu(prev_p);
> > > +	/*
> > > +	 * If the task has used fpu the last 5 timeslices, just do
> > > a full
> > > +	 * restore of the math state immediately to avoid the
> > > trap; the
> > > +	 * chances of needing FPU soon are obviously high now
> > > +	 */
> > > +	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter
> > > > 5; 
> > > +	__unlazy_fpu(prev_p);
> > >  
> > [...]
> > > +	 * If the task has used fpu the last 5 timeslices, just do
> > > a full
> > > +	 * restore of the math state immediately to avoid the
> > > trap; the
> > > +	 * chances of needing FPU soon are obviously high now
> > > +	 */
> > > +	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter
> > > > 5; 
> > 
> > I'm wondering about two things:
> > 
> 
> (btw this is not new code)
> 
> > 1) Where did that magic constant "5" come from?
> 
> from me running a bunch of experiments noticing that tasks that do 5
> do on average many more. Could it be 4? Perhaps. 
> 
> > Is there some fundamental thing about CPU's, cache layout,
> > scheduling, benchmarks or something else that I just don't know that
> > makes 5 the magic "right number"?  Why not 2, 3, 9 or 42?
> 
> At some point *a* number must be taken. That is currently 5.
> Show us that any other number is better and we'll switch ;-)
> 
Thank you for taking the time to answer and explain.
I'm sure 5 is fine, I was merely currious :-)

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

