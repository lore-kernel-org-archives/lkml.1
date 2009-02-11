Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbZBKAup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbZBKAup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbZBKAcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:32:14 -0500
Received: from ozlabs.org ([203.10.76.45]:54849 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757727AbZBKAcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:32:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Wed, 11 Feb 2009 11:02:07 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200902101924.08656.rusty@rustcorp.com.au> <20090210013548.cbf58cbe.akpm@linux-foundation.org>
In-Reply-To: <20090210013548.cbf58cbe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902111102.08472.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009 20:05:48 Andrew Morton wrote:
> On Tue, 10 Feb 2009 19:24:07 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > How about we make work_on_cpu spawn a temp thread; if you care, use
> > something cleverer?  Spawning a thread just isn't that slow.
> 
> That's what
> work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch does?

Err, yeah.

> > Meanwhile, I'll prepare patches to convert all the non-controversial cases
> > (ie. smp_call_function-style ones).
> 
> arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
> arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
> arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
> 
> convert three work_on_cpu() callers.  The drivers/pci/pci-driver.c one
> is a bit problematic.

OK, I've pulled these in to play with them.  My main concern at the moment
is getting all cpumask_ts removed from core & x86 code for 2.6.30, which
usually means converting those save/restore to work_on_cpu or whatever.

> I guess as long as we don't find a high frequency set_cpus_allowed()
> callsite which can't be converted to smp_call_function_single() we'll
> be OK.

Yep.

Thanks,
Rusty.
