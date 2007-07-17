Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbXGQARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbXGQARt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXGQARm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:17:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60082
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbXGQARl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:17:41 -0400
Date: Mon, 16 Jul 2007 17:17:44 -0700 (PDT)
Message-Id: <20070716.171744.85720528.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH]: Fix hrtimer hotplug cpu notifier bug on 64-bit.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I discussed this with Thomas Gleixner last night and he
seemed to be OK with fixing the problem as follows.

If he wants to do things differently, he can submit an alternate
change, but this thing is quite trivial so I doubt that will happen
:-)

Please apply, thanks.

[HRTIMER]: Fix cpu pointer arg to clockevents_notify().

All of the clockevent notifiers expect a pointer to
an "unsigned int" cpu argument, but hrtimer_cpu_notify()
passes in a pointer to a long.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 23c03f4..72d0342 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1406,7 +1406,7 @@ static void migrate_hrtimers(int cpu)
 static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 					unsigned long action, void *hcpu)
 {
-	long cpu = (long)hcpu;
+	unsigned int cpu = (long)hcpu;
 
 	switch (action) {
 
