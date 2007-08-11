Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbXHKKxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbXHKKxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 06:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbXHKKxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 06:53:30 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:36933 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbXHKKx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 06:53:29 -0400
Date: Sat, 11 Aug 2007 13:53:25 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
In-Reply-To: <200708102206.58438.rjw@sisk.pl>
Message-ID: <Pine.SOC.4.64.0708111349520.725@math.ut.ee>
References: <46B9F664.9060600@googlemail.com> <200708102124.01218.rjw@sisk.pl>
 <Pine.SOC.4.64.0708102220290.14225@math.ut.ee> <200708102206.58438.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 3. Can you please check if this patch changes anything:
> > > http://marc.info/?l=linux-mm-commits&m=118669680811669&w=2
> > 
> > Tried it on current git, kernel/power/Kconfig gave 2 rejects.
> > Tried on 2.6.23-rc2, still 2 rejects from the same file, .rej below:
> 
> Sorry, but:
> 
> rafael@albercik:~/src/linux-2.6> git-pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> Already up-to-date.
> rafael@albercik:~/src/linux-2.6> cat ~/pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x.patch | patch -p1
> patching file arch/x86_64/defconfig
> patching file include/linux/cpu.h
> patching file kernel/cpu.c
> patching file kernel/power/Kconfig
> 
> How come?

Hmm, must have been mangled on the web (downloaded via wget so should be 
byte-by-byte exact). I now downloaded it from akpm-s broken-out tarball 
and this one applied fine.

The patch changes the warning to a different warning, it's now
kernel/power/Kconfig:79:warning: 'select' used by config symbol 'PM_SLEEP_SMP' refers to undefined symbol 'HOTPLUG_CPU'

The warning also appears when running just "make ARCH=ppc" after
"make ARCH=ppc oldconfig".

-- 
Meelis Roos (mroos@linux.ee)
