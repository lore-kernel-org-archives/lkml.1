Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYGYAuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYGYAuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbYGYAu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:50:28 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:24324 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753251AbYGYAu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:50:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bQroasujPAb9BorV8AM5DU0/U0HzzYoEYWE0EXSodYqWYSdvHkHIg+enX1w/DOMwzM0d/mGDs8OW/83vyx+lhId8KXOuNt/ms91zE0wy7kHM43E1R1vd3cpIdvtpIh1kUmC+lg/vfAgQuEJbokKCLYYaM1MnSjiGBZFVVkFiJZw=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.26-git] genirq:  better warning on irqchip->set_type() failure
Date: Thu, 24 Jul 2008 17:50:25 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241750.25507.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

While I'm glad to finally see the hole fixed whereby passing an
invalid IRQ trigger type to request_irq() would be ignored, the
current diagnostic isn't quite useful.  Fixed by also listing
the trigger type which was rejected.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -326,8 +326,8 @@ static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
 	ret = chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
 
 	if (ret)
-		pr_err("setting flow type for irq %u failed (%pF)\n",
-				irq, chip->set_type);
+		pr_err("setting trigger type %d for irq %u failed (%pF)\n",
+				flags & IRQF_TRIGGER_MASK, irq, chip->set_type);
 
 	return ret;
 }
