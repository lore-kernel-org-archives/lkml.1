Return-Path: <linux-kernel-owner+w=401wt.eu-S1764073AbYALUWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764073AbYALUWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762955AbYALUU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:20:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:21288 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbYALUUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:20:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Eqy24DHZDwruMTvKgq/yBE8FisbG+S2ygC2ElrzqXiqTpS2jCT6YcgQfuVo/K36O4FkwP5OB0Z/n3sZOYG1hc4Sc5AbzsOpH8oJf2E/8YisQMx2dgq76yCESw17/QC97VpKJo5EeffHTeKwuxbj4rOLXlbVnJc92BHw1XhsP0wg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 18/21] ide-floppy: fix error handling in idefloppy_probe()
Date: Sat, 12 Jan 2008 21:18:01 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-18-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-19-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200052699-28420-19-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801122118.01949.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-floppy.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 89b26ea..0729df5 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -1737,7 +1737,8 @@ static int ide_floppy_probe(ide_drive_t *drive)
>  				" emulation.\n", drive->name);
>  		goto failed;
>  	}
> -	if ((floppy = kzalloc(sizeof (idefloppy_floppy_t), GFP_KERNEL)) == NULL) {
> +	floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL);
> +	if (!floppy) {
>  		printk(KERN_ERR "ide-floppy: %s: Can't allocate a floppy"
>  				" structure\n", drive->name);
>  		goto failed;

I'm unable to see any problem with error handling here?

This change should be combined with the rest of checkpatch.pl fixes.
