Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbXKAWV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbXKAWV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbXKAWVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:21:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296AbXKAWVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:21:47 -0400
Date: Thu, 1 Nov 2007 15:21:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Winischhofer <thomas@winischhofer.net>
Subject: Re: [2.6 patch] video/sis/: fix negative array index
Message-Id: <20071101152131.3f657cc4.akpm@linux-foundation.org>
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

oic, sisfb_validate_mode() could have returned a -ve error code.

Please use the changelog to fully explain your patches.
