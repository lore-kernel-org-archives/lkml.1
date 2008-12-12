Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbYLLSOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbYLLSOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757915AbYLLSOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:14:11 -0500
Received: from smtpauth01.csee.onr.siteprotect.com ([64.26.60.145]:51840 "EHLO
	smtpauth01.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757721AbYLLSOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:14:10 -0500
Date: Fri, 12 Dec 2008 13:18:32 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
In-Reply-To: <1229070345.12883.12.camel@twins>
Message-ID: <Pine.LNX.4.64.0812121307090.26207@pianoman.cluster.toy>
References: <20081211155230.GA4230@elte.hu>  <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
 <1229070345.12883.12.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 12 Dec 2008, Peter Zijlstra wrote:
> On Thu, 2008-12-11 at 13:02 -0500, Vince Weaver wrote:
>
>> Perfmon3 works for all of those 60 machines.  This new proposal works on a
>> 2 out of the 60.
>
> s/works/is implemented/

Once you "implement" the new solution for all the machines I listed, it's 
going to be just as bad, if not worse, than current perfmon3.

> So much for constructive critisism.. have you tried taking the design to
> its limits, if so, where do you see problems?

I have a currently working solution in perfmon3.
I need a pretty strong reason to abandon that.

> I read the above as: I invested a lot of time in something of dubious
> statue (out of tree patch), and now expect it to be merged because I
> have invested in it.

perfmon has been around for years.  It's even been in the kernel (in 
Itanium form) for years.  The perfmon patchset has been posted numerous 
time for reviews to the linux-kernel list.  It's not like perfmon was some 
sort of secret project sprung on the world last-minute.

I know the way the Linux kernel development works.  If some other 
performance monitoring implementation does get merged, I will cope and 
move on.  I'm just trying to help avoid a costly mistake.

>> Also, my primary method of using counters is total aggregate count for a
>> single user-space process.
>
> Process, as in single thread, or multi-threaded? I'll assume
> single-thread.

No.  Multi-thread too.

> I'll argue to disagree, sure such events might not be supported by any
> particular hardware implementation - but the fact that PAPI gives a list
> of 'common' events means that they are, well, common. So unifying them
> between those archs that do implement them seems like a sane choice, no?

No.

I do not use PAPI.  PAPI only supports a small subset of counters.

What is needed is a tool for accessing _all_ performance counters on 
various machines.

What is _not_ needed is pushing PAPI into kernel space.

> The proposal allows for you to specify raw hardware events, so you can
> just totally ignore this part of the abstraction.

If you can do raw events, then that's enough.  There's no need to put some 
sort of abstraction level into the kernel.  That way lies madness if 
you've ever looked at any code that tries to do it.

As others have suggested, check out the P4 PMU documentation.

Vince
