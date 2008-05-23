Return-Path: <linux-kernel-owner+w=401wt.eu-S1760412AbYEWXrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412AbYEWXrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYEWXqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:46:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:38966 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750787AbYEWXqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:46:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+bWI4GHBGbiKZqu694ZYsbqYBgzUkYTXehQDjd3T
	+Ck1jQ0VQABWMI
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Greg Smith <gsmith@gregsmith.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <Pine.GSO.4.64.0805231907150.25273@westnet.com>
References: <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
	 <1211536814.5851.18.camel@marge.simson.net>
	 <20080523101000.GA13964@elte.hu>
	 <1211537717.5851.22.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805231907150.25273@westnet.com>
Content-Type: text/plain
Date: Sat, 24 May 2008 01:46:47 +0200
Message-Id: <1211586407.4786.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 19:18 -0400, Greg Smith wrote:
> On Fri, 23 May 2008, Mike Galbraith wrote:
> 
> > It was running SCHED_BATCH, features=0...it needed features=0 as well to 
> > achieve O(1) batch performance.
> 
> I figured out how to run pgbench with chrt in order to get SCHED_BATCH 
> behavior, but I don't understand what you mean by features=0 here.  Since 
> I didn't see the same magnitude of different just using batch that seems 
> important, where does that get set at?

/proc/sys/kernel/sched_features.  You need CONFIG_SCHED_DEBUG to have
accsess to the scheduler tweakables.

> I'm also curious what hardware your results are coming from, to fit them 
> into my larger pgbench results context space.

A grocery store Q6600 box.

> Got my 4-core system back on-line again today (found some bad RAM) and 
> wanted to try another round of tests on that.  Looks like you've defined 5 
> test sets I should replicate:
> 
> 2.6.22
> 2.6.22, batch
> 2.6.26.git
> 2.6.26.git, batch
> 2.6.26.git, batch + se.load.weight patch
> 
> Should I still be trying Peter's se.waker patch as well in this mix 
> somewhere?

Yeah.

	-Mike

