Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYITCTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYITCTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 22:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYITCSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 22:18:53 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48554 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYITCSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 22:18:52 -0400
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <1221772310.4779.29.camel@calx>
References: <20080910121217.GA16013@elte.hu>
	 <20080910144812.GB18644@wotan.suse.de>
	 <1221058864.30429.291.camel@twins.programming.kicks-ass.net>
	 <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu>
	 <20080914073906.GA6184@elte.hu>
	 <20080914004442.4f8e851f.akpm@linux-foundation.org>
	 <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de>
	 <20080917131419.e6b7622e.akpm@linux-foundation.org>
	 <20080918111226.GD29968@elte.hu>  <48D2ABFD.3040103@goop.org>
	 <1221772310.4779.29.camel@calx>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 19:18:39 -0700
Message-Id: <1221877119.8533.2.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-18 at 14:11 -0700, Matt Mackall wrote:
> On Thu, 2008-09-18 at 12:29 -0700, Jeremy Fitzhardinge wrote:
> > Ingo Molnar wrote:
> > > in 7 days that's about 7000 random bootups, 20% of which had TINY_SHMEM 
> > > enabled, half 32-bit, half 64-bit x86. It did not blow up in any way 
> > > that would have prevented the kernel from building its next random 
> > > version from within itself and it did not produce any kernel messages 
> > > with various random kernel debug, compile and boot options.
> > >   
> > 
> > Does anything in that workload actually use shared memory?
> 
> [adding Dave]
> 
> For the record, Hugh tracked down the history of this bug and it went
> something like this:
> 
> - I forked shmem.c and trimmed it down, keeping the function in question
> intact
> - Dave Hansen made divergent changes to shmem and tiny-shmem for reasons
> that aren't immediately obvious

Man, my memory sucks.  All I see that 'git blame' can pin on me are some
of the i_nlink helper additions.  Those weren't made in tiny-shmem.c
simply because it doesn't manipulate i_nlink like shmem.c does.  Was
there something else you had in mind?

-- Dave

