Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZEVGNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZEVGNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZEVGN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:13:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57607 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZEVGN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:13:27 -0400
Date: Tue, 19 May 2009 22:40:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation
	sched_max_capacity_pct=n
Message-ID: <20090519204015.GE1362@ucw.cz>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <20090513143550.GU19296@one.firstfloor.org> <1242225402.26820.23.camel@twins> <20090513144659.GV19296@one.firstfloor.org> <1242226219.26820.26.camel@twins> <20090513150100.GW19296@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513150100.GW19296@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-05-13 17:01:00, Andi Kleen wrote:
> > >From what I've been told its popular to over-commit the cooling capacity
> > in a rack, so that a number of servers can run at full thermal capacity
> > but not all.
> 
> Yes. But in this case you don't want to use throttling, you want
> to use p-states which actually safe power unlike throttling.
> 
> > I've also been told that hardware sucks at throttling, 
> 
> Throttling is not really something you should use in normal 
> operation, it's just a emergency measure. For that it works
> quite well, but you really don't want it in normal operation.
> 
> > therefore people
> > want to fix the OS so as to limit the thermal capacity and avoid the
> > hardware throttle from kicking in, whilst still not exceeding the rack
> > capacity or similar nonsense.
> 
> Yes that's fine and common, but you actually need to save power for this,
> which throttling doesn't do.

Actually throttling will lower power consumption at any given moment
(not power consumption for any given task!) and will keep your rack
from melting.

But I don't see why it is neccessary to evacuate cores for this. Why
not just schedule special task that enters C3 instead of computing?

That was what I planned to do on athlon 900 (1 core) with broken
fan...

For what you are doing, cpu hotplug seems more suitable. Can you
 enhance it so that it is fast enough for you?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
