Return-Path: <linux-kernel-owner+w=401wt.eu-S1423119AbXDXVf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423119AbXDXVf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423127AbXDXVf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:35:26 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:13105 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423119AbXDXVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:35:25 -0400
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, virtualization@lists.osdl.org,
       Chris Lalancette <clalance@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200704242320.06470.ak@suse.de>
References: <20070327214919.800272641@goop.org> <462E6778.7070305@goop.org>
	 <1177447948.12796.66.camel@imap.mvista.com> <200704242320.06470.ak@suse.de>
Content-Type: text/plain
Date: Tue, 24 Apr 2007 14:33:58 -0700
Message-Id: <1177450439.12796.79.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-24 at 23:20 +0200, Andi Kleen wrote:
> On Tuesday 24 April 2007 22:52:27 Daniel Walker wrote:
> > On Tue, 2007-04-24 at 13:24 -0700, Jeremy Fitzhardinge wrote:
> > 
> > > And sched_clock's use of local_irq_save/restore appears to be absolutely
> > > correct, so I think it must be triggering a bug in either the self-tests
> > > or lockdep itself.
> > 
> > Why does sched_clock need to disable interrupts?
> 
> It's only used in the instable path which is kind of "i already threw up
> my hands" anyways
> 
> I use it because when you transition from stable (TSC) to instable (jiffies)
> the only way to avoid the clock jumping backwards is to remember and update the 
> last value. To avoid races with parallel cpufreq handlers or timer
> interrupts this small section needs to run with interrupts disabled.

Preemption is already disabled with the get_cpu_var() , so it seems like
the timer interrupt is the only worry? I find it confusing that the
access of jiffies_64 isn't protected from interrupts, it's only the
per_cpu data which should already be protected by the
get_cpu_var()/put_cpu_var ..

Daniel

