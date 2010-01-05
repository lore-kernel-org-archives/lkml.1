Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083Ab0AEWpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0AEWpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866Ab0AEWpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:45:22 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:63036 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab0AEWpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:45:21 -0500
Date: Tue, 5 Jan 2010 17:45:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 0/4] Remove local_t
Message-ID: <20100105224516.GA32584@Krystal>
References: <20100105220417.400092933@quilx.com> <20100105222351.GA29675@Krystal> <alpine.DEB.2.00.1001051629550.9108@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001051629550.9108@router.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:43:36 up 20 days,  7:02,  5 users,  load average: 0.89, 0.77,
	0.37
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Tue, 5 Jan 2010, Mathieu Desnoyers wrote:
> 
> > Yes, removing the local_t type could make sense. However, local_t maps
> > to a volatile long, not just "long". Secondly, I am concerned about the
> > fact that the patch you propose:
> 
> Volatile is discouraged as far as I can tell.

If you want to ensure that a simple variable assignment or read
(local_set, local_read) are not performed piecewise by the compiler
which can cause odd effects when shared with interrupt handlers, this
will however be necessary.


> 
> > - does not create the primitives I use in lttng
> > - only deals with x8
> 
> As I said its an RFC. This provides all the functionality you need
> through. The rest is sugar coating.

OK

> 
> > In lttng (which is out of tree, but widely used), I need the equivalent
> > of:
> >
> > local_read
> > local_set
> > local_add
> > local_cmpxchg
> > local_add_return
> > local_inc
> 
> Please read the patch! This is all provided. add_local_return in the RFC
> provides what is needed to replace local_add, local_inc. We can add these
> explicitly.
> 
> local_cmpxchg replacement is already in there in the form of
> cmpxchg_local().
> 
> > The approach of just doing the x86 implementation and leaving all the
> > other architectures "for later" with a slow/non atomic generic fallback
> > is, imho, a no-go, given that some people (myself, actually) already
> > took the time to go through all the kernel architectures to create the
> > optimized local.h headers. Basically, you are destroying all that work,
> > asking for it to be done all over again.
> 
> AS I said this is an RFC. I can easily generate all these things from the
> existing local.hs for the architectures.
> 
> > I therefore argue that we should keep local.h as-is as long as the
> > replacement lacks the wide architecture support and primitive variety
> > found in local.h.
> 
> Cool down and please review the patch.

OK :)

Mathieu
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
