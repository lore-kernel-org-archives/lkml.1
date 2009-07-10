Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZGJJT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZGJJT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZGJJTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:19:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33550 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbZGJJTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:19:10 -0400
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       graydon@redhat.com, fche@redhat.com, Nick Piggin <npiggin@suse.de>,
       cl@linux-foundation.org
In-Reply-To: <alpine.DEB.2.00.0907100158090.13880@chino.kir.corp.google.com>
References: <1247156020.27671.40.camel@debian-nb>
	 <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com>
	 <20090710084745.GA26752@elte.hu>
	 <alpine.DEB.2.00.0907100158090.13880@chino.kir.corp.google.com>
Date: Fri, 10 Jul 2009 12:19:08 +0300
Message-Id: <1247217548.771.10.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, 10 Jul 2009, Ingo Molnar wrote:
> > > SLAB is (slowly) going away so you might want to port this to SLUB 
> > > as well so we can merge both.
> > 
> > and SLQB which will replace both? :-/

On Fri, 2009-07-10 at 02:04 -0700, David Rientjes wrote:
> I'm not sure what the status of slqb is, although I would have expected it 
> to have been pushed for inclusion in 2.6.31 as a slab allocator 
> alternative.  Nick, any forecast for inclusion?

2.6.32 most likely. Nick has fixed a bunch of problems but there's still
one ppc boot time bug that's turning out to be hard to find.

On Fri, 2009-07-10 at 02:04 -0700, David Rientjes wrote:
> SLUB has a pretty noticeable performance degradation on benchmarks such as 
> netperf TCP_RR with high numbers of threads (see my post about it: 
> http://marc.info/?l=linux-kernel&m=123839191416472).  CONFIG_SLAB is the 
> optimal configuration for workloads that share similiar slab thrashing 
> patterns (which my patchset dealt with in an indirect way and yet still 
> didn't match slab's performance).  I haven't yet seen data that suggests 
> anything other than CONFIG_SLAB has parity with such a benchmark.

As I said before, I'm interesting in getting those patches merged. I
think Christoph raised some issues that need to be take care of before
we can do that, no?

			Pekka

