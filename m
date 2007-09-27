Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbXI0WRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbXI0WRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbXI0WRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:17:08 -0400
Received: from www.osadl.org ([213.239.205.134]:44905 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754743AbXI0WRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:17:07 -0400
Subject: [PATCH] clockevents: fix bogus next_event reset for oneshot
	broadcast devices
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 00:17:04 +0200
Message-Id: <1190931424.23376.154.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In periodic broadcast mode the next_event member of the broadcast device
structure is set to KTIME_MAX in the interrupt handler. This is wrong,
as we calculate the next periodic interrupt with this variable.

Remove it.

Noticed by Ralf. MIPS is the first user of this mode, it does not affect
existing users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-and-tested-by: Ralf Baechle <ralf@linux-mips.org>
---

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 0962e05..acf15b4 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -176,8 +176,6 @@ static void tick_do_periodic_broadcast(void)
  */
 static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
-	dev->next_event.tv64 = KTIME_MAX;
-
 	tick_do_periodic_broadcast();
 
 	/*


