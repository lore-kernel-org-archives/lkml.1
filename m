Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbXHWCrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbXHWCrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXHWCre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:47:34 -0400
Received: from n5.bullet.mail.re4.yahoo.com ([206.190.56.24]:45509 "HELO
	n5.bullet.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751186AbXHWCrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:47:33 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 88971.90102.bm@rrr1.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=H3TkPYYpafjQha9p6xO0hXgKkwm6QuWedl49/qd3HSiYlBCZTrPD1rMk9MSefWJZNAsoJcQuAWr064z3q0iNX9vqRbKkP/eaPH4NCQJBG07ZIgq4f//nSNX87KVyt2tSyKtf2OTvdjDhzcakhiqsmjsrJ+KA2a5sG0LXpYevIrc=;
Date: Wed, 22 Aug 2007 19:47:16 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH resubmit] /drivers/ata ioremap returncode check
To: brandon@ifup.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20070823023328.19E6CDA82B@mailserver7.hushmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <159327.52462.qm@web44910.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset against 2.6.23-rc3.  corrects missing ioremap return 
checks, resending after making changes suggested....

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
------------------------------------------------------------
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 4ca7fd6..8dc7c3b 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -189,6 +189,10 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
 	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
 
+	if (!data->cs0 || !data->cs1) {
+		return -ENOMEM;
+	}
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq)
 		set_irq_type(irq, IRQT_RISING);

> ----- Forwarded message from Brandon Philips <brandon@ifup.org> ----
> -
> The iounmap calls are unnecessary since devm_ioremap will un-
> allocate the space if you return an error from probe.  See
> Documentation/driver-model/devres.txt
> 
> But, something like this is needed.
> 
> +	if (!data->cs0 || !data->cs1)
> +		return -ENOMEM;
> 
> Thanks,	Brandon




       
____________________________________________________________________________________
Pinpoint customers who are looking for what you sell. 
http://searchmarketing.yahoo.com/


       
____________________________________________________________________________________
Building a website is a piece of cake. Yahoo! Small Business gives you all the tools to get online.
http://smallbusiness.yahoo.com/webhosting 

