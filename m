Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYERSlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYERSlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYERSiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:38:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:24872 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbYERSiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=RaDk20P278IFGwcCOsDpStcwjDbE3aFe5uSH+ClIom7qIYyIl6tN91SmQAFdEIOYEY+PToi5tfGAwdcj39tmAb+ZKHJhDfpihlPLIeT0Vc6Rp1JQdrCiLSIEdXqC64aQkF1B11KSg+jEq3HGVexPfUrOCepiNFq7uqUVBPch3N8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:55:40 +0200
Message-Id: <20080518185540.5636.32322.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/40] ide-tape: idetape_pc_intr() should use local_irq_enable_in_hardirq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -794,7 +794,7 @@ static ide_startstop_t idetape_pc_intr(i
 				" transferred\n", pc->xferred);
 
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		local_irq_enable();
+		local_irq_enable_in_hardirq();
 
 #if SIMULATE_ERRORS
 		if ((pc->c[0] == WRITE_6 || pc->c[0] == READ_6) &&
