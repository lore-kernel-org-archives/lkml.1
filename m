Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbZBSAMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbZBSAMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZBSAMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:12:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:59377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbZBSAMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:12:22 -0500
Date: Thu, 19 Feb 2009 01:12:20 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single ipi fallback for smp_call_function_many())
Message-ID: <20090219001219.GB8627@wotan.suse.de>
References: <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com> <20090217213256.GJ6761@linux.vnet.ibm.com> <20090217214518.GA13189@redhat.com> <20090217223910.GM6761@linux.vnet.ibm.com> <20090218135212.GB23125@wotan.suse.de> <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 08:09:21AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 18 Feb 2009, Nick Piggin wrote:
> > 
> > I agree with you both that we *should* make arch interrupt code
> > do the ordering, but given the subtle lockups on some architectures
> > in this new code, I didn't want to make it significantly weaker...
> > 
> > Though perhaps it appears that I have, if I have removed an smp_mb
> > that x86 was relying on to emit an mfence to serialise the apic.
> 
> The thing is, if the architecture doesn't order IPI wrt cache coherency, 
> then the "smp_mb()" doesn't really do so _either_. 

Oh yes agreed three, which is why I'm saying it is just a hack
and should be removed at some point.

 
> It might hide some architecture-specific implementation issue, of course, 
> so random amounts of "smp_mb()"s sprinkled around might well make some 
> architecture "work", but it's in no way guaranteed. A smp_mb() does not 
> guarantee that some separate IPI network is ordered - that may well take 
> some random machine-specific IO cycle.

Yes, but I didn't want to pull out that smp_mb() at least until
arch maintainers can ack it. Just because there might indeed be
some random issue hidden by it.

