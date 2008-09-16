Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYIOSvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYIOSvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYIOSvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:51:05 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:46766 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYIOSvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dR5hjdimv55hbMBiOug4D0t8yM9sV//90N+6nOG7t0tuQxN0ISr9bDTC3wE2eaH86l
         3nlUNX6+sTrOiaPM6AuEiHnXAqPYYFmf4Gk2Zth9AWo/KoMAzZsYSy/L9oRijE0uyqAo
         +hrhYz8DYtRNGPJKS3SegV5eiIkx6SAu+kDD8=
Message-ID: <48CF02EE.8050406@gmail.com>
Date: Mon, 15 Sep 2008 20:50:54 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: ralf@linux-mips.org, yoichi_yuasa@tripeaks.co.jp,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [MIPS] vr41xx: unsigned irq cannot be negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned irq cannot be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/mips/vr41xx/common/irq.c b/arch/mips/vr41xx/common/irq.c
index cba36a2..92dd1a0 100644
--- a/arch/mips/vr41xx/common/irq.c
+++ b/arch/mips/vr41xx/common/irq.c
@@ -72,6 +72,7 @@ static void irq_dispatch(unsigned int irq)
 	cascade = irq_cascade + irq;
 	if (cascade->get_irq != NULL) {
 		unsigned int source_irq = irq;
+		int ret;
 		desc = irq_desc + source_irq;
 		if (desc->chip->mask_ack)
 			desc->chip->mask_ack(source_irq);
@@ -79,8 +80,9 @@ static void irq_dispatch(unsigned int irq)
 			desc->chip->mask(source_irq);
 			desc->chip->ack(source_irq);
 		}
-		irq = cascade->get_irq(irq);
-		if (irq < 0)
+		ret = cascade->get_irq(irq);
+		irq = ret;
+		if (ret < 0)
 			atomic_inc(&irq_err_count);
 		else
 			irq_dispatch(irq);
