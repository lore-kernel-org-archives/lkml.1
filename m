Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476Ab0AHCyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0AHCyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 21:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443Ab0AHCyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 21:54:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:22383 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab0AHCyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 21:54:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,238,1262592000"; 
   d="scan'208";a="529503569"
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262870055.9337.34.camel@marge.simson.net>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
	 <1262659686.22471.121.camel@minggr.sh.intel.com>
	 <1262663058.5748.32.camel@marge.simson.net>
	 <1262673817.9534.37.camel@marge.simson.net>
	 <1262853903.18931.17.camel@minggr.sh.intel.com>
	 <1262870055.9337.34.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 08 Jan 2010 10:38:51 +0800
Message-Id: <1262918331.3598.14.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 21:14 +0800, Mike Galbraith wrote:
> On Thu, 2010-01-07 at 16:45 +0800, Lin Ming wrote:
> > On Tue, 2010-01-05 at 14:43 +0800, Mike Galbraith wrote:
> > > On Tue, 2010-01-05 at 04:44 +0100, Mike Galbraith wrote:
> > > > On Tue, 2010-01-05 at 10:48 +0800, Lin Ming wrote:
> > > > > On Mon, 2010-01-04 at 17:03 +0800, Lin Ming wrote:
> > > > > > commit a03ecf08d7bbdd979d81163ea13d194fe21ad339
> > > > > > Author: Lin Ming <ming.m.lin@intel.com>
> > > > > > Date:   Mon Jan 4 14:14:50 2010 +0800
> > > > > > 
> > > > > >     sched: Pass affine target cpu into wake_affine
> > > > > >     
> > > > > >     Since commit a1f84a3(sched: Check for an idle shared cache in select_task_rq_fair()),
> > > > > >     the affine target maybe adjusted to any idle cpu in cache sharing domains
> > > > > >     instead of current cpu.
> > > > > >     But wake_affine still use current cpu to calculate load which is wrong.
> > > > > >     
> > > > > >     This patch passes affine cpu into wake_affine.
> > > > > >     
> > > > > >     Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > > > 
> > > > > Mike,
> > > > > 
> > > > > Any comment of this patch?
> > > > 
> > > > The patch definitely looks like the right thing to do, but when I tried
> > > > this, it didn't work out well.  Since I can't seem to recall precise
> > > > details, I'll let my box either remind me or give it's ack.
> > > 
> > > Unfortunately, box reminded me.  mysql+oltp peak throughput with
> > > nr_clients == nr_cpus
> > 
> > Did you test with your vmark regression fix patch also applied?
> 
> Below is a complete retest.  Mind testing my hacklet?  I bet a nickle
> it'll work at least as well as yours on your beefy boxen.

I tested your hacklet on below 2 machines as before.

Tigerton x86_64 machine: 16cpus(4P/4Cores), 40G mem
IA64 machine: 32cpus(4P/4Cores/HT), 16G mem

Test1: vmark regression fix patch + pass affine target
Test2: this hacklet

Compared with upstream 2.6.33-rc2, 
Test1: Tigerton +3%, IA64 +15%
Test2: Tigerton +3%, IA64 +10%

The test2 also improves on IA64, although not as good as test1.

I also tested tbench, this hacklet does not help.

Lin Ming

