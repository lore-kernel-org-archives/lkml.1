Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbZJIJTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbZJIJTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbZJIJTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:19:17 -0400
Received: from mga06.intel.com ([134.134.136.21]:38368 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753774AbZJIJTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:19:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,530,1249282800"; 
   d="scan'208";a="455932018"
Subject: hackbench regression with kernel 2.6.32-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 17:19:03 +0800
Message-Id: <1255079943.25078.23.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.31's results, hackbench has some regression on a couple of
machines woth kernel 2.6.32-rc1.
I run it with commandline:
./hackbench 100 process 2000

1) On 4*4 core tigerton: 70%;
2) On 2*4 core stoakley: 7%.

I located below 2 patches.
commit 29cd8bae396583a2ee9a3340db8c5102acf9f6fd
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Sep 17 09:01:14 2009 +0200

    sched: Fix SD_POWERSAVING_BALANCE|SD_PREFER_LOCAL vs SD_WAKE_AFFINE

and 

commit de69a80be32445b0a71e8e3b757e584d7beb90f7
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Sep 17 09:01:20 2009 +0200

    sched: Stop buddies from hogging the system


1) On 4*4 core tigerton: if I revert patch 29cd8b, the regression becomes
less than 55%; If I revert the 2 patches, all regression disappears.
2) On 2*4 core stakley: If I revert the 2 patches, comparing with 2.6.31,
I get about 8% improvement instead of regression.

Sorry for reporting the regression later as there is a long national holiday.

Yanmin


