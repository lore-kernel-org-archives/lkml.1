Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbYFIX3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbYFIX3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYFIX3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:29:22 -0400
Received: from ozlabs.org ([203.10.76.45]:35198 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbYFIX3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:29:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Tue, 10 Jun 2008 09:27:48 +1000
User-Agent: KMail/1.9.9
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
References: <20080530035620.587204923@sgi.com> <200806060959.13362.rusty@rustcorp.com.au> <Pine.LNX.4.64.0806091158020.30776@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806091158020.30776@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806100927.48597.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 05:00:36 Christoph Lameter wrote:
> On Fri, 6 Jun 2008, Rusty Russell wrote:
> > > Also, the above cpu_local_wrap(...) adds:
> > >
> > > 	#define cpu_local_wrap(l)               \
> > > 	({                                      \
> > > 	        preempt_disable();              \
> > > 	        (l);                            \
> > > 	        preempt_enable();               \
> > > 	})                                      \
> > >
> > > ... and there isn't a non-preemption version that I can find.
> >
> > Yes, this should be fixed.  I thought i386 had optimized versions
> > pre-merge, but I was wrong (%gs for per-cpu came later, and noone cleaned
> > up these naive versions).  Did you want me to write them?
>
> How can that be fixed? You have no atomic instruction that calculates the
> per cpu address in one go.

Huh?  "incl %fs:varname" does exactly this.

> And as long as that is the case you need to 
> disable preempt. Otherwise you may increment the per cpu variable of
> another processor because the process was rescheduled after the address
> was calculated but before the increment was done.

But of course, that is not a problem.  You make local_t an atomic_t, and then 
it doesn't matter which CPU you incremented.

By definition if the caller cared, they would have had premption disabled.

Hope that clarifies,
Rusty.
