Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZLMUr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZLMUr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 15:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZLMUr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 15:47:57 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:47562 "HELO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753570AbZLMUrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 15:47:55 -0500
X-Auth-Info: ZTqB+TqEsVSJyjtweo6EnUUsuKfvgbthQM3sAntGPr4=
Message-ID: <4B2552C8.4090105@grandegger.com>
Date: Sun, 13 Dec 2009 21:47:04 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Christian Pellegrin <chripell@fsfe.org>,
       "David S. Miller" <davem@davemloft.net>,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>, netdev@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: CAN_MCP251X should depend on HAS_DMA
References: <alpine.DEB.2.00.0912132008100.21225@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.0912132008100.21225@ayla.of.borg>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> When building for Sun 3:
> 
> drivers/net/can/mcp251x.c:1074: undefined reference to `dma_free_coherent'
> drivers/net/can/mcp251x.c:976: undefined reference to `dma_alloc_coherent'
> drivers/net/can/mcp251x.c:1050: undefined reference to `dma_free_coherent'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/net/can/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> index 8c485aa..05b7517 100644
> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -50,7 +50,7 @@ config CAN_TI_HECC
>  
>  config CAN_MCP251X
>  	tristate "Microchip MCP251x SPI CAN controllers"
> -	depends on CAN_DEV && SPI
> +	depends on CAN_DEV && SPI && HAS_DMA
>  	---help---
>  	  Driver for the Microchip MCP251x SPI CAN controllers.
>  

DMA can be selected with the module parameter "mcp251x_enable_dma" and
is *off* by default. Therefore the driver does in principle not depend
on HAS_DMA but I'm not sure if it's worth to handle it with #idef's.
Christian? Any thought?

Wolfgang.

