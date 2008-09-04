Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYIDM0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYIDM0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYIDM0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:26:42 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:5652 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYIDM0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:26:42 -0400
X-SourceIP: 213.46.9.244
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1220530328.12161.29.camel@minggr>
References: <1220518266.9590.22.camel@minggr>
	 <1220519034.8609.206.camel@twins>  <1220525579.12161.8.camel@minggr>
	 <1220526360.8609.213.camel@twins>  <1220530328.12161.29.camel@minggr>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 14:26:27 +0200
Message-Id: <1220531187.8609.217.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 20:12 +0800, Lin Ming wrote:
> > > > Thats bizarre... that just indicates the better clock, which should give
> > > > better (read fairer) scheduling hurts your workload.
> > > > 
> > > > Is there anything I can run to see if we can fix the scheduler perhaps?
> > > 
> > > I observed schedstats of sysbench, there's more
> > > "nr_failed_migrations_hot"
> > > 
> > > 2.6.27-rc4: se.nr_failed_migrations_hot 11
> > > 2.6.27-rc5: se.nr_failed_migrations_hot 95
> > > 
> > > task migration failed because of task_hot, the system is un-balanced?
> > 
> > Ah, that makes sense, a more accurate clock could indeed make more tasks
> > hot.
> > 
> > Can you try fiddling with: /proc/sys/kernel/sched_migration_cost ?
> 
> sched_migration_cost		regression
> ----------------------          -------------
> 50000                           ~6%
> 0				~8%
> 500000 (default)		~10%
> 5000000                         ~14%
> -1				~19%

at 50000 (~6%), is the predominant difference in schedstats still the
nr_failed_migrations_hot?

