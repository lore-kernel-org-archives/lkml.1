Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbZBPIFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbZBPIFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZBPIFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:05:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:38864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZBPIFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:05:24 -0500
Date: Mon, 16 Feb 2009 09:05:21 +0100
From: Karsten Keil <kkeil@suse.de>
To: snakebyte@gmx.de
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [Patch] list usage cleanup in MISDN
Message-ID: <20090216080521.GA22627@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.34-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Fri, 13 Feb 2009 09:10:57 +0100

Trivial cleanup, list_del(); list_add_tail() is equivalent
to list_move_tail(). Semantic patch for coccinelle can be
found at www.cccmz.de/~snakebyte/list_move_tail.spatch

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Acked-by: Karsten Keil <kkeil@novell.com>

diff -u -p a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
--- a/drivers/isdn/mISDN/timerdev.c 2008-12-29 01:36:06.000000000 +0100
+++ b/drivers/isdn/mISDN/timerdev.c 2009-02-11 15:44:06.000000000 +0100
@@ -152,8 +152,7 @@ dev_expire_timer(unsigned long data)
 	u_long			flags;
 
 	spin_lock_irqsave(&timer->dev->lock, flags);
-	list_del(&timer->list);
-	list_add_tail(&timer->list, &timer->dev->expired);
+	list_move_tail(&timer->list, &timer->dev->expired);
 	spin_unlock_irqrestore(&timer->dev->lock, flags);
 	wake_up_interruptible(&timer->dev->wait);
 }

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
