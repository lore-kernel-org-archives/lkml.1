Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYE2HC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYE2HC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYE2HCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:02:51 -0400
Received: from mga06.intel.com ([134.134.136.21]:55173 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbYE2HCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:02:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,560,1204531200"; 
   d="scan'208";a="388190892"
Message-ID: <1740.172.16.180.81.1212044570.squirrel@linux.intel.com>
Date: Thu, 29 May 2008 00:02:50 -0700 (PDT)
Subject: [PATCH 2.6.26-rc3 : schedule] remove unlikely macros in 
     workqueue.c/queue_delayed_work_on
From: youquan_song@linux.intel.com
To: linux-kernel@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com
User-Agent: SquirrelMail/1.4.8-4.0.1.el4.centos
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_ondemand governor call queue_delayed_work_on with entry parameter
"cpu" every sample rate(every logical cpu during 20ms).check the value of
"cpu","cpu>=0" condition meeting rate is over than 90%.

This patch remove the unlikely macros to benefit kernel schedule and
reader comprehension.

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 workqueue.c    |    2++++++
 1 file changed,     1 insertions(+), 1 deletions(-)

--- linux-2.6/kernel/workqueue.c	2008-05-13 10:10:11.000000000 -0400
+++ linux-2.6-new/kernel/workqueue.c	2008-05-29 09:46:16.000000000 -0400
@@ -230,7 +230,7 @@
		timer->data = (unsigned long)dwork;
		timer->function = delayed_work_timer_fn;

-		if (unlikely(cpu >= 0))
+		if (cpu >= 0)
			add_timer_on(timer, cpu);
		else
			add_timer(timer);

