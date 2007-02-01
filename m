Return-Path: <linux-kernel-owner+w=401wt.eu-S1422870AbXBANif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422870AbXBANif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422850AbXBANie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:38:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:58918 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422870AbXBANie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:38:34 -0500
Date: Thu, 1 Feb 2007 14:41:43 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 7/9] Adapt the time initialization code
Message-ID: <20070201134141.GO21755@dwarf.suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <20070201103754.041245000@jet.suse.cz> <200702011226.33339.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011226.33339.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 12:26:33PM +0100, Andi Kleen wrote:
> 
> > +extern void time_initialize_cpu(void);
> 
> Never put externs into .c files. Multiple occurrences.

Ok, will fix it, sorry.

> > +void time_initialize_cpu(void *info)
> > +{
> > +	unsigned long flags;
> > +	int cpu = smp_processor_id();
> 
> Are you sure this can never preempt? 

yes, preemption is explicitly disabled in start_secondary() that
calls this function.

> > +	/* FIXME: what speed does the cpu really start at; I doubt cpu_khz is right at this point ??!!!
> 
> It should be. It comes from measurements. Unless the CPU changes frequency
> behind the kernel's back, but there is nothing that can be done then.

Well, I'm not sure. I think the global variable cpu_khz is wrong
in the first place. This should be per-cpu, because each CPU can
have a different frequency, right?

And cpu_khz is adjusted in time_cpufreq_notifier() when whichever
CPU's frequency changes.  To me it seems that it's a leftover from
the times when all CPUs in a system ran at the same speed. I
think it should be killed. I just did not want to make too many
unrelated changes in one patchset.

It doesn't matter that much in this case that it probably is
wrong (as the comment explains)...


-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

