Return-Path: <linux-kernel-owner+w=401wt.eu-S934073AbXINQPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073AbXINQPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760114AbXINQPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:15:30 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:36137 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761259AbXINQPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:15:30 -0400
Date: Fri, 14 Sep 2007 12:15:03 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] softlockup_tick needs to initialize regs
Message-ID: <20070914161503.GA7049@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

softlockup-improve-debug-output.patch introduces a regs, but fails to
initialize it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 kernel/softlockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/kernel/softlockup.c
===================================================================
--- linux-2.6.22.orig/kernel/softlockup.c	2007-09-02 14:06:00.000000000 -0400
+++ linux-2.6.22/kernel/softlockup.c	2007-09-14 12:05:51.000000000 -0400
@@ -80,7 +80,7 @@ void softlockup_tick(void)
 	int this_cpu = smp_processor_id();
 	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long print_timestamp;
-	struct pt_regs *regs;
+	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
