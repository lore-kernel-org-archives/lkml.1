Return-Path: <linux-kernel-owner+w=401wt.eu-S1751454AbXA0QDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbXA0QDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 11:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXA0QDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 11:03:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:32631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXA0QDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 11:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=H9sIJ/K3N053xqbMnEA69/OoI78zg6C0dabo7pBho1s6w1DM+SKwqa4nSvFZWr18FGtrbunb2mXVGg9qMKW8k3iBPcbr4cxeKvFir4vlRAsMovhmEiOej63g/48ENN22GOWPAab7kSThyqhwgzV4C7gdtKHuRpgnOry1sUKgmXM=
Message-ID: <45BB77C7.5090202@googlemail.com>
Date: Sat, 27 Jan 2007 17:03:19 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, Tejun Heo <teheo@novell.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@osdl.org napisał(a):
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 

drivers/ata/sata_inic162x.c: In function ‘inic_pci_device_resume’:
drivers/ata/sata_inic162x.c:652: warning: ignoring return value of ‘ata_pci_device_do_resume’, declared with attribute warn_unused_result
drivers/ata/sata_inic162x.c: In function ‘inic_init_one’:
drivers/ata/sata_inic162x.c:727: error: ‘SA_SHIRQ’ undeclared (first use in this function)
drivers/ata/sata_inic162x.c:727: error: (Each undeclared identifier is reported only once
drivers/ata/sata_inic162x.c:727: error: for each function it appears in.)
make[2]: *** [drivers/ata/sata_inic162x.o] Błąd 1
make[1]: *** [drivers/ata] Błąd 2
make: *** [drivers] Błąd 2

SA_SHIRQ was removed. IRQF_SHARED should be used instead?

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/drivers/ata/sata_inic162x.c	2007-01-26 16:47:31.000000000 +0100
+++ linux-work/drivers/ata/sata_inic162x.c	2007-01-27 16:53:26.000000000 +0100
@@ -724,7 +724,7 @@ static int inic_init_one(struct pci_dev
 	probe_ent->n_ports		= NR_PORTS;

 	probe_ent->irq = pdev->irq;
-	probe_ent->irq_flags = SA_SHIRQ;
+	probe_ent->irq_flags = IRQF_SHARED;

 	probe_ent->mmio_base = mmio_base;

