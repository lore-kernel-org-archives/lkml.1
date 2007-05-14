Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbXENOD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbXENOD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 10:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXENODW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 10:03:22 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:63403 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbXENODV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 10:03:21 -0400
In-Reply-To: <46484110.5020607@freescale.com>
References: <46484110.5020607@freescale.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F67CA64A-2474-4239-8BC1-17EC4AAA2D92@kernel.crashing.org>
Cc: Paul <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 2/2] powerpc: Fix Section mismatch warnings
Date: Mon, 14 May 2007 09:02:26 -0500
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
> arch/powerpc/platforms/chrp/pegasos_eth.c |    2 +-
> arch/powerpc/platforms/powermac/setup.c   |    2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/platforms/chrp/pegasos_eth.c b/arch/ 
> powerpc/platforms/chrp/pegasos_eth.c
> index 7104567..5c9f135 100644
> --- a/arch/powerpc/platforms/chrp/pegasos_eth.c
> +++ b/arch/powerpc/platforms/chrp/pegasos_eth.c
> @@ -169,7 +169,7 @@ static int Enable_SRAM(void)
> /***********/
> /***********/
> -int mv643xx_eth_add_pds(void)
> +int __init mv643xx_eth_add_pds(void)

it should probably be static as well.

> {
> 	int ret = 0;
> 	static struct pci_device_id pci_marvell_mv64360[] = {
> diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/ 
> platforms/powermac/setup.c
> index a410bc7..07b1c4e 100644
> --- a/arch/powerpc/platforms/powermac/setup.c
> +++ b/arch/powerpc/platforms/powermac/setup.c
> @@ -384,7 +384,7 @@ int boot_part;
> static dev_t boot_dev;
> #ifdef CONFIG_SCSI
> -void __init note_scsi_host(struct device_node *node, void *host)
> +void note_scsi_host(struct device_node *node, void *host)
> {
> 	int l;
> 	char *p;
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

