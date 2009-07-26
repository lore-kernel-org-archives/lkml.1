Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbZGZITB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbZGZITB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZGZIS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:18:58 -0400
Received: from www.tglx.de ([62.245.132.106]:57810 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbZGZISz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:18:55 -0400
Message-Id: <20090726081553.765775043@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [Patch RFC 04/37] input: mouse/hil_ptr: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=driver-input-mouse-hil-ptr-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/mouse/hil_ptr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/input/mouse/hil_ptr.c
===================================================================
--- linux-2.6-tip.orig/drivers/input/mouse/hil_ptr.c
+++ linux-2.6-tip/drivers/input/mouse/hil_ptr.c
@@ -270,7 +270,7 @@ static int hil_ptr_connect(struct serio 
 	serio_set_drvdata(serio, ptr);
 	ptr->serio = serio;
 
-	init_MUTEX_LOCKED(&ptr->sem);
+	semaphore_init_locked(&ptr->sem);
 
 	/* Get device info.  MLC driver supplies devid/status/etc. */
 	serio->write(serio, 0);


