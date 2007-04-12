Return-Path: <linux-kernel-owner+w=401wt.eu-S1030515AbXDLRRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030515AbXDLRRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030524AbXDLRRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:17:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030515AbXDLRRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:17:31 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Date: Thu, 12 Apr 2007 19:17:26 +0200
User-Agent: KMail/1.9.6
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
References: <20070411162904.232696302@mvista.com> <20070411143357.e866b366.akpm@linux-foundation.org> <20070411173902.b2a9ab9d.akpm@linux-foundation.org>
In-Reply-To: <20070411173902.b2a9ab9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704121917.27030.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> OK, so I resurrected x86_64-mm-sched-clock-share.patch and
> x86_64-mm-sched-clock64.patch.  The x86_64 box hangs on boot when using
> netconsole and printk timestamps too.  Removing "time" from the kernel boot
> command line prevents that.

It's not worse than before for you CPU. The old code did 

#ifndef CONFIG_NUMA
        if (!cpu_khz || check_tsc_unstable())
#endif
                /* no locking but a rare wrong value is not a big deal */
                return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);


So if it worked before it still will.

> This explains why the hang only happens with
> x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch applied, too: that
> patch must be triggering a printk inside xtime_lock.
> 
> Does someone want to cook up a lockless printk_clock() for i386 and x86_64?

With the fall back case changed back to jiffies sched_clock will be fully lockless.

-Andi
