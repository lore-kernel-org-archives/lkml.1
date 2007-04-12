Return-Path: <linux-kernel-owner+w=401wt.eu-S1030680AbXDLS1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030680AbXDLS1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030678AbXDLS1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:27:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:35331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030680AbXDLS1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:27:19 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Date: Thu, 12 Apr 2007 20:27:14 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
References: <20070411162904.232696302@mvista.com> <461E6FA7.5080605@goop.org> <20070412105559.385789dd.akpm@linux-foundation.org>
In-Reply-To: <20070412105559.385789dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704122027.14926.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 19:55:59 Andrew Morton wrote:
> On Thu, 12 Apr 2007 10:43:03 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Andrew Morton wrote:
> > > hm.  People (ab)use sched_clock() for all sorts of things nowadays.  I wouldn't
> > > do anything to degrade it just on behalf of printk-timestamping.
> > >   
> > 
> > printk was the only non-scheduler-ish use I could find.  Are there others?
> > 
> 
> blktrace.  I've seen a couple of trace/debug-style things which use
> sched_clock for timestamping event collection. I think lttng does exotic
> things with TSCs, performing private skew correction, although that might
> have changed now.

They should always just store the cpu too and educate the users that
only (cpu, timestamp) pairs make sense to compare.

That said at least my new sched_clock should not normally show 
large non differences between CPUs, so it can be usually ignored, but they can 
happen. I believe some of the already existing sched_clocks() (like the
one used on Altix) have the same property. 

But on VMI/Xen as currently implemented the differences will be large.

-Andi
