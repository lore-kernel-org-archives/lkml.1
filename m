Return-Path: <linux-kernel-owner+w=401wt.eu-S934290AbYD1NQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290AbYD1NQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765531AbYD1NQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:16:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51161 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762680AbYD1NQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:16:25 -0400
Date: Mon, 28 Apr 2008 16:15:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       reinette.chatre@intel.com, linville@tuxdriver.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] iwlwifi: Fix build error in v2.6.25-5561-g064922a
Message-ID: <20080428131552.GI16379@cs181133002.pp.htv.fi>
References: <20080428054700.GA16177@Pilar.virtua.com.br> <20080427.233507.261574307.davem@davemloft.net> <20080428073212.GA7260@Pilar.virtua.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080428073212.GA7260@Pilar.virtua.com.br>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 04:32:14AM -0300, Carlos R. Mafra wrote:
> On Sun 27.Apr'08 at 23:35:07 -0700, David Miller wrote:
> > From: "Carlos R. Mafra" <crmafra2@gmail.com>
> > Date: Mon, 28 Apr 2008 02:47:01 -0300
> > 
> > > I've just tried to compile v2.6.25-5561-g064922a and it failed with
> > > these messages:
> > 
> > Already fixed in net-2.6 by:
> > 
> > commit bd8fd21dfddf51299d782f598cb776b15b7d64cc
> > Author: Luca Tettamanti <kronos.it@gmail.com>
> > Date:   Sun Apr 27 15:34:55 2008 -0700
> > 
> >     wireless: Fix compile error with wifi & leds
> >     
> >     Fix build error caused by commit
> >     e82404ad612ebabc65d15c3d59b971cb35c3ff36 ("iwlwifi: Select
> >     LEDS_CLASS.") from David Miller:
> >     
> >     Since MAC80211_LEDS is selected by wireless drivers it must select its
> >     own dependencies otherwise a build error may occur (kbuild will select
> >     the symbol regardless of "depends" constraints).
> >     
> >     Signed-off-By: Luca Tettamanti <kronos.it@gmail.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> > index 520a518..a24b459 100644
> > --- a/net/mac80211/Kconfig
> > +++ b/net/mac80211/Kconfig
> > @@ -73,7 +73,9 @@ config MAC80211_MESH
> >  
> >  config MAC80211_LEDS
> >  	bool "Enable LED triggers"
> > -	depends on MAC80211 && LEDS_TRIGGERS
> > +	depends on MAC80211
> > +	select NEW_LEDS
> > +	select LEDS_TRIGGERS
> >  	---help---
> >  	  This option enables a few LED triggers for different
> >  	  packet receive/transmit events.
> 
> Hmm, I just tested this patch and it does not solve the problem. 
> 
> I could create a .config using 'make menuconfig' in which I had
> 
> CONFIG_MAC80211_LEDS=y
> CONFIG_RFKILL_LEDS=y
> CONFIG_IWLWIFI_LEDS=y
> CONFIG_IWL4965_LEDS=y
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=m
> 
> So I recompiled the kernel and got the same error message as before.
>...

Please send your .config

Thanks
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

