Return-Path: <linux-kernel-owner+w=401wt.eu-S1422780AbXBAMQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422780AbXBAMQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 07:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422830AbXBAMQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 07:16:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422780AbXBAMQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 07:16:07 -0500
Date: Thu, 1 Feb 2007 13:14:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, arjan@infradead.org,
       tglx@linutronix.de, johnstul@us.ibm.com, Andrew Morton <akpm@osdl.org>
Subject: Re: [-mm patch] x86_64 GTOD: offer scalable vgettimeofday
Message-ID: <20070201121417.GA3900@elte.hu>
References: <20070201095952.589234000@jet.suse.cz> <20070201114644.GB26453@elte.hu> <200702011301.51834.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011301.51834.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> > The 'price' paid for it is lower resolution - but it's still good 
> > for those benchmarking TPC-C runs - and /alot/ simpler. It's also 
> > quite a bit faster than any TSC based vgettimeofday, because it 
> > doesnt have to do an RDTSC (or RDTSCP) instruction nor any 
> > approximation of the time.
> 
> I believe that should be also a separate clock_gettime() CLOCK_
> 
> Global settings for these things are bad. Even if you run TPC-C you 
> don't want your other programs that rely on monotonic time to break.

yeah. But maybe still there should still be an 'easy' option for people 
to consciously degrade the resolution of gettimeofday(), in exchange for 
more performance. There are systems where gettimeofday already has such 
resolution, so apps certainly shouldnt break from this. But i agree with 
you: that's why i made this default-off, and the CLOCK_ option could be 
a way for apps to reliably get this behavior, independently of the 
global setting (hence driving the migration of affected apps to this new 
CLOCK_ thing). Hm?

	Ingo
