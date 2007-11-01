Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbXKAWRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbXKAWRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbXKAWR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:17:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbXKAWR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:17:27 -0400
Date: Thu, 1 Nov 2007 15:17:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Winischhofer <thomas@winischhofer.net>
Subject: Re: [2.6 patch] video/sis/: fix negative array index
Message-Id: <20071101151711.3af1f6dc.akpm@linux-foundation.org>
In-Reply-To: <20071027141946.GX30533@stusta.de>
References: <20071027141946.GX30533@stusta.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007 16:19:46 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the possible usage of a negative value as an array 
> index spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/video/sis/sis_main.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 9f63bf8c543710521e885b09d88271d1a308b158 
> diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
> index bc7d236..37bd24b 100644
> --- a/drivers/video/sis/sis_main.c
> +++ b/drivers/video/sis/sis_main.c
> @@ -1245,24 +1245,25 @@ sisfb_do_set_var(struct fb_var_screeninfo *var, int isactive, struct fb_info *in
>  		ivideo->sisfb_mode_idx++;
>  	}
>  
>  	if(found_mode) {
>  		ivideo->sisfb_mode_idx = sisfb_validate_mode(ivideo,
>  				ivideo->sisfb_mode_idx, ivideo->currentvbflags);
> -		ivideo->mode_no = sisbios_mode[ivideo->sisfb_mode_idx].mode_no[ivideo->mni];
>  	} else {
>  		ivideo->sisfb_mode_idx = -1;
>  	}
>  
>         	if(ivideo->sisfb_mode_idx < 0) {
>  		printk(KERN_ERR "sisfb: Mode %dx%dx%d not supported\n", var->xres,
>  		       var->yres, var->bits_per_pixel);
>  		ivideo->sisfb_mode_idx = old_mode;
>  		return -EINVAL;
>  	}
>  
> +	ivideo->mode_no = sisbios_mode[ivideo->sisfb_mode_idx].mode_no[ivideo->mni];
> +
>  	if(sisfb_search_refresh_rate(ivideo, ivideo->refresh_rate, ivideo->sisfb_mode_idx) == 0) {
>  		ivideo->rate_idx = sisbios_mode[ivideo->sisfb_mode_idx].rate_idx;
>  		ivideo->refresh_rate = 60;
>  	}

Well I spent a little time trying to work out what the actual bug is and
gave up.  There doesn't appear to be any error in sisfb_do_set_var().

Better changelogs, please.
