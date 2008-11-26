Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYKZDxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYKZDxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYKZDxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:53:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYKZDxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:53:12 -0500
Date: Wed, 26 Nov 2008 04:52:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       lethal@linux-sh.org, mingo@redhat.com
Subject: Re: [RFC] Reentrant clock sources
Message-ID: <20081126035251.GA3707@elte.hu>
References: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se> <alpine.LFD.2.00.0811252215270.3235@localhost.localdomain> <20081126030720.GC8242@elte.hu> <1227669624.6298.11.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227669624.6298.11.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> On Wed, 2008-11-26 at 04:07 +0100, Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > > +	cycle_t (*vread)(struct clocksource *cs);
> > > 
> > > This is crap. vread can not access the clocksource.
> > 
> > i think 'reentrant' in the sense of creating self-sufficient driver 
> > entities. vread wont (and shouldnt) call ->vread() recursively - but 
> > it might want to access fields on the clocksource.
> 
> I think Thomas' issue is that vread() *cannot* access fields on the 
> clocksource (since vread has to be careful not to access any 
> non-vsyscall mapped memory).

ah, yeah - i was thinking about ->read().

in a more dynamic driver model the clocksource driver could store 
dynamic data like target port/memory address next to the clocksource 
driver, and access that - if the driver pointer is passed in.

> However not all clocksources use vread(), but really I'm not quite 
> clear on what one would want to access in the clocksource structure 
> when making a ->read() call.
> 
> So maybe a further description of what specific need motivates this 
> change would be helpful? The brief description of power management 
> doesn't quite click in my head yet.

yeah, that would be nice.

	Ingo
