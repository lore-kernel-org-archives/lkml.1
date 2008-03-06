Return-Path: <linux-kernel-owner+w=401wt.eu-S1764950AbYCFUbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764950AbYCFUbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYCFUbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:31:13 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59718 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888AbYCFUbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:31:12 -0500
Subject: Re: [2.6 patch] SCSI_AIC94XX must depend on SCSI
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080306202246.GB5259@cs181133002.pp.htv.fi>
References: <200803062009.20309.toralf.foerster@gmx.de>
	 <20080306202246.GB5259@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=utf-8
Date: Thu, 06 Mar 2008 14:31:07 -0600
Message-Id: <1204835467.3062.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 22:22 +0200, Adrian Bunk wrote:
> This patch fixes the following build error reported by Toralf Förster:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 243 modules
> ERROR: "sas_bios_param" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_change_queue_type" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_change_queue_depth" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_target_destroy" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_target_alloc" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_slave_destroy" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_slave_configure" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_eh_bus_reset_handler" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_eh_device_reset_handler" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_queuecommand" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_ioctl" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_register_ha" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_domain_attach_transport" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_ssp_task_response" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_slave_alloc" [drivers/scsi/mvsas.ko] undefined!
> ERROR: "sas_unregister_ha" [drivers/scsi/mvsas.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> --- a/drivers/scsi/aic94xx/Kconfig
> +++ b/drivers/scsi/aic94xx/Kconfig
> @@ -26,7 +26,7 @@
>  
>  config SCSI_AIC94XX
>  	tristate "Adaptec AIC94xx SAS/SATA support"
> -	depends on PCI
> +	depends on SCSI && PCI
>  	select SCSI_SAS_LIBSAS
>  	select FW_LOADER

This doesn't look to be a fix for your error: the symbols you've listed
as missing are all libsas ones, not core SCSI ones.  Also they're all
claiming to be missing from mvsas, not aic94xx.  There's something else
about the configuration that produced this error.

James


