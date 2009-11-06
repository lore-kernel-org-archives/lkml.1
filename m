Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbZKFWWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbZKFWWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbZKFWWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:36 -0500
Received: from kroah.org ([198.145.64.141]:56696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbZKFWW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:40 2009
Message-Id: <20091106221540.545417553@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [14/99] sparc64: Set IRQF_DISABLED on LDC channel IRQs.
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=sparc64-set-irqf_disabled-on-ldc-channel-irqs.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit c58543c869606532c2382f027d6466f4672ea756 ]

With lots of virtual devices it's easy to generate a lot of
events and chew up the kernel IRQ stack.

Reported-by: hyl <heyongli@gmail.com>
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
-			  IRQF_SAMPLE_RANDOM | IRQF_SHARED,
+			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED | IRQF_SHARED,
 			  lp->rx_irq_name, lp);
 	if (err)
 		return err;
 
 	err = request_irq(lp->cfg.tx_irq, ldc_tx,
-			  IRQF_SAMPLE_RANDOM | IRQF_SHARED,
+			  IRQF_SAMPLE_RANDOM | IRQF_DISABLED | IRQF_SHARED,
 			  lp->tx_irq_name, lp);
 	if (err) {
 		free_irq(lp->cfg.rx_irq, lp);


