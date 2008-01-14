Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYANTmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYANTmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYANTmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:42:06 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:39500 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbYANTmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:42:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAONJi0dMROHU/2dsb2JhbACBVqdc
Date: Mon, 14 Jan 2008 14:36:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost
	Tracing
Message-ID: <20080114193653.GA20774@Krystal>
References: <20071231060911.GB6461@in.ibm.com> <20071231102045.GB30380@elte.hu> <y0modc4vr7a.fsf@ton.toronto.redhat.com> <20080102124734.GC11208@elte.hu> <20080102163309.GC11496@redhat.com> <20080102170157.GA11161@elte.hu> <20080107185954.GA16041@Krystal> <20080113180740.GA4435@ucw.cz> <20080114153505.GA11522@Krystal> <alpine.LFD.1.00.0801140824430.2806@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801140824430.2806@woody.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:17:18 up 72 days, 22 min,  5 users,  load average: 0.47, 0.56,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 14 Jan 2008, Mathieu Desnoyers wrote:
> > 
> > We would have to figure out if enabling -freorder-blocks-and-partition
> > makes sense kernel-wide.
> 
> Last I saw, it generates crappy code, with lots more jumps back and forth, 
> and the image just blows up.
> 
> There's a reason we use -Os, and that's that small footprint I$ is 
> generally more important than fake compiler optimizations that don't 
> actually help except on microbenchmarks where everything fits in the 
> cache.
> 
> Taking a branch instruction from two bytes to five is almost always a 
> mistake, unless you *know* that the code it jumps to will effectively 
> never be done at all (which is not necessarily the case at all). It also 
> makes debugging much nastier, because if now things like backtraces 
> probably look like crap too!
> 
> Don't go there. The *best* we can do is to just use the optimizations that 
> generate good-looking code that humans can read. The rest is just compiler 
> masturbation.
> 

I agree that turning this flag on does not seem like an interesting
solution.

Well, I wonder how important this issue of not sharing L1 instruction
cachelines with scheduler code is. If we care as much about it as Ingo
states, I wonder why we leave about 22 BUG() macros in sched.c
(calculated from the number of ud2 instructions generated on x86), which
adds up to 7 bytes at the end of many scheduler functions (7 bytes
coming from ud2, jmp and .p2align on x86).

And 22 markers in sched.c is already much more than needed. I actually
propose only 5 in my patchset.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
