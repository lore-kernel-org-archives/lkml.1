Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYF1L1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYF1L1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 07:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYF1L1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 07:27:35 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:37677 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYF1L1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 07:27:33 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2008 07:27:33 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AncFAIu7ZUh5LCP2/2dsb2JhbACBW68t
X-IronPort-AV: E=Sophos;i="4.27,719,1204464600"; 
   d="scan'208";a="146915844"
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
From: Tim Connors <tconnors@astro.swin.edu.au>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Mail-Copies-To: tconnors@astro.swin.edu.au
In-reply-to: <48641A7D.6080204@firstfloor.org>
References: <20080625191100.GI21892@dirshya.in.ibm.com>
 <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com>
 <4863DB29.1020304@firstfloor.org>
 <20080626185254.GA12416@dirshya.in.ibm.com>
 <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com>
 <48640C04.9020600@firstfloor.org>
 <1214516584.12265.10.camel@twins.programming.kicks-ass.net>
 <48641A7D.6080204@firstfloor.org>
X-test-to: Andi Kleen <andi@firstfloor.org>
X-cc-to: Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
 balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
 Suresh B Siddha <suresh.b.siddha@intel.com>, Venkatesh Pallipadi
 <venkatesh.pallipadi@intel.com>, Ingo Molnar <mingo@elte.hu>, Peter
 Zijlstra <a.p.zijlstra@chello.nl>, Vatsa <vatsa@linux.vnet.ibm.com>,
 Gautham R Shenoy <ego@in.ibm.com>
X-reply-to-bofh-messageid: <aJ8it-6jm-27@gated-at.bofh.it>
X-Editor: xemacsclientserver
X-EndlessSeptember: Sat Sep 5415 14:44:23 EST 1993
X-yes-we-have-no-x-yes-archive-today: NO
X-Face: +*%dmR:3=9i\[:8fga\UgZT#@`f=DU0(wQqI'AR2/r0sBMO}Ax\,V*cWaW-owRlUmuz&=
 v\KItx0:gRCBg1&z_"4x&-N#Di7))]~p2('`6|5.c3&:Z?VLU`Zt5Kb,~uC6<y}P'~7A+^'|'+iAd
 4t43:P;tPiT<q=9P$MO]u^@OHn1_4#qP7,XiSo21SkgI`:5=i$,t&uNN_\LfuLyH`)8!:Tb]Z
Message-ID: <12146282628495-twc@hexane.ssi.swin.edu.au>
Date: Sat, 28 Jun 2008 21:22:27 +1000
User-Agent: slrn/pre0.9.9-111 (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> said on Fri, 27 Jun 2008 00:38:53 +0200:
> Peter Zijlstra wrote:
> 
> >> And your workload manager could just nice processes. It should probably
> >> do that anyways to tell ondemand you don't need full frequency.
> > 
> > Except that I want my nice 19 distcc processes to utilize as much cpu as
> > possible, but just not bother any other stuff I might be doing...
> 
> They already won't do that if you run ondemand and cpufreq. It won't
> crank up the frequency for niced processes.

Shouldn't there be a powernice, just as there is an ionice and a nice?
Just as you don't always want CPU priority and IO priority to be
coupled, Peter has just demonstrated a very good case where you don't
want power and CPU choices to be coupled.  Whether the ondemand
governor of CPUFreq counts a process as wanting the CPU to run at a
higher speed, and these scheduler decisions should be controlled by
powernice.  By default, perhaps a high powernice should equal a high
nice equal to a high ionice, but the user should be able to change
this.  The last thing you want is a distcc process taking up lots of
time, burning more Joules because it runs 10 times longer with only
half the power.  It's not a nice choice between that and running at
nice 0 where it interferes with the user's editing.
