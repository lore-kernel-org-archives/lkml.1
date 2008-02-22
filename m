Return-Path: <linux-kernel-owner+w=401wt.eu-S1765100AbYBVTIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765100AbYBVTIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbYBVTIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:08:39 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37421 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbYBVTIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:08:37 -0500
Date: Fri, 22 Feb 2008 11:08:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout mechanism
Message-ID: <20080222190814.GD11213@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080221152504.4804.8724.stgit@novell1.haskins.net> <20080221152707.4804.59177.stgit@novell1.haskins.net> <200802211741.10299.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802211741.10299.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 05:41:09PM +0100, Andi Kleen wrote:
> 
> > +config RTLOCK_DELAY
> > +	int "Default delay (in loops) for adaptive rtlocks"
> > +	range 0 1000000000
> > +	depends on ADAPTIVE_RTLOCK
> 
> I must say I'm not a big fan of putting such subtle configurable numbers
> into Kconfig. Compilation is usually the wrong place to configure
> such a thing. Just having it as a sysctl only should be good enough.
> 
> > +	default "10000"
> 
> Perhaps you can expand how you came up with that default number? 
> It looks suspiciously round and worse the actual spin time depends a lot on the 
> CPU frequency (so e.g. a 3Ghz CPU will likely behave quite 
> differently from a 2Ghz CPU) Did you experiment with other spin times? 
> Should it be scaled with number of CPUs? And at what point is real
> time behaviour visibly impacted? 
> 
> Most likely it would be better to switch to something that is more
> absolute time, like checking RDTSC every few iteration similar to what
> udelay does. That would be at least constant time.

One approach would be to set the RTLOCK_DELAY parameter to something like
-1 for default, and to set it to the number of cycles required for about
10 cache misses at boot time.  This would automatically scale with CPU
frequency and memory latency.

							Thanx, Paul
