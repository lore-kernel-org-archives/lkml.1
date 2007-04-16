Return-Path: <linux-kernel-owner+w=401wt.eu-S1030969AbXDPVV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030969AbXDPVV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030981AbXDPVV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:21:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41385 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030969AbXDPVV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:21:57 -0400
Date: Mon, 16 Apr 2007 23:21:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416212154.GA25508@one.firstfloor.org>
References: <20070413202100.GA9957@elte.hu> <p73tzvg56ag.fsf@bingen.suse.de> <20070416210556.GA25637@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416210556.GA25637@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> actually, i designed the CFS code assuming a per-CPU TSC (with no global 
> synchronization), not assuming any globally sync TSC. In fact i wrote it 

That already worked in the old scheduler (just in a hackish way)

> on such systems: a CoreDuo2 box that has stops the TSC in C3 and the 
> different cores have wildly different TSC values and a dual-core 
> Athlon64 that quickly drifts its TSC. So i'll keep the sched_clock() 
> change for now.

The problem is not CPU synchronized TSC, but TSC with varying frequency
on a single CPU like on the A64.

The old implementation can lose really badly on that because it mixes
measurements at different frequencies together without individual scaling.

The error gets worse the longer the system runs.

>> BTW with all this CPU time measurement it would be really nice to
>> report it to the user too. It seems a bit bizarre that the scheduler
>> keeps track of ns, but top only knows jiffies with large sampling
>> errors.

> yeah - i'll fix that too if someone doesnt beat me at it.

I've been pondering for some time if doubling the NMI watchdog as a 
ring 0 counter for this is worth it. So far I'm still undecided
(and it's moot now since it's disabled by default :/)

-Andi

