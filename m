Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXFRCzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXFRCzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 22:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXFRCzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 22:55:23 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:43614 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbXFRCzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 22:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W0OYEBZM+4OwKkX57j+wUVnIGIkEgKyC8E1dJq94N9xy/NRM27ZiZTHab60z12QueywSqtb1IA5AkwNzJENuQUK46rMPaaEafx3durBpR65uo3NpnRV23GOT8XdAVgH6i2tJAsP6fOPEYTxsoOGTky2yLVSqmYJLmiyT+emfENI=
Message-ID: <4e5ebad50706171955m58512c69rb94f9f996377117d@mail.gmail.com>
Date: Mon, 18 Jun 2007 10:55:21 +0800
From: "Sonic Zhang" <sonic.adi@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Linux IDE" <linux-ide@vger.kernel.org>
Subject: Fwd: [PATCH] [libata] Add irq_flags to struct pata_platform_info
In-Reply-To: <1181900749.23447.7.camel@sevens.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181900749.23447.7.camel@sevens.analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments for this patch?

Thank you.

Sonic Zhang

---------- Forwarded message ----------
From: Sonic Zhang <sonic.adi@gmail.com>
Date: Jun 15, 2007 5:45 PM
Subject: [PATCH] [libata] Add irq_flags to struct pata_platform_info
To: Linux IDE <linux-ide@vger.kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>


On some embedded platforms, such as blackfin, the gpio interrupt for
IDE interface is designed to be triggered with high voltage. The gpio
port should be configured properly by set_irq_type() when register
the irq. This patch enable the generic pata platform driver to
accept platform irq flags data.

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
---
 drivers/ata/pata_platform.c   |    6 ++++--
 include/linux/pata_platform.h |    5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index cbb7866..79f841b 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -139,6 +139,7 @@ static int __devinit pata_platform_probe(struct
platform_device *pdev)
        struct resource *io_res, *ctl_res;
        struct ata_host *host;
        struct ata_port *ap;
+       struct pata_platform_info *pp_info;
        unsigned int mmio;

        /*
@@ -208,11 +209,12 @@ static int __devinit pata_platform_probe(struct
platform_device *pdev)

        ap->ioaddr.altstatus_addr = ap->ioaddr.ctl_addr;

-       pata_platform_setup_port(&ap->ioaddr, pdev->dev.platform_data);
+       pp_info = (struct pata_platform_info *)(pdev->dev.platform_data);
+       pata_platform_setup_port(&ap->ioaddr, pp_info);

        /* activate */
        return ata_host_activate(host, platform_get_irq(pdev, 0), ata_interrupt,
-                                0, &pata_platform_sht);
+                                pp_info->irq_flags, &pata_platform_sht);
 }

 /**
diff --git a/include/linux/pata_platform.h b/include/linux/pata_platform.h
index 2d5fd64..5799e8d 100644
--- a/include/linux/pata_platform.h
+++ b/include/linux/pata_platform.h
@@ -8,6 +8,11 @@ struct pata_platform_info {
         * spacing used by ata_std_ports().
         */
        unsigned int ioport_shift;
+       /*
+        * Indicate platform specific irq types and initial
+        * IRQ flags when call request_irq()
+        */
+       unsigned int irq_flags;
 };

 #endif /* __LINUX_PATA_PLATFORM_H */
--
1.5.1.3


-
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
