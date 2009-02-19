Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbZBSVvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbZBSVvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758060AbZBSVu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:50:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:59371 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680AbZBSVu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:50:57 -0500
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
 single ipi fallback for smp_call_function_many())
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20090219150619.GB22611@elte.hu>
References: <1234866453.4744.58.camel@laptop>
	 <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com>
	 <20090217213256.GJ6761@linux.vnet.ibm.com>
	 <20090217214518.GA13189@redhat.com>
	 <20090217223910.GM6761@linux.vnet.ibm.com>
	 <20090218135212.GB23125@wotan.suse.de>
	 <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain>
	 <1235026040.8805.3.camel@pasglop> <20090219131107.GD1747@wotan.suse.de>
	 <20090219150619.GB22611@elte.hu>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 08:49:25 +1100
Message-Id: <1235080165.8805.48.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 16:06 +0100, Ingo Molnar wrote:
> > So your arch_send_call_function_single_ipi etc need to ensure 
> > this, right?  Generic code obviously has no idea about how to 
> > do it.
> 
> The thing is, the most widespread way to send IPIs (x86 
> non-x2apic local APIC) does not need any barriers in the generic 
> code or elsewhere, because the local APIC is mapped uncached so 
> it's implicitly ordered.
> 
> So the right solution is to add barriers to those IPI 
> implementations that need it. This means that the generic code 
> should not have a barrier for IPI sending.

I agree. In fact, our current code should be fine in any case because
our writel() which will be used to generate the IPI has a sync in it
anyway for other reasons.

Cheers,
Ben.


