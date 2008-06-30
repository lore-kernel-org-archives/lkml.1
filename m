Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYF3Obz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYF3Obz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYF3Obr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:31:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43832 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYF3Obr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:31:47 -0400
Message-ID: <4868EE4C.7000103@firstfloor.org>
Date: Mon, 30 Jun 2008 16:31:40 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: davecb@sun.com
CC: svaidy@linux.vnet.ibm.com, Tim Connors <tconnors@astro.swin.edu.au>,
       Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org> <1214516584.12265.10.camel@twins.programming.kicks-ass.net> <48641A7D.6080204@firstfloor.org> <12146282628495-twc@hexane.ssi.swin.edu.au> <4867CE52.8040204@sun.com> <20080630043327.GA6276@dirshya.in.ibm.com> <4868EB3B.1030608@sun.com>
In-Reply-To: <4868EB3B.1030608@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Collier-Brown wrote:
> Vaidyanathan Srinivasan wrote:
>> I am trying to find answer to the question: Should we have the power
>> saving tunable as 'nice' value per process or system wide?
>>
>> How should we interpret the POWER parameter in a datacenter with power
>> constraint as mentioned in this thread?  Or in a simple case of AC vs
>> battery in a laptop.
> 
> I agree with Tim re setting them all independently, 

I agree that powernice is likely a good idea (although the semantics
are not 100% clear yet), but there's still the issue
(shared with ionice) that 99.99+% of all setups won't set powernice
explicitely  so you still need a reasonable default when it is not
set.

Me thinks the correct strategy would be something like this:

- When powernice is set prefer it
- For the idle socket optimization: use nice because it's
unclear that "race to idle" applies here.
- For ondemand: when nice is set behave more like the conservative
governor and take longer to crank up [this might be controversal]

Also are the best powernice semantics the same between idle
sockets and ondemand? I'm not sure.


and suggest that
> they're all really per-process values: setting power saving system-wide
> is meaningful, but so are individual settings.
> There is therefor an argument for making them subsets of
> a higher-level nice program.
> 
> Mind you, the order in which one *implements* the capability,
> and whether one does powernice first and adds it to nice later
> is your call!  I have no idea of how hard what I suggested is (;-))

In general for Linux deployment it tends to be easier
to provide another package with an own command instead of
patching a core package like coreutils

With an own package you can just tell the user
"type (yum|zypper|apt-get|...) install powernice",
while an updated coreutils tends to be more trouble or even
require a distribution update.

-Andi


