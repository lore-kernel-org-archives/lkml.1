Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895Ab0A1JCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0A1JCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511Ab0A1JB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:01:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:56968 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751440Ab0A1JB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:01:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/gycdaM2/gteqpfkkEmvp8sUrOM3PrC8TtQn+DGy
	EOMlrJyN8FDY3H
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
From: Mike Galbraith <efault@gmx.de>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <4B6113C7.201@teksavvy.com>
References: <4B5FA147.5040802@teksavvy.com>
	 <20100127120820.GB25750@csn.ul.ie> <4B60C0A7.7090501@teksavvy.com>
	 <4B610FDA.50104@teksavvy.com>  <4B6113C7.201@teksavvy.com>
Content-Type: text/plain
Date: Thu, 28 Jan 2010 10:01:55 +0100
Message-Id: <1264669315.5996.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 23:34 -0500, Mark Lord wrote:
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

FWFW, it doesn't seem to be anything generic.

My P4 box boots and runs fine nosmp+mem=512M.. no allocation errors so
far while beating it up.  It's not even a tiny bit fun to use with KDE
while doing so though. Doing a bunch of git and nfs activity convinces
reclaim that vital bits of my GUI are expendable.

	-Mike

