Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZBPHRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZBPHRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZBPHRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:17:06 -0500
Received: from ozlabs.org ([203.10.76.45]:41603 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbZBPHRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:17:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch] generic-ipi: remove kmalloc, cleanup
Date: Mon, 16 Feb 2009 17:46:54 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       "rt-users" <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <200902140746.45320.rusty@rustcorp.com.au> <1234568885.4831.14.camel@laptop>
In-Reply-To: <1234568885.4831.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161746.55058.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 February 2009 10:18:05 Peter Zijlstra wrote:
> On Sat, 2009-02-14 at 07:46 +1030, Rusty Russell wrote:
> > I'd be fascinated to see perf numbers once you kill the kmalloc.  Because
> > this patch will add num_possible_cpus * NR_CPUS/8 bytes to the kernel which
> > is something we're trying to avoid unless necessary.
> 
> You're free to make it a pointer and do node affine allocations from an
> init section of choice and add a hotplug handler.
> 
> But I'm not quite sure how perf is affected by size overhead on
> ridiculous configs.

No, I meant "can you actually measure the perf win of this patch?".  If you
did so, I missed it?

But if this patch is worthwhile, the right way to do this is make it a
cpumask_var_t, and do the alloc_cpumask_var_node() in that init routine.

Thanks,
Rusty.
