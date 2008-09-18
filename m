Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYIRVUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYIRVUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYIRVUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:20:07 -0400
Received: from waste.org ([66.93.16.53]:35592 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbYIRVUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:20:06 -0400
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <48D2ABFD.3040103@goop.org>
References: <20080910121217.GA16013@elte.hu>
	 <20080910144812.GB18644@wotan.suse.de>
	 <1221058864.30429.291.camel@twins.programming.kicks-ass.net>
	 <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu>
	 <20080914073906.GA6184@elte.hu>
	 <20080914004442.4f8e851f.akpm@linux-foundation.org>
	 <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de>
	 <20080917131419.e6b7622e.akpm@linux-foundation.org>
	 <20080918111226.GD29968@elte.hu>  <48D2ABFD.3040103@goop.org>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 14:11:50 -0700
Message-Id: <1221772310.4779.29.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-09-18 at 12:29 -0700, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > in 7 days that's about 7000 random bootups, 20% of which had TINY_SHMEM 
> > enabled, half 32-bit, half 64-bit x86. It did not blow up in any way 
> > that would have prevented the kernel from building its next random 
> > version from within itself and it did not produce any kernel messages 
> > with various random kernel debug, compile and boot options.
> >   
> 
> Does anything in that workload actually use shared memory?

[adding Dave]

For the record, Hugh tracked down the history of this bug and it went
something like this:

- I forked shmem.c and trimmed it down, keeping the function in question
intact
- Dave Hansen made divergent changes to shmem and tiny-shmem for reasons
that aren't immediately obvious
- Al Viro fixed a resultant dput bug
- Nick fixed a resultant deadlock bug by undoing the divergence

As far as Hugh and I can see, there was no reason for the divergent
change. Really, we should probably re-unify the files to prevent such
further confusion.

-- 
Mathematics is the supreme nostalgia of our time.

