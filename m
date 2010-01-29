Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257Ab0A2R4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0A2R4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348Ab0A2R42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:56:28 -0500
Received: from gateway-2929.mvista.com ([206.112.117.47]:35164 "HELO
	gateway-2929.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754119Ab0A2R41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:56:27 -0500
X-Greylist: delayed 1084 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 12:56:16 EST
Message-ID: <4B631C88.2020307@ru.mvista.com>
Date: Fri, 29 Jan 2010 20:36:08 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/68] it8213: always program control bits
References: <20100129160308.21495.14120.sendpatchset@localhost> <20100129160551.21495.52656.sendpatchset@localhost>
In-Reply-To: <20100129160551.21495.52656.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] it8213: always program control bits
>
> This matches behavior of libata pata_it8213 host driver.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/it8213.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> Index: b/drivers/ide/it8213.c
> ===================================================================
> --- a/drivers/ide/it8213.c
> +++ b/drivers/ide/it8213.c
> @@ -55,15 +55,13 @@ static void it8213_set_pio_mode(ide_hwif
>  	if (is_slave) {
>  		master_data |=  0x4000;
>  		master_data &= ~0x0070;
> -		if (pio > 1)
> -			master_data = master_data | (control << 4);
> +		master_data = master_data | (control << 4);
>   

    master_data |= control << 4; /* it's C after all */

>  		pci_read_config_byte(dev, slave_port, &slave_data);
>  		slave_data = slave_data & 0xf0;
>  		slave_data = slave_data | (timings[pio][0] << 2) | timings[pio][1];
>  	} else {
>  		master_data &= ~0x3307;
> -		if (pio > 1)
> -			master_data = master_data | control;
> +		master_data = master_data | control;
>   

    master_data |= control;

>  		master_data = master_data | (timings[pio][0] << 12) | (timings[pio][1] << 8);
>   

MBR, Sergei

