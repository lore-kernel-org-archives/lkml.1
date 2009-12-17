Return-Path: <linux-kernel-owner+w=401wt.eu-S935927AbZLQB2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935927AbZLQB2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763684AbZLQBUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:54 -0500
Received: from kroah.org ([198.145.64.141]:48096 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763675AbZLQBUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:48 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:06 2009
Message-Id: <20091217011606.474016081@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [65/90] sparc64: Dont specify IRQF_SHARED for LDC interrupts.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 08a036d583409e3517e3d15b7478d029b25f2cf2 ]

IRQF_SHARED and IRQF_DISABLED don't mix.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/ldc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -1242,13 +1242,13 @@ int ldc_bind(struct ldc_channel *lp, con
 	snprintf(lp->tx_irq_name, LDC_IRQ_NAME_MAX, "%s TX", name);
 
 	err = request_irq(lp->cfg.rx_irq, ldc_rx,
-			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED | IRQF_SHARED,
+			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED,
 			  lp->rx_irq_name, lp);
 	if (err)
 		return err;
 
 	err = request_irq(lp->cfg.tx_irq, ldc_tx,
-			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED | IRQF_SHARED,
+			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED,
 			  lp->tx_irq_name, lp);
 	if (err) {
 		free_irq(lp->cfg.rx_irq, lp);


