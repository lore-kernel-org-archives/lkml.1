Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYJBG7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYJBG7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYJBG7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:59:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:64505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYJBG7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=aPsowuNkEeZmbZ4SzF1fI7g4RIohwdHWi1pZpqz4Zsj8Yam+IWuAXP/R/rEm4ABtF/
         0roPzfEaNKu6FSyCuHrLege8IG7lEM3TE7J0pcC7Uncdf18EeWvj6unUp5z9NQN8Bp5v
         PGF+8k81iXaQ9DzZYqp2NM00bWIAXDDNtCLyI=
Message-ID: <b9df5fa10810012359oac41498sf716ce51b39a36ce@mail.gmail.com>
Date: Thu, 2 Oct 2008 12:59:11 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: mb@bu3sch.de
Subject: [PATCH] drivers/gpio/bt8xxgpio.c Fix compilation warning.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpio/bt8xxgpio.c: In function `bt8xxgpio_remove':
drivers/gpio/bt8xxgpio.c:247: warning: ignoring return value of
`gpiochip_remove', declared with attribute warn_unused_result

Following patch removes the above warning.
Thanks.

Signed-off-by:	Md.Rakib H. Mullick (rakib.mullick@gmail.com)

--- linux-2.6.27-rc8.orig/drivers/gpio/bt8xxgpio.c	2008-10-01
19:20:59.000000000 +0600
+++ linux-2.6.27-rc8/drivers/gpio/bt8xxgpio.c	2008-10-02
12:30:26.374544032 +0600
@@ -242,9 +242,14 @@ err_freebg:

 static void bt8xxgpio_remove(struct pci_dev *pdev)
 {
+	int err;
 	struct bt8xxgpio *bg = pci_get_drvdata(pdev);

-	gpiochip_remove(&bg->gpio);
+	err = gpiochip_remove(&bg->gpio);
+	if (err) {
+		printk(KERN_ERR "bt8xxgpio: Resource busy. Failed to remove.\n");
+		return ;
+	}

 	bgwrite(0, BT848_INT_MASK);
 	bgwrite(~0x0, BT848_INT_STAT);
