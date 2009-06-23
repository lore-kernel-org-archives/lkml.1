Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZFWGTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZFWGTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZFWGTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:19:44 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:40669 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZFWGTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:19:44 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [perfmon2] IV.3 - AMD IBS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rob Fowler <rjf@renci.org>
Cc: Ingo Molnar <mingo@elte.hu>, eranian@gmail.com,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <4A3F9062.6000303@renci.org>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622120018.GR24366@elte.hu>  <4A3F9062.6000303@renci.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 08:19:47 +0200
Message-Id: <1245737987.19816.1477.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 10:08 -0400, Rob Fowler wrote:
> Ingo Molnar wrote:
> >> 3/ AMD IBS
> >>
> >> How is AMD IBS going to be implemented?
> >>
> >> IBS has two separate sets of registers. One to capture fetch
> >> related data and another one to capture instruction execution
> >> data. For each, there is one config register but multiple data
> >> registers. In each mode, there is a specific sampling period and
> >> IBS can interrupt.
> >>
> >> It looks like you could define two pseudo events or event types
> >> and then define a new record_format and read_format. That formats
> >> would only be valid for an IBS event.
> >>
> >> Is that how you intend to support IBS?
> > 
> > That is indeed one of the ways we thought of, not really nice, but
> > then, IBS is really weird, what were those AMD engineers thinking
> > :-)
> 
> Actually, IBS has roots in DEC's "ProfileMe" for Alpha EV67 and later
> processors.   Those of us who used it there found it to be an extremely
> powerful, low-overhead mechanism for directly collecting information about
> how well the micro-architecture is performing.  In particular, it can tell
> you, not only which instructions take a long time to traverse the pipe, but
> it also tells you which instructions delay other instructions and by how much.
> This is extremely valuable if you are either working on instruction scheduling
> in a compiler, or are modifying a program to give the compiler the opportunity
> to do a good job.
> 
> A core group of engineers who worked on Alpha went on to AMD.
> 
> An unfortunate problem with IBS on AMD is that good support isn't common in the "mainstream"
> open source community.

The 'problem' I have with IBS is that its basically a cycle counter
coupled with a pretty arbitrary number of output dimensions separated
into two groups, ops and fetches.

This is a very weird configuration in that it has a miss-match with the
traditional one value per counter thing.

The most natural way to support IBS would be to have a special sampling
cycle counter and use that as group lead and add non sampling siblings
to that group to get individual elements.

This is however quite cumbersome.

One thing to consider when building an IBS interface is its future
extensibility. In which fashion would IBS be extended?, additional
output dimensions or something else all-together?

