Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbXEWU62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbXEWU62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEWU6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:58:20 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754956AbXEWU6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:58:20 -0400
Date: Wed, 23 May 2007 13:56:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Robert Hancock <hancockr@shaw.ca>, Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <200705231349.56976.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705231152.57796.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705231257050.3890@woody.linux-foundation.org>
 <200705231349.56976.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Jesse Barnes wrote:

> On Wednesday, May 23, 2007 1:20 pm Linus Torvalds wrote:
> > On Wed, 23 May 2007, Jesse Barnes wrote:
> > > Fixed it (finally).  I don't think moving the 64 bit probing around
> > > would make a difference, since we'd restore its original value
> > > anyway before moving on to the 32 bit probe which is where I think
> > > the problem is.
> >
> > Well, the thing is, I'm pretty sure there is at least one northbridge
> > that stops memory accesses from the CPU when you turn off the MEM bit
> > on it. Oops, you just killed the machine.
> 
> Wow, that sounds like a pretty lame host bridge.

Umm. Why? Think about it.

You ASKED it to stop forwarding memory.

So who is lamer: the chip that does what it is told, or the software that 
tells it to do it?

I'd vote for the software. Any programmer who expects the hardware to 
"just do what I mean, not what I say" is not a programmer, but a dreamer. 

You told it to not forward memory. Why complain when it does as told?

> > Quite frankly, if we just didn't use mmconfig, the whole issue would
> > go away. Isn't _that_ the much better solution?
> 
> Not for systems with PCIe...  and the platforms I've been having trouble 
> with have PCIe slots, so I'd really like mmconfig to be used at least 
> on machines with PCIe bridges.  For other machines, it probably doesn't 
> matter much.  I don't know of any regular PCI devices offhand that 
> really need extended config space.

Ehh. Even for PCIe, why not use the normal accesses for the first 256 
bytes? Problem solved.

			Linus
