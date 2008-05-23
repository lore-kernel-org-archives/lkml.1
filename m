Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYEWKA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYEWKA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYEWKAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:00:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:32882 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754475AbYEWKAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:00:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX195rpZvTz154lhEoEVgH2WlfbGcJoDMRIeh6+rM5N
	WlVkiSJMO1qfnT
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Greg Smith <gsmith@gregsmith.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <Pine.GSO.4.64.0805230232190.28654@westnet.com>
References: <Pine.GSO.4.64.0805211115390.8451@westnet.com>
	 <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
Content-Type: text/plain
Date: Fri, 23 May 2008 12:00:14 +0200
Message-Id: <1211536814.5851.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 03:13 -0400, Greg Smith wrote:

> With this feedback, any ideas on where to go next?  There seems like's 
> some room for improvement still left here.

Dunno.  This load is very highly tweakable, and doesn't seem to like
preemption much at all.  You can see below what preemption is doing to
2.6.22.18 by looking at the batch numbers.  SCHED_BATCH turns the O(1)
scheduler into a pathetic little round-robin scheduler, and this load
loves pathetic :-)  After seeing the batch numbers, I tweaked .git to
make it as round-robin as I could.

My take on the numbers is that both kernels preempt too frequently for
_this_ load.. but what to do, many many loads desperately need
preemption to perform.

      2.6.22.18     2.6.22.18-batch          2.6.26.git    2.6.26.git.batch
1   7487.115236         7643.563512         9999.400036         9915.823582
2  17074.869889        15360.150210        14042.644140        14958.375329
3  25073.139078        24802.446538        15621.206938        25047.032536
4  24236.413612        26126.482482        16436.055117        25007.183313
5  26367.198572        28298.293443        19926.550734        27853.081679
6  24695.827843        30786.651975        22375.916107        28119.474302
8  21020.949689        31973.674156        25825.292413        31070.664011
10 22792.204610        31775.164023        26754.471274        31596.415197
15 21202.173186        30388.559630        28711.761083        30963.050265
20 21204.041830        29317.044783        28512.269685        30127.614550
30 18519.965964        27252.739106        26682.613791        28185.244056
40 17936.447579        25670.803773        24964.936746        26282.369366
50 16247.605712        25089.154310        21078.604858        25356.750461

	-Mike

