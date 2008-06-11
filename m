Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYFKUbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYFKUbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbYFKU3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:29:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:60482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbYFKU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:29:32 -0400
Date: Wed, 11 Jun 2008 13:29:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: markh@compro.net
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Message-ID: <20080611132921.08985eb9@infradead.org>
In-Reply-To: <48501159.4050908@compro.net>
References: <200806102152.23286.solstice.dhiver@gmail.com>
	<20080610131314.5f7069e6@infradead.org>
	<484EE71A.40002@intel.com>
	<alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>
	<20080611063639.5e1eea5b@infradead.org>
	<alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr>
	<20080611065816.6cff290d@infradead.org>
	<Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com>
	<20080611083644.32afc823@infradead.org>
	<4850046C.4070602@compro.net>
	<20080611104446.3b0ce2d9@infradead.org>
	<48501159.4050908@compro.net>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 13:54:33 -0400
Mark Hounschell <markh@compro.net> wrote:

> > 
> > ondemand governor will change the cpu frequency dynamically all the
> > time.
> > the cpu itself has a dynamic range in which it operates (at least on
> > cpus that support Intel Dynamic Acceleration technology, IDA)
> > 
> 
> OK. If I am always using AMD Opteron/X64 class machines am I safe here
> when no cpu freq scaling stuff is on and I'm pinned to a particular
> processor?

today, yes. What AMD will do in the next stepping? Only they will know.

> 
> >>> 2) the rdtsc "frequency" is conceptually unrelated to cpu
> >>> frequency. In fact, you'll be hard-pressed to buy a system today
> >>> where this relationship works....
> >>>
> >> And what do you mean by "conceptually unrelated to cpu frequency"?
> >> Is it not the clock freq that is driving the cpu and the freq at
> >> which the tsc is incremented?
> > 
> > no it is not that... at all.
> > the tsc comes from an entirely different clock, and on anything you
> > can buy today from AMD or Intel (or the last year for that matter),
> > it's fixed frequency (except in idle) irrespective of the frequency
> > the CPU is operating at!
> > it's a "time stamp counter" not a "cpu cycle counter". You can run
> > instructions faster than the tsc increment or slower. Or sometimes
> > at the same rate.
> > Which it is depends on what cpufreq/ondemand are doing and how
> > active IDA is.
> > 
> 
> I was under the impression that it was the same clock on AMD Opteron
> and newer processors.

for them it's the same: it's independent of the actual cpu clock.
(and constant rate; to be constant rate you pretty much HAVE to be
independent, because you CAN do cpu frequency scaling, even if you as
user decide to not use it)
> 
> So if all this is true how and why can the kernel use it but user
> land is wrong for doing so?
> 

the kernel doesn't (really) use the frequency (other than reporting it
in /proc). And with tsc it is very very careful.

