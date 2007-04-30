Return-Path: <linux-kernel-owner+w=401wt.eu-S1423502AbXD3QBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423502AbXD3QBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423489AbXD3P4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:01 -0400
Received: from ns2.suse.de ([195.135.220.15]:34375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423466AbXD3Pty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:54 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: hifumi.hisashi@oss.ntt.co.jp, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [21/34] i386: replace spin_lock_irqsave with spin_lock
Message-Id: <20070430154954.11007151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

IRQ is already disabled through local_irq_disable().  So
spin_lock_irqsave() can be replaced with spin_lock().

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/reboot.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/arch/i386/kernel/reboot.c
===================================================================
--- linux.orig/arch/i386/kernel/reboot.c
+++ linux/arch/i386/kernel/reboot.c
@@ -198,8 +198,6 @@ static unsigned char jump_to_bios [] =
  */
 void machine_real_restart(unsigned char *code, int length)
 {
-	unsigned long flags;
-
 	local_irq_disable();
 
 	/* Write zero to CMOS register number 0x0f, which the BIOS POST
@@ -212,9 +210,9 @@ void machine_real_restart(unsigned char 
 	   safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
 	 */
 
-	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&rtc_lock);
 	CMOS_WRITE(0x00, 0x8f);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	spin_unlock(&rtc_lock);
 
 	/* Remap the kernel at virtual address zero, as well as offset zero
 	   from the kernel segment.  This assumes the kernel segment starts at
