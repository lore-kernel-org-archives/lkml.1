Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbXKHAer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbXKHAer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbXKHAek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:34:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:53631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbXKHAej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:34:39 -0500
From: Andi Kleen <ak@suse.de>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
Date: Thu, 8 Nov 2007 01:31:00 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, Marin Mitov <mitov@issp.bas.bg>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
References: <200711071921.52330.mitov@issp.bas.bg> <20071107123045.c6d4b855.akpm@linux-foundation.org> <20071108002027.GV17536@waste.org>
In-Reply-To: <20071108002027.GV17536@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711080131.01243.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007 01:20, Matt Mackall wrote:
> On Wed, Nov 07, 2007 at 12:30:45PM -0800, Andrew Morton wrote:
> > Ow.  Yes, from my reading delay_tsc() can return early (or after
> > heat-death-of-the-universe) if the TSCs are offset and if preemption
> > migrates the calling task between CPUs.
> >
> > I suppose a lameo fix would be to disable preemption in delay_tsc().
>
> preempt_disable is lousy documentation here. This and other cases
> (lots of per_cpu users, IIRC) actually want a migrate_disable() which
> is a proper subset. We can simply implement migrate_disable() as
> preempt_disable() for now and come back later and implement a proper
> migrate_disable() that still allows preemption (and thus avoids the
> latency).

We could actually do this right now. migrate_disable() can be just changing
the cpu affinity of the current thread to current cpu and then restoring it 
afterwards. That should even work from interrupt context.

get_cpu() etc. could be changed to use this then too.

-Andi
