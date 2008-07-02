Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYGBRn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYGBRn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 13:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYGBRnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 13:43:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:2692 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYGBRm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 13:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gSatKbEB6Tsk9s/8+Jeqhk0AlWgRzJB+Bo9We1/0nqp9ilbXPK9Q+FSpXToylFlght
         mf108pHtCIapE48xR0MLxBbj5F8brit7RPGFcFOZGGFr+sjJkSBmD510bEAJQEZSrR50
         xhj0xmnDnBOFbr+QmrH2JW08ifGLUYvnyCm8c=
Subject: [PATCH] mfd: fix a bug in the asic3 irq demux code
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@openedhand.com>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 19:42:53 +0200
Message-Id: <1215020573.24941.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong irq numbers were given to desc->handle_irq, which
on some devices caused endless loops (asic3_irq_demux
calling itself, basically).

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 8e41130..59ec9c6 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -308,7 +308,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
 			/* They start at bit 4 and go up */
 			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
-				desc = irq_desc +  + i;
+				desc = irq_desc + asic->irq_base + i;
 				desc->handle_irq(asic->irq_base + i,
 						 desc);
 			}
-- 
1.5.6


