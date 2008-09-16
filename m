Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbYIPDFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbYIPDFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 23:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYIPDFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 23:05:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:22606 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYIPDFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 23:05:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,405,1217833200"; 
   d="scan'208";a="616725819"
Subject: max_clock of the patch "sched_clock: fix cpu_clock()"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 11:01:37 +0800
Message-Id: <1221534097.30750.20.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

I have a question of the max_clock in below patch,
commit 354879bb977e06695993435745f06a0f6d39ce2b
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Aug 25 17:15:34 2008 +0200

    sched_clock: fix cpu_clock()

The original code to calculate min_clock and max_clock is,
min_clock = scd->tick_gtod + delta_jiffies * TICK_NSEC;
max_clock = min_clock + TICK_NSEC;

Now it's changed to,
min_clock = wrap_max(scd->tick_gtod, scd->clock);
max_clock = scd->tick_gtod + TICK_NSEC;

Is this max_clock still correct if, in a rare case, irq is disabled for
many ticks?

Thanks,
Lin Ming


