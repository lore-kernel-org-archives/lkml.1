Return-Path: <linux-kernel-owner+w=401wt.eu-S1762993AbYALUV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762993AbYALUV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762816AbYALUUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:20:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:20776 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759665AbYALUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:20:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=xbsuQenwGAwwa9a2Zvikq4YFqBZ5ooxBEfWqBmbx251YkLbDvHtLWLPl0Ef58d6l4DrIMtXrlGPnOEG7bzRrdv4T05uu3mMSKaG6M8DYIoSFoCVNDFhbV89KLaQdi9Q51gdP1IfRA9kk0HLBeSew8EzE06rWi2wYWPhCeV7OaK0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 14/21] ide-floppy: mv idefloppy_{should_,}report_error
Date: Sat, 12 Jan 2008 21:16:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-14-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-15-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200052699-28420-15-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801122116.31722.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008, Borislav Petkov wrote:
> In addition to shortening the function name, move the printk-call into the
> function thereby saving some code lines. Also, make the function out_of_line
> since it is not on a performance critical path.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-floppy.c |   37 ++++++++++++++-----------------------
>  1 files changed, 14 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 49d83a1..b718615 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -707,16 +707,18 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
>  	return ide_started;
>  }
>  
> -/*
> - * Suppresses error messages resulting from Medium not present.
> - */
> -static inline int idefloppy_should_report_error(idefloppy_floppy_t *floppy)
> +static void idefloppy_report_error(idefloppy_floppy_t *floppy,
> +		idefloppy_pc_t *pc)
>  {

-> Would make a sense to move the comment here instead of removing it
(it is useful unless you remeber all ->{sense_key,asc,ascq} value).

>  	if (floppy->sense_key == 0x02 &&
>  	    floppy->asc       == 0x3a &&
>  	    floppy->ascq      == 0x00)
> -		return 0;
> -	return 1;
> +		return;

Otherwise the patch is fine.
