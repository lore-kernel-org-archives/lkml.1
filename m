Return-Path: <linux-kernel-owner+w=401wt.eu-S1161212AbXBAQ6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161212AbXBAQ6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 11:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161193AbXBAQ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 11:58:06 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:53871 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161234AbXBAQ6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 11:58:05 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 11:58:04 EST
Date: Thu, 1 Feb 2007 14:37:52 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -rt]: mtd cafe: Use IRQF_SHARED
Message-ID: <20070201143752.71fa569b@localhost>
Organization: Mandriva
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 Ingo,

 I need the following fix to compile your -rt patch, otherwise I get:

  CC [M]  drivers/mtd/nand/cafe.o
drivers/mtd/nand/cafe.c: In function ‘cafe_nand_probe’:
drivers/mtd/nand/cafe.c:600: error: ‘SA_SHIRQ’ undeclared (first use in this function)
drivers/mtd/nand/cafe.c:600: error: (Each undeclared identifier is reported only once
drivers/mtd/nand/cafe.c:600: error: for each function it appears in.)
make[2]: *** [drivers/mtd/nand/cafe.o] Error 1
make[1]: *** [drivers/mtd/nand] Error 2
make: *** [_module_drivers/mtd] Error 2

----------

    mtd cafe: Use IRQF_SHARED
    
    Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

diff --git a/drivers/mtd/nand/cafe.c b/drivers/mtd/nand/cafe.c
index 65f9bd3..5a20518 100644
--- a/drivers/mtd/nand/cafe.c
+++ b/drivers/mtd/nand/cafe.c
@@ -597,7 +597,8 @@ static int __devinit cafe_nand_probe(str
 		cafe_writel(cafe, 0xffffffff, NAND_TIMING3);
 	}
 	cafe_writel(cafe, 0xffffffff, NAND_IRQ_MASK);
-	err = request_irq(pdev->irq, &cafe_nand_interrupt, SA_SHIRQ, "CAFE NAND", mtd);
+	err = request_irq(pdev->irq, &cafe_nand_interrupt, IRQF_SHARED,
+			"CAFE NAND", mtd);
 	if (err) {
 		dev_warn(&pdev->dev, "Could not register IRQ %d\n", pdev->irq);
 



-- 
Luiz Fernando N. Capitulino
