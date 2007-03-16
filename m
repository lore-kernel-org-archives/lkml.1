Return-Path: <linux-kernel-owner+w=401wt.eu-S1751390AbXCPKKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbXCPKKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbXCPKKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:10:20 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:36000 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbXCPKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:10:18 -0400
Subject: Re: [PATCH 0/3] FUTEX : new PRIVATE futexes, SMP and NUMA
	improvements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703161030.17597.dada1@cosmosbay.com>
References: <20060808070708.GA3931@localhost.localdomain>
	 <200703152010.35614.dada1@cosmosbay.com> <1174032341.7124.9.camel@twins>
	 <200703161030.17597.dada1@cosmosbay.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 11:10:13 +0100
Message-Id: <1174039813.7124.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 10:30 +0100, Eric Dumazet wrote:
> On Friday 16 March 2007 09:05, Peter Zijlstra wrote:
> > On Thu, 2007-03-15 at 20:10 +0100, Eric Dumazet wrote:
> > > Hi
> > >
> > > I'm pleased to present these patches which improve linux futex
> > > performance and scalability, on both UP, SMP and NUMA configs.
> > >
> > > I had this idea last year but I was not understood, probably because I
> > > gave not enough explanations. Sorry if this mail is really long...
> >
> > I started playing with it after your last reference to it, I have some
> > code here (against -rt):
> >   http://programming.kicks-ass.net/kernel-patches/futex-vma-cache/
> >
> > Which I will post once I have the found what keeps pthread_join() from
> > completing :-(
> >
> > It basically adds a per task vma lookup cache which can also activate
> > the private logic without explicit use of the new interface.
> 
> Hi Peter
> 
> I dont think yet another cache will help in the general case.
> A typical program uses many vmas at once...
> 
> glibc has internal futexes, on a different vma than futexes declared in your 
> program. Each shared library is going to have its own vma for its data (and 
> futexes)
> 
> (244 vmas on one kmail program for example)

Yeah, I was just hoping a few cache entries would be enough to get the
worst of them. A benchmark will have to tell I guess.

> About your guess_futex_shared() thing, I miss the vma_anon() definition.

http://programming.kicks-ass.net/kernel-patches/futex-vma-cache/vma_cache.patch

> But if it has to walk the vmas (and take mmap_sem), you already loose the 
> PRIVATE benefit.

It doesn't take mmap_sem, I am aware of the problems.

