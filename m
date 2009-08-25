Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZHYKSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZHYKSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZHYKSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:18:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZHYKSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:18:06 -0400
Date: Tue, 25 Aug 2009 12:17:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090825101742.GA26801@elte.hu>
References: <20090822103252.GA32369@elte.hu> <20090822171540.1220f50d@skybase> <20090822153346.GA3313@elte.hu> <19088.47213.327897.703458@cargo.ozlabs.ibm.com> <20090823084740.GA7651@elte.hu> <19090.1800.521794.839576@cargo.ozlabs.ibm.com> <20090824082318.GD2424@elte.hu> <19091.24374.210127.155521@drongo.ozlabs.ibm.com> <20090825082612.GA17692@elte.hu> <19091.46451.893720.573893@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19091.46451.893720.573893@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > If you suggest that each and every subsystem maintainer who 
> > touches code that can be built on non-x86 architectures has to 
> > cross-build to 20+ architectures to be able to push out a tree, 
> > all the time, and has to rebase if this ever gets omitted, you 
> > are really defying reality and are hurting Linux.
> 
> Nice straw man, but I never said or even suggested anything like 
> that. :)

... but what you say in essence amounts to that. Every change to a 
file that is built on an architecture 'affects' that architecture so 
your arguments can be repeated for that one. It's a slippery slope 
built on a wrong premise.

I can only repeat what i said because i did not see you really 
counter the core of my argument (you snipped out much of my mail 
that details this and only replied to the last paragraph):

>> I think there's a fundamental disconnect with reality here.
>> 
>> The thing is, as the maintainer of certain core kernel subsystems 
>> i _have to_ mirror and honor the system usage and hardware 
>> preferences of developers, testers and users. Those are 
>> predominantly x86 based currently. I cross-test to a lot of 
>> architectures because i'm nice but in practice it rarely matters.
>> 
>> (It goes beyond that btw: i try to test more common drivers 
>> within x86 too, etc.)
>> 
>> If you want to change that reality you can do it the old 
>> fashioned, fair way: build cool hardware, send more SDVs to 
>> kernel developers, make PowerPC more widely used, etc.
>> 
>> If i put more effort into testing what nobody uses i'd be doing a 
>> disservice to Linux - i'd disproportionately favor PowerPC just 
>> because you are a squeakier wheel.
>> 
>> I.e. please _earn_ your usage share, dont try to dicate it 
>> artificially ... It does not work the other way, you cannot force 
>> in the kernel space what PowerPC did not manage to achieve in the 
>> marketplace.

We should be (and are) testing what matters and 22 architectures 
must not be allowed to hold core kernel facilities hostage.

( Plus, as i said the current tip of timers/core was problematic for 
  other reasons as well, which amounts to a 'might need to be 
  rebased'. )

> I do think that it's reasonable to expect that a patch which 
> touches the architecture-specific code for some architecture gets 
> compiled for that architecture at least once before it gets set in 
> stone.  As far as I can tell, this didn't happen in the case of 
> Martin's patch that triggered this debate.

I've seen similar arguments for patches that didnt touch any 
architecture files but broke it via some other, less direct way.

Say that patch also touches arch/xtensa/. Can you cross-build to 
xtensa?

> Patches which touch multiple architecture's arch-specific code 
> should also get sent to the maintainers of the affected 
> architectures and the linux-arch mailing list.  I don't recall 
> seeing this patch on linux-arch, though I may have missed it (and 
> anyway that would be Martin's responsibility not yours, but it 
> does contribute to the sense of being blindsided).
> 
> More generally - if you don't have the resources to do regular 
> build testing for powerpc or other architectures, then publish a 
> testing branch and we'll get kisskb 
> (http://kisskb.ellerman.id.au/) to build a selection of configs 
> and architectures automatically.

Slowing down patches via buerocracy like that is not acceptable at 
all. Make developers care more about your architecture via natural 
means, not via buerocratic measures.

	Ingo
