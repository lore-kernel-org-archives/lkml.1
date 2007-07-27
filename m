Return-Path: <linux-kernel-owner+w=401wt.eu-S1763604AbXG0SI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763604AbXG0SI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbXG0SIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:08:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4815 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754642AbXG0SIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:08:36 -0400
Date: Fri, 27 Jul 2007 12:04:54 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: Arjan van de Ven <arjan@infradead.org>, david@lang.hm,
       Igor Stoppa <igor.stoppa@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Power Management framework proposal
Message-ID: <20070727120453.GE11895@ucw.cz>
References: <1185091022.19678.28.camel@localhost.localdomain> <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm> <1185105911.29238.43.camel@localhost.localdomain> <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm> <1185145766.2714.27.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707221914550.6350@asgard.lang.hm> <1185162647.2714.35.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707222054060.6350@asgard.lang.hm> <1185164357.2714.49.camel@laptopd505.fenrus.org> <20070723085636.GA4123@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723085636.GA4123@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > let me give you a real world example then, and the numbers I'm using are
> > ballpark the same as you'll find in a (mobile) core 2 duo datasheet, I
> > just rounded them a little so that the math works out nice.
> > 
> > power at full speed: 34W
> > power at half speed: 24W
> > power at idle: 1W
> 
> I have usually seen different numbers, for example:
> 
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30430.pdf

Trust Arjan, modern cpus work as he describes.

> Although this paper speaks about thermal design power instead of power
> consumption, i suppose that it should be roughly equal.
> 
> For example Athlon 64 3700 (ADA3700AEP5AR):
> 
> 2.4 GHz, 1.5 V -> 89 W
> 2.2 GHz, 1.4 V -> 72 W
> 2.0 GHz, 1.3 V -> 53 W
> 1.8 GHz, 1.2 V -> 39 W
> 1.0 GHz, 1.1 V -> 22 W

I guess that means athlon 64 is 'old'.

> Even my measurement on PC (Athlon X2, VIA K8T890) of complete PC power
> consumption shows that it is more efficient to be busy for 2 time units
> on 1 GHz than be busy for 1 time unit and be idle for 1 time unit
> on 2 GHz.
> 
> 1 GHz:
> both cores idle:	48 W
> one core busy:		57 W
> two cores busy:		66 W

2 sec decoding video at both cores: 132J

> 2 GHz:
> both cores idle:	54 W
> one core busy:		78 W
> two cores busy:		95 W

1 sec decode @ 2GHz + 1 sec idle @ 1GHz: 143J

So even on your hw difference is not too big... and take a look at
numbers from core2duo.

Actually...

4 sec decode @ 1 core @ 1GHz: 57*4=228J
1 sec decode @ 2 cores @ 2GHz, then idle: 95 + 48*3 = 142+95 = 235J...

Ok, so it is still 	 win, but even smaller one..
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
