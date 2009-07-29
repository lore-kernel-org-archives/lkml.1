Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbZG2Rei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbZG2Rei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZG2Reh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:34:37 -0400
Received: from fifo99.com ([67.223.236.141]:47509 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZG2Reh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:34:37 -0400
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090729190938.1e4c45e9@skybase>
References: <200907291702.n6TH2LEt017305@d06av05.portsmouth.uk.ibm.com>
	 <20090729190938.1e4c45e9@skybase>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 10:34:37 -0700
Message-Id: <1248888877.6046.11.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 19:09 +0200, Martin Schwidefsky wrote:
> On Wed, 29 Jul 2009 11:02:21 -0600
> dwalker@fifo99.com wrote:
> 
> > On Wed, 2009-07-29 at 18:50 +0200, Martin Schwidefsky wrote:
> > 
> > > void clocksource_change_rating(struct clocksource *cs, int rating)
> > 
> > > the two functions do different things. What exactly is the idea you've
> > > got in mind?
> > 
> > It's only the case when the rating goes to zero .. That makes the
> > clocksource unusable, which is very much like unregistering it..
> 
> True, the clocksource code won't pick the clock any more as long as
> there is an alternative clock available. It still shows up in the list
> of clocks though and you can do an override with it. 

Now that you mention it, if the clocks are sorted by rating (something
your removing) then the sysfs override available listing isn't in rated
order .. So if you do have zero rated clocks you wouldn't have any idea
from looking at the available list.. It could be solved just by printing
them in rated order in the sysfs code tho.

