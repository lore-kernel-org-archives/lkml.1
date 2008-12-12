Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYLLJBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYLLJBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757625AbYLLJBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:01:02 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbYLLJBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:01:00 -0500
Subject: Re: [patch] Performance Counters for Linux, v3
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1229071878.12883.15.camel@twins>
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120035i4ba84180p70dd55e203d8035f@mail.gmail.com>
	 <1229071878.12883.15.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Dec 2008 10:00:36 +0100
Message-Id: <1229072436.12883.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 09:51 +0100, Peter Zijlstra wrote:
> On Fri, 2008-12-12 at 09:35 +0100, stephane eranian wrote:
> > Peter,
> > 
> > On Fri, Dec 12, 2008 at 9:25 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >> > +   /*
> > >> > +    * Common hardware events, generalized by the kernel:
> > >> > +    */
> > >> > +   PERF_COUNT_CYCLES               =  0,
> > >> > +   PERF_COUNT_INSTRUCTIONS         =  1,
> > >> > +   PERF_COUNT_CACHE_REFERENCES     =  2,
> > >> > +   PERF_COUNT_CACHE_MISSES         =  3,
> > >> > +   PERF_COUNT_BRANCH_INSTRUCTIONS  =  4,
> > >> > +   PERF_COUNT_BRANCH_MISSES        =  5,
> > >>
> > >> Many machines do not support these counts.  For example, Niagara T1 does
> > >> not have a CYCLES count.  And good luck if you think you can easily come
> > >> up with something meaningful for the various kind of CACHE_MISSES on the
> > >> Pentium 4.  Also, the Pentium D has various flavors of retired instruction
> > >> count with slightly different semantics.  This kind of abstraction should
> > >> be done in userspace.
> > >
> > > I'll argue to disagree, sure such events might not be supported by any
> > > particular hardware implementation - but the fact that PAPI gives a list
> > > of 'common' events means that they are, well, common. So unifying them
> > > between those archs that do implement them seems like a sane choice, no?
> > >
> > > For those archs that do not support it, it will just fail to open. No
> > > harm done.
> > >
> > > The proposal allows for you to specify raw hardware events, so you can
> > > just totally ignore this part of the abstraction.
> > >
> > I believe the cache related events do not belong in here. There is no definition
> > for them. You don't know what cache miss level, what kind of access. You cannot
> > do this even on Intel Core processors.
> 
> I might agree with that, perhaps we should model this to the common list
> PAPI specifies?

http://icl.cs.utk.edu/projects/papi/files/html_man3/papi_presets.html

Has a lot of cache events.

And I can see the use of a set without the L[123] in there, which would
signify either all or the lack of more specific knowledge. Like with
PAPI its perfectly fine to not support these common events on a
particular hardware platform.


