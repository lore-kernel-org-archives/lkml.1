Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbXDIRGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbXDIRGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXDIRGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:06:34 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44083 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbXDIRGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:06:33 -0400
Message-ID: <461A7246.60003@gmail.com>
Date: Mon, 09 Apr 2007 19:05:10 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ten percent test
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu> <461939A4.2020305@gmail.com> <1176092598.6355.22.camel@Homer.simpson.net> <461A2E39.8060106@gmail.com> <20070409141516.GB11244@elte.hu>
In-Reply-To: <20070409141516.GB11244@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2007 04:15 PM, Ingo Molnar wrote:

> * Rene Herman <rene.herman@gmail.com> wrote:
> 
>> To me, the example rather serves as confirmation of what Kolivas
>> has been saying; endlessly tweaking the tweaks isn't going
>> anywhere.
> 
> but ... SD clearly regresses in some areas, so by that logic SD isnt
> going anywhere either?

No. The logic isn't that (performance and other) characteristics must 
always be exactly the same between two schedulers, the logic is that 
having one of them turn into a contrived heap of heuristics where every 
progression on one front turns into a regression on another means that 
one is on a dead-end road.

Now ofcourse, while not needing to behave the same in all conceivable 
situations, any alternative like SD needs to behave _well_ and for me, 
it is currently, while just using it.

> note that i still like the basic idea about SD, that it is an
> experiment that if the only conceptual focus is on "scheduling
> fairness", we'll get a better scheduler. But for that to work out two
> things have to be done i think:
> 
> - the code actually has to match that stated goal. Right now it 
>   diverges from it (it is not a "fair" scheduler), and it's not clear 
>   why.

I read most of the discussion centering around that specific point as 
well, and frankly, I mostly came away from it thinking "so what?". It 
seems this is largely an issue of you and Kolivas disagreeing on what 
needs to be called design and what needs to be called implementation, 
but more importantly I feel a solution is to just shy away from the 
inherently subjective word "fair". If you feel that some of the things 
SD does need to be called "unfair" as much as mainline, so be it, but do 
you think that SD is less _predictably_ fair or unfair than mainline?

This is what I consider to be very important; if my retarted kid brother 
sometimes walk left and sometimes right when I tell him to walk forward, 
I can't go stand to the right and say "nono, forward I said". If on the 
right there's a highway, you can imagine what that means... All software 
is stupid, but the one that's predictably so allows you to compensate.

> this "provide fairness" goal is quite important, because if SD's code
> is not only about providing fairness, what is the rest of the logic
> doing? Are they "tweaks", to achieve interactivity? If yes, why are
> they not marked as such? I.e. will we go down the _same_ road again,
> but this time with a much less clearly defined rule for what a
> "tweak" is?

One answer to that is that it's much less important what a tweak is as 
long as it's the same always. If I then don't like the definition I'll 
just define it the other way around privately and be done with it. I do 
believe that SDs objective is not fairness as such, it's predictability. 
Being "fair" was postulated as a condition for being so, but let's not 
put too much focus on that one point; it's a matter of definitions (and 
taste) and secondary.

> So _if_ we accept that scheduling must include a fair dose of
> heuristics (which i tend to think it has to), we are perhaps better
> off with an interactivity design that _accepts_ this fundamental fact
> and separates heuristics from core scheduling.

I agree that the demands on a (one) general purpose scheduler are so 
diverse that it's impossible to have one that doesn't break down under 
some set of conditions. The mainline scheduler does so, and SD does so. 
What SD does is take some of the guesswork out of it. I haven't needed 
anything like it yet, but I wouldn't feel particularly bad about, say, 
renicing a kernel compile upon having audio stutter while I'm browsing eBay.

The "I haven't needed anything like it" is important; I ofcourse only 
wouldn't mind it under the condition that what I consider loads that my 
desktop should be able to handle without problem don't need anything 
special. If I'd transpose this load onto the Pentium 1 that's sitting at 
my feet, I wouldn't mind at all though.

> Right now i dont see the SD proponents even _accepting_ that even the
> current SD code does include heuristics.
> 
> the other one is:
> 
>  - the code has to demonstrate that it can flexibly react to various 
>    complaints of regressions.

With one important point -- if every single _change_ in behaviour is 
going to be defined a regression, then obviously noone will ever again 
be able to change anything fundamental. Behaviour is being changed since 
people see current behaviour as not being desireable. Predictability for 
one is in my opinion a strong enough "progression" that I'm willing to 
mark of a few "regressions" against it.

> (I identified a few problem workloads that we tend to care about and
> i havent seen much progress with them - but i really reserve
> judgement about that, given Con's medical condition.)

Indeed. Going forward with it while its main developer is out might be 
unwise ofcourse. From his emails I gather he'll be out for some time, 
but hey, after kernel N+1, there'll probably be a kernel N+2...

I'd just hate to see this being blocked outright. It seems to be 
performing so nicely for me.

Rene.

