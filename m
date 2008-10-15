Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbYJOAf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbYJOAf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYJOAfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:35:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbYJOAfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:35:11 -0400
Date: Tue, 14 Oct 2008 17:34:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: origin tree build failure
In-Reply-To: <20081015000541.GA22570@opensource.wolfsonmicro.com>
Message-ID: <alpine.LFD.2.00.0810141721450.3288@nehalem.linux-foundation.org>
References: <20081015095916.f30c0979.sfr@canb.auug.org.au> <alpine.LFD.2.00.0810141637210.3288@nehalem.linux-foundation.org> <20081015000541.GA22570@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Mark Brown wrote:
>
> That would be people on the ARM list.  Unless I misremember I first
> heard about using NO_IRQ from the ARM list in connection with another
> (much less ARM-specific) driver only within the past six months.

ARM should just do

	#define NO_IRQ (0)

and be done with it. It's what powerpc did long ago. That allows old 
broken drivers to work, and doesn't require new drivers to introduce more 
NO_IRQ insanity.

If there is a "hardware irq 0", either it can be special (eg some 
system-only irq not used by any drivers) or the irq numbers can/must be 
remapped.

ARM already converted to the generic irq layer, and there are actually 
parts of that that know that irq 0 has special meaning. Like the 
autoprobing and spurious irq handling. Of course, ARM may not care, and 
the generic code is generally trying to avoid any assumptions, but it's 
still true that all generic _drivers_ do the whole "if (irq)" thing.

Yeah, yeah, we've let NO_IRQ poison some subsystems (like IDE and 
apparently parts of i2c), but that was a mistake.

		Linus
