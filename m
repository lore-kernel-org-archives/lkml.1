Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYLSDfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYLSDfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 22:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYLSDfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 22:35:19 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:40999 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbYLSDfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 22:35:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYEALSlSklMROB9/2dsb2JhbACBbLwpWJBlgwY
Date: Thu, 18 Dec 2008 22:35:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, benh@kernel.crashing.org, linux-ia64@vger.kernel.org,
       linux-s390@vger.kernel.org, Christoph Lameter <christoph@lameter.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: local_add_return
Message-ID: <20081219033514.GA7162@Krystal>
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com> <200812170908.05423.rusty@rustcorp.com.au> <20081217000155.GA28174@Krystal> <200812190922.57629.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200812190922.57629.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:32:07 up 32 days,  4:12,  2 users,  load average: 0.42, 0.70,
	0.81
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Wednesday 17 December 2008 10:31:55 Mathieu Desnoyers wrote:
> > I think we have two different use-cases here :
> > 
> > - local_t is useful as-is for things such as a tracer, which need to
> >   modify an element of data atomically wrt local interrupts. The
> >   atomic_long_t, in this case, is the correct fallback.
> > - local_count_t could be used for fast counters.
> 
> Hi Mathieu,
> 
>    Complete agreement.
> 
>    I guess I'm biassed towards local_t == counter version, something else
> == nmi-safe version because that's what it was originally.  Looking through
> the tree, there are only 5 users: module, dmaengine and percpu_counter want
> a counter, and tracing and x86 nmi.c want nmi-safe.  There are several other
> places I know of which want local_t-the-counter.
> 
>    I'll prepare a patch which adds nmi_safe_t, and see how it looks.  There's
> no amazing hurry on this, so I won't race to hit the merge window.
> 

OK,

But can we turn what you call "nmi_safe_t" into "local_atomic_t" then ?
Because we have to specify that this type must only be used as part of
per-cpu data with preemption disabled, and we also specify that it is
atomic.

Plus, nmi_safe_t does not make much sense on architectures without NMIs,
where we sometimes disable interrupts to make the modification "atomic"
wrt all other interrupts that can happen.

Mathieu

> Thanks!
> Rusty.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
