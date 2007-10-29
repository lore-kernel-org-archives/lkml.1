Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbXJ2Ffi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbXJ2Ffi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbXJ2Ffa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:35:30 -0400
Received: from ozlabs.org ([203.10.76.45]:54353 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbXJ2Ffa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:35:30 -0400
To: <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Message-Id: <ed0a9ee8c6bc2ac894924b24c22a221a07e66931.1193635831.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] Quieten hrtimer printk: "Switched to high resolution mode .."
Date: Mon, 29 Oct 2007 16:35:29 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the hrtimer printk "Switched to high resolution mode .." to
be KERN_DEBUG, rather than KERN_INFO. If users need to see this they
can pass "loglevel" or "debug" on the command line, or check dmesg.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---

Any objections? It gets a little repetitive, eg:

Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 17
Switched to high resolution mode on CPU 10
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 7
Switched to high resolution mode on CPU 11
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 8
Switched to high resolution mode on CPU 12
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 13
Switched to high resolution mode on CPU 14
Switched to high resolution mode on CPU 15
Switched to high resolution mode on CPU 9
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 16

cheers


 kernel/hrtimer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b6d2ff7..22a2514 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -602,7 +602,7 @@ static int hrtimer_switch_to_hres(void)
 	/* "Retrigger" the interrupt to get things going */
 	retrigger_next_event(NULL);
 	local_irq_restore(flags);
-	printk(KERN_INFO "Switched to high resolution mode on CPU %d\n",
+	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
 	       smp_processor_id());
 	return 1;
 }
-- 
1.5.2.rc1.1884.g59b20

