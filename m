Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbYFQIHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbYFQIHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 04:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYFQIGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 04:06:51 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25085 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYFQIGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 04:06:49 -0400
Date: Tue, 17 Jun 2008 10:06:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] cdrom: don't check CDC_PLAY_AUDIO in cdrom_count_tracks()
Message-ID: <20080617080647.GD20851@kernel.dk>
References: <48574994.9090503@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48574994.9090503@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17 2008, Tejun Heo wrote:
> According to MMC-3 (or any later versions) READ TOCs are mandatory
> commands and have nothing to do with CDC_PLAY_AUDIO.  I have no idea
> why the check was put there in the first place but it now only breaks
> automatic actions on certain drives.
> 
> Note that this test was only effective when ide-cdrom was being used
> as sr didn't mask CDC_PLAY_AUDIO according to the capabilities.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Jens Axboe <jens.axboe@oracle.com>

> ---
>  drivers/cdrom/cdrom.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 69f26eb..11574c5 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -1491,10 +1491,6 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
>  	tracks->xa=0;
>  	tracks->error=0;
>  	cdinfo(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n"); 
> -        if (!CDROM_CAN(CDC_PLAY_AUDIO)) { 
> -                tracks->error=CDS_NO_INFO;
> -                return;
> -        }        
>  	/* Grab the TOC header so we can see how many tracks there are */
>  	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header))) {
>  		if (ret == -ENOMEDIUM)

-- 
Jens Axboe

