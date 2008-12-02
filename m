Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYLBRrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYLBRrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbYLBRqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:46:55 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:47647 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591AbYLBRqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:46:55 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Tue, 2 Dec 2008 18:46:48 +0100
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, greg@kroah.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru
References: <200812020320.31876.rjw@sisk.pl> <200812020629.26714.elendil@planet.nl> <alpine.LFD.2.00.0812020735150.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812020735150.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021846.51479.elendil@planet.nl>
X-OriginalArrivalTime: 02 Dec 2008 17:46:51.0813 (UTC) FILETIME=[F5464550:01C954A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008, Linus Torvalds wrote:
> So, it looks like you have MSI enabled in -rc6, and not in -rc3. And
> yes, for some reason -rc3 will create the prefetchable memory range
> windows, but -rc6 won't.

I have no changes in my config that would explain that (checked the diff). 
The only changes are simple 'make oldconfig' updates.

> I have to admit that I'm not seeing _why_ to that latter one. I don't
> think we've done any resource allocation changes since -rc3 (the "clean
> up late e820 resource allocation" thing happened just _before_ -rc3),
> so I'm really not seeing why -rc3 would act differently from -rc6..

I could reinstall some intermediate versions and check when that change 
got introduced if that would help, or revert to the kernel I was using 
before I did the pull today and applied the debug patch (which was plain 
rc6 + a few selected bug fix patches that had not yet been merged).

> > At the bottom there's a fairly long addition from the few
> > suspend/resume cycles I did (again, running with the debug patch).
>
> Sure. Quite frankly, from these messages, I'm not seeing anything
> really even remotely wrong. And apparently it does actually work for
> you.

Right. All these resumes were perfect.

> It would perhaps be more interesting to see if there is some dmesg
> difference in a boot that then ends up _not_ able to resume from
> hibernation? But apparently that hasn't happened to you lately?

It did happen once a few days ago, but with the workarounds I had resume 
failures were extremely rare. I'll see if I can work out which boot it 
was, but that could well be very tricky as a failed resume leaves no 
trace.

The way I "see" the failure is that the wireless led does not come on

> I don't like not knowing why you have prefetchable windows in one, and
> not in the other, but it is indeed a transparent bridge and so that
> difference really shouldn't even matter.

/me always likes the use of "should" in such situations ;-)

> Do you perhaps dual-boot that laptop? What can sometimes happen is that
> PCI resources do not get totally reset over a warm-boot.

No. I only run Debian testing on that machine. As Debian Lenny is getting 
close to release there are very few changes in userland ATM. For kernels 
I essentially follow git starting with -rc2/3 or so of each new minor.

> We've (very occasionally) had situations where PCI resource bugs only
> happen when you warm-boot from another OS (generally Windows), or when
> you warm-boot from an earlier version of Linux. Exactly because some
> firmware didn't fully re-initialize the state of the PCI bus, and
> because Linux will try to honor everything that the firmware set up..

Given the above that does not seem relevant.
