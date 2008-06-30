Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYF3He1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYF3He1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYF3HeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:34:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:10142 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYF3HeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vu3EJ6ND+85z7CrnunNtVGyrkAC2Iixj+58d6+RYfk/obMIPDI6wmPVh+PpyoWfNBr
         Zb+gL8LeTsEyw1ZsECeVONUcfFSqv6GWhv8MS7oqXKR7Wz4OAWr9C17v0hHCLgvz7APY
         A8tnLzqShLBVjALROADsIAtn6ih0cpkTbkZwc=
Message-ID: <48688C16.5040405@gmail.com>
Date: Mon, 30 Jun 2008 09:32:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: JosephChan@via.com.tw
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, geert@linux-m68k.org
Subject: Re: [PATCH 6/13] viafb: hw.c, hw.h
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E77AC@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E77AC@exchtp03.taipei.via.com.tw>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2008 09:04 AM, JosephChan@via.com.tw wrote:
> Display hw setting and other chips initialization.
> 
> 
> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 
> diff -Nur a/drivers/video/via/hw.c b/drivers/video/via/hw.c
> --- a/drivers/video/via/hw.c	1970-01-01 08:00:00.000000000 +0800
> +++ b/drivers/video/via/hw.c	2008-06-30 08:53:33.000000000 +0800
> @@ -0,0 +1,2865 @@
[...]
> +#include "global.h"
> +
> +static const struct pci_device_id_info pciidlist[] = {
> +	{PCI_VIA_VENDOR_ID, UNICHROME_CLE266_DID, UNICHROME_CLE266},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_PM800_DID, UNICHROME_PM800},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_K400_DID, UNICHROME_K400},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_K800_DID, UNICHROME_K800},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_CN700_DID, UNICHROME_CN700},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_P4M890_DID, UNICHROME_P4M890},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_K8M890_DID, UNICHROME_K8M890},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_CX700_DID, UNICHROME_CX700},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_P4M900_DID, UNICHROME_P4M900},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_CN750_DID, UNICHROME_CN750},
> +	{PCI_VIA_VENDOR_ID, UNICHROME_VX800_DID, UNICHROME_VX800},
> +	{0, 0, 0}
> +};

Why do you need yet another pci_device_id? How do you insure autoloading?

> +
> +struct offset offset_reg = {
> +	/* IGA1 Offset Register */
> +	{IGA1_OFFSET_REG_NUM, {{CR13, 0, 7}, {CR35, 5, 7} } },
> +	/* IGA2 Offset Register */
> +	{IGA2_OFFSET_REG_NUM, {{CR66, 0, 7}, {CR67, 0, 1} } }
> +};
> +
> +struct pll_map pll_value[] = {

May this be static const (and all of these)?

> +	{CLK_25_175M, CLE266_PLL_25_175M, K800_PLL_25_175M, CX700_25_175M},
