Return-Path: <linux-kernel-owner+w=401wt.eu-S1765672AbYBNHna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765672AbYBNHna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbYBNHnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:43:19 -0500
Received: from mga05.intel.com ([192.55.52.89]:30191 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756273AbYBNHnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:43:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,350,1199692800"; 
   d="scan'208";a="518385056"
Subject: Re: 2.6.25-rc1: volanoMark 45% regression
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: vatsa@linux.vnet.ibm.com
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20080213120708.GA16231@linux.vnet.ibm.com>
References: <1202895028.3027.27.camel@ymzhang>
	 <47B2BC2C.80100@linux.vnet.ibm.com>
	 <20080213120708.GA16231@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 14 Feb 2008 15:41:41 +0800
Message-Id: <1202974901.3027.58.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 17:37 +0530, Srivatsa Vaddagiri wrote:
> On Wed, Feb 13, 2008 at 03:15:16PM +0530, Balbir Singh wrote:
> > Zhang, Yanmin wrote:
> > > volanoMark has 45% regression with kernel 2.6.25-rc1 on my both 8-core
> > > stoakley and 16-core Tigerton.
> > > 
> > > I used bisect to locate below patch.
> > > 
> > > commit 58e2d4ca581167c2a079f4ee02be2f0bc52e8729
> > > Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > > Date:   Fri Jan 25 21:08:00 2008 +0100
> > > 
> > >     sched: group scheduling, change how cpu load is calculated
> > > 
> > > 
> > > 
> > > hackbench has about 30% regression on 16-core tigerton, but has about 10% improvement
> > > on 8-core stoakley.
> > > 
> > > In addition, tbench has about 6% regression on my 8-core stoakley and
> > > 25% regression on 16-core stoakley.
I verified tbench regression is not caused by the same patch. I am digging tbench now.

>  Some other benchmarks, like netperf/aim7
> > > also have some regression. I will verify if they are all related to the
> > > patch.
> > > 
> > > -yanmin
> > 
> > Hi, Yamin,
> > 
> > Thanks for reporting the issue? Any chance we could getthe Oprofile output for
> > the run?
I got oprofile data but it didn't show clear evidence.

When doing volanoMark testing, vmstat showed the good kernel's context switch
is about 1100000, but the bad kernel's context switch is 720000. Good kernel's
idle is about 1%, and bad kernel's idle is about 5%.

>  The exact commandline and .config being used would also help.
I used some scripts to start volanoMark.

Netperf loop UDP-RR-1/512's 10% regression on 16-core tigerton is also related to the patch.
If I set CONFIG_FAIR_GROUP_SCHED=n, there is no the netperf regression. I bind the netserver
process to a core and bind the client to another core in another processor.

It's hard to debug into netperf regression if it's caused by scheduler.

> 
> Yamin,
> 	I would also like to know against which previous version is this
> regression being compared with. Is it 2.6.24?
Yes.

>  Did you have
> CONFIG_FAIR_USER_SCHED enabled in both cases?
Yes.

CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y

>  It would also help to know if you
> see the same regression with FAIR_GROUP_SCHED turned off.
No regression if CONFIG_FAIR_GROUP_SCHED=n.

-yanmin



