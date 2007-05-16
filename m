Return-Path: <linux-kernel-owner+w=401wt.eu-S1762814AbXEPFan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762814AbXEPFan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbXEPFag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:30:36 -0400
Received: from hqemgate01.nvidia.com ([216.228.112.170]:17707 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781AbXEPFaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:30:35 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] drivers/ata: correct a wrong free function for sata_nv driver
Date: Wed, 16 May 2007 13:31:34 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B13DEF520@hkemmail01.nvidia.com>
In-Reply-To: <464A94D7.30300@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/ata: correct a wrong free function for sata_nv driver
Thread-Index: AceXek9fNVIiebYuSyehXcTkfOQflAAAMtLg
References: <15F501D1A78BD343BE8F4D8DB854566B13CD8F45@hkemmail01.nvidia.com> <464A94D7.30300@garzik.org>
From: "Peer Chen" <pchen@nvidia.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 16 May 2007 05:29:52.0949 (UTC) FILETIME=[3AF89650:01C7977B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for posting a fault patch,following is the right one.

Signed-off-by: Peer Chen <pchen@nvidia.com>

===================================
--- linux-2.6.22-rc1/drivers/ata/sata_nv.c.orig
+++ linux-2.6.22-rc1/drivers/ata/sata_nv.c
@@ -1619,7 +1619,7 @@ static void nv_remove_one (struct pci_de
 	struct nv_host_priv *hpriv = host->private_data;
 
 	ata_pci_remove_one(pdev);
-	kfree(hpriv);
+	devm_kfree(&pdev->dev, hpriv);
 }
 
 #ifdef CONFIG_PM

============================= 


BRs
Peer Chen

-----Original Message-----
From: Jeff Garzik [mailto:jeff@garzik.org] 
Sent: Wednesday, May 16, 2007 1:21 PM
To: Peer Chen
Cc: linux-kernel@vger.kernel.org; akpm@linux-foundation.org; IDE/ATA
development list
Subject: Re: [PATCH] drivers/ata: correct a wrong free function for
sata_nv driver

Peer Chen wrote:
> For sata_nv driver in kernel 2.6.21 onward, Inside nv_init_one(),use
> 'hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);' but
> using the kfree(hpriv) to free that data struction in nv_remove_one(),
> which will cause system hang when removing the sata_nv module.
> 
> Change the 'kfree()' function to 'devm_kfree' will fix this bug.
> 
> The patch base on kernel 2.6.22-rc1.
> 
> Signed-off-by: Peer Chen <pchen@nvidia.com>
> =====================================
> --- linux-2.6.22-rc1/drivers/ata/sata_nv.c.orig
> +++ linux-2.6.22-rc1/drivers/ata/sata_nv.c
> @@ -1619,7 +1619,7 @@ static void nv_remove_one (struct pci_de
>  	struct nv_host_priv *hpriv = host->private_data;
>  
>  	ata_pci_remove_one(pdev);
> -	kfree(hpriv);
> +	devm_kfree(&pci_dev->dev, hpriv);

This patch is complete crap.  It doesn't even compile.  There is no 
variable "pci_dev" in this function at all.

It is highly discouraging that you cannot even bother to compile your 
own submissions to the second (or third) most popular operating system 
in the world.

	Jeff


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
