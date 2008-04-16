Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbYDPOsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbYDPOsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765510AbYDPOsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:48:17 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:59598 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765397AbYDPOsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:48:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAEKuBUhMROPA/2dsb2JhbACBYK03
Date: Wed, 16 Apr 2008 10:48:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080416144814.GA15554@Krystal>
References: <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu> <20080415134705.GB22351@Krystal> <20080415164814.GA15842@elte.hu> <20080415213832.GC7873@Krystal> <20080416131751.GI6304@elte.hu> <20080416064630.22428aea@laptopd505.fenrus.org> <20080416140009.GA13968@Krystal> <20080416072416.7b9ff3d2@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080416072416.7b9ff3d2@laptopd505.fenrus.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:46:43 up 47 days, 10:57,  4 users,  load average: 0.79, 0.49,
	0.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Wed, 16 Apr 2008 10:00:09 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> 
> > > > > If we want to support NMI context and have the ability to
> > > > > instrument preemptable code without too much headache, we must
> > > > > insure that every modification will leave the code in a
> > > > > "correct" state and that we do not grow the size of any
> > > > > reachable instruction.  Also, we must insure gcc did not put
> > > > > code between these instructions. Modifying non-relocatable
> > > > > instructions would also be a pain, since we would have to deal
> > > > > with instruction pointer relocation in the breakpoint code when
> > > > > the code modification is being done.
> > > 
> > > you also need to make sure no cpu is executing that code ever.. 
> > > but you already deal with that right?
> > > 
> > 
> > By "insure that every modification will leave the code in a "correct"
> > state", I mean that at any given time before, during or after the code
> > modification, if an NMI comes on any CPU and try to run the modified
> > code, it should have a valid version of the code to execute. Does it
> > make more sense ?
> 
> I understand your words. My concern is that I don't quite understand how you
> guarantee that you'll not be executing the code you're modifying.
> Just saying "it's consistent before and after" sounds nice but probably isn't
> enough to be safe.
> 
Ah, I see. I insert a breakpoint and execute a bypass rather than the
code being modified. I only put back the 1st instruction byte after the
rest of the instruction has been modified.

> 
> 
> > Not only does the compare and jmp need to be consecutive, but the movb
> > $0x0,%al also does. I *could* try to detect specific code inserted in
> > between, but I really have to make sure I don't get burned by the
> > compiler inserting a jmp there.
> 
> I wonder if just sticking in 2 barriers around your code make gcc stop moving stuff too much
> 

I'm not sure people would like the side-effect for the rest of
optimizations, but it should be tried.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
