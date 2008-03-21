Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbYCUSlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbYCUSlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYCUSlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:41:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35336 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbYCUSll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:41:41 -0400
Date: Fri, 21 Mar 2008 19:44:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, andreas.herrmann3@amd.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/7] Don't use large pages to map the first 2/4MB of memory
Message-ID: <20080321184430.GL2346@one.firstfloor.org>
References: <20080312353.598285931@firstfloor.org> <20080312025330.AC1961B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211843120.3781@apollo.tec.linutronix.de> <20080321175936.GJ2346@one.firstfloor.org> <alpine.LFD.1.00.0803211859410.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211859410.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 07:03:19PM +0100, Thomas Gleixner wrote:
> On Fri, 21 Mar 2008, Andi Kleen wrote:
> > > Also we split the first GB mapping anyway due to the various regions
> > > (NX, RO, UC) in there.
> > 
> > I didn't think so unless you have DEBUG_RODATA enabled? 
> 
> NX is independent of DEBUG_RODATA 

Sure, but it is still not split by default. At least I don't see any code
for that anywhere except in my own patchkit.

> and the RODATA protection should be
> made unconditional on anyway.

Requiring hundreds instead of two TLB entries for the kernel text? 

I must say I personally cannot ever remember any bug caught by RODATA
anyways, so I am a bit dubious on its value.

> > Also there
> > should be no UC region there as known by the kernel. There might
> > be a WC region there from the frame buffer code, but that is an MTRR,
> > not a pageattr.
> 
> The first ioremap of the PCI space splits the GB page as well.

PCI space is normally in the fourth or sometimes third GB page,
not in the first.  I am not aware of any system that has the PCI hole 
in the first GB.

-Andi

