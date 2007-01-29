Return-Path: <linux-kernel-owner+w=401wt.eu-S1750977AbXA2Pjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbXA2Pjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbXA2Pjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:39:40 -0500
Received: from www.osadl.org ([213.239.205.134]:45403 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750957AbXA2Pjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:39:39 -0500
Subject: Re: 2.6.20-rc6-mm2
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0701291122570.9448@twin.jikos.cz>
References: <20070129001207.71ea3470.akpm@osdl.org>
	 <Pine.LNX.4.64.0701291122570.9448@twin.jikos.cz>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 16:40:18 +0100
Message-Id: <1170085218.29240.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 12:02 +0100, Jiri Kosina wrote:
>
> I guess that it's caused by some timer changes (added Thomas and Ingo to 
> CC), which confuse the softlockup detector sense of time? 

Does the patch below fix this ?

	tglx

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


