Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZDNBu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZDNBu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZDNBuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:50:18 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:2353 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbZDNBuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=DeMA8wvnZ15HBT65GBZrrzhS365eWG+MKx1VDW8aijQbDK4j56oJsIp1t9P86h84Rp
         z8F3WWag0/iL0FAC5nFTBkfMJhG7jl0FJ5ZgYd1OrtjwYVuOA++On0iSigW8xnUHvrh7
         Bxao+3twhcTNcRUFYrEc0FASY2v5PW9blI59o=
MIME-Version: 1.0
Date: Tue, 14 Apr 2009 09:50:15 +0800
Message-ID: <804dabb00904131850r32e63e7g1000a8a03521383d@mail.gmail.com>
Subject: no_irq_type to no_irq_chip change
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And looking into definition for no_irq_type (include/linux/irq.h):

/*
 * Migration helpers for obsolete names, they will go away:
 */
#define hw_interrupt_type       irq_chip
#define no_irq_type             no_irq_chip
typedef struct irq_desc         irq_desc_t;

We can see that "no_irq_type" is being made obsoleted:

For eg:

http://git.kernel.org/?p=linux/kernel/git/aegl/linux-2.6.git;a=blobdiff;f=arch/mn10300/kernel/irq.c;h=4c3c58ef5cda6fe571cbe39a649e8d4ebbfc3ae0;hp=50fdb5c16e0c34368e4faad479d041b4b4362eb9;hb=91e58b6e95a9c6b9efd928ae352eae5e75ae598c;hpb=df5529297ec4c32d57dd149398e3add6c37bc054

diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 50fdb5c..4c3c58e 100644 (file)
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -140,7 +140,7 @@ void __init init_IRQ(void)
       int irq;

       for (irq = 0; irq < NR_IRQS; irq++)
-               if (irq_desc[irq].chip == &no_irq_type)
+               if (irq_desc[irq].chip == &no_irq_chip)
                       /* due to the PIC latching interrupt requests, even
                        * when the IRQ is disabled, IRQ_PENDING is superfluous
                        * and we can use handle_level_irq() for edge-triggered


But looking further into existing source:

./ia64/hp/sim/hpsim_irq.c:
               if (idesc->chip == &no_irq_type)

./ia64/sn/kernel/irq.c:
               if (base_desc[i].chip == &no_irq_type) {

./ia64/kernel/iosapic.c:
               if (idesc->chip != &no_irq_type)

./sh/kernel/sh_ksyms_32.c:
extern struct hw_interrupt_type no_irq_type;
EXPORT_SYMBOL(no_irq_type);


Does it make sense that I can change all these to no_irq_chip?
Purely naming change in nature.

Thanks.


-- 
Regards,
Peter Teoh
