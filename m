Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbXL2ItN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbXL2ItN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXL2ItD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:49:03 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43477 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbXL2ItA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:49:00 -0500
Date: Sat, 29 Dec 2007 10:48:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: errandir_news@mph.eclipse.co.uk, m.kozlowski@tuxland.pl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
Message-ID: <20071229084846.GA27360@does.not.exist>
References: <200712261329.08313.m.kozlowski@tuxland.pl> <20071226.190504.20990618.davem@davemloft.net> <20071228232255.GB9105@does.not.exist> <20071229.001411.210630819.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071229.001411.210630819.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 12:14:11AM -0800, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Sat, 29 Dec 2007 01:22:56 +0200
> 
> > At least the sunserial_console_match() one is an obvious Oops 
> > (EXPORT_SYMBOL of an __init function).
> > 
> > The comment in the description of
> > commit 58d784a5c754cd66ecd4791222162504d3c16c74 the warning was bogus    
> > is bullshit.
> > 
> > I'm not sure whether this might count as a 2.6.24-rc regression or 
> > whether 2.6.23 is simply differently but similarly broken (does anyone 
> > actually use the Sun console drivers modular?).
> 
> You can't do that, the FOO_CONSOLE config options depend upon
> FOO=y.

Looking closer, the problem aren't the FOO_CONSOLE options themselves, 
the problem is that with FOO_CONSOLE=n sunserial_console_match() still 
gets called.

> That's why I'm not worried about this issue and it's not critical at
> all.

If a module calls sunserial_console_match() that's an Oops.

I removed the EXPORT_SYMBOL(sunserial_console_match), and this is the 
result:
  MODPOST 136 modules
ERROR: "sunserial_console_match" [drivers/serial/sunzilog.ko] undefined!
ERROR: "sunserial_console_match" [drivers/serial/sunsu.ko] undefined!
ERROR: "sunserial_console_match" [drivers/serial/sunsab.ko] undefined!

-ENOHARDWARE, but looking at the code you could call me _very_ surprised 
if you manage to load a modular sunsab from 2.6.24-rc6 on a machine with 
the hardware without getting an Oops.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

