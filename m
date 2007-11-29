Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbXK2HiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbXK2HiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXK2Hhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:37:45 -0500
Received: from [222.73.24.84] ([222.73.24.84]:57831 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbXK2Hhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:37:43 -0500
Message-ID: <474E6BAD.4050508@cn.fujitsu.com>
Date: Thu, 29 Nov 2007 15:35:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: [PATCH 1/6] clocksource: remove redundant code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Flag CLOCK_SOURCE_WATCHDOG is cleared twice. Note clocksource_change_rating()
won't do anyting with the cs flag.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 kernel/time/clocksource.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c8a9d13..0ba9fa8 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -91,7 +91,6 @@ static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
 	       cs->name, delta);
 	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
 	clocksource_change_rating(cs, 0);
-	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
 	list_del(&cs->wd_list);
 }
 
-- 
1.5.3.rc7

