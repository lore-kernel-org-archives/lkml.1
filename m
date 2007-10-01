Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXJAT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXJAT2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXJAT2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:28:04 -0400
Received: from www.tglx.de ([62.245.132.106]:58903 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbXJAT2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:28:02 -0400
Date: Mon, 1 Oct 2007 21:27:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: David Bahi <dbahi@novell.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
In-Reply-To: <200710012116.59356.ak@suse.de>
Message-ID: <alpine.LFD.0.9999.0710012124420.20478@localhost.localdomain>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710011936.01528.ak@suse.de> <alpine.LFD.0.9999.0710012052310.20478@localhost.localdomain> <200710012116.59356.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Andi Kleen wrote:
> On Monday 01 October 2007 20:54:21 Thomas Gleixner wrote:
> > On Mon, 1 Oct 2007, Andi Kleen wrote:
> > 
> > > On Wednesday 26 September 2007 20:03:12 David Bahi wrote:
> > > > Thanks to tglx and ghaskins for all the help in tracking down a very
> > > > early nmi_watchdog crash on certain x86_64 machines.
> > > 
> > > The patch is totally bogus. irq 0 doesn't say anything about whether
> > > the current CPU still works or not. You always need some local
> > > interrupt. This basically disables the NMI watchdog for the non boot CPUs.
> > > 
> > > It's even wrong on i386 -- i wonder how that broken patch
> > > made it in there. I'll remove it there.
> > 
> > Right, it's wrong for the broadcast case, but simply removing it will
> > trigger false positives on the CPU which runs the broadcast timer. I
> > fix this proper.
> 
> I already did this here by checking for cpu != 0. But it also needs either tracking
> or forbidding migrations of irq 0. I can take care of the patch.

I was thinking about the same fix. On i386 we already have the irq 
migration / balancing of irq 0 disabled. That's why we setup IRQ0 with
IRQ_NOBALANCING.

	tglx




