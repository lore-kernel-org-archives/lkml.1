Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbXJVTyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbXJVTyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbXJVTx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:53:59 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59473 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752850AbXJVTx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:53:59 -0400
Date: Mon, 22 Oct 2007 21:54:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <patrick.boettcher@desy.de>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] DVB: BANDWIDTH_TO_KHZ strangeness
Message-ID: <20071022195424.GP30533@stusta.de>
References: <20071014175055.GJ4211@stusta.de> <Pine.LNX.4.64.0710221657450.21323@pub1.ifh.de> <1193077776.15350.22.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1193077776.15350.22.camel@gaivota>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 04:29:36PM -0200, Mauro Carvalho Chehab wrote:
> 
> > I know that in the future the linux-dvb-API will also support other 
> > bandwidths so I'm begging for mercy for those 3 things here to not get too 
> > much out-of-sync with our internal code.
> 
> I don't see much problem on keeping this for a while. 
> 
> However, if not causing to much troubles for you to manage, I would to
> this, instead:
> #if 0
> 	/* Currently, DVB API allows only bandwidths starting from 5 GHz */
>         factor = BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth);
>         if (factor >= 5000)
>                 factor = 1;
>         else
>                 factor = 6;
> #else
> 	factor = 6;
> #endif
> 
> With the above code, gentree.pl scripts will automatically remove the
> dead code from the Kernel, while keeping it defined at the development
> environment.
>...

Good compilers like gcc generate the same code for both cases [1], so 
there's no reason for changing anything.

The reason for my email was that it looked strange, but since it's 
intended I'd say it's OK.

> Cheers,
> Mauro

cu
Adrian

[1] except that your #else case contains the wrong value  ;-)

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

