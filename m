Return-Path: <linux-kernel-owner+w=401wt.eu-S934273AbZJJPic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273AbZJJPic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933401AbZJJPi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:38:29 -0400
Received: from www.tglx.de ([62.245.132.106]:55538 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933545AbZJJPiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:25 -0400
Message-Id: <20091010153349.763059241@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/28] watchdog: Fix probe function of riowd
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline;
	filename=drivers-watchdog-rio-fix-probe-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After sucessfully registering the misc device the driver iounmaps the
device registers and kfree's the device data structure. Ouch !

This was introduced with commit e42311d75 (riowatchdog: Convert to
pure OF driver) and went unnoticed for more than a year :)

Return success instead of dropping into the error cleanup code path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/watchdog/riowd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/watchdog/riowd.c
===================================================================
--- linux-2.6-tip.orig/drivers/watchdog/riowd.c
+++ linux-2.6-tip/drivers/watchdog/riowd.c
@@ -206,7 +206,7 @@ static int __devinit riowd_probe(struct 
 
 	dev_set_drvdata(&op->dev, p);
 	riowd_device = p;
-	err = 0;
+	return 0;
 
 out_iounmap:
 	of_iounmap(&op->resource[0], p->regs, 2);


