Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbXFVCec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbXFVCec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 22:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXFVCeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 22:34:24 -0400
Received: from h146-az.mvista.com ([65.200.49.156]:5715 "EHLO
	zipcode.az.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751887AbXFVCeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 22:34:23 -0400
Date: Thu, 21 Jun 2007 19:32:08 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: jaylubo@motorola.com
Subject: [PATCH] serial: Clear proper MPSC interrupt cause bits
Message-ID: <20070622023208.GA20651@mag.az.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Lubomirski <jaylubo@motorola.com>

Don't clobber the interrupt cause bits for both MPSC controllers when
clearing the interrupt for one of them.  Just clear the one that is
supposed to be cleared.

Signed-off-by: Jay Lubomirski <jaylubo@motorola.com>
Acked-by: Mark A. Greer <mgreer@mvista.com>
---
 drivers/serial/mpsc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index d09f209..00924fe 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -503,7 +503,8 @@ mpsc_sdma_intr_ack(struct mpsc_port_info *pi)
 
 	if (pi->mirror_regs)
 		pi->shared_regs->SDMA_INTR_CAUSE_m = 0;
-	writel(0, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE);
+	writeb(0x00, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE +
+	       pi->port.line);
 	return;
 }
 
