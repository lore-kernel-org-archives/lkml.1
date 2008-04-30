Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbYD3T3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbYD3T3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762926AbYD3T3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:29:13 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49032 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762571AbYD3T3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:29:13 -0400
Date: Wed, 30 Apr 2008 22:28:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: mkrufky@linuxtv.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080430192829.GF29330@cs181133002.pp.htv.fi>
References: <20080428182501.5bb87058@gaivota> <481641CD.5030202@linuxtv.org> <20080430161712.50d1fc84@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430161712.50d1fc84@gaivota>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:17:12PM -0300, Mauro Carvalho Chehab wrote:
> On Mon, 28 Apr 2008 17:29:49 -0400
> mkrufky@linuxtv.org wrote:
> 
> > Mauro Carvalho Chehab wrote:
> > > On Tue, 29 Apr 2008 00:01:22 +0300
> > > Adrian Bunk <bunk@kernel.org> wrote:
>...
> > >> Mauro, where were we regarding this issue?
> > >>
> > >> What about:
> > >>
> > >> config TUNER_TDA8290
> > >>         tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
> > >>         depends on I2C
> > >> 	depends on DVB_CORE || DVB_CORE=n
> > >>         select DVB_TDA827X if DVB_CORE
> > >>         select DVB_TDA18271 if DVB_CORE
> > >>         default m if VIDEO_TUNER_CUSTOMIZE
> > >>         help
> > >>           Say Y here to include support for Philips TDA8290+8275(a)
> > tuner.
> > >>
> > >> Or is there some twist I'm missing?
> > >>     
> > >
> > >
> > > This will fix compilation, but some drivers will be broken, since tda8275
> > is
> > > needed even for some analog-only drivers.
> > >
> > > It would be better to do a "select DVB_CORE", although this is also ugly.
> > >
> > > I'm pinging Mkrufky. He is the one that touched a lot on those drivers.
> > Maybe
> > > he can come up with a better solution.
> > 
> > The fix for this issue will come "for free" after the tuner location 
> > reorganization to the media/common/ folder.
> 
> Yes, but I think we should try do do something for 2.6.25 and 2.6.24.

Toralf and Ingo only discovered it during randconfig testing.

Are there actually reports from users running into this problem?

> Maybe, we
> may just do:
> obj-y += /dvb
>...

Do DVB_TDA827X/DVB_TDA18271 need anything from DVB_CORE?

If yes you'd only transform one build error into another.

> Cheers,
> Mauro

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

