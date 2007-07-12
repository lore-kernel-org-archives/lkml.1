Return-Path: <linux-kernel-owner+w=401wt.eu-S1765025AbXGLUlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765025AbXGLUlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933979AbXGLUjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:39:49 -0400
Received: from waste.org ([66.93.16.53]:42769 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934741AbXGLUjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:39:47 -0400
Date: Thu, 12 Jul 2007 15:38:35 -0500
From: Matt Mackall <mpm@selenic.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070712203834.GX11166@waste.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org> <1184194219.12353.170.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184194219.12353.170.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 12:50:19AM +0200, Thomas Gleixner wrote:
> Linus,
> 
> On Wed, 2007-07-11 at 15:20 -0700, Linus Torvalds wrote:
> > For example, we can make sure that the code in question that actually 
> > touches the hardware stays exactly the same, and then just move the 
> > interfaces around - and basically guarantee that _zero_ hardware-specific 
> > issues pop up when you switch over, for example.
> > 
> > That way there is a gradual change-over.
> 
> Ok, I can try to split this down further.
> 
> > The other approach (which would be nice _too_) is to actually try to 
> > convert one clock source at a time. Why is that not an option? 
> 
> We need to give control to the clock events core code once we convert
> one clock event device. Having two competing subsystems controlling
> different devices (e.g. PIT and APIC) is not really desirable.

Can't you take the entire legacy clock system and wrap it as a single
legacy clock source? Then you take bits out of the old system and put
them as independent sources in the new system? When the legacy clock
system is empty, you remove the legacy clock source.

-- 
Mathematics is the supreme nostalgia of our time.
