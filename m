Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZA0P0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZA0P0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZA0PZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:25:21 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:39919 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZA0PZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:25:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pPdEIKYLal7qhaEqWizWlUzs7ZPHmZ7HXOXB+miPs9pda2owt9UmBzt1jufHORcP6R
         Vj3bV1MzangSi1lqDXesutAUWTJ+KYtQKK7whseIcNaiwLkbS7orE5yOTOsjPGFm+TJI
         F7OMm8ui/cXPwdSnMcHShsSM61HKXK2F6e4P4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/3] ide-cd: use ide_drive_t's rq in cdrom_queue_request_sense
Date: Tue, 27 Jan 2009 16:07:08 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090126; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1233002440-4325-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1233002440-4325-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271607.10869.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 January 2009, Borislav Petkov wrote:
> There should be no functionality change resulting from this patch.
> 
> Suggested-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-cd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index d3d5fb6..3907466 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -207,7 +207,7 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
>  				      struct request *failed_command)
>  {
>  	struct cdrom_info *info		= drive->driver_data;
> -	struct request *rq		= &info->request_sense_request;
> +	struct request *rq		= &drive->request_sense_rq;

Don't we want to also remove now unused ->request_sense_request?
