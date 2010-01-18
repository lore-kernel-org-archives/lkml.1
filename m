Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037Ab0ARTMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0ARTMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026Ab0ARTMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:12:50 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:10108 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754264Ab0ARTMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:12:48 -0500
Message-ID: <4B54B245.4050507@ru.mvista.com>
Date: Mon, 18 Jan 2010 22:11:01 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/64] ide: use standard timing for XFER_PIO_SLOW mode
 in ide_timing_compute()
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171729.14623.46024.sendpatchset@localhost>
In-Reply-To: <20100118171729.14623.46024.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-timings.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> Index: b/drivers/ide/ide-timings.c
> ===================================================================
> --- a/drivers/ide/ide-timings.c
> +++ b/drivers/ide/ide-timings.c
> @@ -166,12 +166,13 @@ int ide_timing_compute(ide_drive_t *driv
>  	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
>  		memset(&p, 0, sizeof(p));
>  
> -		if (speed <= XFER_PIO_2)
> -			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
> -		else if ((speed <= XFER_PIO_4) ||
> -			 (speed == XFER_PIO_5 && !ata_id_is_cfa(id)))
> -			p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO_IORDY];
> -		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
> +		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
>   

   Ah, I see what to fix now but I guess it's rather your call. :-)

MBR, Sergei

