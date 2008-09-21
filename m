Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbYIUJ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbYIUJ4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 05:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYIUJ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 05:56:09 -0400
Received: from h155.mvista.com ([63.81.120.155]:52704 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751274AbYIUJ4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 05:56:06 -0400
Message-ID: <48D61A31.9090203@ru.mvista.com>
Date: Sun, 21 Sep 2008 13:56:01 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] ide: check drive->present in ide_get_paired_drive()
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain> <20080726134057.10589.10226.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134057.10589.10226.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Change ide_get_paired_drive() to return NULL if peer device
>   is not present and update all users accordingly.
>
> While at it:
>
> * ide_get_paired_drive() -> ide_get_pair_dev()
>   

   Hm, ide_get_mate_dev() appeals to me more.

> * Use ide_get_pair_dev() in cs5530.c, sc1200.c and via82cxxx.c.
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/pci/cs5530.c
> ===================================================================
> --- a/drivers/ide/pci/cs5530.c
> +++ b/drivers/ide/pci/cs5530.c
> @@ -81,11 +81,11 @@ static void cs5530_set_pio_mode(ide_driv
>  static u8 cs5530_udma_filter(ide_drive_t *drive)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
> -	ide_drive_t *mate = &hwif->drives[(drive->dn & 1) ^ 1];
> +	ide_drive_t *mate = ide_get_pair_dev(drive);
>  	u16 *mateid = mate->id;
>  	u8 mask = hwif->ultra_mask;
>  
> -	if (mate->present == 0)
> +	if (mate == NULL)
>   

   Hum... no == in some places and == isn't very consistent...

MBR, Sergei


