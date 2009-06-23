Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZFWRBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZFWRBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760465AbZFWRAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:00:52 -0400
Received: from www.tglx.de ([62.245.132.106]:37413 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760024AbZFWRAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:00:51 -0400
Date: Tue, 23 Jun 2009 18:58:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: kerneloops.org report for the week of June 14 2009
In-Reply-To: <200906231856.24959.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0906231857450.2767@localhost.localdomain>
References: <20090614173331.18f01123@infradead.org> <alpine.LFD.2.00.0906231201430.2767@localhost.localdomain> <20090623115510.GC9497@elte.hu> <200906231856.24959.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Rafael J. Wysocki wrote:
> The long term solution for the issue at hand is to clean up the suspend-resume
> support in cpufreq so that it doesn't do stupid things like calling
> smp_call_function_single() with interrupts disabled, but that requires someone
> (I can do it, but I need to dig through the cpufreq code for this purpose) to
> figure out how to fix it.
> 
> I'm not quite sure if there's an acceptable short term solution, though.
> 
> In principle we can do
> 
> local_irq_save()
> ...
> local_irq_restore()
> 
> around each sysdevs ->susend() and ->resume() in addition to checking the
> status of interrupts.  Would that work?

Well not really, if the function enables interrupts you run into the
same issue (interrupt service routine calls ktime_get()) again.

Thanks,

	tglx
