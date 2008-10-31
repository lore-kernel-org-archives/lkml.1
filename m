Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbYJaKhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbYJaKhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 06:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbYJaKgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 06:36:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41686 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbYJaKgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 06:36:50 -0400
Date: Fri, 31 Oct 2008 10:36:46 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot (bisected)
Message-ID: <20081031103646.GA24395@csn.ul.ie>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <20081030142632.GA15645@csn.ul.ie> <18698.7794.500191.189515@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <18698.7794.500191.189515@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 07:52:02AM +1100, Paul Mackerras wrote:
> Mel Gorman writes:
> 
> > On some ppc64 machines, NVRAM is being corrupted very early in boot (before
> > console is initialised). The machine reboots and then fails to find yaboot
> > printing the error "PReP-BOOT: Unable to load PRep image".  It's nowhere near
> > as serious as the ftrace+e1000 problem as the machine is not bricked but it's
> > fairly scary looking, the machine cannot boot and the fix is non-obvious. To
> > "fix" the machine;
> > 
> > 1. Go to OpenFirmware prompt
> > 2. type dev nvram
> > 3. type wipe-nvram
> > 
> > The machine will reboot, reconstruct the NVRAM using some magic and yaboot
> > work again allowing an older kernel to be used. I bisected the problem down
> > to this commit.
> 
> Eek!
> 
> Which ppc64 machines has this been seen on, and how were they being
> booted (netboot, yaboot, etc.)?
> 

Yaboot in my case and I've heard it affected a DVD installation. I don't
know for sure if it affects netboot but as I think it's something the
kernel is doing, it probably doesn't matter how it gets loaded?

> Is it just the Powerstations with their SLOF-based firmware, or is it
> IBM pSeries machines as well?
> 

To be honest, I haven't been brave enough to try this on a Powerstation yet
as I only have the one and I don't know if it's a) affected or b) fixable
with the same workaround. It was an IBM pSeries that was affected in my case
and a few people have hit the problem on pSeries AFARIK.

It's been pointed out that it can be "fixed" by upgrading the firmware but
surely we can avoid breaking the machine in the first place?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
