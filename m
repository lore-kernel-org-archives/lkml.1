Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbYHVKUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbYHVKUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYHVKUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:20:47 -0400
Received: from h155.mvista.com ([63.81.120.155]:15915 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754695AbYHVKUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:20:46 -0400
Message-ID: <48AE92F8.8020704@ru.mvista.com>
Date: Fri, 22 Aug 2008 14:20:40 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ide: set IDE_AFLAG_DRQ_INTERRUPT in do_identify()
References: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
In-Reply-To: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Set IDE_AFLAG_DRQ_INTERRUPT in do_identify() instead of ATAPI
> device drivers *_setup() methods.
>
> While at it:
> - use ata_id_cdb_intr()
>
> There should be no functional changes caused by this patch.
>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   
[...]
> Index: b/drivers/ide/ide-cd.c
> ===================================================================
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1887,9 +1887,6 @@ static int ide_cdrom_setup(ide_drive_t *
>  	drive->atapi_flags = IDE_AFLAG_MEDIA_CHANGED | IDE_AFLAG_NO_EJECT |
>  		       ide_cd_flags(id);
>  
> -	if ((id[ATA_ID_CONFIG] & 0x0060) == 0x20)
> -		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
> -
>   

   Wait, this needs to be fixed first -- 0x20 does *not* mean CDB INTRQ!

> Index: b/drivers/scsi/ide-scsi.c
> ===================================================================
> --- a/drivers/scsi/ide-scsi.c
> +++ b/drivers/scsi/ide-scsi.c
> @@ -385,8 +385,6 @@ static const struct ide_proc_devset ides
>   */
>  static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
>  {
> -	if ((drive->id[ATA_ID_CONFIG] & 0x0060) == 0x20)
>   

   This one is wrong too...

WBR, Sergei


