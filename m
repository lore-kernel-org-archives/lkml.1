Return-Path: <linux-kernel-owner+w=401wt.eu-S1762461AbXHCM7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762461AbXHCM7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762110AbXHCM5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:57:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762091AbXHCM5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:57:04 -0400
Message-Id: <20070803123712.987126000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 14:37:13 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 00/23] per device dirty throttling -v8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Per device dirty throttling patches

These patches aim to improve balance_dirty_pages() and directly address three
issues:
  1) inter device starvation
  2) stacked device deadlocks
  3) inter process starvation

1 and 2 are a direct result from removing the global dirty limit and using
per device dirty limits. By giving each device its own dirty limit is will
no longer starve another device, and the cyclic dependancy on the dirty limit
is broken.

In order to efficiently distribute the dirty limit across the independant
devices a floating proportion is used, this will allocate a share of the total
limit proportional to the device's recent activity.

3 is done by also scaling the dirty limit proportional to the current task's
recent dirty rate.

Changes since -v7:
 - perpcu_counter renames (partially suggested by Linus)
 - percpu_counter error handling
 - bdi_init error handling
 - fwd port to .23-rc1-mm


---
#
# cleanups
#
nfs_congestion_fixup.patch
#
# percpu_counter rework
#
percpu_counter_add.patch
percpu_counter_batch.patch
percpu_counter_add64.patch
percpu_counter_set.patch
percpu_counter_sum_positive.patch
percpu_counter_sum.patch
percpu_counter_init.patch
percpu_counter_init_irq.patch
#
# per BDI dirty pages
#
bdi_init.patch
bdi_init_container.patch
bdi_init_mtd.patch
mtd-bdi-fixups.patch
bdi_mtdconcat.patch
bdi_stat.patch
bdi_stat_reclaimable.patch
bdi_stat_writeback.patch
bdi_stat_sysfs.patch
#
# floating proportions
#
proportions.patch
proportions_single.patch
#
# per BDI dirty
#
writeback-balance-per-backing_dev.patch
dirty_pages2.patch
#
# debug foo
#
bdi_stat_debug.patch


