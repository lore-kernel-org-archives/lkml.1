Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZKFHiC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZKFHiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:38:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZKFHiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:38:01 -0500
Received: from mga07.intel.com ([143.182.124.22]:40367 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752887AbZKFHiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:38:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,691,1249282800"; 
   d="scan'208";a="208374289"
Subject: specjbb2005 and aim7 regression with 2.6.32-rc kernels
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 15:38:50 +0800
Message-Id: <1257493130.16282.109.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.31, specjbb2005 and aim7 have some regressions with
2.6.32-rc kernels on core2 machines.

1) On 4*4 core tigerton: specjbb2005 has about 5% regression.
2) On 2*4 stoakley: aim7 has about 5% regression.

On Nehalem, specjbb2005 has about 2%~8%  improvement instead of regression.

aim7 has much dependency on schedule patameters, such like sched_latency_ns,
sched_min_granularity_ns, and sched_wakeup_granularity_ns. 2.6.32-rc kernel
decreases these parameter values. I restore them and retest aim7 on stoakley.
aim7 regression becomes about 2% and specjbb2005 regression also becomes
2%. But on Nehalem, the improvement shrinks.


