Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZBRSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZBRSfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZBRSfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:35:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:13622 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150AbZBRSfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:35:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,230,1233561600"; 
   d="scan'208";a="111955301"
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
	single ipi fallback for smp_call_function_many())
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       asit.k.mallick@intel.com
In-Reply-To: <alpine.LFD.2.00.0902180913110.21686@localhost.localdomain>
References: <20090217112657.GE26402@wotan.suse.de>
	 <20090217192810.GA4980@redhat.com>
	 <20090217213256.GJ6761@linux.vnet.ibm.com>
	 <20090217214518.GA13189@redhat.com>
	 <20090217223910.GM6761@linux.vnet.ibm.com>
	 <20090218135212.GB23125@wotan.suse.de>
	 <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain>
	 <20090218162116.GC29863@elte.hu>
	 <alpine.LFD.2.00.0902180828430.21686@localhost.localdomain>
	 <20090218165808.GA9120@elte.hu> <20090218170517.GA9769@elte.hu>
	 <alpine.LFD.2.00.0902180913110.21686@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 18 Feb 2009 10:33:46 -0800
Message-Id: <1234982026.29823.17.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 09:14 -0800, Linus Torvalds wrote:
> 
> On Wed, 18 Feb 2009, Ingo Molnar wrote:
> >
> > an off-list comment pointed out this piece of information as 
> > well:
> > 
> >   http://www.sandpile.org/ia32/coherent.htm
> > 
> >   A WRMSR to one of the x2APIC MSRs (0000_0800h...0000_0BFFh) is 
> >   not guaranteed to be serializing.
> > 
> > So i suspect we should just enclose it in smp_mb() pairs to make 
> > sure it's a full barrier in both directions?
> 
> Why would we care about "both directions"?

on x86 we don't need in both directions.

> 
> I think putting an sfence _before_ the wrmsr (and not even all of them - 
> just put it in front of the "send IPI" sequence) should be fine. Any other 
> ordering sounds like just unnecessary overhead to me.

For x2apic ipi's, we should use a serializing instruction or a "mfence"
instruction. "sfence" will not help in this scenario.

thanks,
suresh

