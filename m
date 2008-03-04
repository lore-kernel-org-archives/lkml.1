Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYCDGP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYCDGP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYCDGPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:15:16 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40245 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750704AbYCDGPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:15:15 -0500
Date: Tue, 4 Mar 2008 00:15:07 -0600
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080304001507.3ddc8f26.pj@sgi.com>
In-Reply-To: <6599ad830803032126m39935eaeu1df67d6263e8e123@mail.gmail.com>
References: <20080227222103.673194000@chello.nl>
	<47C87084.3090208@qualcomm.com>
	<1204318980.6243.133.camel@lappy>
	<47C8771C.1070001@qualcomm.com>
	<1204545445.11412.6.camel@twins>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<6599ad830803031041r6c635141n6520a915f2e1d08@mail.gmail.com>
	<20080303125253.5d2d580c.pj@sgi.com>
	<6599ad830803032126m39935eaeu1df67d6263e8e123@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> One of the arguments that you posted against his proposal was that
> this would break due to the memory overlap requirements of
> mem_exclusive cpusets.

There were three concerns I had with his proposal -- (1) it conflicted
with memory placement, (2) it conflicted with cpu placement (sched
domain definition) and (3) it broke the conventional cpuset hierarchy
configuration on which users have come to depend.

Separating cpus and memory as distinct cgroup subsystems wouldn't help
much; there's still (2) and (3).  And in the legacy /dev/cpuset
interface, cpus and memory remain together, whether or not cgroups
enables them to be separate.


> I'm sure if cpusets were being developed today on top of cgroups,
> rather than being its inspiration, there would be no good reason to
> have the memory mask assignment and the cpu mask assignment be part of
> the same subsystem 

Perhaps ... though they work together rather well in practice, perhaps
because CPUs and memory banks usually are physically associated;
selecting which CPUs to use and which memory banks to use really is not
an independent choice, on most hardware.

Now however the shoe is on the other foot.  Is there a good reason to
separate them ... an actual would-be user, or actual problems inflicted
on current users due to the lack of this split?

If there's just a rare occassion such an independently split CPU and
Memory hiearchy, one can still use the current combined cpuset
implementation, just with a less natural cpuset hierarchy (more leaf
node cpusets, representing the cross product of interesting CPU subsets
and interesting memory node subsets.)  If some specified users start
doing this routinely, then that gets sufficiently cumbersome that it's
worth trying to remedy.

As usual, I seem to be counseling resisting adding code, complexity and
incompatible change, without actual need, beyond just increased
conceptual sophistication.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
