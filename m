Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbXHVA00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbXHVA00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXHVA0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:26:19 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:51778 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007AbXHVA0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:26:18 -0400
Date: Tue, 21 Aug 2007 20:26:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070822002616.GA1400@Krystal>
References: <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com> <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com> <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:16:02 up 23 days, 34 min,  3 users,  load average: 0.34, 0.40, 0.36
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:
> 
> > - Rounding error.. you seem to round at 0.1ms, but I keep the values in
> >   cycles. The times that you get (1.1ms) seems strangely higher than
> >   mine, which are under 1000 cycles on a 3GHz system (less than 333ns).
> >   I guess there is both a ms - ns error there and/or not enough
> >   precision in your numbers.
> 
> Nope the rounding for output is depending on the amount. Rounds to one 
> digit after whatever unit we figured out is best to display.
> 
> And multiplications (cyc2ns) do not result in rounding errors.
> 

Ok, I see now that the 1.1ms was for the 10000 iterations, which makes
it about 230 ns/iteration for the 10000 times kmalloc(8) = 2.3ms test.

As I am going back through the initial cmpxchg_local implementation, it
seems like it was executing __slab_alloc() with preemption disabled,
which is wrong. new_slab() is not designed for that.

I'll try to run my tests on AMD64.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
