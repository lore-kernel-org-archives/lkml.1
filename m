Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYCENaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYCENaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYCENaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:30:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbYCENaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:30:21 -0500
Date: Wed, 5 Mar 2008 14:29:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Greg KH <gregkh@suse.de>, "Zhang, Rui" <rui.zhang@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Message-ID: <20080305132952.GD11701@elte.hu>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com> <20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu> <20080305101617.GD19059@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305101617.GD19059@localhost.sw.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@sw.ru> wrote:

> On Tue, Mar 04, 2008 at 02:54:47PM +0100, Ingo Molnar wrote:
> > CONFIG_SYSFS_DEPRECATED=y changed its meaning recently and causes
> > regressions in working setups that had SYSFS_DEPRECATED disabled.
> > 
> > so rename it to SYSFS_DEPRECATED_V2 so that testers pick up the new
> > default via 'make oldconfig', even if their old .config's disabled
> > CONFIG_SYSFS_DEPRECATED ...
> 
> It has all the same help text, so people who disabled it in the past 
> will disable again!

please send a patch that changes the help text. For this to happen 
people have to change the default consciously.

> > +config SYSFS_DEPRECATED_V2
> >  	bool "Create deprecated sysfs files"
> >  	depends on SYSFS
> >  	default y
> > +	select SYSFS_DEPRECATED
> >  	help
> >  	  This option creates deprecated symlinks such as the
> >  	  "device"-link, the <subsystem>:<name>-link, and the
> 
> Is anyone aware of a case when turning SYSFS_DEPRECATED back on also 
> breaks something? I mean, option can be simply removed and sysfs 
> people can finally stop breaking boxes.

i have no strong opinion either way, but i think distributions that ship 
new userspace can legitimately disable this option.

That way once all new distributions have updated userspace we can flip 
the default around and can mark it 'default n'. This at least gives us a 
theoretical path towards getting rid of unwanted legacies. (I suspect 
this was the plan all along, it's just that the clock got restarted now 
with the different legacy/breakage property.)

longer term we could also put in a WARN_ON_ONCE() which kerneloops.org 
would automatically track. That would give an objective metric about 
when to change the default. (and when to get rid of the legacy 
altogether)

	Ingo
