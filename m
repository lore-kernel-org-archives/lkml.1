Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbXJVMPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbXJVMPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXJVMPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:15:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42986 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008AbXJVMPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:15:47 -0400
Date: Mon, 22 Oct 2007 14:16:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix CONFIG_TUNER_TEA5761=m
Message-ID: <20071022121616.GN30533@stusta.de>
References: <20071022024755.GJ30533@stusta.de> <471C19F1.8090505@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <471C19F1.8090505@linuxtv.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 11:33:05PM -0400, Michael Krufky wrote:
> Adrian Bunk wrote:
> > This patch fixes CONFIG_TUNER_TEA5761=m broken by
> > commit ca805d57cf5ea7482ed3da28653f30621249ee45.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > ---
> >
> >  drivers/media/video/tuner-core.c |    6 ------
> >  1 file changed, 6 deletions(-)
> >
> > 26336c30e76c37bda368a24b8b12978388a18cf3 
> > diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> > index 9484308..1795b78 100644
> > --- a/drivers/media/video/tuner-core.c
> > +++ b/drivers/media/video/tuner-core.c
> > @@ -30,9 +30,7 @@
> >  
> >  /* standard i2c insmod options */
> >  static unsigned short normal_i2c[] = {
> > -#ifdef CONFIG_TUNER_TEA5761
> >  	0x10,
> > -#endif
> >   
> ^^^ I believe that we want to keep these #ifdef's above...  The removals
> below are fine.
>...

If it's required, then we need
  #if defined(CONFIG_TUNER_TEA5761) || (defined(CONFIG_TUNER_TEA5761_MODULE) && defined(MODULE))
here for getting the modular case working.

But at least at first glance it seems the code already tries to handle 
the cases when tea5761_{attach,autodetection}() fail?

> Regards,
> 
> Mike Krufky

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

