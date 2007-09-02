Return-Path: <linux-kernel-owner+w=401wt.eu-S934132AbXIBRCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbXIBRCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXIBRC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:02:29 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2286 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbXIBRC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:02:28 -0400
Date: Sun, 2 Sep 2007 19:02:55 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Bill Davidsen <davidsen@tmr.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <46DA1DBF.7090509@tmr.com>
Message-ID: <Pine.LNX.4.64.0709021727170.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <20070831105447.GA17956@elte.hu>
 <Pine.LNX.4.64.0709010206400.1817@scrub.home> <46DA1DBF.7090509@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 1 Sep 2007, Bill Davidsen wrote:

> > I'd expect Ingo to know better, but the more he refuses to answer my
> > questions, the more I doubt it, at least than it comes to the math part.
> > 
> The "math part" is important if you're doing a thesis defense, but
> demonstrating better behavior under some realistic load would probably be a
> better starting point.

That wasn't my design goal. The initial trigger for this was all the 64bit 
math in CFS and the question how can this be tuned using arch specific 
knowledge about the input values. For this I needed a correct and 
verifyable model to analyze, so I know where the limits are and how it 
reacts to different sets of inputs. This is where I got into trouble with 
all the rounding - I couldn't substantially change the math without 
convincing myself that it's still correct for all kinds of input data. 
That's why I completely redid the math from scratch - it's based on the 
same basic ideas, but the solution and thus the math is quite different.

The main reason I didn't concentrate on the behaviour so much is that 
since both scheduler are conceptually not that far apart, it should be 
possible to apply any tuning done to CFS also to my model. But this 
requires someone actually understands what tuning was done and it wasn't 
done by random changes and seeing what happens, i.e. someone should be 
able to explain it to me.
BTW in this context it's rather interesting to see that Ingo attacks me 
now for not having done this tuning yet and for which I explicitely asked 
for help...

> Maybe Ingo missed something in your math, and maybe he
> just didn't find a benefit.

Maybe he didn't understand it at all and is too proud to admit it?
(At least that's the only explanation which makes sense to me.)

> You dropped this on the world two days before a major US holiday, at the end
> of the summer when those of us not on vacation may be covering for those who
> are, did you expect Ingo to drop his regular work to look at your stuff?

Did I demand anything like that? It had been fine if he had been asking 
for more time or if he had more questions first, but it took him only a 
few hours to come to his conclusion without any need for further 
questions.

> And
> do you think there are many people who can look at your math, and look at your
> code, and then have any clue how well it works in practice? I bet there aren't
> ten people in the world who would even claim to do that, and half of them are
> kidding themselves.

I don't think the math is that complex, it may need some more explanations 
outside the math formulas though. But the math is needed to analyze what 
effect changes to scheduler have, otherwise there is a risk it becomes 
only guesswork with random changes which may help in some situations but 
break others.

bye, Roman
