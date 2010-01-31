Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246Ab0AaJ2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0AaJ2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 04:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087Ab0AaJ2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 04:28:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54640 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab0AaJ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 04:28:39 -0500
Date: Sun, 31 Jan 2010 10:28:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] staging/dream: add missing include files/fix
 compilation
Message-ID: <20100131092829.GJ2238@elf.ucw.cz>
References: <20091225205917.GA25761@elf.ucw.cz>
 <20100115002419.GA25643@kroah.com>
 <20100119054516.GB22153@elf.ucw.cz>
 <1263914079.1951.43.camel@m0nster>
 <20100131084421.GG2238@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131084421.GG2238@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > This adds missing include files, so it should now compile. ifdef
> > > > > guards were added to Kconfig, so it should not cause problems on
> > > > > non-arch-msm machines.
> > > > > 
> > > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > > 
> > > > Odd, this doesn't apply to the linux-next tree, some of the files are
> > > > already there.
> > > 
> > > Strange, it seems it is almost all already in. Well, good :-).
> > > 
> > > But there's small problem. linux-next now contains dwalker's tree, and
> > > I could not get it to compile, even with staging disabled. I'll need
> > > to look into that.
> > 
> > I worked on it a little, but I won't have time to really start cleaning
> > up that tree till next week, or this weekend.
> > 
> > I pushed a new tree for next that should compile for dream with the
> > attached config. I also included the patch that I added to get it to
> > compile (you'll need the machine types too which I didn't include).
> 
> Thanks! I checked out linux-next version, and it seems to include
> 
> > commit cdf6c137865357112aa31666b65b938ab29fa736
> >     msm: compile fixes for dream.
> 
> this patch. It still fails with:
> 
> arch/arm/mach-msm/rpc_hsusb.c: In function 'msm_chg_rpc_connect':
> arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
> function 'machine_is_msm7201a_surf'
> arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
> function 'machine_is_msm7x27_surf'
> arch/arm/mach-msm/rpc_hsusb.c:157: error: implicit declaration of
> function 'machine_is_qsd8x50_surf'
> make[1]: *** [arch/arm/mach-msm/rpc_hsusb.o] Error 1
> make: *** [arch/arm/mach-msm] Error 2
> 
> (and similar error further down). This fixes it, but you probably want
> to add machine_is_* to your git. (Aha, is that what you meant by
> "machine types"?
> 
> With this patch it compiles.

Ok, it compiles, but I do not see it booting. You config has:

CONFIG_MSM_DEBUG_UART=3
# CONFIG_MSM_DEBUG_UART_NONE is not set
# CONFIG_MSM_DEBUG_UART1 is not set
# CONFIG_MSM_DEBUG_UART2 is not set
CONFIG_MSM_DEBUG_UART3=y
...
CONFIG_DEBUG_LL=y
CONFIG_EARLY_PRINTK=y

set, so I'd expect it to say something on the serial line... (right?
Or do I still need to patch printk.c to get that?). And I see nothing
:-(.

I'm using

./fastboot -c "console=ttyMSM2 root=/dev/mmcblk0p1 rootdelay=5 fbcon=rotate:1" boot /data/l/linux-dwalker/arch/arm/boot/zImage

...with different kernel, it works (as in "I get most of the boot on
serial line; it will not actually mount root").
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
