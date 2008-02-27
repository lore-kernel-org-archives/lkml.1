Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbYB0WPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbYB0WPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbYB0WPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:15:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:37156 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbYB0WPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:15:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=wjRgpIKfJtDg/H+0wIOmX+Qpr9doQ2pM2QOKiuRp1ekVkwFBnYsx7QIEQ2i7ZYgonInH/ehMm3ix2rBIHfJ5HDzXP4PPCJOXTWl2/Xklqx0h/CxorZiBqy2CHZBmbNoE1qaRJrWjLlNrsgnqxmhcZXj88Qqgb5/Hrh2UzBhNeXo=
Date: Wed, 27 Feb 2008 23:15:32 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] ide-cd: shorten lines longer than 80 columns
Message-ID: <20080227221532.GB9545@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com> <1204136449-9490-5-git-send-email-petkovbb@gmail.com> <200802272218.50537.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802272218.50537.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 10:18:50PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 27 February 2008, Borislav Petkov wrote:
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> interdiff for the merged version
> 
> diff -u b/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> --- b/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -433,13 +433,13 @@
>  			 * sector. If we got here the error is not correctable.
>  			 */
>  			ide_dump_status_no_sense(drive,
> -						"media error (bad sector)",
> -						stat);
> +						 "media error (bad sector)",
> +						 stat);
>  			do_end_request = 1;
>  		} else if (sense_key == BLANK_CHECK) {
>  			/* disk appears blank ?? */
>  			ide_dump_status_no_sense(drive, "media error (blank)",
> -						stat);
> +						 stat);
>  			do_end_request = 1;
>  		} else if ((err & ~ABRT_ERR) != 0) {
>  			/* go to the default handler for other errors */
> @@ -510,7 +510,7 @@
>  	default:
>  		if (!(rq->cmd_flags & REQ_QUIET))
>  			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n",
> -				rq->cmd[0]);
> +					 rq->cmd[0]);

why do you push the rq->cmd[0] thingy back here. Shouldn't it be aligned
with the opening brace as the zillion others so far?

>  		wait = 0;
>  		break;
>  	}
> @@ -552,7 +552,7 @@
>  
>  		/* packet command */
>  		ide_execute_command(drive, WIN_PACKETCMD, handler,
> -					ATAPI_WAIT_PC, cdrom_timer_expiry);
> +				    ATAPI_WAIT_PC, cdrom_timer_expiry);
>  		return ide_started;
>  	} else {
>  		unsigned long flags;
> @@ -809,7 +809,7 @@
>  	info->dma = 0;
>  	info->start_seek = jiffies;
>  	return cdrom_start_packet_command(drive, 0,
> -					cdrom_start_seek_continuation);
> +					  cdrom_start_seek_continuation);
>  }
>  
>  /*
> @@ -819,8 +819,8 @@
>  static void restore_request(struct request *rq)
>  {
>  	if (rq->buffer != bio_data(rq->bio)) {
> -		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) /
> -				SECTOR_SIZE;
> +		sector_t n =
> +			(rq->buffer - (char *)bio_data(rq->bio)) / SECTOR_SIZE;

i must say, lines like this one always look ugly, no matter the formatting
tricks.

>  		rq->buffer = bio_data(rq->bio);
>  		rq->nr_sectors += n;
> @@ -1192,8 +1192,8 @@
>  	/* sg request */
>  	if (rq->bio) {
>  		int mask = drive->queue->dma_alignment;
> -		unsigned long addr = (unsigned long)
> -					page_address(bio_page(rq->bio));
> +		unsigned long addr =
> +			(unsigned long)page_address(bio_page(rq->bio));
>  
>  		info->dma = drive->using_dma;
>  
> @@ -1233,16 +1233,14 @@
>  					return ide_stopped;
>  				}
>  				printk(KERN_ERR "%s: DSC timeout\n",
> -					drive->name);
> +						drive->name);
>  			}
>  			info->cd_flags &= ~IDE_CD_FLAG_SEEKING;
>  		}
> -		if ((rq_data_dir(rq) == READ) &&
> -			IDE_LARGE_SEEK(info->last_block,
> -					block,
> -					IDECD_SEEK_THRESHOLD) &&
> -			drive->dsc_overlap)
> -
> +		if (rq_data_dir(rq) == READ &&
> +		    IDE_LARGE_SEEK(info->last_block, block,
> +				   IDECD_SEEK_THRESHOLD) &&
> +		    drive->dsc_overlap)
>  			action = cdrom_start_seek(drive, block);
>  		else
>  			action = cdrom_start_rw(drive, rq);
> @@ -1375,7 +1373,7 @@
>  		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
>  		if (toc == NULL) {
>  			printk(KERN_ERR "%s: No cdrom TOC buffer!\n",
> -				drive->name);
> +					drive->name);
>  			return -ENOMEM;
>  		}
>  		info->toc = toc;
> @@ -1619,7 +1617,7 @@
>  	if (drive->media == ide_optical) {
>  		cdi->mask &= ~(CDC_MO_DRIVE | CDC_RAM);
>  		printk(KERN_ERR "%s: ATAPI magneto-optical drive\n",
> -			drive->name);
> +				drive->name);
>  		return nslots;
>  	}
>  
> @@ -2118,7 +2116,7 @@
>  	if (ignore != NULL) {
>  		if (strstr(ignore, drive->name)) {
>  			printk(KERN_INFO "ide-cd: ignoring drive %s\n",
> -				drive->name);
> +					 drive->name);
>  			goto failed;
>  		}
>  	}
> @@ -2130,7 +2128,7 @@
>  	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
>  	if (info == NULL) {
>  		printk(KERN_ERR "%s: Can't allocate a cdrom structure\n",
> -			drive->name);
> +				drive->name);
>  		goto failed;
>  	}
>  

-- 
Regards/Gruﬂ,
    Boris.
