Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZBRTft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZBRTft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbZBRTfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:35:11 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:62973 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754911AbZBRTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:35:07 -0500
Message-ID: <499C62FF.1090805@ru.mvista.com>
Date: Wed, 18 Feb 2009 22:35:27 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH] ide-cd: document capacity hack
References: <200902182018.52195.bzolnier@gmail.com>
In-Reply-To: <200902182018.52195.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Just copy the comment from drivers/scsi/sr.c::sr_done()
> (from which the capacity hack has been originated).

> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/ide-cd.c
> ===================================================================
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -189,6 +189,14 @@ static void cdrom_analyze_sense_data(ide
>  			bio_sectors = max(bio_sectors(failed_command->bio), 4U);
>  			sector &= ~(bio_sectors - 1);
>  
> +			/*
> +			 * The SCSI specification allows for the value
> +			 * returned by READ CAPACITY to be up to 75 2K
> +			 * sectors past the last readable block.

    Oh horror... :-)

> +			 * Therefore, if we hit a medium error within the
> +			 * last 75 2K sectors, we decrease the saved size
> +			 * value.
> +			 */
>  			if (sector < get_capacity(info->disk) &&
>  			    drive->probed_capacity - sector < 4 * 75)
>  				set_capacity(info->disk, sector);

    Would be nice if the CHS capacity workround was finally documented too? ;-)

MBR, Sergei
