Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbYAGVXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbYAGVXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYAGVXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:23:40 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:51230 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbYAGVXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:23:39 -0500
Message-ID: <4782984F.3050601@ct.jp.nec.com>
Date: Mon, 07 Jan 2008 13:23:27 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: enable irq in default_idle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I think local_irq_enable() is missing in default_idle() on x86_64.
It's for recent x86 tree.

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86_64: enable irq in default_idle

local_irq_enable() is missing after sched_clock_idle_wakeup_event().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/process_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c6ad1a0..93ce4f3 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -119,8 +119,8 @@ void default_idle(void)
 		t1 = ktime_get();
 		t1n = ktime_to_ns(t1);
 		sched_clock_idle_wakeup_event(t1n - t0n);
-	} else
-		local_irq_enable();
+	}
+	local_irq_enable();
 	current_thread_info()->status |= TS_POLLING;
 }
 
-- 
1.5.3.6


