Return-Path: <linux-kernel-owner+w=401wt.eu-S1760532AbXEOOH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532AbXEOOH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 10:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbXEOOHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 10:07:50 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:21955 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981AbXEOOHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 10:07:49 -0400
In-Reply-To: <46484110.5020607@freescale.com>
References: <46484110.5020607@freescale.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4575ED11-C144-49CF-9FBA-0613B61EFCE3@kernel.crashing.org>
Cc: Paul <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 2/2] powerpc: Fix Section mismatch warnings
Date: Tue, 15 May 2007 09:06:53 -0500
To: Li Yang <leoli@freescale.com>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14, 2007, at 5:59 AM, Li Yang wrote:

> This patch fix the following Section mismatch warnings
> in powerpc code.
>
> WARNING: arch/powerpc/platforms/built-in.o - Section mismatch:  
> reference to .init.data:mv643xx_eth_pd_devs from .text between  
> 'mv643xx_eth_add_pds' (at offset 0x9ed2) and 'gg2_read_config'
> WARNING: arch/powerpc/platforms/built-in.o - Section mismatch:  
> reference to .init.data:mv643xx_eth_pd_devs from .text between  
> 'mv643xx_eth_add_pds' (at offset 0x9ed6) and 'gg2_read_config'
> WARNING: arch/powerpc/platforms/built-in.o - Section mismatch:  
> reference to .init.text:note_scsi_host from __ksymtab between  
> '__ksymtab_note_scsi_host' (at offset 0x8) and '__ksymtab_sys_ctrler'
>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
>  arch/powerpc/platforms/chrp/pegasos_eth.c |    2 +-
>  arch/powerpc/platforms/powermac/setup.c   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Did you change anything?

- k

> diff --git a/arch/powerpc/platforms/chrp/pegasos_eth.c b/arch/ 
> powerpc/platforms/chrp/pegasos_eth.c
> index 7104567..5c9f135 100644
> --- a/arch/powerpc/platforms/chrp/pegasos_eth.c
> +++ b/arch/powerpc/platforms/chrp/pegasos_eth.c
> @@ -169,7 +169,7 @@ static int Enable_SRAM(void)
>
>  /***********/
>  /***********/
> -int mv643xx_eth_add_pds(void)
> +int __init mv643xx_eth_add_pds(void)
>  {
>  	int ret = 0;
>  	static struct pci_device_id pci_marvell_mv64360[] = {
> diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/ 
> platforms/powermac/setup.c
> index a410bc7..07b1c4e 100644
> --- a/arch/powerpc/platforms/powermac/setup.c
> +++ b/arch/powerpc/platforms/powermac/setup.c
> @@ -384,7 +384,7 @@ int boot_part;
>  static dev_t boot_dev;
>
>  #ifdef CONFIG_SCSI
> -void __init note_scsi_host(struct device_node *node, void *host)
> +void note_scsi_host(struct device_node *node, void *host)
>  {
>  	int l;
>  	char *p;
>
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

