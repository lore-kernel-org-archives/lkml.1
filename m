Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYAFWxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYAFWxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYAFWx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:53:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:26500 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbYAFWx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:53:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nuOqlTRCWMPJiCaKDS6N95HDOKQdeHNgcOTlZSRflY8Pt0uUVXv+fDCwI7hXtCzgXSwDOKKm1SeFUlRjUFEKWFTDqxTmTP8mCBmZ36U/M+oRiN76hPs5wDQRviofq88jsR93NqQOvj4wVOZU98b/t83/LVxRSi+JDHKc6NF6i2Y=
Message-ID: <68cac7520801061453w6906e510o5d53449e0b28f400@mail.gmail.com>
Date: Sun, 6 Jan 2008 20:53:27 -0200
From: "Douglas Landgraf" <dougsland@gmail.com>
To: "Gregor Jasny" <jasny@vidsoft.de>
Subject: Re: [v4l-dvb-maintainer] [PATCH] Re: Regression: VIDIOCGMBUF ioctl hangs on bttv driver (2.6.24-rc6)
Cc: linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080106141548.GB18690@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080105223338.GA18690@vidsoft.de>
	 <20080106141548.GB18690@vidsoft.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

    Gregor, we have converted bttv driver to use vidioc_ioctl2 some days ago.
Could you check and create your patch against v4l development tree?
Bttv driver does not have anymore bttv_do_ioctl().

Cheers,
Douglas

On Jan 6, 2008 12:15 PM, Gregor Jasny <jasny@vidsoft.de> wrote:
> From: Gregor Jasny <gjasny@web.de>
>
> Fix bttv VIDIOCGMBUF locking like done in commit
> 820eacd84cff23b76693f4be1e28feb672f4488f.
>
> Signed-off-by: Gregor Jasny <gjasny@web.de>
> ---
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index c02d92d..581a3c9 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -3063,11 +3063,10 @@ static int bttv_do_ioctl(struct inode *inode, struct file *file,
>                 struct video_mbuf *mbuf = arg;
>                 unsigned int i;
>
> -               mutex_lock(&fh->cap.lock);
>                 retval = videobuf_mmap_setup(&fh->cap,gbuffers,gbufsize,
>                                              V4L2_MEMORY_MMAP);
>                 if (retval < 0)
> -                       goto fh_unlock_and_return;
> +                       return retval;
>
>                 gbuffers = retval;
>                 memset(mbuf,0,sizeof(*mbuf));
> @@ -3075,7 +3074,6 @@ static int bttv_do_ioctl(struct inode *inode, struct file *file,
>                 mbuf->size   = gbuffers * gbufsize;
>                 for (i = 0; i < gbuffers; i++)
>                         mbuf->offsets[i] = i * gbufsize;
> -               mutex_unlock(&fh->cap.lock);
>                 return 0;
>         }
>         case VIDIOCMCAPTURE:
>
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
>
