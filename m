Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812Ab0ARTaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0ARTaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353Ab0ARTaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:30:11 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:3080 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751190Ab0ARTaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:30:10 -0500
Message-ID: <4B54B656.2090307@ru.mvista.com>
Date: Mon, 18 Jan 2010 22:28:22 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/64] ide: add drive->pio_mode field
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118172028.14623.55296.sendpatchset@localhost>
In-Reply-To: <20100118172028.14623.55296.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: add drive->pio_mode field
>
> Add pio_mode field to ide_drive_t matching pio_mode field used in
> struct ata_device.
>
> The validity of the field is restricted to ->set_pio_mode method
> only currently in IDE subsystem.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-devsets.c   |    2 ++
>  drivers/ide/ide-probe.c     |    2 ++
>  drivers/ide/ide-xfer-mode.c |    3 +++
>  include/linux/ide.h         |    1 +
>  4 files changed, 8 insertions(+)
>
> Index: b/drivers/ide/ide-devsets.c
> ===================================================================
> --- a/drivers/ide/ide-devsets.c
> +++ b/drivers/ide/ide-devsets.c
> @@ -105,6 +105,8 @@ static int set_pio_mode(ide_drive_t *dri
>  		return -ENOSYS;
>  
>  	if (set_pio_mode_abuse(drive->hwif, arg)) {
> +		drive->pio_mode = arg + XFER_PIO_0;
> +
>   

   Er, didn't understand this... these 'arg' values are not really PIO 
modes, no?

>  		if (arg == 8 || arg == 9) {
>  			unsigned long flags;
>   

MBR, Sergei

