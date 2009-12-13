Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832AbZLMMxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbZLMMxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 07:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZLMMxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 07:53:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:50037 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750911AbZLMMxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 07:53:09 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+83Lt/BCC8jE7UYJF8xPykdKe/ZupJ1kHjHDtank
	XzOYxNNP4otrOJ
Message-ID: <4B24E3AB.9040609@gmx.de>
Date: Sun, 13 Dec 2009 13:52:59 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: JosephChan@via.com.tw, Scott Fang <ScottFang@viatech.com.cn>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/9] drivers/video: Correct code taking the size of a
 pointer
References: <Pine.LNX.4.64.0912131242240.24267@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912131242240.24267@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia, Andrew,

Julia Lawall schrieb:
> From: Julia Lawall <julia@diku.dk>
> 
> sizeof(viafb_gamma_table) is just the size of the pointer.  This is changed
> to the size used when calling kmalloc to initialize the pointer.

this is the second patch addressing this issue ending up in my mailbox. 
At least this one is technically correct so feel free to upstream it.
However I vote for removing this ioctl hell from viafb as most of them 
duplicate framebuffer functionality or have unknown (not clearly 
defined) functionality or at least solve a generic problem with a custom 
ioctl (which I consider bad). I had a patch ready to move this stuff to 
an extra file and print a warning that it is subject to be removed. I 
feel a bit uncomfortable about repairing broken stuff prior to removing it.
Any comments on this subject?


Thanks,

Florian Tobias Schandinat

> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/video/via/viafbdev.c        |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> index 56ec696..a0b47f1 100644
> --- a/drivers/video/via/viafbdev.c
> +++ b/drivers/video/via/viafbdev.c
> @@ -680,7 +680,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
>  		if (!viafb_gamma_table)
>  			return -ENOMEM;
>  		if (copy_from_user(viafb_gamma_table, argp,
> -				sizeof(viafb_gamma_table))) {
> +				256 * sizeof(u32))) {
>  			kfree(viafb_gamma_table);
>  			return -EFAULT;
>  		}
> @@ -694,7 +694,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
>  			return -ENOMEM;
>  		viafb_get_gamma_table(viafb_gamma_table);
>  		if (copy_to_user(argp, viafb_gamma_table,
> -			sizeof(viafb_gamma_table))) {
> +			256 * sizeof(u32))) {
>  			kfree(viafb_gamma_table);
>  			return -EFAULT;
>  		}
