Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbYLIUSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbYLIUSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYLIUR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:17:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYLIUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:17:57 -0500
Date: Tue, 9 Dec 2008 15:17:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Gregory Haskins <ghaskins@novell.com>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [ANNOUNCE] The -rt git tree
In-Reply-To: <3efb10970812091206l2e6a17a6tc475a57b942cd28f@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812091511300.19875@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812090946210.16798@gandalf.stny.rr.com>  <c62985530812090908i38c5a7bflcbbcce6c8b9cd2f9@mail.gmail.com>  <alpine.DEB.1.10.0812091248020.19115@gandalf.stny.rr.com> <3efb10970812091206l2e6a17a6tc475a57b942cd28f@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Dec 2008, Remy Bohmer wrote:

> Hello Steven,
> 
> It all sounds good!
> 
> But, I was wondering, why using the scripts to convert the spinlocks
> over and over, instead of pushing only the new lock API to mainline
> asap? That would save a lot of conversion complexity and sounds like
> migrating the RT patch to mainline much easier. It sounds to me like a
> major rename action, and as long as there is only a spinlock behind
> the new API, there is a very low risk in breaking things.
> Later on the rt-mutex can be integrated behind the new API. In the
> mean time everybody can get used to the new locking API.
> That would save complexity and improve stability of the rt-patchset,
> because it does not need to be figured out over and over if there are
> new locks in new code that need to be converted back to spinlocks...
> (In fact we only need to focus from there on new code that use the
> spinlock API, and if it is really required to use that.)
> 

Hi Remy,

Thanks!  And you have caught on to our plan ;-)  This is actually why we 
have the scripts. My plan was to start introducing the new API slowly over 
time, but in the mean time, the RT tree will keep the script to convert 
all the rest that we want to the new locks. Eventually (hopefully), all 
the locks in mainline will be the same as the locks in the rt git tree. 
When that happens, we will not need these scripts anymore.

The rt git tree is a place to start testing the waters of the new API. 
With this exposure, other developers will start understanding what it is 
made for.

One thing we want in mainline before we use this is interrupts as threads. 
This will first start out as drivers having their own interrupt threads, 
and eventually we can get rid of the need for softirqs and tasklets.  Then 
we could have a option to turn all interrupts into threads as RT does. If 
we do that, then the new lock API could be used even more immediately. It 
could then be used to convert locks that are spinlocks only because they 
are shared with an interrupt. The lock_t type could be changed to a mutex 
when interrupts are threads and spinlocks otherwise.

But first we need to take it slowly. And this git tree is the first step.

-- Steve

