Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYIOSdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYIOSdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYIOScP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:32:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:5749 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbYIOScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=wsJs9wGTLdr9Y72/i5CwVKUYFkju10/cibDf3/1LIrcZc5y73z07x3z8USJ+0Hnd+3
         I2AU8K5zJFkcSa/Nj/iTdGIKGsplM9jKXQu6yIHm7RJQJCHJMwxab/JCis5goFA+WEfN
         XfYcsB2OGm3uWIC6E8K7/AbUwvIhjhGaYgqLs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 06/10] ide-atapi: add a DEV_IS_IDECD macro
Date: Mon, 15 Sep 2008 20:19:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com> <1221392158-3848-7-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1221392158-3848-7-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809152019.02395.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2008 13:35:54 Borislav Petkov wrote:
> This is a short-term-use one and will be removed later - it is added to solely
> improve readability.
> 
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-atapi.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index 7045d34..e1fa52d 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -477,6 +477,9 @@ static int ide_delayed_transfer_pc(ide_drive_t *drive)
>  	return WAIT_FLOPPY_CMD;
>  }
>  
> +#define DEV_IS_IDECD(drive)	\
> +		(drive->media == ide_cdrom || drive->media == ide_optical)
> +

This needs to check for drive->scsi or the subtle bugs will happen.

Also why not use dev_is_idecd() static inline function instead?
