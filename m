Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZG3Kx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZG3Kx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZG3Kx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:53:56 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:35999 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZG3Kx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:53:56 -0400
Date: Thu, 30 Jul 2009 12:53:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: dwalker@fifo99.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
Message-ID: <20090730125351.6f16e9ec@skybase>
In-Reply-To: <200907291717.n6THHG6f001426@d06av06.portsmouth.uk.ibm.com>
References: <200907291717.n6THHG6f001426@d06av06.portsmouth.uk.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 11:17:16 -0600
dwalker@fifo99.com wrote:

> On Wed, 2009-07-29 at 19:09 +0200, Martin Schwidefsky wrote:
> > On Wed, 29 Jul 2009 11:02:21 -0600
> > dwalker@fifo99.com wrote:
> > 
> > > On Wed, 2009-07-29 at 18:50 +0200, Martin Schwidefsky wrote:
> > > 
> > > > void clocksource_change_rating(struct clocksource *cs, int rating)
> > > 
> > > > the two functions do different things. What exactly is the idea you've
> > > > got in mind?
> > > 
> > > It's only the case when the rating goes to zero .. That makes the
> > > clocksource unusable, which is very much like unregistering it..
> > 
> > True, the clocksource code won't pick the clock any more as long as
> > there is an alternative clock available. It still shows up in the list
> > of clocks though and you can do an override with it. 
> 
> I'm not sure allowing that type of override a good idea tho .. I don't
> think it's considered a usable clock when the rating goes to zero.

Override as the root user -> your foot, no? The whole override stuff is
there for the case that the clocksource selection picked a broken clock
and you want to force the system into a semi-working state. Ideally the
whole override would go away, but that is probably wishful thinking..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

