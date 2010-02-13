Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0BMKgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 05:36:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:44305 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab0BMKgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 05:36:11 -0500
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Feb 2010 11:36:28 +0100
Message-ID: <1266057388.557.59599.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 17:31 -0800, Suresh Siddha wrote:
> 
> We have one more problem that Yanmin and Ling Ma reported. On a dual
> socket quad-core platforms (for example platforms based on NHM-EP), we
> are seeing scenarios where one socket is completely busy (with all the 4
> cores running with 4 tasks) and another socket is completely idle.
> 
> This causes performance issues as those 4 tasks share the memory
> controller, last-level cache bandwidth etc. Also we won't be taking
> advantage of turbo-mode as much as we like. We will have all these
> benefits if we move two of those tasks to the other socket. Now both the
> sockets can potentially go to turbo etc and improve performance.
> 
> In short, your recent change (shown below) broke this behavior. In the
> kernel summit you mentioned you made this change with out affecting the
> behavior of SMT/MC. And my testing immediately after kernel-summit also
> didn't show the problem (perhaps my test didn't hit this specific
> change). But apparently we are having performance issues with this patch
> (Ling Ma's bisect pointed to this patch). I will look more detailed into
> this after the long weekend (to see if we can catch this scenario in
> fix_small_imbalance() etc). But wanted to give you a quick heads up.
> Thanks.

Right, so the behaviour we want should be provided by SD_PREFER_SIBLING,
it provides the capacity==1 thing the cpu_power games used to provide.

Not saying it's not broken, but that's where the we should be looking to
fix it.
