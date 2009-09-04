Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZIDINt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZIDINt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZIDINt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:13:49 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33072 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbZIDINs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:13:48 -0400
Message-Id: <4AA0E85D02000078000136F9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 04 Sep 2009 09:13:49 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <yhlu.kernel@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: increase timeout for EHCI debug port reset
	 completion in early printk
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one of my systems, several thousand iterations are needed before
CMD_RESET can be observed clear after setting it. Using a much higher
value here obviously cannot hurt.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/early_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.31-rc8/arch/x86/kernel/early_printk.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc8-x86-earlyprintk-dbgp-reset/arch/x86/kernel/early_printk.c	2009-09-02 12:13:01.000000000 +0200
@@ -624,7 +624,7 @@ try_next_port:
 		return -1;
 	}
 
-	loop = 10;
+	loop = 100000;
 	/* Reset the EHCI controller */
 	cmd = readl(&ehci_regs->command);
 	cmd |= CMD_RESET;



