Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbYD1IOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbYD1IOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765668AbYD1INv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:13:51 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46708 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYD1INu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:13:50 -0400
Date: Mon, 28 Apr 2008 11:13:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig 'depend' vs. 'select'
Message-ID: <20080428081319.GC16379@cs181133002.pp.htv.fi>
References: <20080427.174536.62560212.davem@davemloft.net> <20080428063953.GA2088@cs181133002.pp.htv.fi> <20080427.234221.40346351.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080427.234221.40346351.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 11:42:21PM -0700, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Mon, 28 Apr 2008 09:39:54 +0300
> 
> > On Sun, Apr 27, 2008 at 05:45:36PM -0700, David Miller wrote:
> > > 
> > > I'm trying to stir up interest in solving a problem that seems to pop
> > > up frequently. :)
> > > 
> > > The short story is:
> > > 
> > > 1) If you say your driver "depend"s on a subsystem providing a set of
> > >    interfaces you need, this doesn't work properly if your driver is
> > >    marked built-in and that subsystem you need is modular for some
> > >    reason.
> > >...
> > 
> > This should work.
> 
> It doesn't.
> 
> > Can you give an example of the problem you are thinking of?
> 
> We've hit this specifically with the intel iwlwifi wireless drivers
> over the past week.

If you refer to Luca's patch, that's the select problem, not a problem 
with depends.

The only small pitfall with depends I'm aware of is if a bool driver 
depends on a tristate subsystem (same problem as what I describe below).

> > What about "select"?
> > 
> > That's exactly what it's doing.
> 
> Select doesn't enable downstream dependencies, it just blindly turns
> it on, non-modular.  That's not what we want at all.

The non-modular is only true for "bool selects tristate".

You are talking about things like:

config IWL4965_LEDS
        bool "Enable LEDS features in iwl4965 driver"
        select LEDS_CLASS

The problem here is that from a kconfig perspective IWL4965_LEDS could 
as well be an own driver you want for some reason non-modular.

The solution is to do the following instead:

config IWL4965
        tristate "Intel Wireless WiFi 4965AGN"
	select LEDS_CLASS if IWL4965_LEDS

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

