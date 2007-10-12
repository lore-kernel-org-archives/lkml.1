Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbXJLLtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbXJLLtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 07:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbXJLLto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 07:49:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47752 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbXJLLtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 07:49:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: APM shutdown oops (Re: [stable] [patch 09/12] Fix SMP poweroff hangs)
Date: Fri, 12 Oct 2007 14:05:07 +0200
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jgarzik@pobox.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin <spaceman__spiff@cox.net>, Greg KH <greg@kroah.com>,
       Olof Johansson <olof@lixom.net>, Greg KH <gregkh@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Mark Lord <mlord@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk, BDFL <volkerdi@slackware.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <20071008180406.052382073@mini.kroah.org> <470E6E79.6040908@pobox.com> <20071011232755.GA3620@stusta.de>
In-Reply-To: <20071011232755.GA3620@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710121405.10260.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 12 October 2007 01:27, Adrian Bunk wrote:
> On Thu, Oct 11, 2007 at 02:42:01PM -0400, Jeff Garzik wrote:
> > Linus Torvalds wrote:
> >> On Wed, 10 Oct 2007, Kevin wrote:
> >>> The last kernel I used was 6.2.22 the "dmesg" the file is attached:
> >>>
> >>> dmesg 2.6.22 line 158 >  apm: overridden by ACPI.
> >>>
> >>> dmesg, APM on, has no line > apm: overridden by ACPI.
> >> Ok, this is the real reason. The APM code does:
> >>         if (PM_IS_ACTIVE()) {
> >>                 printk(KERN_NOTICE "apm: overridden by ACPI.\n");
> >>                 apm_info.disabled = 1;
> >>                 return -ENODEV;
> >>         }
> >> and in previous kernels that would notice that you have ACPI enabled, and 
> >> APM gets shut out, and you never see your buggy APM BIOS.
> >> In 2.6.23, this apparently doesn't happen for some reason.
> >> And I think I see the problem: it's a config change. You don't have 
> >> PM_LEGACY enabled. Your config file diff shows:
> >> 	-CONFIG_PM_LEGACY=y
> >> 	+# CONFIG_PM_LEGACY is not set
> >> I suspect we should make CONFIG_APM either depend on, or select, 
> >> PM_LEGACY. But as far as I can see, nothing has actually changed in this 
> >> area in the kernel, and this bug has been there before - just your config 
> >> change made it appear. Rafael? Stephen? Opinions? I'd think that making 
> >> APM depend on CONFIG_PM_LEGACY is the right thing to do these days..
> >
> > Speaking as the author of
> >
> > 	[PATCH] move pm_register/etc. to CONFIG_PM_LEGACY, pm_legacy.h
> >
> > I agree.  arch/i386/kernel/apm.c clearly requires include/linux/pm_legacy.h 
> > and the legacy PM API.
> >
> > I would vote for a dependency rather than select, but don't have any strong 
> > feelings on the matter...
> 
> It should be a select since a dependency would make it needlessly hard 
> for kconfig users to find the APM option.

Well, my experience with selects is such that I'd rather avoid them in the
future, if possible ...

Greetings,
Rafael
