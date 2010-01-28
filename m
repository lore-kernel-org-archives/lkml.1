Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053Ab0A1Kv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0A1Kv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483Ab0A1Kv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:51:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36648 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab0A1Kv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:51:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <kernel@teksavvy.com>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
Date: Thu, 28 Jan 2010 11:52:20 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-rjw; KDE/4.3.5; x86_64; ; )
Cc: Mel Gorman <mel@csn.ul.ie>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
References: <4B5FA147.5040802@teksavvy.com> <4B610FDA.50104@teksavvy.com> <4B6113C7.201@teksavvy.com>
In-Reply-To: <4B6113C7.201@teksavvy.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001281152.20352.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 January 2010, Mark Lord wrote:
> Mark Lord wrote:
> > Mark Lord wrote:
> >> Mel Gorman wrote:
> >>> On Tue, Jan 26, 2010 at 09:13:27PM -0500, Mark Lord wrote:
> >>>> I recently upgraded our 24/7 server from 2.6.31.5 to 2.6.32.5.
> >>>>
> >>>> Now, suddenly the logs are full of "page allocation failure. order:1",
> >>>> and the odd "page allocation failure. order:4" failures.
> >>>>
> >>>> Wow.  WTF happened in 2.6.32 ???
> >>>>
> >>>
> >>> There was one bug related to MIGRATE_RESERVE that might be affecting
> >>> you. It reported as impacting swap-orientated workloads but it could
> >>> easily affect drivers that depend on high-order atomic allocations.
> >>> Unfortunately, the fix is not signed-off yet but I expect it to make its
> >>> way towards mainline when it is.
> >>>
> >>> Here is the patch with a slightly-altered changelog. Can you test if it
> >>> makes a difference please?
> >> ..
> >>
> >> We don't like to reboot our 24/7 server very often,
> >> and certainly not for debugging buggy kernels.
> >>
> >> It's rock solid again with 2.6.31.12 on it now.
> >>
> >> The defining characteristic of that machine, is that it has only 512MB
> >> of physical RAM.  So perhaps I'll try booting a different machine here
> >> with mem=512M and see how that behaves.  If the problem shows up on that,
> >> then I'll try the patch.
> > ..
> > 
> > Sod it.  2.6.32 is simply too broken for us here on 32-bit non-SMP.
> > 
> > Attempting to boot a 32-bit kernel with "nosmp mem=512M" on my notebook
> > locks up at boot time with several repeated messages like this:
> > 
> >   request_module: runaway loop modprobe binfmt_464c
> > 
> > Useless kernel on 32-bit.  I hope 2.6.33 ends up less buggy.
> ..
> 
> I rebuilt it (again!), this time as a pure UP (non-SMP) kernel,
> and it still locks at boot, with or without the mem=512M parameter.
> 
> This is one really bad kernel release for 32-bit x86.

Have you attached a (2.6.31.x) dmesg output from the failing box somewhere
or have I just missed it?

Rafael
