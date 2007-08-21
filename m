Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbXHUXXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbXHUXXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbXHUXXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:23:24 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:65319 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092AbXHUXXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:23:23 -0400
Date: Tue, 21 Aug 2007 19:23:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070821232320.GC29691@Krystal>
References: <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:21:53 up 22 days, 23:40,  3 users,  load average: 0.38, 0.35, 0.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:
> 
> > - Changed smp_rmb() for barrier(). We are not interested in read order
> >   across cpus, what we want is to be ordered wrt local interrupts only.
> >   barrier() is much cheaper than a rmb().
> 
> But this means a preempt disable is required. RT users do not want that.
> Without preemption the processor can be moved after c has been determined.
> That is why the smp_rmb() is there.

preemption is required if we want to use cmpxchg_local anyway.

We may have to find a way to use preemption while being able to give an
upper bound on the preempt disabled execution time. I think I got a way
to do this yesterday.. I'll dig in my patches.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
