Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbYCDGwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbYCDGwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYCDGvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:51:54 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50830 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753963AbYCDGvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:51:53 -0500
Date: Tue, 4 Mar 2008 00:51:48 -0600
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080304005148.4e6f1fe8.pj@sgi.com>
In-Reply-To: <6599ad830803032234v3bce2769l26379ea304fe885@mail.gmail.com>
References: <20080227222103.673194000@chello.nl>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<6599ad830803031041r6c635141n6520a915f2e1d08@mail.gmail.com>
	<20080303125253.5d2d580c.pj@sgi.com>
	<6599ad830803032126m39935eaeu1df67d6263e8e123@mail.gmail.com>
	<20080304001507.3ddc8f26.pj@sgi.com>
	<6599ad830803032221j740c9657yec237ebbadbeaeaa@mail.gmail.com>
	<20080304002651.95089ff1.pj@sgi.com>
	<6599ad830803032234v3bce2769l26379ea304fe885@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> I'm one such user who's been forced to add the mem_hardwall flag to
> get around the fact that exclusive and hardwall are controlled by the
> same flag. I keep meaning to send it in as a patch but haven't yet got
> round to it.

I made essentially the same mistake twice in the evolution of cpusets:
 1) overloading the cpu_exclusive flag to define sched domains, and
 2) overloading the mem_exclusive flag to define memory hardwalls.

I eventually reversed (1), with a deliberately incompatible change
(and you know how I resist those ;), creating a new 'sched_load_balance'
flag that controls the sched_domain partitioning, and removing any
affect that the cpu_exclusive flag has on this.

Perhaps the unfortunate interaction of mem_exclusive and hardwall is
destined to go the same path.  Thought the audience that is currently
using mem_exclusive for the purpose of hardwall enforcement of kernel
allocations might be broader than the specialized real-time audience
that was using cpu_exclusive for dynamic sched domain isolation, and so
we might not choose to just break compatibility in one shot, but rather
phase in your new flag, before, perhaps, in a later release, phasing
out the old hardwall overloading of the mem_exclusive flag.

(My primeval mistake was including the cpu_exclusive and mem_exclusive
flags in the original cpuset design; those two flags have given me
nothing but temptation to commit further design errors ;).


> Also, if you're using fake numa for memory isolation (which we're
> experimenting with) then the correlation between cpu placement and
> memory placement is much much weaker, or non-existent.

That might be a good answer to my asking where the beef was.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
