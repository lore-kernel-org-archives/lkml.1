Return-Path: <linux-kernel-owner+w=401wt.eu-S935033AbYEVJFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033AbYEVJFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763247AbYEVJFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:05:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:50896 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761090AbYEVJFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:05:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/wUB1lPm7wROXdQLdLLNVE/vaSAZbECYt2269K/X
	bz+HtHQJdOL9oQ
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Greg Smith <gsmith@gregsmith.com>, lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20080522082814.GA4499@linux.vnet.ibm.com>
References: <Pine.GSO.4.64.0805211115390.8451@westnet.com>
	 <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 11:05:05 +0200
Message-Id: <1211447105.4823.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 13:58 +0530, Dhaval Giani wrote:
> On Thu, May 22, 2008 at 09:10:07AM +0200, Mike Galbraith wrote:
> > 
> > On Wed, 2008-05-21 at 13:34 -0400, Greg Smith wrote:
> > > PostgreSQL ships with a simple database benchmarking tool named pgbench, 
> > > in what's labeled the contrib section (in many distributions it's a 
> > > separate package from the main server/client ones).  I see there's been 
> > > some work done already improving how the PostgreSQL server works under the 
> > > new scheduler (the "Poor PostgreSQL scaling on Linux 2.6.25-rc5" thread). 
> > > I wanted to provide you a different test case using pgbench that has taken 
> > > a sharp dive starting with 2.6.23, and the server improvement changes in 
> > > 2.6.25 actually made this problem worse.
> > > 
> > > I think it will be easy for someone else to replicate my results and I'll 
> > > go over the exact procedure below.
> > 
> > Yup, I can reproduce.  Running the test with 2.6.25.4, everything is
> > waking/running on one CPU, leaving my box 75% idle.  Not good.
> > 
> 
> Can you try with 2.6.26-rc? There is minimal load balancing for group
> scheduling till 25, which might explain the lack of scalability.

I'm playing with it now, it's tweakable with migration cost.  This
testcase is funky.  It can't generate enough work to keep CPUs busy for
spit, and can't saturate my little quad with any kernel I've tried.

	-Mike

