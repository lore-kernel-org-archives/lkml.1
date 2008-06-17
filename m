Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYFQJmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYFQJmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYFQJm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:42:29 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:50848 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYFQJm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=jWMYZDvjq907tSUdAU7i0Pv93qNq1++HscLuOB8OdzEmgLY2zNlhOEuI65OIwjkPql
         83Z/5OyGdQbyweipvUMSupVwrKGmzayzfq5KI7OA99eT+3A5VC0BUcSaHhZiE5i+8dSP
         /wRTn1hhUD3hJOWaHRy549Du0ZVcbUjYkMXvY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cdrom: don't check CDC_PLAY_AUDIO in cdrom_count_tracks()
Date: Tue, 17 Jun 2008 11:43:53 +0200
User-Agent: KMail/1.9.9
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Borislav Petkov <petkovbb@googlemail.com>
References: <48574994.9090503@kernel.org>
In-Reply-To: <48574994.9090503@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806171143.53883.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2008, Tejun Heo wrote:
> According to MMC-3 (or any later versions) READ TOCs are mandatory
> commands and have nothing to do with CDC_PLAY_AUDIO.  I have no idea
> why the check was put there in the first place but it now only breaks
> automatic actions on certain drives.
> 
> Note that this test was only effective when ide-cdrom was being used

cc:ing Borislav

> as sr didn't mask CDC_PLAY_AUDIO according to the capabilities.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
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
