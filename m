Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXHWVmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXHWVmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763269AbXHWViz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:38:55 -0400
Received: from mailhub.hp.com ([192.151.27.10]:60570 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763112AbXHWVix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:38:53 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Thu, 23 Aug 2007 17:38:49 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070823213849.GA7617@localhost>
References: <20070823222115.122a37ca@localhost> <617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com> <1187903135.6024.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187903135.6024.18.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:	[Thu Aug 23 2007, 05:05:35PM EDT]
> On Thu, 2007-08-23 at 13:41 -0700, Luck, Tony wrote:
> > > I have a double "hpet" entry in "available_clocksource":
> > >	$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > >	tsc hpet hpet acpi_pm jiffies
> > 
> > Oops.  If seems that both drivers/char/hpet.c and arch/x86_64/kernel/hpet.c
> > both register a clocksource named "hpet".  Probably a result of bringing
> > back to life a long lost patch, and having someone else (John Stultz, according
> > to git blame) make a similar change to a different file in the intervening
> > time.
> > 
> > Presumably the thing to do would be merge the x86_64 specific version
> > into the drivers/char/hpet.c version?
> 
> Ugh. Yea. i386 has an hpet clocksource as well. We should kill the
> duplication, but at the moment I'm not comfortable that the
> driver/char/hpet.c is ok to be used for i386/x86_64 (Bob: Do you know
> why the shift value is only 10?).
No I don't have a clue why Pete chose this value.
> 
> 
> I'm a little surprised by this, as the clocksource code use to prevent
> duplicate named clocksources from being registered, so I'm not sure how
> that check got dropped.  Also I'm not quite sure I see where the hard
> freeze is coming from.
> 
> My initial reaction would be to either ifdef ia64 implementation in
> drivers/char/hpet.c or move the code under the ia64 arch dir until it is
> really usable by all arches.
> 
> Bob, your thoughts?
It appears the ACPI for this platform might work. We don't know because
of a hpet driver probe error discussed below. I assume you're suggesting
the driver is only required by ia64? I think that might not be true.

Well I'm slightly confused. The fs_initcall was first into hpet_alloc.
It appears ACPI discovery failed during driver initialization because
of:
hpet_resources: 0xfed00000 is busy
from dmesg. So why do we have a second hpet registered? Also hpet_alloc
is suspose to check for redundant registration. I need to look more
tomorrow.
> 
bob
