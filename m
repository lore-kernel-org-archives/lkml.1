Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYIDMmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYIDMmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYIDMmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:42:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:25320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYIDMmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:42:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="612687565"
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1220531187.8609.217.camel@twins>
References: <1220518266.9590.22.camel@minggr>
	 <1220519034.8609.206.camel@twins>  <1220525579.12161.8.camel@minggr>
	 <1220526360.8609.213.camel@twins>  <1220530328.12161.29.camel@minggr>
	 <1220531187.8609.217.camel@twins>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 20:42:03 +0800
Message-Id: <1220532123.12955.3.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-09-04 at 14:26 +0200, Peter Zijlstra wrote:
> On Thu, 2008-09-04 at 20:12 +0800, Lin Ming wrote:
> > > > > Thats bizarre... that just indicates the better clock, which should give
> > > > > better (read fairer) scheduling hurts your workload.
> > > > > 
> > > > > Is there anything I can run to see if we can fix the scheduler perhaps?
> > > > 
> > > > I observed schedstats of sysbench, there's more
> > > > "nr_failed_migrations_hot"
> > > > 
> > > > 2.6.27-rc4: se.nr_failed_migrations_hot 11
> > > > 2.6.27-rc5: se.nr_failed_migrations_hot 95
> > > > 
> > > > task migration failed because of task_hot, the system is un-balanced?
> > > 
> > > Ah, that makes sense, a more accurate clock could indeed make more tasks
> > > hot.
> > > 
> > > Can you try fiddling with: /proc/sys/kernel/sched_migration_cost ?
> > 
> > sched_migration_cost		regression
> > ----------------------          -------------
> > 50000                           ~6%
> > 0				~8%
> > 500000 (default)		~10%
> > 5000000                         ~14%
> > -1				~19%
> 
> at 50000 (~6%), is the predominant difference in schedstats still the
> nr_failed_migrations_hot?

Yes, it's strange that nr_failed_migrations_hot (cost=50000) is larger
than (cost=500000)

sched_migration_cost = 50000
----------------------------------------------------------
se.exec_start                      :       3475158.689868
se.vruntime                        :        935215.526989
se.sum_exec_runtime                :         14358.431942
se.avg_overlap                     :             0.000000
se.wait_start                      :             0.000000
se.sleep_start                     :       3475158.689868
se.block_start                     :             0.000000
se.sleep_max                       :            37.910779
se.block_max                       :             0.033796
se.exec_max                        :             0.121028
se.slice_max                       :             0.000000
se.wait_max                        :             6.007209
se.wait_sum                        :         25029.649588
se.wait_count                      :              1954948
sched_info.bkl_count               :                    0
se.nr_migrations                   :                 2521
se.nr_migrations_cold              :                    0
se.nr_failed_migrations_affine     :                    0
se.nr_failed_migrations_running    :                  147
se.nr_failed_migrations_hot        :                  123
se.nr_forced_migrations            :                    0
se.nr_forced2_migrations           :                 1236
se.nr_wakeups                      :              1952827
se.nr_wakeups_sync                 :              1944785
se.nr_wakeups_migrate              :                 2479
se.nr_wakeups_local                :              1930122
se.nr_wakeups_remote               :                22705
se.nr_wakeups_affine               :                13252
se.nr_wakeups_affine_attempts      :               825950
se.nr_wakeups_passive              :                    0
se.nr_wakeups_idle                 :                    0
avg_atom                           :             0.007355
avg_per_cpu                        :             5.695530
nr_switches                        :              1951994
nr_voluntary_switches              :              1949963
nr_involuntary_switches            :                 2031
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                   81


sched_migration_cost = 500000
----------------------------------------------------------
se.exec_start                      :       3719706.806593
se.vruntime                        :       1049301.798712
se.sum_exec_runtime                :         14636.764384
se.avg_overlap                     :             0.000121
se.wait_start                      :             0.000000
se.sleep_start                     :       3719706.806593
se.block_start                     :             0.000000
se.sleep_max                       :           214.989106
se.block_max                       :             0.036240
se.exec_max                        :             0.147829
se.slice_max                       :             0.000000
se.wait_max                        :             6.475864
se.wait_sum                        :         24932.530233
se.wait_count                      :              1922627
sched_info.bkl_count               :                    0
se.nr_migrations                   :                 2314
se.nr_migrations_cold              :                    0
se.nr_failed_migrations_affine     :                    0
se.nr_failed_migrations_running    :                   71
se.nr_failed_migrations_hot        :                   76
se.nr_forced_migrations            :                    0
se.nr_forced2_migrations           :                 1735
se.nr_wakeups                      :              1920337
se.nr_wakeups_sync                 :              1908767
se.nr_wakeups_migrate              :                 2272
se.nr_wakeups_local                :              1898194
se.nr_wakeups_remote               :                22143
se.nr_wakeups_affine               :                 1218
se.nr_wakeups_affine_attempts      :               820118
se.nr_wakeups_passive              :                    0
se.nr_wakeups_idle                 :                    0
avg_atom                           :             0.007624
avg_per_cpu                        :             6.325308
nr_switches                        :              1919596
nr_voluntary_switches              :              1917396
nr_involuntary_switches            :                 2200
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                   69




