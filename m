Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0CCRzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:55:49 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56910 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab0CCRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:55:43 -0500
Message-ID: <4B8EA21A.2040601@ru.mvista.com>
Date: Wed, 03 Mar 2010 20:53:30 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] ahci: Export generic AHCI symbols, turn libahci
 into a separate module
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru> <20100303171749.GJ12362@oksana.dev.rtsoft.ru>
In-Reply-To: <20100303171749.GJ12362@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anton Vorontsov wrote:

> This is needed for non-PCI drivers that will be added soon.
>
> Since the symbols are exported now, libahci and ahci can be built as
> a separate modules.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/ata/Kconfig   |    8 +++++++-
>  drivers/ata/Makefile  |    3 ++-
>  drivers/ata/libahci.c |   20 ++++++++++++++++++++
>  3 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 01c52c4..365a9da 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -59,12 +59,18 @@ config SATA_PMP
>  
>  config SATA_AHCI
>  	tristate "AHCI SATA support"
> -	depends on PCI
>  	help
>  	  This option enables support for AHCI Serial ATA.
>  
>  	  If unsure, say N.
>  
> +config SATA_AHCI_PCI
> +	tristate "PCI AHCI SATA support"
> +	depends on SATA_AHCI && PCI
>   

   Perhaps it's worth to turn that into select SATA_AHCI and make 
SATA_AHCI invisible to users instead, so that each particular AHCI 
implementation could select it.

> +	default y
>   

   Why force the default "y" if the predecessor option SATA_AHCI didn't 
do it?

MBR, Sergei

