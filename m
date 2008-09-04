Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYIDMMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYIDMMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYIDMML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:12:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:43390 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYIDMMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:12:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="376682069"
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1220526360.8609.213.camel@twins>
References: <1220518266.9590.22.camel@minggr>
	 <1220519034.8609.206.camel@twins>  <1220525579.12161.8.camel@minggr>
	 <1220526360.8609.213.camel@twins>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 20:12:08 +0800
Message-Id: <1220530328.12161.29.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Thats bizarre... that just indicates the better clock, which should give
> > > better (read fairer) scheduling hurts your workload.
> > > 
> > > Is there anything I can run to see if we can fix the scheduler perhaps?
> > 
> > I observed schedstats of sysbench, there's more
> > "nr_failed_migrations_hot"
> > 
> > 2.6.27-rc4: se.nr_failed_migrations_hot 11
> > 2.6.27-rc5: se.nr_failed_migrations_hot 95
> > 
> > task migration failed because of task_hot, the system is un-balanced?
> 
> Ah, that makes sense, a more accurate clock could indeed make more tasks
> hot.
> 
> Can you try fiddling with: /proc/sys/kernel/sched_migration_cost ?

sched_migration_cost		regression
----------------------          -------------
50000                           ~6%
0				~8%
500000 (default)		~10%
5000000                         ~14%
-1				~19%
			
> 
> Also, we used to have some auto-tuning in there, which dissapeared some
> time ago, gregory brought it back to live recently, perhaps he likes to
> share? :-)
> 

