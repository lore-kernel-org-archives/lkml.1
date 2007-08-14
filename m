Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbXHNDhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbXHNDhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 23:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXHNDhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 23:37:22 -0400
Received: from n7a.bullet.mail.re3.yahoo.com ([68.142.236.45]:22198 "HELO
	n7a.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750976AbXHNDhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 23:37:22 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 23:37:21 EDT
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 500270.66910.bm@rrr4.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=KP2xgLqWSQRSbod+XHgMg6iSUqwuPm9OBDxhoKEgUx+eRM2ljWK0jWfvYpVFw0iJG84+zRJEgsEJFSEbhw/syM21Tt6kWj3+5v0VvV5EQQBl60ypIc7F8zr8S3OtP7IyouSTerEzO4+1BgCilIYbdlkIhxCf3H+iKiQL9mmnvL0=;
Date: Mon, 13 Aug 2007 20:31:33 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH ] /drivers/ata ioremap returncode check
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       postfail@hushmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <387498.11798.qm@web44905.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc3.  corrects missing ioremap return checks.

Warning -- cleanup handler here may miss additional required cleanup as has occurred on other
portions of ioremap audit.

This patch had been submitted previously but hushmail client caused wordwrap issues, resending
with different mail client.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------

diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 4ca7fd6..eaebc4d 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -189,6 +189,14 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
 	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
 
+	if (!data->cs0 || !data->cs1) {
+		if (data->cs0)
+			iounmap(data->cs0);
+		if (data->cs1)
+			iounmap(data->cs1);
+		return -ENOMEM;
+	}
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq)
 		set_irq_type(irq, IRQT_RISING);


       
____________________________________________________________________________________
Yahoo! oneSearch: Finally, mobile search 
that gives answers, not web links. 
http://mobile.yahoo.com/mobileweb/onesearch?refer=1ONXIC


      ____________________________________________________________________________________
Luggage? GPS? Comic books? 
Check out fitting gifts for grads at Yahoo! Search
http://search.yahoo.com/search?fr=oni_on_mail&p=graduation+gifts&cs=bz

