Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab0BRQDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:03:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55591 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab0BRQDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:03:39 -0500
Date: Thu, 18 Feb 2010 17:03:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Anton Blanchard <anton@samba.org>,
       tglx@linutronix.de, davem@davemloft.net, linux-kernel@vger.kernel.org,
       arjan@infradead.org, venkatesh.pallipadi@intel.com
Subject: Re: NO_HZ migration of TCP ack timers
Message-ID: <20100218160329.GG5964@basil.fritz.box>
References: <20100218052820.GD24270@kryten> <87mxz755ks.fsf@basil.nowhere.org> <20100218103301.GB26101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218103301.GB26101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > What should we do? Should we use mod_timer_pinned here? Or is this an issue
> > 
> > Sounds like something that should be controlled by the cpufreq governour's
> > idle predictor? Only migrate if predicted idle time is long enough.
> > It's essentially the same problem as deciding how deeply idle to put
> > a CPU. Heavy measures only pay off if the expected time is long enough.
> > 
> 
> cpuidle infrastructure hs statistics about the idle times for
> all the cpus. Maybe we can look to use this infrastructure to decide
> whether to migrate timers or not?

Yes sorry I reallhy meant cpuidle when I wrote cpufreq. 
That's what I suggested too.

But if the problem is lock contention on the target CPU that would
still not completely solve it, just make it less frequent depending
on the idle pattern.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
