Return-Path: <linux-kernel-owner+w=401wt.eu-S941021AbXHMPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941021AbXHMPZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031304AbXHMNV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:21:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:59836 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031299AbXHMNVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WPg32AKr2lmQitHuS1oqU2KTZQ4Zj+bPo5Vgo0qJ/AzhvnfXbqNeCM1K0r5zGNNA90GBqtWB6wEAWh/FGtpnMv2m6g1gg3h4yEjzKx0osMX5gICKlyIEsmg2zWYIgd6kfT5WkL5w0xnh3HKk2mhfbtx+TdYhlid0V5o1kXWQiPM=
Message-ID: <6bffcb0e0708130621s74411866mc07446854fb96cd4@mail.gmail.com>
Date: Mon, 13 Aug 2007 15:21:54 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
Cc: "Meelis Roos" <mroos@linux.ee>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Pavel Machek" <pavel@ucw.cz>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <200708112342.01989.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B9F664.9060600@googlemail.com> <200708102206.58438.rjw@sisk.pl>
	 <Pine.SOC.4.64.0708111349520.725@math.ut.ee>
	 <200708112342.01989.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/08/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 11 August 2007 12:53, Meelis Roos wrote:
> > > > > 3. Can you please check if this patch changes anything:
> > > > > http://marc.info/?l=linux-mm-commits&m=118669680811669&w=2
> > > >
> > > > Tried it on current git, kernel/power/Kconfig gave 2 rejects.
> > > > Tried on 2.6.23-rc2, still 2 rejects from the same file, .rej below:
> > >
> > > Sorry, but:
> > >
> > > rafael@albercik:~/src/linux-2.6> git-pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > > Already up-to-date.
> > > rafael@albercik:~/src/linux-2.6> cat ~/pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x.patch | patch -p1
> > > patching file arch/x86_64/defconfig
> > > patching file include/linux/cpu.h
> > > patching file kernel/cpu.c
> > > patching file kernel/power/Kconfig
> > >
> > > How come?
> >
> > Hmm, must have been mangled on the web (downloaded via wget so should be
> > byte-by-byte exact). I now downloaded it from akpm-s broken-out tarball
> > and this one applied fine.
> >
> > The patch changes the warning to a different warning, it's now
> > kernel/power/Kconfig:79:warning: 'select' used by config symbol 'PM_SLEEP_SMP' refers to undefined symbol 'HOTPLUG_CPU'
> >
> > The warning also appears when running just "make ARCH=ppc" after
> > "make ARCH=ppc oldconfig".
>
> Yes, I have reproduced it now.
>
> Well, it's clearly a false positive, since none of the options PM_SLEEP_SMP
> depends on is set in your .config.  Also, it seems to be ppc-specific (for
> example, if I change the architecture to powerpc, the warning doesn't show up).
>
> The only problem I see here is that the warning in fact should not be printed,
> but I don't know how to make the build system stop printing it.

I removed this from KR list. Sam, is it possible to remove this warning?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
