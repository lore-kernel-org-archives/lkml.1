Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbYJKO6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbYJKO6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYJKO6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:58:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60619 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbYJKO6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:58:41 -0400
Date: Sat, 11 Oct 2008 16:58:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [bug] latest -git boot hang
Message-ID: <20081011145823.GA14062@elte.hu>
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org> <20081011071939.GA26465@elte.hu> <20081011140826.GS19428@kernel.dk> <20081011143355.GA6274@elte.hu> <20081011143947.GT19428@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011143947.GT19428@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Sat, Oct 11 2008, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Sat, Oct 11 2008, Ingo Molnar wrote:
> > > > 
> > > > * Tejun Heo <tj@kernel.org> wrote:
> > > > 
> > > > > > It does sound like perhaps the option should be hidden more, if it's 
> > > > > > really only reasonably enabled for some very specialized distro 
> > > > > > debuggers, not normal kernel people.
> > > > > 
> > > > > Yeap, if fedora didn't work, I think it should be hidden.  Do we 
> > > > > already have place to hide things like this?
> > > > 
> > > > in my local testing i'm using simple annotations like the one attached 
> > > > further below. Any objections against sending my BROKEN_BOOT_ALLOWED kit 
> > > > upstream, and merge my annotations for various kernel features that 
> > > > break a generic distro bootup?
> > > > 
> > > > Right now i have about 40 such annotations for -tip testing:
> > > > 
> > > >   fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   security/selinux/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   security/smack/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   security/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/net/appletalk/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/net/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/media/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/scsi/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/watchdog/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/watchdog/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/ide/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/i2c/busses/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/block/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/video/console/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/video/console/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/mtd/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   drivers/isdn/icn/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   lib/Kconfig.kgdb:	depends on BROKEN_BOOT_ALLOWED
> > > >   lib/Kconfig.debug:	depends on BROKEN_BOOT_ALLOWED
> > > >   lib/Kconfig.debug:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig.debug:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig:	# depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
> > > >   arch/x86/Kconfig.cpu:	depends on BROKEN_BOOT_ALLOWED
> > > > 
> > > > and note the stark contrast to CONFIG_BROKEN - sometimes a given 
> > > > functionality is really not meant to be enabled on a generic system.
> > > > 
> > > > 	Ingo
> > > > 
> > > > ---------------->
> > > > Subject: qa: no ext devt
> > > > From: Ingo Molnar <mingo@elte.hu>
> > > > Date: Fri Oct 10 22:54:57 CEST 2008
> > > > 
> > > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > > ---
> > > >  lib/Kconfig.debug |    2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > Index: linux/lib/Kconfig.debug
> > > > ===================================================================
> > > > --- linux.orig/lib/Kconfig.debug
> > > > +++ linux/lib/Kconfig.debug
> > > > @@ -670,6 +670,8 @@ config DEBUG_BLOCK_EXT_DEVT
> > > >          bool "Force extended block device numbers and spread them"
> > > >  	depends on DEBUG_KERNEL
> > > >  	depends on BLOCK
> > > > +	depends on BROKEN_BOOT_ALLOWED
> > > > +	select BROKEN_BOOT
> > > >  	default n
> > > >  	help
> > > >  	  Conventionally, block device numbers are allocated from
> > > 
> > > What is BROKEN_BOOT_ALLOWED? Honestly, I'd prefer to just put an extra 
> > > 2-3 line paragraph in the help entry, saying that it's quite possible 
> > > that current distros wont boot with this testing code enabled. Since 
> > > it default to 'n', people should read the entry before turning it on 
> > > anyway.
> > 
> > well, the extra BROKEN_BOOT_ALLOWED helps my automated test-setup to 
> > decide whether a .config that it's testing (either sent by a reporter or 
> > generated randomly) can be booted.
> > 
> > If CONFIG_BROKEN_BOOT_ALLOWED=y, then i allow config options that can 
> > break the bootup. In that case, and _if_ such a possibly-boot-breaking 
> > config option is enabled, CONFIG_BROKEN_BOOT is set - which my scripts 
> > detect.
> > 
> > This gives the test harness the highest flexibility and annotates those 
> > kernel features / drivers which can result in a (possibly) broken 
> > bootup. The scripts cannot read help entries.
> 
> OK, makes sense to me then, thanks. I was afraid it was some user
> exposed parameter, in which case it sounded... interesting :-)
> 
> For users, we just need to expand the help entry a bit.

We could perhaps rename it to:

  CONFIG_ALLOW_NON_GENERIC_FEATURES=y

?

It's usually things like ISA drivers or very specific hardware support 
that falls into this category - none of our major features or drivers, 
so you should not be worried about any limitation effects of such a 
feature. The help text does not help me much in that case, it was not me 
who enabled that option, i just want to use a .config from some other 
person and want to reproduce a bugreport. I do that almost on a daily 
basis.

And this CONFIG_ALLOW_NON_GENERIC_FEATURES=y option could even be 
exposed to users. I have three first-hand usecases for it:

First usecase: when i get a .config from a tester and want to test-boot 
it on a box, i dont want to spend hours of .config bisection just to 
find out that it has a driver enabled that is known to break generic 
boxes. Yes, this has happened to me in the past.

The second usecase where i utilize it is random kernel testing: there 
randconfig is what enables drivers, not me, so the help text does not 
help much.

Third usecase: where i just accidentally enable something i should not 
have enabled. It's nice to have tools around that can protect me from 
such mistakes. This too has happened to me.

So i find it very convenient that i can just disable 
CONFIG_ALLOW_NON_GENERIC_FEATURES - which automatically disables all 
possibly-broken functionality.

	Ingo
