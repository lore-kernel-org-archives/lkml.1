Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXEPTTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXEPTTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbXEPTTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:19:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1498 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758990AbXEPTTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:19:46 -0400
Date: Wed, 16 May 2007 14:20:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Schmidt Michal <xschmi00@stud.feec.vutbr.cz>
Cc: Ondrej Zary <linux@rainbow-software.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [announce] Intel announces the PowerTOP utility for Linux
Message-ID: <20070516142048.GA4577@ucw.cz>
References: <fa.FTEkheuP0nHOUv0cCp0k8pBuoMU@ifi.uio.no> <4648FB1B.90208@shaw.ca> <200705151830.01891.linux@rainbow-software.org> <464AB84F.8060609@stud.feec.vutbr.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464AB84F.8060609@stud.feec.vutbr.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >On Tuesday 15 May 2007 02:13:15 Robert Hancock wrote:
> >>Looks like the radeon driver has the same problem as 
> >>the i915 driver
> >>mentioned on the known problems page - I get 60 
> >>wakeups/sec from it on
> >>my Compaq X1000 laptop (Radeon 9000 graphics) while in 
> >>X, which
> >>essentially prevents entry into C3.
> >
> >And Rage 128 too.
> >
> 
> I have a Radeon 7500 in my laptop. The attached hack to 
> disable the VBLANK interrupt works for me. I don't know 
> if it breaks 3D, I've only tried 2D.

Hmm, you should probably find where it is used, and only enable irq
when neccessary. Disabling it always will break something.

> diff --git a/drivers/char/drm/radeon_irq.c b/drivers/char/drm/radeon_irq.c
> index 3ff0baa..a990bb6 100644
> --- a/drivers/char/drm/radeon_irq.c
> +++ b/drivers/char/drm/radeon_irq.c
> @@ -227,9 +227,8 @@ void radeon_driver_irq_postinstall(drm_device_t * dev)
>  	atomic_set(&dev_priv->swi_emitted, 0);
>  	DRM_INIT_WAITQUEUE(&dev_priv->swi_queue);
>  
> -	/* Turn on SW and VBL ints */
> -	RADEON_WRITE(RADEON_GEN_INT_CNTL,
> -		     RADEON_CRTC_VBLANK_MASK | RADEON_SW_INT_ENABLE);
> +	/* Turn on the SW interrupt */
> +	RADEON_WRITE(RADEON_GEN_INT_CNTL, RADEON_SW_INT_ENABLE);
>  }
>  
>  void radeon_driver_irq_uninstall(drm_device_t * dev)


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
