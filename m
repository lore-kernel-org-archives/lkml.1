Return-Path: <linux-kernel-owner+w=401wt.eu-S2993096AbXDYU3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993096AbXDYU3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993097AbXDYU3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:29:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993096AbXDYU3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:29:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Wed, 25 Apr 2007 22:33:23 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org> <20070425200836.GB17387@elf.ucw.cz>
In-Reply-To: <20070425200836.GB17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252233.25296.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 25 April 2007 22:08, Pavel Machek wrote:
> Hi!
> 
> > > > .. but if the alternative is a feature that just isn't worth it, and 
> > > > likely to not only have its own bugs, but cause bugs elsewhere? (And yes, 
> > > > I believe STD is both of those. There's a reason it's called "STD". Go 
> > > > to google and type "STD" and press "I'm feeling lucky". Google is God).
> > > 
> > > Is there really no use case for STD?

[--snip--]
> > So my objections to STD have nothing to do with saving state and shutting 
> > down. They have everything to do with the fact that it is not - and will 
> > never be - a "suspend", and it shouldn't affect suspend.
> 
> STD needs to snapshot system, and then it needs devices to be
> suspended so that snapshot is consistent.

Not suspended.  _Frozen_.  In fact don't want any DMA transfers or interrupts
to take place when we're creating the image.  That's all and that's what we're
doing (or rather, trying to do).

So, the "suspend" and "resume" for the functions being called for that are
wrong, but then we call them with PMSG_FREEZE. ;-)  Still, we could add
.freeze() and .thaw() callbacks for hibernation just fine.  This wouldn't even
be that difficult ...

Greetings,
Rafael
