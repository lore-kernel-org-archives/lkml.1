Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYGDMnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYGDMnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYGDMnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:43:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:53594 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYGDMnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RM5vO6s9RVUnHTeG+fn/Eyp2AdLaqowR3rY5ju83If6L1418DMm3hVL6pJEC1YUOjC
         7hYYbDuBpZYS4TSoB2nKA8h2DQh+3OPTYi1mUY0fPztW5pj+eGbCVACme80jBaFlSdOT
         mmHQb21xB0p8pEPArkXIRwpSSr1Rt7peHVrc0=
Date: Fri, 4 Jul 2008 16:42:56 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix build error of driver/mfd/tc6393xb.c
Message-ID: <20080704124256.GB21747@doriath.ww600.siemens.net>
References: <s5hiqvlc2ut.wl%tiwai@suse.de> <20080704114755.GA21747@doriath.ww600.siemens.net> <s5hej69c0tt.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hej69c0tt.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 02:04:30PM +0200, Takashi Iwai wrote:
> At Fri, 4 Jul 2008 15:47:55 +0400,
> Dmitry Baryshkov wrote:
> > 
> > On Fri, Jul 04, 2008 at 01:20:42PM +0200, Takashi Iwai wrote:
> > > Fix the build of tc6393xb  due to missing definition of struct
> > > gpio_chip.
> > > 
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > 
> > > ---
> > > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > > index 9f93c29..2981da4 100644
> > > --- a/drivers/mfd/Kconfig
> > > +++ b/drivers/mfd/Kconfig
> > > @@ -44,7 +44,7 @@ config HTC_PASIC3
> > >  
> > >  config MFD_TC6393XB
> > >  	bool "Support Toshiba TC6393XB"
> > > -	depends on HAVE_GPIO_LIB
> > > +	depends on HAVE_GPIO_LIB && GENERIC_GPIO
> > >  	select MFD_CORE
> > >  	help
> > >  	  Support for Toshiba Mobile IO Controller TC6393XB
> > 
> > Which configuration does provide HAVE_GPIO_LIB but not GENERIC_GPIO?
> 
> The below is the config with which I got the error.

The proper fix probably is to make PPC_MPC5200_GPIO also select
GENERIC_GPIO. I don't think that building GPIO_LIB w/o GENERIC_GPIO
should be supported.

-- 
With best wishes
Dmitry

