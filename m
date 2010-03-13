Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789Ab0CMA0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:26:55 -0500
Received: from kroah.org ([198.145.64.141]:32863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935026Ab0CMAVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:06 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:14 2010
Message-Id: <20100313001514.840305535@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Hogan <james@albanarts.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: [patch 111/123] rtc-coh901331: fix braces in resume code
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: James Hogan <james@albanarts.com>

commit 5a98c04d78c896d52baef20ffc11f6d1ba6eb786 upstream.

The else part of the if statement is indented but does not have braces
around it. It clearly should since it uses clk_enable and clk_disable
which are supposed to balance.

Signed-off-by: James Hogan <james@albanarts.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-coh901331.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -271,12 +271,13 @@ static int coh901331_resume(struct platf
 {
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
 
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(&pdev->dev)) {
 		disable_irq_wake(rtap->irq);
-	else
+	} else {
 		clk_enable(rtap->clk);
 		writel(rtap->irqmaskstore, rtap->virtbase + COH901331_IRQ_MASK);
 		clk_disable(rtap->clk);
+	}
 	return 0;
 }
 #else


