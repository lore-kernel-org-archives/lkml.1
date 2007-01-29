Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbXA2RkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbXA2RkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXA2RkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:40:17 -0500
Received: from www.osadl.org ([213.239.205.134]:35835 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752515AbXA2RkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:40:16 -0500
Subject: [PATCH-mm] tick-management touch softlockup watchdog on resume
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@osdl.org>
Cc: Jiri Kosina <jikos@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 18:40:56 +0100
Message-Id: <1170092456.29240.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The softlockup watchdog needs to be touched after resume to avoid a
false positive.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jiri Kosina <jkosina@suse.cz>

Index: linux-2.6.20-rc6-mm/kernel/time/tick-common.c
===================================================================
--- linux-2.6.20-rc6-mm.orig/kernel/time/tick-common.c
+++ linux-2.6.20-rc6-mm/kernel/time/tick-common.c
@@ -320,6 +320,7 @@ static int tick_notify(struct notifier_b
 
 	case CLOCK_EVT_NOTIFY_RESUME:
 		tick_resume_jiffy_update();
+		touch_softlockup_watchdog();
 		break;
 
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:


