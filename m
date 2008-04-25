Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbYDYEsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbYDYEsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYDYEsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:48:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46572 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbYDYEsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:48:22 -0400
Message-ID: <48116294.80106@garzik.org>
Date: Fri, 25 Apr 2008 00:48:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] libata-acpi.c: remove unneeded #if's
References: <20080421225035.GK2633@cs181133002.pp.htv.fi>
In-Reply-To: <20080421225035.GK2633@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> These #if's are unneeded since they:
> - did anyway not handle the CONFIG_ACPI_DOCK_MODULE case correctly and
> - this is already handled in include/acpi/acpi_drivers.h and
> - it's now correctly handled in kconfig.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked-by: Tejun Heo <htejun@gmail.com>
> 
> ---
> 
> This patch has been sent on:
> - 14 Apr 2008
> - 31 Mar 2008
> 
>  drivers/ata/libata-acpi.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> 2a7326b50cd80e6570803d4efb7bc15e029e61e3 diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index bf98a56..1db912e 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -227,11 +227,9 @@ void ata_acpi_associate(struct ata_host *host)
>  			acpi_install_notify_handler(ap->acpi_handle,
>  						    ACPI_SYSTEM_NOTIFY,
>  						    ata_acpi_ap_notify, ap);
> -#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
>  			/* we might be on a docking station */
>  			register_hotplug_dock_device(ap->acpi_handle,
>  						     ata_acpi_ap_notify, ap);
> -#endif
>  		}
>  
>  		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
> @@ -241,11 +239,9 @@ void ata_acpi_associate(struct ata_host *host)
>  				acpi_install_notify_handler(dev->acpi_handle,
>  						ACPI_SYSTEM_NOTIFY,
>  						ata_acpi_dev_notify, dev);
> -#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
>  				/* we might be on a docking station */
>  				register_hotplug_dock_device(dev->acpi_handle,
>  						ata_acpi_dev_notify, dev);
> -#endif

applied


