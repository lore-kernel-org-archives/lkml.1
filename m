Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbXCPIpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbXCPIpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXCPIpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:45:39 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:51386 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbXCPIpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:45:38 -0400
Message-ID: <45FA5951.2050902@drzeus.cx>
Date: Fri, 16 Mar 2007 09:46:09 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Philip Langdale <philipl@overt.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>, juha.yrjola@solidboot.com
Subject: Re: [PATCH] MMC: Fix handling of low-voltage cards
References: <45F49BE9.6070803@overt.org>
In-Reply-To: <45F49BE9.6070803@overt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Langdale wrote:
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index c87ce56..74ebd97 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -317,6 +317,24 @@ static u32 mmc_select_voltage(struct mmc
>   

The idea with the new structure is to keep a bare minimum of protocol
information in core.c. So stick these tests into mmc.c and sd.c.

> +	if (ocr & 0x7F) {
> +		printk("%s: card claims to support voltages below "
>   

Please include a level with the printk().

> +	if (host->mode == MMC_MODE_SD && (ocr & MMC_VDD_165_195)) {
>   

Ooops. host->mode should have been removed by now.


Otherwise the patch looks good. Just fix these points and I'll include it.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

