Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbXCMGIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbXCMGIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXCMGIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:08:13 -0400
Received: from rune.pobox.com ([208.210.124.79]:36753 "EHLO rune.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbXCMGIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:08:12 -0400
From: Rodney Gordon II <meff@pobox.com>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 01:08:02 -0500
User-Agent: KMail/1.9.5
Cc: Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <1173762639.7944.45.camel@Homer.simpson.net> <200703131653.39415.kernel@kolivas.org>
In-Reply-To: <200703131653.39415.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703130108.03119.meff@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 00:53, Con Kolivas wrote:
> On Tuesday 13 March 2007 16:10, Mike Galbraith wrote:
> > On Tue, 2007-03-13 at 09:51 +1100, Con Kolivas wrote:
> > > On 13/03/07, Mike Galbraith <efault@gmx.de> wrote:
> > > > As soon as your cpu is fully utilized, fairness looses or
> > > > interactivity loses.  Pick one.
> > >
> > > That's not true unless you refuse to prioritise your tasks
> > > accordingly. Let's take this discussion in a different direction. You
> > > already nice your lame processes. Why? You already have the concept
> > > that you are prioritising things to normal or background tasks. You
> > > say so yourself that lame is a background task. Stating the bleedingly
> > > obvious, the unix way of prioritising things is via nice. You already
> > > do that. So moving on from that...
> >
> > Sure.  If a user wants to do anything interactive, they can indeed nice
> > 19 the rest of their box before they start.
> >
> > > Your test case you ask "how can I maximise cpu usage". Well you know
> > > the answer already. You run two threads. I won't dispute that.
> > >
> > > The debate seems to be centered on whether two tasks that are niced +5
> > > or to a higher value is background. In my opinion, nice 5 is not
> > > background, but relatively less cpu. You already are savvy enough to
> > > be using two threads and nicing them. All I ask you to do when using
> > > RSDL is to change your expectations slightly and your settings from
> > > nice 5 to nice 10 or 15 or even 19. Why is that so offensive to you?
> >
> > It's not "offensive" to me, it is a behavioral regression.  The
> > situation as we speak is that you can run cpu intensive tasks while
> > watching eye-candy.  With RSDL, you can't, you feel the non-interactive
> > load instantly.  Doesn't the fact that you're asking me to lower my
> > expectations tell you that I just might have a point?

I do not feel nearly any non-interactive load. See below.

>
> Yet looking at the mainline scheduler code, nice 5 tasks are also supposed
> to get 75% cpu compared to nice 0 tasks, however I cannot seem to get 75%
> cpu with a fully cpu bound task in the presence of an interactive task. To
> me that means mainline is not living up to my expectations. What you're
> saying is your expectations are based on a false cpu expectation from nice
> 5. You can spin it both ways. It seems to me the only one that lives up to
> a defined expectation is to be fair. Anything else is at best vague, and at
> worst starvation prone.
>
> > > Please don't pick 5.none of the above. Please try to work with me on
> > > this.
> >
> > I'm not trying to be pig-headed.  I'm of the opinion that fairness is
> > great... until you strictly enforce it wrt interactive tasks.
>
> How about answering my question then since I offered you numerous
> combinations of ways to tackle the problem? The simplest one doesn't even
> need code, it just needs you to alter the nice value that you're already
> setting.

Also, just to chime in, I am doing a large project converting over 250GB of 
FLAC audio to MP3 via lame for my archive conversion.

I am using 2.6.20.2-rsdl0.30, and I have 2 processes of flac decoding/lame 
encoding running simultaneously from a perl script I hacked up on my P-D 830. 
These processes are both nice'd to 19.

I have almost no degredation in latency in my usage of X (which is at nice 0), 
if that matters at all. Please try what Con is suggesting by adjusting your 
nice level, and see if that helps you at all.

These are just useless arguments, time better spent on coding and fixing real 
problems, than a flamewar on whether nice 5 is good enough or not.

Con's rsdl implements what ingosched was supposed to do, wrt the niceness 
levels. Perhaps Mike, you are used to the impression ingosched gave you with 
nice +5, but try something else as Con suggested.. +10, +15, hell, whatever. 
Is that so hard?

My 2c,
-r

-- 
Rodney "meff" Gordon II -*- meff@pobox.com
Systems Administrator / Coder Geek -*- Open yourself to OpenSource
