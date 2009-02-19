Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbZBSMaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbZBSMaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZBSMaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:30:06 -0500
Received: from ns.suse.de ([195.135.220.2]:48029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbZBSMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:30:04 -0500
Date: Thu, 19 Feb 2009 13:29:57 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single ipi fallback for smp_call_function_many())
Message-ID: <20090219122957.GB1747@wotan.suse.de>
References: <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <1234923702.29823.7.camel@vayu> <20090218135945.GC23125@wotan.suse.de> <1234982620.29823.22.camel@vayu> <20090218191757.GD8889@elte.hu> <1235001314.14523.2.camel@vayu> <20090219122031.GC1703@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219122031.GC1703@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 01:20:31PM +0100, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > On Wed, 2009-02-18 at 11:17 -0800, Ingo Molnar wrote: 
> > > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > > So what should happen is to move that smp_mb() from the x86 
> > > generic IPI path to the x86 x2apic IPI path. (and turn it into 
> > > an smp_wmb() - that should be enough - we dont care about future 
> > > reads being done sooner than this point.)
> > 
> > Ingo, smp_wmb() won't help. x2apic register writes can still 
> > go ahead of the sfence. According to the SDM, we need a 
> > serializing instruction or mfence. Our internal experiments 
> > also proved this.
> 
> ah, yes - i got confused about how an x2apic write can pass a 
> _store_ fence.

And about how smp_wmb() doesn't emit a store fence ;)

