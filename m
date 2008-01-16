Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbYAPWjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbYAPWjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYAPWjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:39:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:32542 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYAPWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:39:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=a0FG+SgUC02YiT5bZWFBMOoLZ1OgoFW3iw3SbJRCBvFfi/Hwi08yI8p6hVBnP8s+GtAaqkNrs3QqAsgZoTvgQtVVKz8me/mrCblD6iI8ofdYtKy8/EFVmmF6P8q9uLHmLzmc9+TrCGHHZWoh4jSxE4hiRXkBOJ2yrtjhKgpuLa4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: bbpetkov@yahoo.de
Subject: Re: [PATCH 10/12] ide-floppy: remove atomic test_*bit macros
Date: Wed, 16 Jan 2008 23:25:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <200801142250.58201.bzolnier@gmail.com> <20080115201032.GB5699@gollum.tnic>
In-Reply-To: <20080115201032.GB5699@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801162325.31598.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008, Borislav Petkov wrote:

[...]

> .. this is the second one...
> 
> 
> From: Borislav Petkov <bbpetkov@yahoo.de>
> Date: Tue, 15 Jan 2008 20:49:18 +0100
> Subject: [PATCH 16/18] ide-floppy: remove atomic test_*bit macros
> 
> ..and replace them with flag enums.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied

[...]

> @@ -1713,13 +1723,16 @@ static int idefloppy_media_changed(struct gendisk *disk)
>  {
>  	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
>  	ide_drive_t *drive = floppy->drive;
> +	int ret;
>  
>  	/* do not scan partitions twice if this is a removable device */
>  	if (drive->attach) {
>  		drive->attach = 0;
>  		return 0;
>  	}
> -	return test_and_clear_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
> +	ret = floppy->flags & IDEFLOPPY_FLAG_MEDIA_CHANGED;
> +	floppy->flags &= ~IDEFLOPPY_FLAG_MEDIA_CHANGED;
> +	return ret;
>  }

this chunk (idefloppy_media_changed() return value is now 2 instead of 1
if IDEFLOPPY_FLAG_MEDIA_CHANGED flag is set) seems to have slipped through

[ I fixed it while merging the patch ]
