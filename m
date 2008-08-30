Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYH3CpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYH3CpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYH3CpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:45:00 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:37602 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbYH3Co7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:44:59 -0400
Date: Fri, 29 Aug 2008 21:44:53 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org
Subject: [PATCH 2/2] ne.c msleep not mdelay
Message-ID: <20080830024453.GB24929@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 29 Aug 2008 21:44:53 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mdelay(10) replaced by msleep(10) to give up the CPU, it's just
waiting for an interrupt, so timing isn't critical.

Signed-off-by: David Fries <david@fries.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
---
 drivers/net/ne.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ne.c b/drivers/net/ne.c
index b0bf47e..bcbeff7 100644
--- a/drivers/net/ne.c
+++ b/drivers/net/ne.c
@@ -529,7 +529,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
 		outb_p(0x00, ioaddr + EN0_RCNTLO);
 		outb_p(0x00, ioaddr + EN0_RCNTHI);
 		outb_p(E8390_RREAD+E8390_START, ioaddr); /* Trigger it... */
-		mdelay(10);	/* wait 10ms for interrupt to propagate */
+		msleep(10);	/* wait 10ms for interrupt to propagate */
 		outb_p(0x00, ioaddr + EN0_IMR); 		/* Mask it again. */
 		dev->irq = probe_irq_off(cookie);
 		if (ei_debug > 2)
-- 
1.4.4.4

