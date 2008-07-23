Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYGWQsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYGWQsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYGWQsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:48:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49528 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYGWQsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:48:47 -0400
Date: Wed, 23 Jul 2008 20:52:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark McLoughlin <markmc@redhat.com>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 2/2] posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun
Message-ID: <20080723165205.GA4295@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_schedule_next_timer() sets info->si_overrun = timr->it_overrun_last,
this discards the already accumulated overruns.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~2_SNT_OVERRUN	2008-07-23 15:04:18.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-07-23 20:24:05.000000000 +0400
@@ -289,7 +289,7 @@ void do_schedule_next_timer(struct sigin
 		else
 			schedule_next_timer(timr);
 
-		info->si_overrun = timr->it_overrun_last;
+		info->si_overrun += timr->it_overrun_last;
 	}
 
 	if (timr)

