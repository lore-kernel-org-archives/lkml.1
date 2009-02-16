Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbZBPJ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbZBPJ6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZBPJ5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:57:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbZBPJ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:57:50 -0500
Subject: Re: [patch] generic-ipi: remove kmalloc, cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <200902161746.55058.rusty@rustcorp.com.au>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <200902140746.45320.rusty@rustcorp.com.au>
	 <1234568885.4831.14.camel@laptop>
	 <200902161746.55058.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 10:57:16 +0100
Message-Id: <1234778236.4703.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 17:46 +1030, Rusty Russell wrote:
> On Saturday 14 February 2009 10:18:05 Peter Zijlstra wrote:
> > On Sat, 2009-02-14 at 07:46 +1030, Rusty Russell wrote:
> > > I'd be fascinated to see perf numbers once you kill the kmalloc.  Because
> > > this patch will add num_possible_cpus * NR_CPUS/8 bytes to the kernel which
> > > is something we're trying to avoid unless necessary.
> > 
> > You're free to make it a pointer and do node affine allocations from an
> > init section of choice and add a hotplug handler.
> > 
> > But I'm not quite sure how perf is affected by size overhead on
> > ridiculous configs.
> 
> No, I meant "can you actually measure the perf win of this patch?".  If you
> did so, I missed it?

Over what, the always single-ipi case, or the kmalloc case?

The thing is, we're removing that kmalloc because its somewhat of a wart
on the whole thing.

> But if this patch is worthwhile, the right way to do this is make it a
> cpumask_var_t, and do the alloc_cpumask_var_node() in that init routine.

Right, and installing a hotplug handler and ... *sigh*

