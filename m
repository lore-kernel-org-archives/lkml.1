Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbXDZPrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbXDZPrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXDZPrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:47:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083AbXDZPri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:47:38 -0400
Date: Thu, 26 Apr 2007 08:47:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070426125802.GL3468@stusta.de>
Message-ID: <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Adrian Bunk wrote:
> 
> There is a conflict between Linus trying to release kernels every
> 2 months and releasing with few regressions.

No. 

Regressions _increase_ with longer release cycles. They don't get fewer.

The fact is, we have a -stable series for a reason. The reason is that the 
normal development kernel can work in three ways:

 (a) long release cycles, with two subcases:
	(a1) huge changes (ie a "long development series". This is what we 
	     used to have. There's no way to even track the regressions, 
	     because things just change too much.
	(a2) keep the development limited, just stretch out the 
	     "stabilization phase". This simply *does*not*work*. You might 
	     want it to work, but it's against human psychology. People 
	     get bored, and start wasting their time discussing esoteric 
	     scheduler issues which weren't regressions at all.
 (b) Short and staggered release cycle: keep changes limited (like a2), 
     but recognize when it gets counter-productive, and cut a release so 
     that the stable team can continue with it, while most developers (who 
     wouldn't have worked on the stable kernel _anyway_) don't get 
     frustrated.

And yes, we've gone for (b). With occasional "I'm not taking any half-way 
scary things at _all_" releases, like 2.6.20 was.

> Trying to avoid regressions might in the worst case result in an -rc12 
> and 4 months between releases. If the focus is on avoiding regressions 
> this has to be accepted.

No. You are ignoring the reality of development. The reality is that you 
have to balance things. If you have a four-month release cycle, where 
three and a half months are just "wait for reports to trickle in from 
testers", you simply won't get _anything_ done. People will throw their 
hands up in frustration and go somewhere else.

> And a serious delay of the next regression-merge window due to unfixed 
> regressions might even have the positive side effect of more developers 
> becoming interested in fixing the current regressions for getting their 
> shiny new regressions^Wfeatures faster into Linus' tree.

No. Quite the reverse. 

If we have a problem right now

> 0 regressions is never realistic (especially since many regressions 
> might not be reported during -rc), but IMHO we could do much better than 
> what happened in 2.6.20 and 2.6.21.

2.6.20 was actually really good. Yes, it had some regressions, but I do 
believe that it was one of the least buggy releases we've had. The process 
_worked_. 

2.6.21 was much less pleasant, but the timer thing really was 

> I'm not satisfied with the result, and the world won't stop turning when 
> I'm not tracking 2.6.22-rc regressions.

True. However, it's sad that you feel like you can't bother to track them. 
They were _very_ useful. The fact that you felt they weren't is just 
becasue I think you had unrealistic expectations, and you think that the 
stable people shouldn't have to have anything to do.

You're maintaining 2.6.16 yourself - do you not see what happens when you 
decide that "zero regressions" is the target? You have to stop 
development. And while that may sound like a good thing at any particular 
time, it's a total *disaster* in the long run (not even very long, 
actually: in the two-to-three release cycle kind of run), because while 
you are in a "regression fix" mode, people still go on developing, and 
you're just causing problems for the _next_ release by holding things up 
too long.

That's the *real* reality: 5 to 7 _million_ lines of diffs in a release 
every two to three months. Do you really think those changes stop just 
because of a release process? No. If you drag out the releases to be 4+ 
months, you'll just have 10-15 million lines of changes instead (or, more 
likely, you'll have developers who can't be bothered any more, and you may 
have just 2 million lines, and three years later you have a kernel that 
isn't relevant any more. Look at any of the other Unixes).

In other words, there's a _reason_ we have staggered development. We have 
the "crazy development trees" (aka -mm and various other trees), we have 
the "development tree" (aka Linus' tree), and we have the -stable tree. If 
the stable tree has a dozen known issues that they'll have to sort out 
over the next two months, that's *fine*. That's kind of the point of the 
stable tree.

And you would helpe them with the 2.6.22-stable releases if you'd maintain 
that list. Even if it is _designed_ not to go down to zero.

I suspect that you got overly optimistic from the fact that 2.6.20 really 
_was_ an easy release. It was designed that way. You feel that it was bad 
or average, but that's actually because of _your_ unrealistic 
expectations, not becasue there was anything wrong with 2.6.20.

		Linus
