Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbXJJASj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbXJJASj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbXJJASb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:18:31 -0400
Received: from as4.cineca.com ([130.186.84.213]:34633 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbXJJASa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:18:30 -0400
From: Luca Risolia <luca.risolia@studio.unibo.it>
Reply-To: luca.risolia@studio.unibo.it
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/3] V4L: w9968cf, remove bad usage of ERESTARTSYS
Date: Wed, 10 Oct 2007 02:18:05 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mchehab@infradead.org, video4linux-list@redhat.com
References: <21044149499772302@pripojeni.net>
In-Reply-To: <21044149499772302@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710100218.05997.luca.risolia@studio.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

acked-by: Luca Risolia <luca.risolia@studio.unibo.it>

On Monday 08 October 2007 14:40:13 Jiri Slaby wrote:
> w9968cf, remove bad usage of ERESTARTSYS
>
> down_read_trylock can't be interrupted and so ERESTARTSYS would reach
> userspace, which is not permitted. Change it to EAGAIN
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>
> ---
> commit db38c559d37219c32b179ae005ca7e489336ec94
> tree f2d606165e6ef2daa6e1a2860f87521222eeecd2
> parent 6e42c2183befe136d85e6a8708ee4eabc543774b
> author Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:14:03 +0200
> committer Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:14:03 +0200
>
>  drivers/media/video/w9968cf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/w9968cf.c b/drivers/media/video/w9968cf.c
> index 77599f2..5a1b5f5 100644
> --- a/drivers/media/video/w9968cf.c
> +++ b/drivers/media/video/w9968cf.c
> @@ -2679,7 +2679,7 @@ static int w9968cf_open(struct inode* inode, struct
> file* filp)
>
>  	/* This the only safe way to prevent race conditions with disconnect */
>  	if (!down_read_trylock(&w9968cf_disconnect))
> -		return -ERESTARTSYS;
> +		return -EAGAIN;
>
>  	cam = (struct w9968cf_device*)video_get_drvdata(video_devdata(filp));


