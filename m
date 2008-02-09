Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYBIQSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYBIQSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYBIQSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:18:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:33423 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYBIQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=rOHfo4Yapr2Lm4OmFbHL1iZXnoGoQG8u1B9FnqkWvX/YRKETHbgXQnEo4xwrl/vVWupbyhetRIHsyJV2B2X2B1fQaYlihh6sU5W6k3uZug6vPpczrQbj7+ZlOBQPmOe2Um7e1WPti2XHg6vzqnB2UcHWnmA9qZrQMWCNVOOaCuc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-floppy: remove struct idefloppy_id_gcw
Date: Sat, 9 Feb 2008 16:21:05 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080209080334.GA23177@gollum.tnic>
In-Reply-To: <20080209080334.GA23177@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802091621.05671.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008, Borislav Petkov wrote:
> commit a6aaf3dd3e88d1bd1e85fb4329042ecb9247e0eb
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Fri Feb 8 18:21:47 2008 +0100
> 
>     ide-floppy: remove struct idefloppy_id_gcw
>     
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied with some changes

> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index faf22d7..5d5bde8 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c

[...]

>  #ifdef CONFIG_PPC
>  	/* kludge for Apple PowerBook internal zip */
> -	if ((gcw.device_type == 5) &&
> -	    !strstr(id->model, "CD-ROM") &&
> -	    strstr(id->model, "ZIP"))
> -		gcw.device_type = 0;
> +	if ((device_type == 5) &&
> +		trstr(id->model, "CD-ROM") &&
                ^^^^^

[...]

> -	else if (!gcw.removable)
> -		printk(KERN_ERR "ide-floppy: The removable flag is not set\n");
> -	else if (gcw.drq_type == 3) {
> +				"to floppy\n", device_type);
> +	else if (!removable)
> +		printk(KERN_ERR "ide-floppy: The removable flag (0x%02x) is not"

no need to dump it (it is a single bit flag)

[ please document such changes in patch description ]

> +	else if (drq_type == 3) {
>  		printk(KERN_ERR "ide-floppy: Sorry, DRQ type (0x%02x) not "
> -				"supported\n", gcw.drq_type);
> -	} else if (gcw.packet_size != 0) {
> +				"supported\n", drq_type);
> +	} else if (packet_size != 0) {
>  		printk(KERN_ERR "ide-floppy: Packet size (0x%02x) is not 12 "
> -				"bytes long\n", gcw.packet_size);
> +				"bytes\n", packet_size);
>  	} else

needless braces can be removed while at it
