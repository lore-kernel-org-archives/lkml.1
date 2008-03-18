Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYCRJQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYCRJQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYCRJQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:16:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:47749 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbYCRJQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:16:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,517,1199692800"; 
   d="scan'208";a="307193727"
Subject: volanoMark 12% regression with 2.6.25-rc6
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 18 Mar 2008 17:14:10 +0800
Message-Id: <1205831650.3215.569.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.25-rc5, volanoMark has 12% regression with 2.6.25-rc6
on my 8-core stoakley.


Bisect tracked it down to:

e22ecef1d2658ba54ed7d3fdb5d60829fb434c23 is first bad commit
commit e22ecef1d2658ba54ed7d3fdb5d60829fb434c23
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Mar 14 22:16:08 2008 +0100

    sched: fix fair sleepers
    
    Fair sleepers need to scale their latency target down by runqueue
    weight. Otherwise busy systems will gain ever larger sleep bonus.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


In the patch, vruntime -= calc_delta_fair(sysctl_sched_latency, &cfs_rq->load).

Should we call __sched_period to get the first parameter of calc_delta_fair in case
there are more than 5 tasks in the runqueue?

-yanmin


