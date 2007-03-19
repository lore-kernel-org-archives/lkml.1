Return-Path: <linux-kernel-owner+w=401wt.eu-S933863AbXCSNIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbXCSNIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 09:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933870AbXCSNIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 09:08:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34969 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933863AbXCSNIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 09:08:37 -0400
Date: Mon, 19 Mar 2007 14:08:39 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Clement Guedez <klem.dev@gmail.com>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6.21 patch] fix sound/pci/ice1712/wtm.c:wtm_init()
Message-ID: <20070319130839.GT752@stusta.de>
References: <20070319092438.GL752@stusta.de> <s5htzwhjzo7.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5htzwhjzo7.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 11:27:52AM +0100, Takashi Iwai wrote:
> At Mon, 19 Mar 2007 10:24:38 +0100,
> Adrian Bunk wrote:
> > 
> > The Coverity checker spotted this bogus for() loop that produces an 
> > array overrun.
> 
> Hmm, I'm dense now before a caffee, but how can it overrun...?

Looking again, it seems I'm the one who should have drunken more tea 
before looking at this.  :-(

> > It seems what actually should be done is quite simple?
> 
> Yes... unless someone wants to add more register initializations
> there.
> 
> 
> Takashi
> 
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > 
> > ---
> > 
> >  sound/pci/ice1712/wtm.c |   14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
> > 
> > --- linux-2.6.21-rc3-mm2/sound/pci/ice1712/wtm.c.old	2007-03-19 01:29:23.000000000 +0100
> > +++ linux-2.6.21-rc3-mm2/sound/pci/ice1712/wtm.c	2007-03-19 01:33:06.000000000 +0100
> > @@ -489,23 +489,15 @@
> >  
> >  static int __devinit wtm_init(struct snd_ice1712 *ice)
> >  {
> > -	static unsigned short stac_inits_prodigy[] = {
> > -		STAC946X_RESET, 0,
> > -		(unsigned short)-1
> > -	};
> > -	unsigned short *p;
> > -		
> >  	/*WTM 192M*/
> >  	ice->num_total_dacs = 8;
> >  	ice->num_total_adcs = 4;
> >  	ice->force_rdma1 = 1;
> >  
> >  	/*initialize codec*/
> > -	p = stac_inits_prodigy;
> > -	for (; *p != (unsigned short)-1; p += 2) {
> > -		stac9460_put(ice, p[0], p[1]);
> > -		stac9460_2_put(ice, p[0], p[1]);
> > -	}
> > +	stac9460_put(ice, STAC946X_RESET, 0);
> > +	stac9460_2_put(ice, STAC946X_RESET, 0);
> > +
> >  	return 0;
> >  }
> >  
> > 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

