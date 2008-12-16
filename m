Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYLPUcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYLPUcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYLPUcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:32:11 -0500
Received: from cmpxchg.org ([85.214.51.133]:34016 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYLPUcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:32:10 -0500
Date: Tue, 16 Dec 2008 21:33:47 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: time_is_after_jiffies misnomer
Message-ID: <20081216203347.GA22396@cmpxchg.org>
References: <20081216144608.GA19675@cmpxchg.org> <200812161517.mBGFHUE07109@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161517.mBGFHUE07109@inv.it.uc3m.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 04:17:30PM +0100, Peter T. Breuer wrote:
> "Also sprach Johannes Weiner:"
> > On Tue, Dec 16, 2008 at 12:31:41PM +0100, Peter T. Breuer wrote:
> > > 
> > > I thought at first that
> > > 
> > >     time_is_after_jiffies(foo)
> > > 
> > > meant that the current time is later than foo jiffies.
> > 
> > 'foo jiffies'?
> 
> 
> ?? What does that mean? Yes, "the current time is later than foo
> jiffies", is what I wrote. I don't understand why you query it. What I
> wrote is a perfectly normal english sentence. It means "if the current
> time is X and and the 

Sorry, I forgot to remove that when I realized you were referring to
jiffies as a unit here.  Don't worry, I got it.

> > It behaves like all the other time_(after|before) macros.  "Compare a
> > given time T against some other time X".
> 
> It's poor english. Yes, to an english speaker
> 
>    time_is_after_jiffies(foo)
> 
> looks like
> 
>    the current time is later than foo jiffies
> 
> Look at the two:
> 
>    the current time is later than foo jiffies
>                  |   |  |           `/.
>                time_is_after_jiffies(foo)

The only problem I see is the `is'.  It should be called

	time_after_jiffies()

But time doesn't refer to `the current time' in the first place!  The
macro is not (meant to be) an English sentence.

'time' is the prefix for a group of symbols, a namespace if you will
and it stands for the first argument in all these macros. 'is_after'
is the relation.  'jiffies' the thing you compare with.  It's an infix
operator used in prefix form.

The only problem that I see with the jiffies-comparing macros is the
`is'.  They should be called time_after_jiffies() and
time_before_jiffies() etc.

> (I AM a native english speaker, and a very good one - please take this
> on board and pay attention to it; you'll find me quoted as the author
> of hundreds of technical articles on google :-).

They are probably written in a natural language.

> The mathematical "jiffies(foo)" for colloquial "foo jiffies" is the
> normal way of writing formal predicates.  Like "colour(red)" for
> "red colour". This is a predicate.

I don't think there are many functions/macros in the (core-)kernel
that have the types they operate on encoded in their names.

So interpreting the macro the way you did makes no sense to me
regarding the code in context.

> > The banner comment above the macro group should have clarified the
> > misunderstanding, btw.
> 
> No, it says nothing:
> 
>   * These four macros compare jiffies and 'a' for convenience.
> 
> What's written above the individual macros is more explanatory, but
> it's the NAMES of the macros that are the wrong way round for english:
> 
>   
>   /* time_is_before_jiffies(a) return true if a is before jiffies */
>   #define time_is_before_jiffies(a) time_after(jiffies, a)
> 
> It's time_is_before_jiffies(foo) that reads the wrong way round in
> english. It should be
> 
> 
>      current_time_is_after_jiffies(foo).

How would you name the existing time_after() then?

	Hannes
