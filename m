Return-Path: <linux-kernel-owner+w=401wt.eu-S1762735AbXHWTew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735AbXHWTew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbXHWTeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:34:44 -0400
Received: from n6.bullet.re3.yahoo.com ([68.142.237.91]:31936 "HELO
	n6.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756378AbXHWTen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:34:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 167328.75634.bm@rrr4.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Kk5sjRv675/ReFozOIGj5UpM0Na/UoY/87EfFBdbtZkzWXjZP8xylgPfTiyHkgRLn+x2HR/skVR6jFh4ryLB2257CWvLGp0Wd/OSE70T74ldQveNwPxjg1YF3dtCr+RyZqrBvH8bLmF8yuf8sQlqim74eaYRhGmoS6/MO/eoJ8U=;
Date: Thu, 23 Aug 2007 12:34:31 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH resubmit] /drivers/ata ioremap returncode check
To: brandon@ifup.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <648310.70195.qm@web44903.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset against 2.6.23-rc3.  corrects missing ioremap return 
checks, resending after fixing for documentation making changes suggested...

As for suggestions, I did fix the {} that weren't needed.  I did not add in a
"printk" err or warn statement as the rest of the module does not contain these
messages.  When auditing (as I am for ioremap checking here) I am attempting
to keep changes "in the style of their surroundings".  Otherwise it's massive
scope screep on these patches.
 
Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
---------------------------------------------------------------
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 4ca7fd6..6f9a2b7 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -189,6 +189,9 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
 	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
 
+	if (!data->cs0 || !data->cs1) 
+		return -ENOMEM;
+	
 	irq = platform_get_irq(pdev, 0);
 	if (irq)
 		set_irq_type(irq, IRQT_RISING);


       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at
Yahoo! Games.
http://sims.yahoo.com/  


       
____________________________________________________________________________________
Looking for a deal? Find great prices on flights and hotels with Yahoo! FareChase.
http://farechase.yahoo.com/

