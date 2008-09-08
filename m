Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYIHNzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYIHNzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYIHNzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:55:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYIHNzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:55:00 -0400
Date: Mon, 8 Sep 2008 15:58:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
Message-ID: <20080908135834.GH26079@one.firstfloor.org>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com> <1220880346.12278.17.camel@twins.programming.kicks-ass.net> <20080908134843.GA4053@dirshya.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908134843.GA4053@dirshya.in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. Detailed documentation

Messy code cannot be really made good with documentation. It's
not that your patches are that messy, it's more that it makes
something already overcomplicated even worse.

> 2. Cleanup the group_min and group_leader stuff in
>    find_busiest_group()

I think one issue is that there are general too many special cases
that completely change the algorithm especially for power saving.
Perhaps it would make sense to refactor the code a bit and then
use different high level code paths for those?  I assume that
would make it all simpler and easier to understand.

The other alternative would be to dynamically change the domains
so that a generic graph walker without knowledge of power savings
could DTRT in all cases. But I assume that would be much harder.

-Andi


