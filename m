Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbZHLK0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbZHLK0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbZHLK0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:26:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52538 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446AbZHLK0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:26:08 -0400
Message-ID: <4A8298BD.8020500@pobox.com>
Date: Wed, 12 Aug 2009 06:26:05 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [PATCH 2.6.32 v3] Conditional MSI support for sata_nv
References: <20090805235009.88C091007F@gold.linx.net>
In-Reply-To: <20090805235009.88C091007F@gold.linx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon wrote:
> At least the nVidia MCP55 controller quite happily supports MSI.
> This adds an option to use it. It is disabled by default.
> As per feedback by Robert Hancock, it will honour the user 
> request as the kernel will not enable MSI where the controller 
> or the specific system configuration do not support it.
> 
> Signed-off-by: Tony Vroon <tony@linx.net>
> Cc: Robert Hancock <hancockrwd@gmail.com>
> 
> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index b2d11f3..4598f19 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -602,6 +602,7 @@ MODULE_VERSION(DRV_VERSION);
>  
>  static int adma_enabled;
>  static int swncq_enabled = 1;
> +static int msi_enabled;
>  
>  static void nv_adma_register_mode(struct ata_port *ap)
>  {
> @@ -2459,6 +2460,12 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	} else if (type == SWNCQ)
>  		nv_swncq_host_init(host);
>  
> +	if (msi_enabled) {
> +		dev_printk(KERN_NOTICE, &pdev->dev, "Using MSI\n");
> +		pci_enable_msi(pdev);
> +	}
> +
>  	pci_set_master(pdev);
>  	return ata_host_activate(host, pdev->irq, ipriv->irq_handler,
>  				 IRQF_SHARED, ipriv->sht);
> @@ -2558,4 +2565,6 @@ module_param_named(adma, adma_enabled, bool, 0444);
>  MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: false)");
>  module_param_named(swncq, swncq_enabled, bool, 0444);
>  MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");

applied


