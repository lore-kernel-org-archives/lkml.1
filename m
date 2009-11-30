Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZK3KeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZK3KeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZK3KeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:34:12 -0500
Received: from mga12.intel.com ([143.182.124.36]:39842 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbZK3KeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:34:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,312,1257148800"; 
   d="scan'208";a="216907680"
Date: Mon, 30 Nov 2009 11:35:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Andrey A. Porodko" <andrey.porodko@gmail.com>
Cc: "A. Porodko" <panda@chelcom.ru>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Balaji Rao <balajirrao@openmoko.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Patch for MSP430 support on Neuros OSD2 board
Message-ID: <20091130103556.GB3696@sortiz.org>
References: <4B0E7E07.4080404@chelcom.ru>
 <4B0E7FE2.7060204@gmail.com>
 <20091129234605.GA4292@sortiz.org>
 <4B13682D.4030202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B13682D.4030202@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 11:37:33AM +0500, Andrey A. Porodko wrote:
> Hi Samuel,
> 
> The reason I used "ifdef" instead of refactoring code is that I don't
> have dm355 board to check nor I'm familiar with this hardware and I was
> afraid to screw up what's already done for dm355.
> Initially I created a completely separate driver (although based on
> dm355) for Neuros, but kernel people told me to combine code with existent.
Yes, keeping one driver for those 2 boards is the only way.


> - Is it possible to find someone with dm355 hardware to check if didn't
> screw up it?
Please cc all relevant people to your refactored code (Vipin Bhandari, Kevin
Hilman, David Brownell, see git log drivers/mfd/dm355evm_msp.c) and ask them
for review/test on their HW.
The code as it is really needs some refactoring for being more generic and not
so board specific, so it's not like you'd be doing intrusive useless cleanups.


> - I don't quite understand how to evaluate impact on config_* files, do
> you mean I need to check standard kernel configuration files bundled
> with kernel and make necessary adjustments there?
That's correct, that and the Kconfig dependencies. For example INPUT_DM355EVM
and RTC_DRV_DM355EVM depend on MFD_DM355EVM_MSP at the moment.
Also, if you're changing the driver's exported API, you should also fix all
its current users. In this case, that would mean fixing rtc-dm355evm.c and
dm355evm_keys.c.

Cheers,
Samuel.


> Thank you for a quick reply.
> > Hi Andrey,
> >
> > On Thu, Nov 26, 2009 at 06:17:22PM +0500, Andrey A. Porodko wrote:
> >   
> >> Hello,
> >>
> >> Here is a patch for MSP430 chip support for Neuros OSD2 (Davinci DM6446
> >> based) board.
> >> Patch made against 2.6.32-rc6 kernel.
> >>     
> > Thanks for the patch, here are some comments about it:
> >
> > - Renaming a file may be acceptable, but you have to delete the prvious one.
> > Also, as you're changing the Kconfig symbol, you should evaluate the impact on
> > the current users (in config_* files for example).
> >
> > - Then about the code itself: ifdefs as the one you're doing here is not
> > exactly nice, and leads to a lot of code replication and maintenance burden.
> > It seems that you're trying to have a common MSP430 driver support for 2
> > different boards, which is a good idea. The main problem, if I understand it
> > correctly, is those 2 boards are running the same MSP430 HW running different
> > FWs.
> > What I'd really like to see here would be to have a generic MSP430 support.
> > You'd need to define a FW definition structure (it seems it would mostly be
> > GPIO settings), then have different static definitions for every known firmware
> > revision, and finally have a common probe routine that would go through this
> > firmware structure and sets thing accordingly. You would pass the firmware
> > revision you're using from your board definitions, unless there are some
> > registers on that chip that would let us know about this firmware.
> >
> > Cheers,
> > Samuel.
> >
> >
> >   
> 
> 
> -- 
> Best regards
> Andrey A. Porodko
>  
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
