Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927Ab0ARNe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab0ARNe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244Ab0ARNe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:34:56 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57295 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0ARNew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:34:52 -0500
Date: Mon, 18 Jan 2010 19:04:45 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
       utrace-devel <utrace-devel@redhat.com>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100118133444.GA23680@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4B53661A.9090907@redhat.com> <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com> <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com> <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com> <1263816857.4283.381.camel@laptop> <4B5455FF.7010409@redhat.com> <1263820551.4283.499.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263820551.4283.499.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 02:15:51PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 14:37 +0200, Avi Kivity wrote:
> > On 01/18/2010 02:14 PM, Peter Zijlstra wrote:
> > >
> > >> Well, the alternatives are very unappealing.  Emulation and
> > >> single-stepping are going to be very slow compared to a couple of jumps.
> > >>      
> > > With CPL2 or RPL on user segments the protection issue seems to be
> > > manageable for running the instructions from kernel space.
> > >    
> > 
> > CPL2 gives unrestricted access to the kernel address space; and RPL does 
> > not affect page level protection.  Segment limits don't work on x86-64.  
> > But perhaps I missed something - these things are tricky.
> 
> So setting RPL to 3 on the user segments allows access to kernel pages
> just fine? How useful.. :/
> 
> > It should be possible to translate the instruction into an address space 
> > check, followed by the action, but that's still slower due to privilege 
> > level switches.
> 
> Well, if you manage to do the address validation you don't need the priv
> level switch anymore, right?
> 
> Are the ins encodings sane enough to recognize mem parameters without
> needing to know the actual ins?
> 
> How about using a hw-breakpoint to close the gap for the inline single
> step? You could even re-insert the int3 lazily when you need the
> hw-breakpoint again. It would consume one hw-breakpoint register for
> each task/cpu that has probes though..
>

A very scarce resource that it is, well, sometimes all that we might have
is just one hw-breakpoint register (like older PPC64 with 1 IABR) in the
system. If one process/thread consumes it, then all other contenders (from
both kernel and user-space) are prevented from acquiring it.

Also to mention the existence of processors with no support for
instruction breakpoints.

Thanks,
K.Prasad

