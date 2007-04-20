Return-Path: <linux-kernel-owner+w=401wt.eu-S1031187AbXDTAU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031187AbXDTAU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 20:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031164AbXDTAU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 20:20:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:48426 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031141AbXDTAUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 20:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gidDU6kb0qbRFdtWa1XRQJNdpTiZRnjSYblPbhFpYgtRDXLNkickj0tpIPKvddR4i1EenRto+u8SZnYkiwIcKiSqpBiM0Ls+zh6PU8yiKYcg9Mi7mSZKvo/If99uqTixeCTxQ6AabIjoPAqv8zFZ0WLv7I5WT3DXk5GgC3uu+K8=
Message-ID: <f2b55d220704191720k761ffce2qa8cdb4cb58cc8c79@mail.gmail.com>
Date: Thu, 19 Apr 2007 17:20:53 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: Renice X for cpu schedulers
Cc: ray-gmail@madrabbit.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Mike Galbraith" <efault@gmx.de>, "ck list" <ck@vds.kolivas.org>,
       "Bill Huey" <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200704200856.06387.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417062621.GL2986@holomorphy.com>
	 <200704192159.35546.kernel@kolivas.org>
	 <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com>
	 <200704200856.06387.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Con Kolivas <kernel@kolivas.org> wrote:
> The cpu scheduler core is a cpu bandwidth and latency
> proportionator and should be nothing more or less.

Not really.  The CPU scheduler is (or ought to be) what electric
utilities call an economic dispatch mechanism -- a real-time
controller whose goal is to service competing demands cost-effectively
from a limited supply, without compromising system stability.

If you live in the 1960's, coal and nuclear (and a little bit of
fig-leaf hydro) are all you have, it takes you twelve hours to bring
plants on and off line, and there's no live operational control or
pricing signal between you and your customers.  So you're stuck
running your system at projected peak + operating margin, dumping
excess power as waste heat most of the time, and browning or blacking
people out willy-nilly when there's excess demand.  Maybe you get to
trade off shedding the loads with the worst transmission efficiency
against degrading the customers with the most tolerance for brownouts
(or the least regulatory clout).  That's life without modern economic
dispatch.

If you live in 2007, natural gas and (outside the US) better control
over nuclear plants give you more ability to ramp supply up and down
with demand on something like a 15-minute cycle.  Better yet, you can
store a little energy "in the grid" to smooth out instantaneous demand
fluctuations; if you're lucky, you also have enough fast-twitch hydro
(thanks, Canada!) that you can run your coal and lame-ass nuclear very
close to base load even when gas is expensive, and even pump water
back uphill when demand dips.  (Coal is nasty stuff and a worse
contributor by far to radiation exposure than nuclear generation; but
on current trends it's going to last a lot longer than oil and gas,
and it's a lot easier to stockpile next to the generator.)

Best of all, you have industrial customers who will trade you live
control (within limits) over when and how much power they take in
return for a lower price per unit energy.  Some of them will even dump
power back into the grid when you ask them to.  So now the biggest
challenge in making supply and demand meet (in the short term) is to
damp all the different ways that a control feedback path might result
in an oscillation -- or in runaway pricing.  Because there's always
some asshole greedhead who will gamble with system stability in order
to game the pricing mechanism.  Lots of 'em, if you're in California
and your legislature is so dumb, or so bought, that they let the
asshole greedheads design the whole system so they can game it to the
max.  (But that's a whole 'nother rant.)

Embedded systems are already in 2007, and the mainline Linux scheduler
frankly sucks on them, because it thinks it's back in the 1960's with
a fixed supply and captive demand, pissing away "CPU bandwidth" as
waste heat.  Not to say it's an easy problem; even academics with a
dozen publications in this area don't seem to be able to model energy
usage to the nearest big O, let alone design a stable economic
dispatch engine.  But it helps to acknowledge what the problem is:
even in a 1960's raised-floor screaming-air-conditioners
screw-the-power-bill machine room, you can't actually run a
half-decent CPU flat out any more without burning it to a crisp.

You can act ignorant and let the PMIC brown you out when it has to.
Or you can start coping in mainline the way that organizations big
enough (and smart enough) to feel the heat in their pocketbooks do in
their pet kernels.  (Boo on Google for not sharing, and props to IBM
for doing their damnedest.)  And guess what?  The system will actually
get simpler, and stabler, and faster, and easier to maintain, because
it'll be based on a real theory of operation with equations and things
instead of a bunch of opaque, undocumented shotgun heuristics.

This hypothetical economic-dispatch scheduler will still _have_
heuristics, of course -- you can't begin to model a modern CPU
accurately on-line.  But they will be contained in _data_ rather than
_code_, and issues of numerical stability will be separated cleanly
from the rule set.  You'll be able to characterize the rule set's
domain of stability, given a conservative set of assumptions about the
feedback paths in the system under control, with the sort of
techniques they teach in the engineering schools that none of us (me
included) seem to have attended.  (I went to school thinking I was
going to be a physicist.  Wishful thinking -- but I was young and
stupid.  What's your excuse?  ;-)

OK, it feels better to have that off my chest.  Apologies to those
readers -- doubtless the vast majority of LKML, including everyone
else in this thread -- for whom it's irrelevant, pseudo-learned
pontification with no patch attached.  And my sincere thanks to Ingo,
Con, and really everyone else CC'ed, without whom Linux wouldn't be as
good as it is (really quite good, all things considered) and wouldn't
contribute as much as it does to my own livelihood.

Cheers,
- Michael
