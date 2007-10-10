Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXJJATZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXJJATZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXJJATN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:19:13 -0400
Received: from as4.cineca.com ([130.186.84.213]:34715 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbXJJATM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:19:12 -0400
From: Luca Risolia <luca.risolia@studio.unibo.it>
Reply-To: luca.risolia@studio.unibo.it
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 2/3] V4L: zc0301, remove bad usage of ERESTARTSYS
Date: Wed, 10 Oct 2007 02:18:50 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, mchehab@infradead.org,
       video4linux-list@redhat.com
References: <11237258561195029635@pripojeni.net>
In-Reply-To: <11237258561195029635@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710100218.50987.luca.risolia@studio.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

acked-by: Luca Risolia <luca.risolia@studio.unibo.it>


On Monday 08 October 2007 14:40:53 Jiri Slaby wrote:
> zc0301, remove bad usage of ERESTARTSYS
>
> down_read_trylock can't be interrupted and so ERESTARTSYS would reach
> userspace, which is not permitted. Change it to EAGAIN
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>
> ---
> commit 235cf594bc65128250632a642f3e9d7e4df4975e
> tree 0557746416827daeb4d829610fec2f0c9111a675
> parent db38c559d37219c32b179ae005ca7e489336ec94
> author Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:15:47 +0200
> committer Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:15:47 +0200
>
>  drivers/media/video/zc0301/zc0301_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/zc0301/zc0301_core.c
> b/drivers/media/video/zc0301/zc0301_core.c index 35138c5..08a93c3 100644
> --- a/drivers/media/video/zc0301/zc0301_core.c
> +++ b/drivers/media/video/zc0301/zc0301_core.c
> @@ -655,7 +655,7 @@ static int zc0301_open(struct inode* inode, struct
> file* filp) int err = 0;
>
>  	if (!down_read_trylock(&zc0301_dev_lock))
> -		return -ERESTARTSYS;
> +		return -EAGAIN;
>
>  	cam = video_get_drvdata(video_devdata(filp));


