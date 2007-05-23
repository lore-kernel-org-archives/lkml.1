Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbXEWVD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbXEWVD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXEWVDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:03:52 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:55305 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755509AbXEWVDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:03:51 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 14:03:18 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>, Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705231349.56976.jbarnes@virtuousgeek.org> <alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231403.24439.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 1:56 pm Linus Torvalds wrote:
> On Wed, 23 May 2007, Jesse Barnes wrote:
> > On Wednesday, May 23, 2007 1:20 pm Linus Torvalds wrote:
> > > On Wed, 23 May 2007, Jesse Barnes wrote:
> > > > Fixed it (finally).  I don't think moving the 64 bit probing
> > > > around would make a difference, since we'd restore its original
> > > > value anyway before moving on to the 32 bit probe which is
> > > > where I think the problem is.
> > >
> > > Well, the thing is, I'm pretty sure there is at least one
> > > northbridge that stops memory accesses from the CPU when you turn
> > > off the MEM bit on it. Oops, you just killed the machine.
> >
> > Wow, that sounds like a pretty lame host bridge.
>
> Umm. Why? Think about it.
>
> You ASKED it to stop forwarding memory.
>
> So who is lamer: the chip that does what it is told, or the software
> that tells it to do it?
>
> I'd vote for the software. Any programmer who expects the hardware to
> "just do what I mean, not what I say" is not a programmer, but a
> dreamer.
>
> You told it to not forward memory. Why complain when it does as told?

Well, because that's not actually very useful functionality, and likely 
makes software that seems "obviously" correct wrt the PCI spec break.

> > > Quite frankly, if we just didn't use mmconfig, the whole issue
> > > would go away. Isn't _that_ the much better solution?
> >
> > Not for systems with PCIe...  and the platforms I've been having
> > trouble with have PCIe slots, so I'd really like mmconfig to be
> > used at least on machines with PCIe bridges.  For other machines,
> > it probably doesn't matter much.  I don't know of any regular PCI
> > devices offhand that really need extended config space.
>
> Ehh. Even for PCIe, why not use the normal accesses for the first 256
> bytes? Problem solved.

Yeah, that's another option.  Would just mean an additional conditional 
in the mmconfig code, I'll give it a try...

Apparently Vista will move away from using type 1 config space accesses 
though, so if we keep using it, we'll probably run into some lame board 
that assumes you're using mmconfig at some point in the near future.  
But then again, we're often on that less tested path (e.g. with ACPI), 
so maybe that doesn't matter much.

Jesse
