Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZKSHnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZKSHnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 02:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZKSHnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 02:43:40 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47851 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbZKSHnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 02:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Ehh/g6RVi9B/2r+xDLAulahF41FiLokSj71VRdQWeC4N+386IuatOXhYOw0fltUrN6
         VUVd7xHKCbeRg6UDY+cPEDPN3FTXfBoljx/7fScvPAs6tRZ8/KbItYEOzrOveCs39lrl
         suWH38glEy3KxyDOD8xiiYHI4woaeFtZZoA30=
Date: Thu, 19 Nov 2009 08:43:43 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: mike@mspradling.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] video: Removed Dead Code
Message-Id: <20091119084343.0a34860f.kristoffer.ericson@gmail.com>
In-Reply-To: <20091119024731.GA29035@MSServer>
References: <20091119024731.GA29035@MSServer>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 21:47:31 -0500
Michael Spradling <mike@mspradling.com> wrote:

> Removed Dead code within video driver.
> 
> Signed-off-by: Michael Spradling <mike@mspradling.com>

This code is needed for the extension of the bitblt code Im working on
so it shouldnt be removed.

> ---
>  drivers/video/s1d13xxxfb.c |   50 --------------------------------------------
>  1 files changed, 0 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/s1d13xxxfb.c
> index 0deb0a8..d3059cd 100644
> --- a/drivers/video/s1d13xxxfb.c
> +++ b/drivers/video/s1d13xxxfb.c
> @@ -409,28 +409,6 @@ s1d13xxxfb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
>   ************************************************************/
>  
>  /**
> - *	bltbit_wait_bitset - waits for change in register value
> - *	@info : framebuffer structure
> - *	@bit  : value expected in register
> - *	@timeout : ...
> - *
> - *	waits until value changes INTO bit
> - */
> -static u8
> -bltbit_wait_bitset(struct fb_info *info, u8 bit, int timeout)
> -{
> -	while (!(s1d13xxxfb_readreg(info->par, S1DREG_BBLT_CTL0) & bit)) {
> -		udelay(10);
> -		if (!--timeout) {
> -			dbg_blit("wait_bitset timeout\n");
> -			break;
> -		}
> -	}
> -
> -	return timeout;
> -}
> -
> -/**
>   *	bltbit_wait_bitclear - waits for change in register value
>   *	@info : frambuffer structure
>   *	@bit  : value currently in register
> @@ -453,34 +431,6 @@ bltbit_wait_bitclear(struct fb_info *info, u8 bit, int timeout)
>  	return timeout;
>  }
>  
> -/**
> - *	bltbit_fifo_status - checks the current status of the fifo
> - *	@info : framebuffer structure
> - *
> - *	returns number of free words in buffer
> - */
> -static u8
> -bltbit_fifo_status(struct fb_info *info)
> -{
> -	u8 status;
> -
> -	status = s1d13xxxfb_readreg(info->par, S1DREG_BBLT_CTL0);
> -
> -	/* its empty so room for 16 words */
> -	if (status & BBLT_FIFO_EMPTY)
> -		return 16;
> -
> -	/* its full so we dont want to add */
> -	if (status & BBLT_FIFO_FULL)
> -		return 0;
> -
> -	/* its atleast half full but we can add one atleast */
> -	if (status & BBLT_FIFO_NOT_FULL)
> -		return 1;
> -
> -	return 0;
> -}
> -
>  /*
>   *	s1d13xxxfb_bitblt_copyarea - accelerated copyarea function
>   *	@info : framebuffer structure
> -- 
> 1.6.5.2
> 
> 


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
