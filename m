Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYLIAWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYLIAWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 19:22:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYLIAVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 19:21:52 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:65524 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYLIAVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 19:21:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=PX1fAP0VQ8xvycIJKEDhk279yQxZkdwwMf/N50V0AJ00o1onIBOA+uEADqRPsdoe6z
         CKl04zxH1VZj2uAPkkFCKo0wHZKvKQ6ovmFHaYCwT3qBy2H9ZfW7WN3Oq1GFYTgWNQsm
         aa4s5kyakrOubQfTU0kTACoA7NMG+P3uTLEdA=
Message-ID: <7c86c4470812081621u7f4ca1bax20300f7b0f522625@mail.gmail.com>
Date: Tue, 9 Dec 2008 01:21:48 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Cc: "Paul Mackerras" <paulus@samba.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "Steven Rostedt" <rostedt@goodmis.org>,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <20081208111153.GA12377@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	 <18744.56857.259756.129894@cargo.ozlabs.ibm.com>
	 <20081205080813.GA2030@elte.hu>
	 <18744.61429.548462.667020@cargo.ozlabs.ibm.com>
	 <20081205120734.GA26244@elte.hu>
	 <18745.49593.567217.277510@cargo.ozlabs.ibm.com>
	 <1228566879.16244.4.camel@lappy.programming.kicks-ass.net>
	 <18747.23509.977047.540995@cargo.ozlabs.ibm.com>
	 <7c86c4470812072318n33e27045k50490f180ecfd8c0@mail.gmail.com>
	 <20081208111153.GA12377@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 12:11 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * stephane eranian <eranian@googlemail.com> wrote:
>
>> Let me explain the HW complexity a bit. It's all a matter of tradeoffs.
>> I have regular discussions with the PMU design architects about this.
>> If you talk to them, then you understand the environment they have to
>> live in and you understand why those constraints are there. The key
>> point to understand is that the PMU is never critical to the chip. The
>> chip can work well without. The real-estate on the chip is always very
>> tight. PMU is a 2nd class citizen, thus low in the priority list. [...]
>
> The chip designers i talk to with my scheduler maintainer hat on do point
> out that performance monitoring is (of course) in the critical path of
> any chip, and hence its overhead and impact on the gate count of various
> critical components of the CPU core and its impact on the power envelope
> must be kept very low.
>

You have a talent for turning people's argument into something else.

You dropped my example about the wire limitation. It was describing my point
about constraints and PMU as 2nd class citizen. I'd rather have a new
constrained
PMU feature that no new feature at all. You also seem to limit your
world to x86,
you have to look beyond like Itanium and Power, for instance.

I know quite well that the PMU is used for debugging internally and early on,
so don't lecture me on this! I have participated in the architectural design of
some.

> Nevertheless, the same chip designers rely on performance counters on a
> daily basis to plan their next-gen chip. They very much want them to work
> fine, and they work hard on making them relevant and easy to use. Often
> the performance counters are the _only_ real cheap hands-on insight into
> the dynamic situation of a modern CPU core, even for hw designers.
>
Like, I did not know that?

> And all the current hw trends show that it's not just talk but action as
> well: the Core2 PMCs are already much saner (less constrained) than the
> P4 ones, and now they even expanded on them: Nehalem / Core i7 doubled
> the number of generic PMCs from two to four.
>

You think I am not aware of that?I know that quite well because I talk to the
PMU architects on a regular basis trying to get them to add new features and
make the PMU easier to manage. And I make sure I broaden my horizon
beyond x86.

And yes, the PMU is becoming more and more critical and a true-value add.
That's good for end-users as long as the new features can be exposed.

> So, contrary to your suggestion, chip designers very much care about

You did not get my point, but I am not surprised...

> performance counters and they are working very hard to make this stuff
> useful to us. [ Yes, there are constraints even with generic counters
> (for example you only want a single line towards a PMC register from
> divider units), but the number of cross-counter constraints and their
> relevance is decreasing, not increasing. ]
>
> Anyway ... i think your reply highlights why the fundamental premise of
> your patchset is so wrong: i believe you have designed your code and APIs
> at the wrong level by (paradoxically) assuming in essence that
> performance counters do not matter in the general scheme of things. (!)
>
> So you introduced limited, special-purpose but still quite complex APIs

That's not a valid argument! Perfmon, unlike any other existing API, has
exposed all advanced features of all existing PMU models and across
multiple architectures.

> that tailored the ABIs to intricate low level details of PMUs. I see an
> explosion in complexity due to that incorrect design choice: too many

You current API does not offer access to any of the advanced features of
X86, like PEBS, IBS, LBR and others,  let alone on the other architectures.
So again your arguments are unfounded.

> syscalls, too broad interaction between core code and architecture code,
> and too little practical utility in the end.
>

I think the number of syscalls is irrelevant, that's not how I measure
the usefulness of an API.
What matters is the functionalities. Any performance monitoring API should have:
   - create a session
   - program the registers
   - start and stop on demand and has many times as you want
   - attach to a thread or CPU
   - read the register values
   - advanced support for event-based sampling

> We did what we believe to be the right thing: we gave performance
> counters the proper high-level abstraction they _deserve_, and we made
> performance counters a prime-time Linux citizen as well.
>
You have no validation to prove you chose the right level.

As if the perfmon project did not put the PMU on the forefront.
Who is going to buy that?
