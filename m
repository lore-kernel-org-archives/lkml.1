Return-Path: <linux-kernel-owner+w=401wt.eu-S1031361AbXDZRKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031361AbXDZRKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbXDZRJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:09:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35425 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754872AbXDZQ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:59:40 -0400
Date: Thu, 26 Apr 2007 18:59:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426165950.GO3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 08:47:26AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 26 Apr 2007, Adrian Bunk wrote:
> > 
> > There is a conflict between Linus trying to release kernels every
> > 2 months and releasing with few regressions.
> 
> No. 
> 
> Regressions _increase_ with longer release cycles. They don't get fewer.
> 
> The fact is, we have a -stable series for a reason. The reason is that the 
> normal development kernel can work in three ways:
> 
>  (a) long release cycles, with two subcases:
> 	(a1) huge changes (ie a "long development series". This is what we 
> 	     used to have. There's no way to even track the regressions, 
> 	     because things just change too much.
> 	(a2) keep the development limited, just stretch out the 
> 	     "stabilization phase". This simply *does*not*work*. You might 
> 	     want it to work, but it's against human psychology. People 
> 	     get bored, and start wasting their time discussing esoteric 
> 	     scheduler issues which weren't regressions at all.
>  (b) Short and staggered release cycle: keep changes limited (like a2), 
>      but recognize when it gets counter-productive, and cut a release so 
>      that the stable team can continue with it, while most developers (who 
>      wouldn't have worked on the stable kernel _anyway_) don't get 
>      frustrated.

<SCNR>

They get frustrated because they focussed on developing new features 
instead of fixing regressions, and now it takes longer until their new 
features get merged because noone fixed the regressions...

</SCNR>

> And yes, we've gone for (b). With occasional "I'm not taking any half-way 
> scary things at _all_" releases, like 2.6.20 was.
> 
> > Trying to avoid regressions might in the worst case result in an -rc12 
> > and 4 months between releases. If the focus is on avoiding regressions 
> > this has to be accepted.
> 
> No. You are ignoring the reality of development. The reality is that you 
> have to balance things. If you have a four-month release cycle, where 

I'm not saying it always have to be 4 months.

> three and a half months are just "wait for reports to trickle in from 
> testers", you simply won't get _anything_ done. People will throw their 
> hands up in frustration and go somewhere else.

"wait for reports to trickle in from testers" is exactly the opposite of 
our problem.

I started the regression lists originally to prove the fairy tale
"noone tests -rc kernels" some kernel developers spread as wrong.

Look at the facts:
8 out of 14 regressions in my current list were reported in March or earlier.
And for many regressions fixed it took several weeks until debugging 
by a kernel developer was started.

We do not lack testers for getting bug reports quickly.
We lack developer manpower for debugging the many regression reports.

>...
> > 0 regressions is never realistic (especially since many regressions 
> > might not be reported during -rc), but IMHO we could do much better than 
> > what happened in 2.6.20 and 2.6.21.
> 
> 2.6.20 was actually really good. Yes, it had some regressions, but I do 
> believe that it was one of the least buggy releases we've had. The process 
> _worked_. 

In the country of the blind the one-eyed man is king...

> 2.6.21 was much less pleasant, but the timer thing really was 
> 
> > I'm not satisfied with the result, and the world won't stop turning when 
> > I'm not tracking 2.6.22-rc regressions.
> 
> True. However, it's sad that you feel like you can't bother to track them. 
> They were _very_ useful. The fact that you felt they weren't is just 
> becasue I think you had unrealistic expectations, and you think that the 
> stable people shouldn't have to have anything to do.
> 
> You're maintaining 2.6.16 yourself - do you not see what happens when you 
> decide that "zero regressions" is the target? You have to stop 
> development. And while that may sound like a good thing at any particular 
> time, it's a total *disaster* in the long run (not even very long, 
> actually: in the two-to-three release cycle kind of run), because while 
> you are in a "regression fix" mode, people still go on developing, and 
> you're just causing problems for the _next_ release by holding things up 
> too long.
> 
> That's the *real* reality: 5 to 7 _million_ lines of diffs in a release 
> every two to three months. Do you really think those changes stop just 
> because of a release process? No. If you drag out the releases to be 4+ 
> months, you'll just have 10-15 million lines of changes instead (or, more 
> likely, you'll have developers who can't be bothered any more, and you may 
> have just 2 million lines, and three years later you have a kernel that 
> isn't relevant any more. Look at any of the other Unixes).

There's not a realistic chance for 0 regressions, and 4 months was 
a worst case, not the average case.

But I am not happy with the current state of released kernels.

> In other words, there's a _reason_ we have staggered development. We have 
> the "crazy development trees" (aka -mm and various other trees), we have 
> the "development tree" (aka Linus' tree), and we have the -stable tree. If 
> the stable tree has a dozen known issues that they'll have to sort out 
> over the next two months, that's *fine*. That's kind of the point of the 
> stable tree.

And all the people who have to upgrade to 2.6.21 for getting an 
important security fix run into a dozen known (and many unknown) 
regressions.

I don't think that's fine.

> And you would helpe them with the 2.6.22-stable releases if you'd maintain 
> that list. Even if it is _designed_ not to go down to zero.
> 
> I suspect that you got overly optimistic from the fact that 2.6.20 really 
> _was_ an easy release. It was designed that way. You feel that it was bad 
> or average, but that's actually because of _your_ unrealistic 
> expectations, not becasue there was anything wrong with 2.6.20.

If we had the developer manpower to get each reported regression 
debugged and fixed [1] within three weeks, 2.6.21 might be in the shape 
I would have liked it to be today.

But there are the three interdependent variables time, developer 
manpower and quality. And few developer manpower and few time results in 
a lower quality of the release I'm not happy with.

Life has taught me that sometimes I'm right, sometimes I'm wrong, and 
sometimes both sides have a possible solution. We might agree to 
disagree, and you are the one who's opinion counts. I can only say that 
I am not happy with the result, and that I do therefore not spend my 
time on maintaining regression lists for 2.6.22 - and maintaining such 
lists is not something special noone else could do equally well.

> 		Linus

cu
Adrian

[1] "fixed" can also be e.g. "patch reverted" or "not a bug"

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

