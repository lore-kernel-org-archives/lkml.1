Return-Path: <linux-kernel-owner+w=401wt.eu-S1761798AbZGIP2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761798AbZGIP2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761045AbZGIP22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:28:28 -0400
Received: from mail.anarazel.de ([217.115.131.40]:50431 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbZGIP21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:28:27 -0400
From: Andres Freund <andres@anarazel.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( possibly?caused by netem)
Date: Thu, 9 Jul 2009 17:28:22 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc2-andres-00152-g6a6dd01-dirty; KDE/4.2.95; x86_64; ; )
Cc: Jarek Poplawski <jarkao2@gmail.com>,
       Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       Peter Zijlstra <peterz@infradead.org>
References: <200907031326.21822.andres@anarazel.de> <20090709142414.GC3651@ami.dom.local> <alpine.LFD.2.00.0907091625540.24704@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907091625540.24704@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907091728.23367.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 09 July 2009 16:28:05 Thomas Gleixner wrote:
> On Thu, 9 Jul 2009, Jarek Poplawski wrote:
> > On Thu, Jul 09, 2009 at 04:15:28PM +0200, Thomas Gleixner wrote:
> > > On Thu, 9 Jul 2009, Jarek Poplawski wrote:
> > > > On Thu, Jul 09, 2009 at 02:03:50PM +0200, Thomas Gleixner wrote:
> > > > > On Thu, 9 Jul 2009, Jarek Poplawski wrote:
> > > > > > > I have the feeling that the code relies on some implicit cpu
> > > > > > > boundness, which is not longer guaranteed with the timer
> > > > > > > migration changes, but that's a question for the network
> > > > > > > experts.
> > > > > >
> > > > > > As a matter of fact, I've just looked at this __netif_schedule(),
> > > > > > which really is cpu bound, so you might be 100% right.
> > > > >
> > > > > So the watchdog is the one which causes the trouble. The patch
> > > > > below should fix this.
> > > >
> > > > I hope so. On the other hand it seems it should work with this
> > > > migration yet, so it probably needs additional debugging.
> > >
> > > Right. I just provided the patch to narrow down the problem, but
> > > please test the fix of the hrtimer migration code which I sent out a
> > > bit earlier: http://lkml.org/lkml/2009/7/9/150
> > >
> > > It fixes a possible endless loop in the timer code which is related to
> > > the migration changes. Looking at the backtraces of the spinlock
> > > lockup I think that is what you hit.
> >
> > Actually, Andres and Joao hit this, and I hope they'll try these two
> > patches.
>
> Please test them separate from each other. The one I sent in this
> thread was just for narrowing down the issue, but I'm now quite sure
> that they really hit the issue which is addressed by the hrtimer
> patch.
No crash yet. 15min running (seconds to a minute before).

Will let it run for some hours to be sure.

Nice!

Andres
