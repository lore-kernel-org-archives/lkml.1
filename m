Return-Path: <linux-kernel-owner+w=401wt.eu-S1763317AbXIZWgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763317AbXIZWgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbXIZWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:36:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:20885 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXIZWgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:36:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=JEpDbTaMa/lAIoOsCn6ZsVxo3wFmqDLBP2N3U/4bdA24BY5mssv2lYdlzg5Un1YTYG9dn5CFOmKtEF1kqkANS4H7iJ+NVvBFM6UNtXSCKWFGmE5DDUECEfZaY2qoQIPNoTmUbBzV0Bg1O/w1/zZRrHrkclwK0BaZ5dVbXrmuwKo=
Date: Thu, 27 Sep 2007 01:35:43 +0300
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ralf@linux-mips.org
Subject: [PATCH 2/3] MIPS: Remove deprecated IRQ flags (SA_*)
Message-ID: <20070926223543.GB25905@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926223343.GA25905@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

A patch to stop using deprecated IRQ flags. The new IRQF_* macros are used
instead.


Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/arch/mips/pci/ops-pmcmsp.c b/arch/mips/pci/ops-pmcmsp.c
index 09fa007..a86a189 100644
--- a/arch/mips/pci/ops-pmcmsp.c
+++ b/arch/mips/pci/ops-pmcmsp.c
@@ -404,7 +404,7 @@ int msp_pcibios_config_access(unsigned char access_type,
 	if (pciirqflag == 0) {
 		request_irq(MSP_INT_PCI,/* Hardcoded internal MSP7120 wiring */
 				bpci_interrupt,
-				SA_SHIRQ | SA_INTERRUPT,
+				IRQF_SHARED | IRQF_DISABLED,
 				"PMC MSP PCI Host",
 				preg);
 		pciirqflag = ~0;
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c b/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
index 6fa8572..ab96a2d 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
@@ -163,7 +163,7 @@ static int msp_hwbutton_register(struct hwbutton_interrupt *hirq)
 		CIC_EXT_SET_ACTIVE_HI(cic_ext, hirq->eirq);
 	*CIC_EXT_CFG_REG = cic_ext;
 
-	return request_irq(hirq->irq, hwbutton_handler, SA_INTERRUPT,
+	return request_irq(hirq->irq, hwbutton_handler, IRQF_DISABLED,
 				hirq->name, (void *)hirq);
 }
 

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
