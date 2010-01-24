Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953Ab0AXQTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0AXQTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606Ab0AXQTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:19:51 -0500
Received: from www.tglx.de ([62.245.132.106]:58219 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab0AXQTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:19:51 -0500
Date: Sun, 24 Jan 2010 17:19:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer fixes for 2.6.33
Message-ID: <alpine.LFD.2.00.1001241718230.2906@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Xiaotian Feng (1):
      clockevent: Don't remove broadcast device when cpu is dead


 kernel/time/clockevents.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 6f740d9..d7395fd 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -259,7 +259,8 @@ void clockevents_notify(unsigned long reason, void *arg)
 		cpu = *((int *)arg);
 		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
 			if (cpumask_test_cpu(cpu, dev->cpumask) &&
-			    cpumask_weight(dev->cpumask) == 1) {
+			    cpumask_weight(dev->cpumask) == 1 &&
+			    !tick_is_broadcast_device(dev)) {
 				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 				list_del(&dev->list);
 			}
