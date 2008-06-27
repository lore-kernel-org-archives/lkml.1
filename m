Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbYF0AQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbYF0AQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 20:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbYF0AQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 20:16:04 -0400
Received: from saeurebad.de ([85.214.36.134]:59910 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbYF0AQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 20:16:01 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 02:08:05 2008
Message-Id: <20080627000805.504878592@saeurebad.de>
References: <20080627000445.346130358@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 02:04:48 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
Content-Disposition: inline; filename=softlockup-fix-watchdog-wakeup.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wake up the watchdog every second instead of every second.  If the
current timestamp is bigger than the last touch, we are already (at
least) a second ahead.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 kernel/softlockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -108,7 +108,7 @@ void softlockup_tick(void)
 	now = get_timestamp(this_cpu);
 
 	/* Wake up the high-prio watchdog task every second: */
-	if (now > (touch_timestamp + 1))
+	if (now > touch_timestamp)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable delays: */

-- 

