Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZBZI7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZBZI7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZBZI6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:58:39 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:37015 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZBZI6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:58:37 -0500
Date: Thu, 26 Feb 2009 14:28:31 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       ego@in.ibm.com, tglx@linutronix.de, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arun@linux.vnet.ibm.com, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090226085831.GA28397@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090220132145.GF26418@elte.hu> <20090220141415.GA27381@dirshya.in.ibm.com> <20090220160737.GC11294@elte.hu> <20090220115745.43d202d6@infradead.org> <20090220215318.GA30665@elte.hu> <20090223075521.GA3725@balbir.in.ibm.com> <20090223091158.GJ9582@elte.hu> <20090223094850.GA10226@balbir.in.ibm.com> <20090223103814.GB8817@dirshya.in.ibm.com> <20090223110725.GB17312@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223110725.GB17312@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 12:07:25PM +0100, Ingo Molnar wrote:
> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > * Identify set of idle CPUs (CPU package) from which timers 
> >   can be removed
> > * Identify a semi-idle or idle CPU package to which the timers
> >   can be moved
> > * Decide when to start moving timers as the system has large
> >   number of idle CPUs
> > * Decide when to stop migrating as system becomes less idle
> >   and utilisation increases
> > 
> > Guiding all of the above decisions from user space may not be 
> > fast enough.
> 
> Exactly.

That is true for power management. However there are other
situations where we may need targeted avoidance of timers.
Certain type of applications - HPC for example - prefer avoidance
of jitters due to periodic timers. It would be good to be
able to say "avoid these CPUs for timers" while they are being
used for HPC tasks.

Thanks
Dipankar
