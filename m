Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYF1MgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYF1MgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYF1MgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:36:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44489 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYF1MgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:36:06 -0400
Message-ID: <48663032.6010207@firstfloor.org>
Date: Sat, 28 Jun 2008 14:36:02 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org> <1214516584.12265.10.camel@twins.programming.kicks-ass.net> <48641A7D.6080204@firstfloor.org> <1214553090.2801.7.camel@twins.programming.kicks-ass.net> <48649F84.4090501@firstfloor.org> <20080628122237.GA22099@srcf.ucam.org>
In-Reply-To: <20080628122237.GA22099@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Fri, Jun 27, 2008 at 10:06:28AM +0200, Andi Kleen wrote:
> 
>> Ok distcc is a special case, but it doesn't apply to a lot of other
>> processes (do you really want your CPU to crank up for "updatedb" or
>> beagle or some backup job for example?)
> 
> If something's CPU-bound, then you almost certainly want to speed the 
> CPU up. There's no power advantage to leaving it at a low frequency. 

I'm not sure you can say it that certainly. While on many standalone systems
"race to idle" is the best strategy, there are cases where it is not
true.

For example if you're in a data center at a specific operating point and
you would need to crank up the air condition at significant power cost it might
be well better overall to force all servers to a lower operating point
and avoid that.

That said in general you all should have complained when ondemand behaviour
was introduced.

Also it's unclear that the general "race to idle" heuristic really
applies to the case of the "keep sockets idle" power optimization
that started this thread.

Usually package C states bring much more than core C states
and keeping another package completely idle saves likely
more power than the power cost of running something a little
bit slower on a package that is already busy on another core.

I still think using nice levels for this is reasonable.

-Andi
