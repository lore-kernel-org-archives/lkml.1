Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbYJNPJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbYJNPJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYJNPJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:09:45 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:45466 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYJNPJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:09:44 -0400
Subject: Re: [bug] latest -git boot hang
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
In-Reply-To: <20081011071939.GA26465@elte.hu>
References: <20081010203043.GA11798@elte.hu>
	 <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu>
	 <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org>
	 <48EFF84B.5060108@kernel.org>  <20081011071939.GA26465@elte.hu>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 14 Oct 2008 11:07:39 -0400
Message-Id: <1223996859.5193.61.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-11 at 09:19 +0200, Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
> > > It does sound like perhaps the option should be hidden more, if it's 
> > > really only reasonably enabled for some very specialized distro 
> > > debuggers, not normal kernel people.
> > 
> > Yeap, if fedora didn't work, I think it should be hidden.  Do we 
> > already have place to hide things like this?
> 
> in my local testing i'm using simple annotations like the one attached 
> further below. Any objections against sending my BROKEN_BOOT_ALLOWED kit 
> upstream, and merge my annotations for various kernel features that 
> break a generic distro bootup?
> 
> Right now i have about 40 such annotations for -tip testing:
> 
>   fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   security/selinux/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   security/smack/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   security/Kconfig:	depends on BROKEN_BOOT_ALLOWED

What in particular under fs/Kconfig and security/*Kconfig falls into
this category, and why?  What constitutes a "generic distro bootup"?
For distros that support SELinux, it obviously shouldn't break the
bootup (there have of course been cases where it has, but those were
bugs that have been addressed, including the recent /proc/net breakage),
and for other distros, it should yield no effect as no policy will be
loaded and thus SELinux just allows everything.

>   drivers/net/appletalk/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/net/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/media/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/scsi/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/watchdog/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/watchdog/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/ide/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/i2c/busses/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/block/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/video/console/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/video/console/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/mtd/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   drivers/isdn/icn/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   lib/Kconfig.kgdb:	depends on BROKEN_BOOT_ALLOWED
>   lib/Kconfig.debug:	depends on BROKEN_BOOT_ALLOWED
>   lib/Kconfig.debug:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig.debug:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig:	# depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
>   arch/x86/Kconfig.cpu:	depends on BROKEN_BOOT_ALLOWED
> 
> and note the stark contrast to CONFIG_BROKEN - sometimes a given 
> functionality is really not meant to be enabled on a generic system.
> 
> 	Ingo
> 
> ---------------->
> Subject: qa: no ext devt
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri Oct 10 22:54:57 CEST 2008
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  lib/Kconfig.debug |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux/lib/Kconfig.debug
> ===================================================================
> --- linux.orig/lib/Kconfig.debug
> +++ linux/lib/Kconfig.debug
> @@ -670,6 +670,8 @@ config DEBUG_BLOCK_EXT_DEVT
>          bool "Force extended block device numbers and spread them"
>  	depends on DEBUG_KERNEL
>  	depends on BLOCK
> +	depends on BROKEN_BOOT_ALLOWED
> +	select BROKEN_BOOT
>  	default n
>  	help
>  	  Conventionally, block device numbers are allocated from
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Stephen Smalley
National Security Agency

