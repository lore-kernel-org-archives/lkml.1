Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbXCMV1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbXCMV1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbXCMV1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:27:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50839 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933632AbXCMV1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:27:08 -0400
Subject: Re: Stolen and degraded time and schedulers
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>
In-Reply-To: <45F70A71.9090205@goop.org>
References: <45F6D1D0.6080905@goop.org>
	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 14:27:04 -0700
Message-Id: <1173821224.1416.24.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 13:32 -0700, Jeremy Fitzhardinge wrote:

> Most of the existing clocksource infrastructure would only operate on
> CLOCK_TIMEBASE_REALTIME clocksources, so I'm not sure how much overlap
> there would be here.  In the case of dealing with cpufreq, there's a
> certain appeal to manipulating the shift/mult parameters to reflect the
> fractional speed of a cpu as it changes.

The frequency tracking you mention is done to some extent inside the
timekeeping adjustment functions, but I'm not sure it's totally accurate
for non-timekeeping, and it also tracks things like interrupt latency.
Tracking frequency changes where it's important to get it right
shouldn't be done I think ..

If you want accurate time accounting, don't use the TSC .

> sched_clock would definitely be the interface which exposes all this
> stuff to the rest of the kernel.  After all, its basically a very simple
> interface, though the backend implementation details may not be.

The sched_clock interface is basically a stripped down clocksource..
I've implemented sched_clock as a clocksource in the past ..

> We currently have a sched_clock interface in paravirt_ops to deal with
> the hypervisor aspect.  It only occurred to me this morning that cpufreq
> presents exactly the same problem to the rest of the kernel, and so
> there's room for a more general solution.

Are there other architecture which have this per-cpu clock frequency
changing issue? I worked with several other architectures beyond just
x86 and haven't seen this issue ..

Daniel

