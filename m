Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXDLTr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXDLTr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXDLTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:47:27 -0400
Received: from gw.goop.org ([64.81.55.164]:45323 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbXDLTr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:47:26 -0400
Message-ID: <461E8CAA.3020902@goop.org>
Date: Thu, 12 Apr 2007 12:46:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@novell.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
References: <20070411162904.232696302@mvista.com> <200704121845.39961.ak@novell.com> <461E6F5F.1030008@goop.org> <200704121945.54053.ak@novell.com>
In-Reply-To: <200704121945.54053.ak@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Even on real hardware it's also per CPU, although the errors
> are usually not big. At least the scheduler deals with that by
> only ever comparing time stamps from the same CPU.
>   

Well, it uses sched_clock to measure how long something has been asleep,
which is inherently non-per-cpu.  But it tries to keep a measure of the
skew between the various runqueue's sched_clocks, so the error doesn't
seem to get too large.

> If you have big deviations between CPUs then it might cause problems
> for non scheduler uses. I guess printk_clock is not critical, but
> it might be a little confusing.

They could be huge differences - unbounded, in fact.  It would make
printk fairly hard to interpret,  I would think.  The only benefit to
using sched_clock in printk is that if you're using it to work out the
startup latencies you won't be confused by stolen time.  But I think
that's a fairly small benefit compared to the disadvantage of not being
able to meaningfully compare the timestamps on two printk messages.

    J
