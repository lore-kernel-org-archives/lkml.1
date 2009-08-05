Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbZHEBdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbZHEBdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbZHEBc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:32:57 -0400
Received: from ozlabs.org ([203.10.76.45]:47666 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998AbZHEBc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:32:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Problem with percpu values when bringing up second CPU?
Date: Wed, 5 Aug 2009 11:01:19 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4A78BD1A.9050001@goop.org>
In-Reply-To: <4A78BD1A.9050001@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051101.20471.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009 08:28:34 am Jeremy Fitzhardinge wrote:
> Hi,
> 
> I just tracked down a bug I was having to a change where I changed one
> of my Xen event channel variables to a percpu variable, relating to
> masking an event channel.
> 
> The symptom was that shortly after bringing up the second CPU, the first
> CPU's timer events stopped arriving, apparently because they had become
> masked.
> 
> The event channels masks are declared as:
> 
> #define NR_EVENT_CHANNEL_LONGS (NR_EVENT_CHANNELS/BITS_PER_LONG)
> static DEFINE_PER_CPU(unsigned long,
>                      cpu_evtchn_mask[NR_EVENT_CHANNEL_LONGS]) =
>        {[0 ... NR_EVENT_CHANNEL_LONGS-1] = ~0ul };	/* everything masked by default */
> 
> 
> My theory about what's happening is that when the second CPU comes up,
> it allocates separate percpu areas for each CPU, but it is somehow
> failing to accurately copy CPU 0's percpu data over

If you touch the per-cpu vars before setup_per_cpu_areas(), you will hit the
master copy.

Is that possible?
Rusty.
