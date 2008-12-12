Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbYLLKWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbYLLKWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 05:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYLLKWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 05:22:10 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:30141 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYLLKWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:22:08 -0500
X-BigFish: VPS-38(zz146fK1432R62a3L98dR936eQ1805Mzzzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KBRE4F-02-SCH-01
Date: Fri, 12 Dec 2008 11:21:11 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: eranian@gmail.com, Vince Weaver <vince@deater.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081212102111.GE30490@erda.amd.com>
References: <20081211155230.GA4230@elte.hu> <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy> <1229070345.12883.12.camel@twins> <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com> <1229073834.12883.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1229073834.12883.41.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Dec 2008 10:21:52.0672 (UTC) FILETIME=[737A2A00:01C95C43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.12.08 10:23:54, Peter Zijlstra wrote:
> On Fri, 2008-12-12 at 09:59 +0100, stephane eranian wrote:
> > For instance, people have pointed out that your design necessarily implies
> > pulling into the kernel the event table for all PMU models out there. This
> > is not just data, this is also complex algorithms to assign events to counters.
> > The constraints between events can be very tricky to solve. If you get this
> > wrong, this leads to silent errors, and that is really bad.
> 
> (well, its not my design - I'm just trying to see how far we can push it
> out of sheer curiosity)
> 
> This has to be done anyway, and getting it wrong in userspace is just as
> bad no? 
> 
> The _ONLY_ technical argument I've seen to do this in userspace is that
> these tables and text segments are unswappable in-kernel - which doesn't
> count too heavily in my book.

But, there are also no arguments to implement it not in userspace.

> > Looking at Intel Core, Nehalem, or AMD64 does not reflect the reality of
> > the complexity of this. Paul pointed out earlier the complexity on Power.
> > I can relate to the complexity on Itanium (I implemented all the code in
> > the user level libpfm for them).  Read the Itanium PMU description and I
> > hope you'll understand.
> 
> Again, I appreciate the fact that multi-dimensional constraint solving
> isn't easy. But any which way we turn this thing, it still needs to be
> done.

I agree with Stephane. There are already many different PMU
descriptions depending on family, model and steppping and with *every*
new cpu revision you will get one more update. Implementing this in
the kernel would require kernel updates where otherwise no changes
would be necessary.

If you look at current pmu implementations, there are tons of
descriptions files and code you don't want to have in the kernel.

Also, a profiling tool that needs a certain pmu feature would depend
then on its kernel implementation. (Actually, it is impossible to have
a 100% implementation coverage.) If the pmu could be programmed from
userspace, the tool could provide the feature itself.

> > Events constraints are not going away anytime soon, quite the contrary.
> > 
> > Furthermore, event tables are not always correct. In fact, they are
> > always bogus.
> > Event semantics varies between steppings. New events shows up, others
> > get removed.
> > Constraints are discovered later on.
> > 
> > If you have all of that in the kernel, it means you'll have to
> > generate a kernel patch each
> > time. Even if that can be encapsulated into a kernel module, you will
> > still have problems.
> 
> How is updating a kernel module (esp one that only contains constraint
> tables) more difficult than upgrading a user-space library? That just
> doesn't make sense.

At least this would require a kernel with modules enabled.

> > Furthermore, Linux commercial distribution release cycles do not
> > align well with new processor
> > releases. I can boot my RHEL5 kernel on a Nehalem system and it would
> > be  nice not to have to
> > wait for a new kernel update to get the full Nehalem PMU event table,
> > so I can program more than
> > the basic 6 architected events of Intel X86.
> 
> Talking with my community hat on, that is an artificial problem created
> by distributions, tell them to fix it.

It does not make sense to close the eyes to reality. There are systems
where it is not possible to update the kernel frequently. Probably you
have one running yourself.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

