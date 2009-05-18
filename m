Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbZERKLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbZERKLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbZERKLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:11:14 -0400
Received: from h155.mvista.com ([63.81.120.155]:45033 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756829AbZERKLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:11:12 -0400
Message-ID: <4A11343C.5070809@ru.mvista.com>
Date: Mon, 18 May 2009 14:11:08 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 6/6] drivers/ide: Convert printk(KERN_NOTICE to pr_notice(
References: <cover.1242609803.git.joe@perches.com> <3ff9e9c7a8918f4d5f7bab5590f46073a196a4bf.1242609804.git.joe@perches.com>
In-Reply-To: <3ff9e9c7a8918f4d5f7bab5590f46073a196a4bf.1242609804.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
>   

  This patch creates lines > 80 chars long, co no ACK this time.

> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index a6edb0d..d7c4f5c 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
>   
[...]
> @@ -428,17 +428,15 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
>  			memcpy(&floppy->cap_desc, cap_desc, 8);
>  
>  			if (!length || length % 512) {
> -				printk(KERN_NOTICE PFX "%s: %d bytes block size"
> -				       " not supported\n", drive->name, length);
> +				pr_notice(PFX "%s: %d bytes block size not supported\n",
>   

  Line longer than 80 characters...

> +					  drive->name, length);
>  			} else {
>  				floppy->blocks = blocks;
>  				floppy->block_size = length;
>  				floppy->bs_factor = length / 512;
>  				if (floppy->bs_factor != 1)
> -					printk(KERN_NOTICE PFX "%s: Warning: "
> -					       "non 512 bytes block size not "
> -					       "fully supported\n",
> -					       drive->name);
> +					pr_notice(PFX "%s: Warning: non 512 bytes block size not fully supported\n",
>   

   Again.

> +						  drive->name);
>  				drive->capacity64 =
>  					floppy->blocks * floppy->bs_factor;
>  				rc = 0;
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 138c42d..bf3c128 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -756,8 +756,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
>  
>  	if (!blk_special_request(rq)) {
>  		/* We do not support buffer cache originated requests. */
> -		printk(KERN_NOTICE "ide-tape: %s: Unsupported request in "
> -			"request queue (%d)\n", drive->name, rq->cmd_type);
> +		pr_notice("ide-tape: %s: Unsupported request in request queue (%d)\n",
>   

    And again.

MBR, Sergei


