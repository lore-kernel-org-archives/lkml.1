Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZCLUrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZCLUrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZCLUrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:47:31 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:47053
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753343AbZCLUrb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:47:31 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 16:47:31 EDT
X-BigFish: VPS3(zz4015Mzz1202hzzz2dh6bh95p61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,8,
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: FW: level interrupt handling in the Kernel
Date: Thu, 12 Mar 2009 14:32:09 -0600
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: level interrupt handling in the Kernel
Thread-Index: AcmjRKcB+XeldVHNTWyUVcTB6CLahgADJg/w
From: Julie Zhu <julie.zhu@xilinx.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Mar 2009 20:32:04.0802 (UTC) FILETIME=[9B2F5A20:01C9A351]
Message-ID: <20090312203206.0113C1A3009D@mail92-va3.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We found that level interrupts are handled in the following way in the
Linux
kernel:
1. mask irq, disable it
2. ack irq, clear it in interrupt controller.
3. move irq, handle it in handler for the source.
4. unmask irq, reenable it.

This sequnce results in bogus interrupts in the system. The reason is
that, after step 2 but before step 3, interrupt controller sees that the
interrupt source is high, and will re-assert the interrupt after step 4.
This will be a bogus interrupt, because the interrupt handler for the
source has cleared the interrupt.

We solve this issue by changing the interrupt controller to do nothing
in step 2, ack irq, if it is a level interrupt. In step 4, unmask irq,
we ack the interrupt controller, and then re-enable the interrupt. Since
interrupt
is level, and source interrupt handler only clears interrupts once in
the
handler, nothing will be missed.

I am not sure whether we are doing the right thing, and why the Linux
kernel
chooses to handle level interrupt in that sequence.

Thanks,
Julie.

Thanks,
-- 
View this message in context:
http://www.nabble.com/level-interrupt-handling-in-the-Kernel-tp22481320p
22481320.html
Sent from the linux-newbie mailing list archive at Nabble.com.

--
To unsubscribe from this list: send the line "unsubscribe linux-newbie"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at http://www.linux-learn.org/faqs


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


