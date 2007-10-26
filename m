Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbXJZPJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbXJZPJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbXJZPJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:09:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbXJZPJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:09:11 -0400
Date: Fri, 26 Oct 2007 08:09:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710260756260.30120@woody.linux-foundation.org>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
 <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Bart Van Assche wrote:
> On 10/25/07, Linus Torvalds <> wrote:
> > 
> > The gcc developers seem to have had a total disregard for what people
> > want or need, and every time some code generation issue comes up, there's
> > a lot of people on the list that do language-lawyering, rather than admit
> > that there might be a problem.
> 
> Please make a proposal for how gcc should be modified instead of just
> shooting on the gcc people -- the root cause here is the way the C/C++
> memory model is defined. (Note: I'm not in any way involved in gcc
> development.)

Note that I'm very ambivalent about gcc. I think it's a *great* compiler. 
I have my doubts about some of the things it does, but hey, it is an old 
project, it has accumulated cruft over time, and cleaning things up is 
often almost impossible.

And bugs happen. I'm not complaining about that at all either, even if 
sometimes a compiler bug is damn frustrating.

And the fact is, most of the gcc developers are great.

So my basic worry about gcc is in fact none of the individual technical 
problems themselves - those can be fixed. No, the problem I've seen in gcc 
is that _some_ of the developers seem to be total d*ckheads when it comes 
to "language definition", and seem to think that it's more important to 
read the language spec like a lawyer than it is to solve actual user 
problems.

And that has come up before. It has nothing to do with this particular 
"gcc doesn't create thread-safe code" issue. We had the exact same issue 
with gcc creating totally unusable code due to having a fundamentally 
braindead memory aliasing model. The language-lawyering people basically 
could push their *idiotic* model onto gcc, just by quoting the standard, 
and not caring about actual users at all.

And that's a problem. In the kernel, we've historically always cared a lot 
about POSIX and SuS, but while conforming to standards have been primary 
goals since pretty much day one (ie I asked around about POSIX before the 
very first release, and it's how I met some suckers^Wupstanding citizens 
to try those early kernels), it has *always* taken a back seat to things 
like compatibility with existing apps.

The gcc lists seem to often get to the point where people quote the 
standard, and that's that. In that environment, the paper standard (that 
hass *nothing* to do with reality) trumps any other argument. "What we do 
is _allowed_ by the standard" seems to be a good argument, even if it 
breaks real code and there is no sane way to avoid doing it.

And I really don't think it's everybody. At all. But I think it's the case 
that sometimes it's easier to quote the standard than write good code, and 
so gcc lists have more people quoting the papers than trying to fix some 
problem.

			Linus
