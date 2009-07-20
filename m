Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZGTNsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZGTNsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZGTNso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:48:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbZGTNso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:48:44 -0400
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20090720063305.2ad49d40@infradead.org>
References: <1247873945.8334.67.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
	 <1247954978.14494.19.camel@work-vm> <20090718153011.1de3af8e@infradead.org>
	 <1248088622.15751.8465.camel@twins> <20090720063305.2ad49d40@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Jul 2009 15:49:14 +0200
Message-Id: <1248097754.15751.8867.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 06:33 -0700, Arjan van de Ven wrote:
> > Maybe power64, sparc64 and s390x qualify, but certainly nothing on x86
> > does.
> 
> the x86 on my desk disagrees.

>From what I know even nehalem doesn't have fully synced tscs when your
machine is large enough, and the timers are still a tad expensive.

Maybe your desktop is next-gen? 't would be nice to finally have an x86
that has usable clock and timer hardware.

I'm sure tglx would be pleasantly surprised :-)

> > Furthermore, on the software side we'd need a few modifications, such
> > as doing lazy accounting for things like u/s-time which currently
> > rely on the tick and moving the load-balancing into a hrtimer.
> 
> I thought the load balancer no longer runs as a timer.. but I could
> well be wrong.

It doesn't but it does need wakeup kicks, which are currently done from
the tick.

And I'm not at all disagreeing that we want the tick gone, I'm just
pointing out there's some challenges ahead still ;-)
