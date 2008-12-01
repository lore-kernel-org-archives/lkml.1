Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYLALl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYLALl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 06:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYLALls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 06:41:48 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:54567 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYLALlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 06:41:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEFAHhaM0lMROB9/2dsb2JhbACBbcxlgn0
Date: Mon, 1 Dec 2008 06:41:46 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] keypad/touchscreen driver events latencies using
	LTTng on ARM?
Message-ID: <20081201114146.GG25340@Krystal>
References: <5d5443650811301000t58665a7j7aa93be52325a23b@mail.gmail.com> <20081201103502.GC25340@Krystal> <20081201104529.GB28971@flint.arm.linux.org.uk> <20081201105737.GE25340@Krystal> <20081201105956.GC28971@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081201105956.GC28971@flint.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 06:38:51 up 14 days, 12:19,  1 user,  load average: 0.55, 0.59,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> On Mon, Dec 01, 2008 at 05:57:37AM -0500, Mathieu Desnoyers wrote:
> > Ok, so for LTTng on ARM it would make sense to use the same clock source
> > as sched_clock for :
> > mach-pxa, mach-realview, mach-sa1100, mach-versatile, plat-omap.
> > 
> > We basically have, for each of these build scenarios, to take the mmio
> > clock used by sched_clock and use it through
> > kernel/trace/trace-clock-32-to-64 to extend it to 64-bits. Therefore we
> > won't suffer from any of the constrains linked to cnt32_to_63 and we
> > would be sure that the trace clock is correct wrt SMP wrt memory
> > barriers and cache line bouncing because it uses per-cpu data to keep
> > the counters.
> 
> Just remember that MMIO clock sources are not available until after
> setup_arch() has finished - in other words, they don't work when the
> kernel initially boots.  Accessing them too early will cause a page
> fault and hang the kernel.
> 

This can be dealt with by refusing the get_trace_clock(), which should
probably be allowed to fail if the underlying infrastructure is not
ready when the trace buffers are created. The tracer would therefore not
accept to start any sort of tracing too soon for the architecture being
used.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
