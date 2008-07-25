Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYGYTC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYGYTC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 15:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYGYTCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 15:02:11 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:38474 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753896AbYGYTCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 15:02:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Tq+HLP9s1CMW1XBB/OHrVD8JYUJVZpxIBeUefUSWrPF3b1LEn33wysw/ARWGKgoe3zKtT8oahgfq2+3tOOUsuLUSLh6TwQgZ1FH3AkVbTqJJrm4eO7Mg3tccLaDj+zvbx8K01mrKYno7xEulGY7IAAs+o1dwIuKZr3wCkQj3McQ=  ;
X-YMail-OSG: BpFS4HEVM1l7oN7tB7Cd6mXEaHVbz8BgDtCP.VbbtmRp3gi4QlPxcFadWoQ7_u9i34C_bG5c_cUwP1Yx8.laoOOP1VChwz31TQm_ddNXZw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [patch 2.6.26-git] genirq:  better warning on irqchip->set_type() failure
Date: Fri, 25 Jul 2008 12:02:07 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200807241750.25507.david-b@pacbell.net> <20080725075324.GB24021@digi.com>
In-Reply-To: <20080725075324.GB24021@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807251202.07599.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

While I'm glad to finally see the hole fixed whereby passing an
invalid IRQ trigger type to request_irq() would be ignored, the
current diagnostic isn't quite useful.  Fixed by also listing
the trigger type which was rejected.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
Minor change:  cast trigger mode to int, one compiler warned.

 kernel/irq/manage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/irq/manage.c	2008-07-25 02:07:05.000000000 -0700
+++ b/kernel/irq/manage.c	2008-07-25 02:08:13.000000000 -0700
@@ -326,7 +326,8 @@ static int __irq_set_trigger(struct irq_
 	ret = chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
 
 	if (ret)
-		pr_err("setting flow type for irq %u failed (%pF)\n",
+		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
+				(int)(flags & IRQF_TRIGGER_MASK),
 				irq, chip->set_type);
 
 	return ret;
