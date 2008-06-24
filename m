Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbYFXQBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbYFXQBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYFXQA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:00:57 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:53818 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYFXQA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:00:56 -0400
X-BigFish: VPS-43(zz146cM1432R98dR7efV1805M3117Kzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K2Z5T5-01-ANK-01
Date: Tue, 24 Jun 2008 18:00:41 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alistair John Strachan <alistair@devzero.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable hpet=force for AMD SB400
Message-ID: <20080624160041.GB4167@alberich.amd.com>
References: <20080509094911.GG5023@alberich.amd.com> <alpine.LFD.1.10.0805100140490.3197@apollo.tec.linutronix.de> <20080509165501.a0fdb29d.akpm@linux-foundation.org> <200805110402.20327.alistair@devzero.co.uk> <alpine.LFD.1.10.0805111059190.3197@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805111059190.3197@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 24 Jun 2008 16:00:45.0556 (UTC) FILETIME=[762ECB40:01C8D613]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 11:03:16AM +0200, Thomas Gleixner wrote:
> On Sun, 11 May 2008, Alistair John Strachan wrote:
> > > Well we don't have to auto-enable the hpet.  Simply adding a loud "you
> > > should try the hpet=force option" printk would help a lot of people.
> > 
> > I'm a bit confused about the policy here: if we look at the Intel chipset 
> > overrides for HPET, they conditionally enable the HPET _without_ the 
> > hpet=force option if you have a chipset on the whitelist.
> > 
> > If Intel can do this on their chipsets, why is this not being done for the ATI 
> > chipsets for which (presumably) AMD have specs?
> 
> Well, we have no confirmation for the correctness of the non Intel
> quirks so far. I'm happy to move them into unconditional mode once
> AMD/ATI/NVidia tell us that the HPET is indeed discoverable this way.
>  
> > One thing I'd considered was that HPET isn't actually used very often on Intel 
> > chipsets because on most recent Intel CPUs the TSC is stable, but I think 
> 
> Well, stable except for the C-States. We still need a backup clock
> source as TSC is stopping in C3.
> 
> > either the Intel quirk should be consistent with the hpet=force usage, 
> > or "known correct" HPET overrides should just always be applied.
> 
> That's what we do. We have "known correct" for Intel and those which
> work on the patch submitters box w/o confirmation of the
> correctness. I guess the SB400 one can move into the "is correct"
> category, Andreas ???

Sorry for the late reply, but I had to look for the spec in the first
place ;-) and I have done some coding and testing since then.
(Well, the patch was written as a quick hack to get HPET working on my
private laptop.)

The point is that at least some revisions of IXP400/IXP450 have indeed
hardware issues regarding HPET. Thus HPET works only for certain
chip revisions.

Currently I am internally discussing whether it makes sense to enable
(and properly configure) HPET for those chipset revisions.

BTW, if outcome of this discussion is that HPET on IXP400/IXP450
shouldn't be used then IMHO a quirk is needed to reliably disable it.
I.e. disable it even if a system provides an ACPI HPET table.

Thanks for your patience.


Regards,

Andreas


