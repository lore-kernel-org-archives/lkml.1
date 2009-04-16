Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZDPUt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZDPUt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZDPUtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:49:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:6058 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbZDPUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=IJ17UbW/m2nO5U+v+LnT5vw8Kk+D96M/qlUlIVEKfju6AnbZmJxmCw06m5jwA0IOHx
         g79CVoRmz6VnZpEXiW0pGvIFvHvhPhXRqXL9lgbvCDYbNdcMhrtwSRILaC6PQg/IyvRr
         vrHMXxzjLLqk1w1xADi9+mkk1i5ursTzoxxFc=
Message-ID: <49E799CD.1010902@gmail.com>
Date: Thu, 16 Apr 2009 22:49:17 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] microblaze: iowrite upon timeout
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

retries reaches -1, so the iowrite occurrs upon timeout.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
index 62cc789..4b0f0fd 100644
--- a/arch/microblaze/kernel/early_printk.c
+++ b/arch/microblaze/kernel/early_printk.c
@@ -36,7 +36,7 @@ static void early_printk_putc(char c)
 
 	unsigned retries = 10000;
 	/* read status bit - 0x8 offset */
-	while (retries-- && (in_be32(base_addr + 8) & (1 << 3)))
+	while (--retries && (in_be32(base_addr + 8) & (1 << 3)))
 		;
 
 	/* Only attempt the iowrite if we didn't timeout */
