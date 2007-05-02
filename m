Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbXEBKoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbXEBKoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbXEBKoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:44:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34486 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbXEBKoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:44:15 -0400
Date: Wed, 2 May 2007 12:44:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070502104413.GC4392@one.firstfloor.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501220803.GA27698@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It is currently used as an instrumentation infrastructure for the LTTng
> tracer at IBM, Google, Autodesk, Sony, MontaVista and deployed in
> WindRiver products.  The SystemTAP project also plan to use this type of
> infrastructure to trace sites hard to instrument. The Linux Kernel
> Markers has the support of Frank C. Eigler, author of their current
> marker alternative (which he wishes to drop in order to adopt the
> markers infrastructure as soon as it hits mainline).

All of the above don't use mainline kernels.
That doesn't constitute using it.

> Quoting Jim Keniston <jkenisto@us.ibm.com> :
> 
> "kprobes remains a vital foundation for SystemTap.  But markers are
> attactive as an alternate source of trace/debug info.  Here's why:
> [...]"

Talk is cheap. Do they have working code to use it?

>   - Allow per-architecture optimized versions which removes the need for
>     a d-cache based branch (patch a "load immediate" instruction
>     instead). It minimized the d-cache impact of the disabled markers.

That's a good idea in general, but should be generalized (available
independently), not hidden in your subsystem. I know a couple of places
who could use this successfully.

>   - Accept the cost of an unlikely branch at the marker site because the
>     gcc compiler does not give the ability to put "nops" instead of a
>     branch generated from C code. Keep this in mind for future
>     per-architecture optimizations.

See upcomming paravirt code for a way to do this.

> - Instrumentation of challenging kernel sites
>   - Instrumentation such as the one provided in the already existing
>     Lock dependency checker (lockdep) and instrumentation of trap
>     handlers implies being reentrant for such context. Therefore, the
>     implementation must be lock-free and update the state in an atomic
>     fashion (rcu-style). It must also let the programmer who describes
>     a marker site the ability to specify what is forbidden in the probe
>     that will be connected to the marker : can it generate a trap ? Can
>     it call lockdep (irq disable, take any type of lock), can it call
>     printk ? This is why flags can be passed to the _MARK() marker,
>     while the MARK() marker has the default flags.

Why can't you just generally forbid probes from doing all of this?
It would greatly simplify your code, wouldn't it?

Keep it simple please.

> Please tell me if I forgot to explain the rationale behind some
> implementation detail and I will be happy to explain in more depth.

Having lots of flags to do things differently optionally normally
starts up all warning lights of early over design. While Linux
has this sometimes it is generally only in mature old subsystems.
But when something is freshly merged it shouldn't be like this.
That is because code tends to grow more complicated over its livetime
and when it is already complicated at the beginning it will eventually
fall over (you can study current slab as a poster child of this)

-Andi

