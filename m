Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab0BEReu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:34:50 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:41895 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab0BERet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:34:49 -0500
Message-ID: <4B6C5628.6050308@oracle.com>
Date: Fri, 05 Feb 2010 09:32:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
CC: Jeff Garzik <jgarzik@pobox.com>, Erik Inge Bols?? <knan-lkml@anduin.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] non-existant config in kernel source (CONFIG_AHCI)
References: <20100205132959.GB6874@faui49.informatik.uni-erlangen.de>
In-Reply-To: <20100205132959.GB6874@faui49.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B6C5641.014C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/10 05:29, Christoph Egger wrote:
> Hi all!
>
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
>
> 	While there's one place that is checking for CONFIG_AHCI, this
> config being referenced from printed books and people pointing to this
> config item I can't find it anywhere in the kernel kconfig
> infrastruture and it doesn't seem to ever have been there (since
> git). Is this maybe a typo for CONFIG_SATA_AHCI? reading the
> information for the affected piece of source it would actually make
> sense.
>
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.
>
> Regards
>
> 	Christoph Egger
>
> [0] http://vamos1.informatik.uni-erlangen.de/
>
> ----
>  From 60136f94d9c97f9a788738e30731e25bd794322b Mon Sep 17 00:00:00 2001
> From: Christoph Egger<siccegge@stud.informatik.uni-erlangen.de>
> Date: Fri, 5 Feb 2010 13:26:33 +0100
> Subject: [PATCH] CONFIG_AHCI is really CONFIG_SATA_AHCI
>
> The marvell driver comtains a fallback to ahci for the sata ports
> which is incorrectly checked as CONFIG_AHCI while the only AHCI config
> item is actually called SATA_AHCI (which also sounds sensible
> considering it's a fallback for the sata ports).
>
> Signed-off-by: Christoph Egger<siccegge@stud.informatik.uni-erlangen.de>
> ---
>   drivers/ata/pata_marvell.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
> index 950da39..eabd138 100644
> --- a/drivers/ata/pata_marvell.c
> +++ b/drivers/ata/pata_marvell.c
> @@ -147,7 +147,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
>   	if (pdev->device == 0x6101)
>   		ppi[1] =&ata_dummy_port_info;
>
> -#if defined(CONFIG_AHCI) || defined(CONFIG_AHCI_MODULE)
> +#if defined(CONFIG_SATA_AHCI) || defined(SATA_CONFIG_AHCI_MODULE)
                                             ~~~~~~~~~~~~~~~~~~~~~~~
                                      -->    CONFIG_SATA_AHCI_MODULE

>   	if (!marvell_pata_active(pdev)) {
>   		printk(KERN_INFO DRV_NAME ": PATA port not active, deferring to AHCI driver.\n");
>   		return -ENODEV;


-- 
~Randy
