Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362Ab0ASTou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0ASTou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696Ab0ASTot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:44:49 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:6546 "HELO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751524Ab0ASTos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:44:48 -0500
Message-ID: <4B560B41.6080205@ru.mvista.com>
Date: Tue, 19 Jan 2010 22:42:57 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/64] ide: use standard timing for XFER_PIO_SLOW mode
 in ide_timing_compute()
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171729.14623.46024.sendpatchset@localhost> <20100119.012526.203639880.davem@davemloft.net> <201001191609.42582.bzolnier@gmail.com>
In-Reply-To: <201001191609.42582.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Subject: [PATCH] ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>       
>> Applied.
>>     
>
> Thanks.
>
> Here is a bonus fixup for a small issue noticed by Sergei yesterday.
>
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: ide_timing_compute() fixup
>
> XFER_SW_DMA_0 mode should be excluded from the extended cycle
> timing computations.
>
> [ This is just a documentation fix -- code inside the affected
>   'if' block already makes sure to accept only PIO modes. ]
>
> Noticed-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-timings.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: b/drivers/ide/ide-timings.c
> ===================================================================
> --- a/drivers/ide/ide-timings.c
> +++ b/drivers/ide/ide-timings.c
> @@ -166,7 +166,7 @@ int ide_timing_compute(ide_drive_t *driv
>  	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
>  		memset(&p, 0, sizeof(p));
>  
> -		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
> +		if (speed >= XFER_PIO_0 && speed < XFER_SW_DMA_0) {
>  			if (speed <= XFER_PIO_2)
>  				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
>  			else if ((speed <= XFER_PIO_4) ||
>   

   But shouldn't this just be merged to "ide: use standard timing for 
XFER_PIO_SLOW mode in ide_timing_compute()" since it's the patch that 
introduced that check?

MBR, Sergei

