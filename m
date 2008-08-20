Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbYHTH7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbYHTH7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 03:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYHTH7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 03:59:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55384 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYHTH7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 03:59:14 -0400
Date: Wed, 20 Aug 2008 08:57:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, sfr@canb.auug.org.au,
       sam@ravnborg.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, sameo@openedhand.com
Subject: Re: linux-next: Tree for August 19 (mfd/ucb)
Message-ID: <20080820075734.GA29002@flint.arm.linux.org.uk>
References: <20080819185454.d9c74915.sfr@canb.auug.org.au> <20080819170517.04d91de8.randy.dunlap@oracle.com> <20080819171658.4cdb8cd9.akpm@linux-foundation.org> <s5h7iacnn15.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h7iacnn15.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 09:49:58AM +0200, Takashi Iwai wrote:
> At Tue, 19 Aug 2008 17:16:58 -0700,
> Andrew Morton wrote:
> > 
> > On Tue, 19 Aug 2008 17:05:17 -0700
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > drivers/mfd/ucb1400 is a sound (AC97) driver, so it should depend
> > > on AC97_BUS, like in the patch below.  However, with that patch in
> > > place, oldconfig goes belly up on me:
> > > 
> > > 
> > > linux-next-20080819> make ARCH=x86_64  O=X64  V=1 oldconfig
> > > make -C /local/linsrc/linux-next-20080819/X64 \
> > > 	KBUILD_SRC=/local/linsrc/linux-next-20080819 \
> > > 	KBUILD_EXTMOD="" -f /local/linsrc/linux-next-20080819/Makefile \
> > > 	oldconfig
> > > make -f /local/linsrc/linux-next-20080819/scripts/Makefile.build obj=scripts/basic
> > > /bin/sh /local/linsrc/linux-next-20080819/scripts/mkmakefile \
> > > 	    /local/linsrc/linux-next-20080819 /local/linsrc/linux-next-20080819/X64 2 6
> > >   GEN     /local/linsrc/linux-next-20080819/X64/Makefile
> > > mkdir -p include/linux include/config
> > > make -f /local/linsrc/linux-next-20080819/scripts/Makefile.build obj=scripts/kconfig oldconfig
> > > scripts/kconfig/conf -o arch/x86/Kconfig
> > > make[2]: *** [oldconfig] Segmentation fault (core dumped)
> > > make[1]: *** [oldconfig] Error 2
> > > make: *** [sub-make] Error 2
> > > 
> > > 
> > > 
> > > ---
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > mfd/ucb1400 sound driver uses/depends on AC97_BUS:
> > > 
> > > ERROR: "ac97_bus_type" [drivers/mfd/ucb1400_core.ko] undefined!
> > > 
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > cc: Samuel Ortiz <sameo@openedhand.com>
> > > 
> > > ---
> > >  drivers/mfd/Kconfig |    1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > --- linux-next-20080819.orig/drivers/mfd/Kconfig
> > > +++ linux-next-20080819/drivers/mfd/Kconfig
> > > @@ -52,6 +52,7 @@ config HTC_PASIC3
> > >  
> > >  config UCB1400_CORE
> > >  	tristate "Philips UCB1400 Core driver"
> > > +	depends on AC97_BUS
> > >  	help
> > >  	  This enables support for the Philips UCB1400 core functions.
> > >  	  The UCB1400 is an AC97 audio codec.
> > 
> > And this:
> > 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > ia64 allmodconfig:
> > 
> > In file included from include/linux/ucb1400.h:27,
> >                  from drivers/mfd/ucb1400_core.c:24:
> > include/asm-generic/gpio.h: In function `gpio_get_value_cansleep':
> > include/asm-generic/gpio.h:147: error: implicit declaration of function `gpio_get_value'
> > include/asm-generic/gpio.h: In function `gpio_set_value_cansleep':
> > include/asm-generic/gpio.h:153: error: implicit declaration of function `gpio_set_value'
> > drivers/mfd/ucb1400_core.c: At top level:
> 
> This one is because the superfluous inclusion of <asm-generic/gpio.h>.
> Should have been fixed in the latest Russell's tree.

Haven't merged the two fixes discussed just yet - I only got a reply
from Stephen on his this morning.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
