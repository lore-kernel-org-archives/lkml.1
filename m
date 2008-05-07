Return-Path: <linux-kernel-owner+w=401wt.eu-S1762503AbYEGVlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762503AbYEGVlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYEGVlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:41:40 -0400
Received: from www.tglx.de ([62.245.132.106]:51695 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYEGVlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:41:37 -0400
Date: Wed, 7 May 2008 23:41:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <48221AE3.6020602@keyaccess.nl>
Message-ID: <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Rene Herman wrote:
> On 07-05-08 22:52, Thomas Gleixner wrote:
> 
> > > And why do we need this clear_cpu_cap(c, X86_FEATURE_PAT) and then manual
> > > setting of X86_FEATURE_PAT at all?
> > 
> > The reason is to make cpu_has_pat a useful check and to avoid checking
> > cpu vendors, families and models inside of the PAT code. That's a good
> > thing actually, because the PAT code only cares about that cpu_has_pat
> > flag.
> > 
> > Clearing it in the cpuinfo is just a cosmetic side effect which does
> > no harm at all.
> 
> Oh yes, it does. It makes people unaware that their CPUs _should_ be
> supporting PAT. The thing's not called /proc/kernelinfo for a reason.

it's named /proc/cpuinfo and this unawareness of the until now not
utilized PAT feature is the least of our worries vs. PAT

> > > And this patch (by the author of the code himself) is the first time where
> > > it breaks.
> > 
> > Very interesting analysis. What broke ? This CPU was never in the set
> > of supported ones at all.
> 
> You misunderstood. Yinghai's patch only changed one of the code sites
> and not the others, which (if I understood right) is the breakage
> Adrian was reffering to.

I know exactly what he was referring to. So what's the problem ?

Yinghai missed to add it to the other place and he is hardly to blame
for that. This code is messy and thats not his fault. It will be
cleaned up, but that's not an simple taks to do. If you think you can
do it without breaking tons of systems, you're welcome.
 
> > Anyway, you are welcome to review x86 code - it can definitely use more
> > eyeballs, but please try to inform yourself about the topic or ask polite
> > questions before yelling at people who contribute in a very valuable way.
> 
> And would yelling at people how shuffle in code without (publicly at
> least) addressing one of your fellow arch maintainers objections

1) hpa asked a question http://lkml.org/lkml/2008/3/25/118
2) his question was answered http://lkml.org/lkml/2008/3/25/292
3) hpa did not object (no lkml ref, because there is none)

So what's your point ? Throwing factoids into a discussion is
not really helpful.

> and Pavel's review comments about code duplication without a single
> line of explanation/changelog do?

As I said before. The changelog is useless and Adrians point about
that is completely correct. 

Thanks,

	tglx
