Return-Path: <linux-kernel-owner+w=401wt.eu-S937620AbXG3C1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937620AbXG3C1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965685AbXG3C1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:27:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45246 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936194AbXG3C1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:27:15 -0400
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kyungmin.park@samsung.com>
To: <linux-kernel@vger.kernel.org>
References: <000001c7c831$78e0f570$27a0367c@user001b2c71e3>
Subject: [PATCH] mips: qemu network work again
Date: Mon, 30 Jul 2007 11:27:03 +0900
Message-ID: <005401c7d251$237b3710$e1ac580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-reply-to: <000001c7c831$78e0f570$27a0367c@user001b2c71e3>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-index: AcfIMXPjmy7GuSZtTdSgK38jFt/KCQKHjNVw
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After kernel 2.6.21, the qemu of mips with nfsroot is not working.
There are too much WATCHDOG timeout.
I try to find what makes it not working and I found it.
After Ingo Monlar's patch "[PATCH] genirq: do not mask interrupts by default" [1], it's not working.
To solve this, we also have to register the IRQ disable field in MIPS, as x86 does.

1. http://www.uwsg.iu.edu/hypermail/linux/kernel/0701.3/1892.html

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
index 2345160..b6c3080 100644
--- a/arch/mips/kernel/i8259.c
+++ b/arch/mips/kernel/i8259.c
@@ -36,6 +36,7 @@ void mask_and_ack_8259A(unsigned int);
 static struct irq_chip i8259A_chip = {
        .name           = "XT-PIC",
        .mask           = disable_8259A_irq,
+       .disable        = disable_8259A_irq,
        .unmask         = enable_8259A_irq,
        .mask_ack       = mask_and_ack_8259A,
 };

