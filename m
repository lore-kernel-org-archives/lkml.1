Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbXG1SFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbXG1SFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 14:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXG1SFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 14:05:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbXG1SFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 14:05:45 -0400
Date: Sat, 28 Jul 2007 11:05:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Jonathan Jessup <jonathanjessup@gmail.com>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <Pine.LNX.4.64.0707281927500.15125@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.999.0707281050590.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost>  <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
  <Pine.LNX.4.63.0707280817540.27758@alpha.polcom.net>
 <954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com>
 <alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707281927500.15125@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Jan Engelhardt wrote:
> 
> You cannot please everybody in the scheduler question, that is clear,
> then why not offer dedicated scheduling alternatives (plugsched comes to mind)
> and let them choose what pleases them most, and handles their workload best?

This is one approach, but it's actually one that I personally think is  
often the worst possible choice. 

Why? Because it ends up meaning that you never get the cross-pollination 
from different approaches (they stay separate "modes"), and it's also 
usually really bad for users in that it forces the user to make some 
particular choice that the user is usually not even aware of.

So I personally think that it's much better to find a setup that works 
"well enough" for people, without having modal behaviour. People complain 
and gripe now, but what people seem to be missing is that it's a journey, 
not an end-of-the-line destination. We haven't had a single release kernel 
with the new scheduler yet, so the only people who have tried it are 
either

 (a) interested in schedulers in the first place (which I think is *not* a 
     good subset, because they have very specific expectations of what is 
     right and what is wrong, and they come into the whole thing with that 
     mental baggage)

 (b) people who test -rc1 kernels (I love you guys, but sadly, you're not 
     nearly as common as I'd like ;)

so the fact is, we'll find out more information about where CFS falls 
down, and where it does well,  and we'll be able to *fix* it and tweak it.

In contrast, if you go for a modal approach, you tend to always fixate 
those two modes forever, and you'll never get something that works well: 
people have to switch modes when they switch workloads.

[ This, btw, has nothing to do with schedulers per se. We have had these 
  exact same issues in the memory management too - which is a lot more 
  complex than scheduling, btw. The whole page replacement algorithm is 
  something where you could easily have "specialized" algorithms in order 
  to work really well under certain loads, but exactly as with scheduling, 
  I will argue that it's a lot better to be "good across a wide swath of 
  loads" than to try to be "perfect in one particular modal setup". ]

This is also, btw, why I think that people who argue for splitting desktop 
kernels from server kernels are total morons, and only show that they 
don't know what the hell they are talking about.

The fact is, the work we've done on server loads has improved the desktop 
experience _immensely_, with all the scalability work (or the work on 
large memory configurations, etc etc) that went on there, and that used to 
be totally irrelevant for the desktop.

And btw, the same is very much true in reverse: a lot of the stuff that 
was done for desktop reasons (hotplug etc) has been a _huge_ boon for the 
server side, and while there were certainly issues that had to be resolved 
(the sysfs stuff so central to the hotplug model used tons of memory when 
you had ten thousand disks, and server people were sometimes really 
unhappy), a lot of the big improvements actually happen because somethng 
totally _unrelated_ needed them, and then it just turns out that it's good 
for the desktop too, even if it started out as a server thing or vice 
versa.

This is why the whole "modal" mindset is stupid. It basically freezes a 
choice that shouldn't be frozen. It sets up an artificial barrier between 
two kinds of uses (whether they be about "server" vs "desktop" or "3D 
gaming" vs "audio processing", or anything else), and that frozen choice 
actually ends up being a barrier to development in the long run.

So "modal" things are good for fixing behaviour in the short run. But they 
are a total disaster in the long run, and even in the short run they tend 
to have problems (simply because there will be cases that straddle the 
line, and show some of _both_ issues, and now *neither* mode is the right 
one)

			Linus
