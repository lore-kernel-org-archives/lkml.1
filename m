Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYJKHU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYJKHU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYJKHUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:20:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYJKHUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:20:12 -0400
Date: Sat, 11 Oct 2008 09:19:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [bug] latest -git boot hang
Message-ID: <20081011071939.GA26465@elte.hu>
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EFF84B.5060108@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> > It does sound like perhaps the option should be hidden more, if it's 
> > really only reasonably enabled for some very specialized distro 
> > debuggers, not normal kernel people.
> 
> Yeap, if fedora didn't work, I think it should be hidden.  Do we 
> already have place to hide things like this?

in my local testing i'm using simple annotations like the one attached 
further below. Any objections against sending my BROKEN_BOOT_ALLOWED kit 
upstream, and merge my annotations for various kernel features that 
break a generic distro bootup?

Right now i have about 40 such annotations for -tip testing:

  fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  fs/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  security/selinux/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  security/smack/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  security/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/net/appletalk/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/net/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/media/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/scsi/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/watchdog/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/watchdog/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/ide/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/i2c/busses/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/block/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/video/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/video/console/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/video/console/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/mtd/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  drivers/isdn/icn/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  lib/Kconfig.kgdb:	depends on BROKEN_BOOT_ALLOWED
  lib/Kconfig.debug:	depends on BROKEN_BOOT_ALLOWED
  lib/Kconfig.debug:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig.debug:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig:	# depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig:	depends on BROKEN_BOOT_ALLOWED
  arch/x86/Kconfig.cpu:	depends on BROKEN_BOOT_ALLOWED

and note the stark contrast to CONFIG_BROKEN - sometimes a given 
functionality is really not meant to be enabled on a generic system.

	Ingo

---------------->
Subject: qa: no ext devt
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Oct 10 22:54:57 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/lib/Kconfig.debug
===================================================================
--- linux.orig/lib/Kconfig.debug
+++ linux/lib/Kconfig.debug
@@ -670,6 +670,8 @@ config DEBUG_BLOCK_EXT_DEVT
         bool "Force extended block device numbers and spread them"
 	depends on DEBUG_KERNEL
 	depends on BLOCK
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
 	default n
 	help
 	  Conventionally, block device numbers are allocated from

