Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbYA0JVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbYA0JVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYA0JUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:20:54 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:54962 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbYA0JUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:20:51 -0500
Date: Sun, 27 Jan 2008 10:21:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: (Updated) [Patch] Shut up warnings from files under drivers/
Message-ID: <20080127092100.GA18116@uranus.ravnborg.org>
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org> <20080126191717.GA25701@uranus.ravnborg.org> <20080127041521.GC2495@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127041521.GC2495@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi WANG.

Thanks for chasing these annoying warnings - it is
good to keep the warning level low so we keep
attention when new warnings happens!

> index d775eb6..eec1624 100644
> --- a/drivers/video/aty/atyfb_base.c
> +++ b/drivers/video/aty/atyfb_base.c
> @@ -244,7 +244,9 @@ static int atyfb_sync(struct fb_info *info);
>       */
>  
>  static int aty_init(struct fb_info *info);
> +#if defined(CONFIG_PM) && defined(CONFIG_PCI)
>  static void aty_resume_chip(struct fb_info *info);
> +#endif

It is preferable to have the forward declaration unconditional
to keep the #if/#endif count low.


>  #endif
> @@ -2709,6 +2711,7 @@ aty_init_exit:
>  	return -1;
>  }
>  
> +#if defined(CONFIG_PM) && defined(CONFIG_PCI)
>  static void aty_resume_chip(struct fb_info *info)
>  {
>  	struct atyfb_par *par = info->par;
> @@ -2721,6 +2724,7 @@ static void aty_resume_chip(struct fb_info *info)
>  	if (par->aux_start)
>  		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
>  }
> +#endif

Moving the aty_resume_chip() function down just above
atyfb_pci_resume() would put in in the same #if/#endif
block and you can kill the forward declaration too.
Did you try that out?

I could not spot any obvious reason why it should not work,
but I did not try it out.

	Sam
