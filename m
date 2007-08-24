Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbXHXIVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbXHXIVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbXHXIVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:21:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42065 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbXHXIVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:21:45 -0400
Date: Fri, 24 Aug 2007 13:51:21 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de
Subject: Re: [PATCH RFC] Priority boosting for preemptible RCU
Message-ID: <20070824082121.GA16301@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070822190254.GA1135@linux.vnet.ibm.com> <20070823042639.GA28026@in.ibm.com> <20070823085456.GA18627@linux.vnet.ibm.com> <20070823101444.GB11258@in.ibm.com> <20070823131501.GC18627@linux.vnet.ibm.com> <20070823142211.GC11258@in.ibm.com> <20070823155526.GB8371@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823155526.GB8371@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 08:55:26AM -0700, Paul E. McKenney wrote:
> > Even if we use another cpumask_t, whenever a cpu goes down or comes up,
> > that will be reflected in this map, no? So what's the additional
> > advantage of using it?
> 
> The additional map allows the code to use something other than the
> lock_cpu_hotplug/unlock_cpu_hotplug, and also is robust against any
> changes to the hotplug synchronization mechanism.  Might well be
> better just to use the current hotplug synchronization mechanism,
> but I was feeling paranoid.  ;-)

If it was doing something more complicated in the critical section other
than summing stuff up, I would probably recommend going for another map
instead of using the current hotplug synchronization. But for this case
the current hotplug synchronization would work just fine.

I can very well understand your paranoia, but let me assure you, you are
not the only one ;-)

Regards
gautham.
> 
> 						Thanx, Paul

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
