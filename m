Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbXDLRqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbXDLRqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXDLRqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:46:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXDLRqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:46:36 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Date: Thu, 12 Apr 2007 19:45:53 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
References: <20070411162904.232696302@mvista.com> <200704121845.39961.ak@novell.com> <461E6F5F.1030008@goop.org>
In-Reply-To: <461E6F5F.1030008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704121945.54053.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 19:41:51 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Ok. I think it's better to just fix sched_clock() again than to
> > add another one.  I can probably
> > eliminate the ktime_get() and use something based on jiffies. That will
> > be inaccurate for the instable case of course.
> >
> > I will do that later today.
> 
> sched_clock seems a bit weird to use.  In the pv_ops world, it only
> counts unstolen time, and it is therefore inherently per-cpu.  The
> timestamps should be at least system-wide monotonic.

Even on real hardware it's also per CPU, although the errors
are usually not big. At least the scheduler deals with that by
only ever comparing time stamps from the same CPU.

If you have big deviations between CPUs then it might cause problems
for non scheduler uses. I guess printk_clock is not critical, but
it might be a little confusing.

-Andi
