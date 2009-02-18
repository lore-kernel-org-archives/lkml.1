Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZBRRQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZBRRQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZBRRPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:15:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbZBRRPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:15:50 -0500
Date: Wed, 18 Feb 2009 09:14:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
 ipi fallback for smp_call_function_many())
In-Reply-To: <20090218170517.GA9769@elte.hu>
Message-ID: <alpine.LFD.2.00.0902180913110.21686@localhost.localdomain>
References: <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com> <20090217213256.GJ6761@linux.vnet.ibm.com> <20090217214518.GA13189@redhat.com> <20090217223910.GM6761@linux.vnet.ibm.com> <20090218135212.GB23125@wotan.suse.de>
 <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain> <20090218162116.GC29863@elte.hu> <alpine.LFD.2.00.0902180828430.21686@localhost.localdomain> <20090218165808.GA9120@elte.hu> <20090218170517.GA9769@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Feb 2009, Ingo Molnar wrote:
>
> an off-list comment pointed out this piece of information as 
> well:
> 
>   http://www.sandpile.org/ia32/coherent.htm
> 
>   A WRMSR to one of the x2APIC MSRs (0000_0800h...0000_0BFFh) is 
>   not guaranteed to be serializing.
> 
> So i suspect we should just enclose it in smp_mb() pairs to make 
> sure it's a full barrier in both directions?

Why would we care about "both directions"?

I think putting an sfence _before_ the wrmsr (and not even all of them - 
just put it in front of the "send IPI" sequence) should be fine. Any other 
ordering sounds like just unnecessary overhead to me.

We do want this to be low-overhead, even if we probably don't care _that_ 
much.

			Linus
