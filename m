Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZGZISp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZGZISp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZGZISn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:18:43 -0400
Received: from www.tglx.de ([62.245.132.106]:57776 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbZGZISm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:18:42 -0400
Message-Id: <20090726081553.636717065@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [Patch RFC 03/37] input: misc/hp_sdc_rtc: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=driver-input-misc-hp-sdc-rtc-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of these "mutex"es is non obvious and probably a completion in
some places. Make them semaphores.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/misc/hp_sdc_rtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/drivers/input/misc/hp_sdc_rtc.c
===================================================================
--- linux-2.6-tip.orig/drivers/input/misc/hp_sdc_rtc.c
+++ linux-2.6-tip/drivers/input/misc/hp_sdc_rtc.c
@@ -104,7 +104,7 @@ static int hp_sdc_rtc_do_read_bbrtc (str
 	t.endidx =		91;
 	t.seq =			tseq;
 	t.act.semaphore =	&tsem;
-	init_MUTEX_LOCKED(&tsem);
+	semaphore_init_locked(&tsem);
 	
 	if (hp_sdc_enqueue_transaction(&t)) return -1;
 	
@@ -686,7 +686,7 @@ static int __init hp_sdc_rtc_init(void)
 		return -ENODEV;
 #endif
 
-	init_MUTEX(&i8042tregs);
+	semaphore_init(&i8042tregs);
 
 	if ((ret = hp_sdc_request_timer_irq(&hp_sdc_rtc_isr)))
 		return ret;


