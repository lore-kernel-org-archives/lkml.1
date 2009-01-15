Return-Path: <linux-kernel-owner+w=401wt.eu-S1763412AbZAOSGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763412AbZAOSGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbZAOSGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:06:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbZAOSGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:06:38 -0500
Date: Thu, 15 Jan 2009 19:06:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090115180619.GK22472@elte.hu>
References: <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115174440.GF29283@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jan 14, 2009 at 08:28:11PM +0100, Ingo Molnar wrote:
> >                       [v2.6.14]     [v2.6.29]
> > 
> >                       Semaphores  | Mutexes
> >             ----------------------------------------------
> >                                   | no-spin           spin
> >                                   |
> >   [tmpfs]   ops/sec:       50713  |  291038         392865       (+34.9%)
> >   [ext3]    ops/sec:       45214  |  283291         435674       (+53.7%)
> > 
> > A 10x macro-performance improvement on ext3, compared to 2.6.14 :-)
> > 
> > While lots of other details got changed meanwhile, i'm sure most of 
> > the performance win on this particular VFS workload comes from 
> > mutexes.
> 
> I asked a couple of our benchmarking teams to try -v9.  Neither the OLTP 
> benchmark, nor the kernel-perf test suite found any significant 
> performance change.  I suspect mutex contention isn't a significant 
> problem for most workloads.

basically only VFS is mutex-bound really, and few of the 'benchmarks' tend 
to be VFS intense. Maybe things like mail-server benchmarks would do that.

Also, -v9 is like two days old code ;-) Old and crufty. The real 
performance uptick was not even in -v10 but in -v11 (the one we submitted 
in this thread).

	Ingo
