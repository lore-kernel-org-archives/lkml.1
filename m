Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbYJZDzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbYJZDzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 23:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYJZDzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 23:55:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55062
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbYJZDzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 23:55:24 -0400
Date: Sat, 25 Oct 2008 20:55:01 -0700 (PDT)
Message-Id: <20081025.205501.193695937.davem@davemloft.net>
To: rjw@sisk.pl
Cc: mingo@elte.hu, s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, efault@gmx.de
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200810251313.21120.rjw@sisk.pl>
References: <200810250025.35734.rjw@sisk.pl>
	<20081024.163111.244324800.davem@davemloft.net>
	<200810251313.21120.rjw@sisk.pl>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, 25 Oct 2008 13:13:20 +0200

> Could you please give me a pointer to the commit disabling the hrtimer feature?

Here it is:

commit 0c4b83da58ec2e96ce9c44c211d6eac5f9dae478
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Oct 20 14:27:43 2008 +0200

    sched: disable the hrtick for now
    
    David Miller reported that hrtick update overhead has tripled the
    wakeup overhead on Sparc64.
    
    That is too much - disable the HRTICK feature for now by default,
    until a faster implementation is found.
    
    Reported-by: David Miller <davem@davemloft.net>
    Acked-by: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 7c9e8f4..fda0162 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -5,7 +5,7 @@ SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 SCHED_FEAT(SYNC_WAKEUPS, 1)
-SCHED_FEAT(HRTICK, 1)
+SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 1)
