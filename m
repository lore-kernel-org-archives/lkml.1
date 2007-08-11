Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbXHKVc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbXHKVc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 17:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbXHKVcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 17:32:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55985 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbXHKVcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 17:32:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
Date: Sat, 11 Aug 2007 23:42:01 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
References: <46B9F664.9060600@googlemail.com> <200708102206.58438.rjw@sisk.pl> <Pine.SOC.4.64.0708111349520.725@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0708111349520.725@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708112342.01989.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 11 August 2007 12:53, Meelis Roos wrote:
> > > > 3. Can you please check if this patch changes anything:
> > > > http://marc.info/?l=linux-mm-commits&m=118669680811669&w=2
> > > 
> > > Tried it on current git, kernel/power/Kconfig gave 2 rejects.
> > > Tried on 2.6.23-rc2, still 2 rejects from the same file, .rej below:
> > 
> > Sorry, but:
> > 
> > rafael@albercik:~/src/linux-2.6> git-pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > Already up-to-date.
> > rafael@albercik:~/src/linux-2.6> cat ~/pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x.patch | patch -p1
> > patching file arch/x86_64/defconfig
> > patching file include/linux/cpu.h
> > patching file kernel/cpu.c
> > patching file kernel/power/Kconfig
> > 
> > How come?
> 
> Hmm, must have been mangled on the web (downloaded via wget so should be 
> byte-by-byte exact). I now downloaded it from akpm-s broken-out tarball 
> and this one applied fine.
> 
> The patch changes the warning to a different warning, it's now
> kernel/power/Kconfig:79:warning: 'select' used by config symbol 'PM_SLEEP_SMP' refers to undefined symbol 'HOTPLUG_CPU'
> 
> The warning also appears when running just "make ARCH=ppc" after
> "make ARCH=ppc oldconfig".

Yes, I have reproduced it now.

Well, it's clearly a false positive, since none of the options PM_SLEEP_SMP
depends on is set in your .config.  Also, it seems to be ppc-specific (for
example, if I change the architecture to powerpc, the warning doesn't show up).

The only problem I see here is that the warning in fact should not be printed,
but I don't know how to make the build system stop printing it.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
