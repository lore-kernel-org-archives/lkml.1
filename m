Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbXC1Jh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbXC1Jh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933779AbXC1Jh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:37:56 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:45160 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbXC1Jhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:37:55 -0400
X-Greylist: delayed 1259 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2007 05:37:55 EDT
Message-Id: <6.0.0.20.2.20070328181552.04f827a8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Wed, 28 Mar 2007 18:16:28 +0900
To: akpm@osdl.org, linux-kernel@vger.kernel.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] replace spin_lock_irqsave with spin_lock
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


IRQ is already disabled through local_irq_disable().
So spin_lock_irqsave() can be replaced with spin_lock().

Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

--- linux-2.6.21-rc5.org/arch/i386/kernel/reboot.c	2007-02-05 
03:44:54.000000000 +0900
+++ linux-2.6.21-rc5-test/arch/i386/kernel/reboot.c	2007-03-28 
17:57:56.000000000 +0900
@@ -197,8 +197,6 @@ static unsigned char jump_to_bios [] =
   */
  void machine_real_restart(unsigned char *code, int length)
  {
-	unsigned long flags;
-
  	local_irq_disable();

  	/* Write zero to CMOS register number 0x0f, which the BIOS POST
@@ -211,9 +209,9 @@ void machine_real_restart(unsigned char
  	   safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
  	 */

-	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&rtc_lock);
  	CMOS_WRITE(0x00, 0x8f);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	spin_unlock(&rtc_lock);

  	/* Remap the kernel at virtual address zero, as well as offset zero
  	   from the kernel segment.  This assumes the kernel segment starts at

