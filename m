Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXC0HIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXC0HIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXC0HIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:08:37 -0400
Received: from www.osadl.org ([213.239.205.134]:48398 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965277AbXC0HIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:08:36 -0400
Subject: [PATCH] i386: Fix bogus return value in hpet_next_event()
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1174900868.4182.21.camel@chaos>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <1174900868.4182.21.camel@chaos>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 09:08:26 +0200
Message-Id: <1174979306.4023.7.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The clockevents / tick management code expects an error value, when the
event is already expired. hpet_next_event() returns 1 in that case.

Fix it to return the proper -ETIME error code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
index f3ab61e..76afea6 100644
--- a/arch/i386/kernel/hpet.c
+++ b/arch/i386/kernel/hpet.c
@@ -197,7 +197,7 @@ static int hpet_next_event(unsigned long delta,
 	cnt += delta;
 	hpet_writel(cnt, HPET_T0_CMP);
 
-	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0);
+	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0) ? -ETIME : 0;
 }
 
 /*


