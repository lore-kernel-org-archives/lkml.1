Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905Ab0ARSsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0ARSsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885Ab0ARSsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:48:11 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:46825 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754025Ab0ARSsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:48:08 -0500
Message-ID: <4B54AC7B.4030903@ru.mvista.com>
Date: Mon, 18 Jan 2010 21:46:19 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/64] pata_cmd64x: fix handling of address setup timings
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171504.14623.11688.sendpatchset@localhost>
In-Reply-To: <20100118171504.14623.11688.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_cmd64x: fix handling of address setup timings
>
> Account for the requirements of the DMA mode currently used
> by the pair device.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_cmd64x.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> Index: b/drivers/ata/pata_cmd64x.c
> ===================================================================
> --- a/drivers/ata/pata_cmd64x.c
> +++ b/drivers/ata/pata_cmd64x.c
> @@ -165,8 +165,14 @@ static void cmd64x_set_timing(struct ata
>  
>  		if (pair) {
>  			struct ata_timing tp;
> +
>  			ata_timing_compute(pair, pair->pio_mode, &tp, T, 0);
>  			ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
> +			if (pair->dma_mode) {
> +				ata_timing_compute(pair, pair->dma_mode,
> +						&tp, T, 0);
> +				ata_timing_merge(&tp, &t, &t, ATA_TIMING_SETUP);
>   

   I wonder where Jeff has got the address setup timings for the DMA 
modes...

MBR, Sergei

