Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZFYRuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZFYRuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZFYRt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:49:56 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:38849 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbZFYRtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:49:55 -0400
Date: Thu, 25 Jun 2009 20:49:15 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: fix build bug in i2c-designware.c
Message-ID: <20090625174915.GV6027@tarshish>
References: <alpine.LFD.2.01.0906241656030.3605@localhost.localdomain> <20090625063221.GA17798@elte.hu> <20090625174000.GV14476@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625174000.GV14476@trinity.fluff.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, Jun 25, 2009 at 06:40:00PM +0100, Ben Dooks wrote:
> On Thu, Jun 25, 2009 at 08:32:21AM +0200, Ingo Molnar wrote:
> > >From 8bf467c9f4591f77e1d69bd78fb6cc4f1ff387f8 Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Thu, 25 Jun 2009 08:27:14 +0200
> > Subject: [PATCH] i2c: fix build bug in i2c-designware.c
> > 
> > This build error triggers on x86:
> > 
> >  drivers/built-in.o: In function `i2c_dw_init':
> >  i2c-designware.c:(.text+0x4e37ca): undefined reference to `clk_get_rate'
> >  drivers/built-in.o: In function `dw_i2c_probe':
> >  i2c-designware.c:(.devinit.text+0x51f5e): undefined reference to `clk_get'
> >  i2c-designware.c:(.devinit.text+0x51f76): undefined reference to `clk_enable'
> >  i2c-designware.c:(.devinit.text+0x520ff): undefined reference to `clk_disable'
> >  i2c-designware.c:(.devinit.text+0x52108): undefined reference to `clk_put'
> > 
> > Because this new driver uses the clk_*() facilities which is an
> > ARM-only thing currently.
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  drivers/i2c/busses/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> > index d56351a..0760f25 100644
> > --- a/drivers/i2c/busses/Kconfig
> > +++ b/drivers/i2c/busses/Kconfig
> > @@ -334,6 +334,7 @@ config I2C_DAVINCI
> >  
> >  config I2C_DESIGNWARE
> >  	tristate "Synopsys DesignWare"
> > +	depends on HAVE_CLK
> >  	help
> >  	  If you say yes to this option, support will be included for the
> >  	  Synopsys DesignWare I2C adapter. Only master mode is supported.
> 
> thanks, missed there not being a 'depends on' line...
> 
> Baurch - can you submit a patch to declare which ARM architectures that
> this runs on, or whether Ingo's dependency on HAVE_CLK is the fix to merge?

Ingo's fix should be enough.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
