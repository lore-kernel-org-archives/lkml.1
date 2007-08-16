Return-Path: <linux-kernel-owner+w=401wt.eu-S935013AbXHPIjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbXHPIjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbXHPI3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:29:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765950AbXHPI3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:29:01 -0400
Message-Id: <20070816074525.065850000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 09:45:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 00/23] per device dirty throttling -v9
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

Changes since -v8:
 - cleanup of the proportion code
 - fix percpu_counter_add(&counter, -(unsigned long))
 - fix per task dirty rate code
 - fwd port to .23-rc2-mm2

--

