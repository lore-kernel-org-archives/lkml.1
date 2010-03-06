Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab0CFIWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 03:22:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:38315 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751973Ab0CFIWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 03:22:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+RUndKPdWRetP96jNDrKr22MGMEp7nV9d+BFEOcB
	73cXVawUMMoP/A
Subject: Re: [patch 2/2] sched: fix select_idle_sibling() logic in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1267820755.6384.85.camel@marge.simson.net>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
	 <20100305184213.922106492@sbs-t61.sc.intel.com>
	 <1267820755.6384.85.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 06 Mar 2010 09:21:55 +0100
Message-Id: <1267863715.22645.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 21:25 +0100, Mike Galbraith wrote: 
> On Fri, 2010-03-05 at 10:39 -0800, Suresh Siddha wrote:
>  
> > c) Also, selelct_idle_sibling() should also treat the current cpu as an idle
> >    cpu if it is a sync wakeup and we have only one task running.
> 
> I'm going to have to crawl over and test the above, but this bit sounds
> like a decidedly un-good thing to do.  Maybe I'm misunderstanding.

Nope, no misunderstanding.  This patch does kill throughput gains.  Once
awakened affine, always awaken affine is a bad idea.

I dug up my old P4 though.  With it's wimpy siblings, the cost of
running two schedulers doesn't appear to be generally worth it at a
glance.  You need considerable overlap to break even.

	-Mike

