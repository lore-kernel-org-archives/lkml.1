Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZBJP6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZBJP6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZBJP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:58:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbZBJP6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:58:16 -0500
Subject: Re: cgroup, RT reservation per core(s)?
From: Peter Zijlstra <peterz@infradead.org>
To: Rolando Martins <rolando.martins@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <b6a2d2e20902100646q6c7073cse86b8f5790a120ac@mail.gmail.com>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <1234209174.5951.165.camel@laptop>
	 <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
	 <1234271177.23438.24.camel@twins>
	 <b6a2d2e20902100646q6c7073cse86b8f5790a120ac@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Feb 2009 17:00:02 +0100
Message-Id: <1234281602.23438.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 14:46 +0000, Rolando Martins wrote:
> 
> >  I've never actually tried anything like this, let me know if it
> >  works ;-)
> >
> 
> Thanks Peter, it works!

> I am thinking for different strategies to be used in my rt middleware
> project, and I think there is a limitation.
> If I wanted to have some RT on the B cpuset, I couldn't because I
> assigned A.cpu.rt_runtime_ns = root.cpu.rt_runtime_ns (then subdivided
> the A cpuset, with 2,3,4, each one having A.cpu.rt_runtime_ns/3).

Try it, you can run RT proglets in B.

You get n*utilization per schedule domain, where n is the number of cpus
in it.

So you still have 200% left in B, even if you use 200% of A.

> This happens because there is a
> global /proc/sys/kernel/sched_rt_runtime_us and
> /proc/sys/kernel/sched_rt_period_us.

These globals don't actually do much (except provide a global cap) in
the cgroup case.

> What do you think about adding a separate tuple (runtime,period) for
> each core/cpu?

> Does this make sense? ;)

That's going to give me a horrible head-ache trying to load-balance
stuff.
