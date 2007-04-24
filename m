Return-Path: <linux-kernel-owner+w=401wt.eu-S1030767AbXDXVUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767AbXDXVUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030882AbXDXVUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:20:19 -0400
Received: from mail.suse.de ([195.135.220.2]:40908 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030767AbXDXVUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:20:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: virtualization@lists.linux-foundation.org
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
Date: Tue, 24 Apr 2007 23:20:06 +0200
User-Agent: KMail/1.9.6
Cc: Daniel Walker <dwalker@mvista.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, virtualization@lists.osdl.org,
       Chris Lalancette <clalance@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <20070327214919.800272641@goop.org> <462E6778.7070305@goop.org> <1177447948.12796.66.camel@imap.mvista.com>
In-Reply-To: <1177447948.12796.66.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704242320.06470.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 22:52:27 Daniel Walker wrote:
> On Tue, 2007-04-24 at 13:24 -0700, Jeremy Fitzhardinge wrote:
> 
> > And sched_clock's use of local_irq_save/restore appears to be absolutely
> > correct, so I think it must be triggering a bug in either the self-tests
> > or lockdep itself.
> 
> Why does sched_clock need to disable interrupts?

It's only used in the instable path which is kind of "i already threw up
my hands" anyways

I use it because when you transition from stable (TSC) to instable (jiffies)
the only way to avoid the clock jumping backwards is to remember and update the 
last value. To avoid races with parallel cpufreq handlers or timer
interrupts this small section needs to run with interrupts disabled.

The alternative would be a seqlock, but people have complained about this
earlier too so i judged irq disabling better.

-Andi
