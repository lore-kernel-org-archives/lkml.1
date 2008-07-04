Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbYGDOWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbYGDOWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYGDOW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:22:29 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:49745 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYGDOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MgDUXE+zkPyjYKj6xbPqwmluSO2Zt4y6oz1juyGTdbPmRnDok5HhlzsSvCoxT98Zb+
         OpeFUtW2JGK2LiNq2doQO5jdKcG/XUnR/SVO8uLhzYPTaAeqPgyAh3P5Ohx7deDGm1Fg
         HYjuNvFK+HNC/sYopeWtZD8H7zUJQVvArmxBQ=
Date: Fri, 4 Jul 2008 18:22:08 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Brownell <david-b@pacbell.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix build error of driver/mfd/tc6393xb.c
Message-ID: <20080704142208.GB4576@doriath.ww600.siemens.net>
References: <s5hiqvlc2ut.wl%tiwai@suse.de> <20080704114755.GA21747@doriath.ww600.siemens.net> <s5hej69c0tt.wl%tiwai@suse.de> <20080704124256.GB21747@doriath.ww600.siemens.net> <s5hk5g1ls9l.wl%tiwai@suse.de> <20080704132234.GA4576@doriath.ww600.siemens.net> <s5hd4ltlpgl.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hd4ltlpgl.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 03:59:54PM +0200, Takashi Iwai wrote:
> At Fri, 4 Jul 2008 17:22:35 +0400,
> Dmitry Baryshkov wrote:
> > 
> > On Fri, Jul 04, 2008 at 02:59:18PM +0200, Takashi Iwai wrote:
> > > At Fri, 4 Jul 2008 16:42:56 +0400,
> > > Dmitry Baryshkov wrote:
> > > > 
> > > > On Fri, Jul 04, 2008 at 02:04:30PM +0200, Takashi Iwai wrote:
> > > > > At Fri, 4 Jul 2008 15:47:55 +0400,
> > > > > Dmitry Baryshkov wrote:
> > > > > > 
> > > > > > On Fri, Jul 04, 2008 at 01:20:42PM +0200, Takashi Iwai wrote:
> > > > > > > Fix the build of tc6393xb  due to missing definition of struct
> > > > > > > gpio_chip.
> > > > > > > 
> > > > > > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > > > > > 
> > > > > > > ---
> > > > > > > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > > > > > > index 9f93c29..2981da4 100644
> > > > > > > --- a/drivers/mfd/Kconfig
> > > > > > > +++ b/drivers/mfd/Kconfig
> > > > > > > @@ -44,7 +44,7 @@ config HTC_PASIC3
> > > > > > >  
> > > > > > >  config MFD_TC6393XB
> > > > > > >  	bool "Support Toshiba TC6393XB"
> > > > > > > -	depends on HAVE_GPIO_LIB
> > > > > > > +	depends on HAVE_GPIO_LIB && GENERIC_GPIO
> > > > > > >  	select MFD_CORE
> > > > > > >  	help
> > > > > > >  	  Support for Toshiba Mobile IO Controller TC6393XB
> > > > > > 
> > > > > > Which configuration does provide HAVE_GPIO_LIB but not GENERIC_GPIO?
> > > > > 
> > > > > The below is the config with which I got the error.
> > > > 
> > > > The proper fix probably is to make PPC_MPC5200_GPIO also select
> > > > GENERIC_GPIO. I don't think that building GPIO_LIB w/o GENERIC_GPIO
> > > > should be supported.
> > > 
> > > [Added David to Cc]
> > > 
> > > Then HAVE_GPIO_LIB should depend on GENERIC_GPIO.
> > > Or, linux/gpio.h should be fixed so that the code can be built
> > > properly without GENERIC_GPIO.
> > 
> > IIRC selected symbols don't propagate their depends.
> 
> Then HAVE_GPIO_LIB selects GENERIC_GPIO.  Right now, it's a missing
> dependency.

Please submit a patch where HAVE_GPIO_LIB selects GENERIC_GPIO.
Tested-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

> 
> > Also linux/gpio.h don't have anything in common with HAVE_GPIO_LIB.
> 
> That's another side of the problem.

-- 
With best wishes
Dmitry

