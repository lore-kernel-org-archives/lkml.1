Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbXHCIpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbXHCIpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 04:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbXHCIo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 04:44:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36057 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbXHCIo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 04:44:58 -0400
Date: Fri, 3 Aug 2007 10:44:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070803084436.GC19284@elte.hu>
References: <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801112229.GA11710@elte.hu> <20070803030436.GO11166@waste.org> <1186113467.3996.0.camel@laptopd505.fenrus.org> <20070803043800.GE11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803043800.GE11115@waste.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> > question is if it's significantly worse than before. With a 100 or 
> > 1000Hz timer, you can't expect perfect fairness just due to the 
> > extremely rough measurement of time spent...
> 
> Indeed. I'm just pointing out that not having TSC, fast HZ, no-HZ 
> mode, or high-res timers should not be treated as an unusual 
> circumstance. That's a PC-centric view.

actually, you dont need high-res or fast HZ or TSC to reduce those timer 
artifacts: all you need is _two_ (low-res, slow) hw clocks.

Most platforms do have that (even the really really cheap ones), but 
arches do not set up the scheduler tick one of them and the timer tick 
to the other, and to skew the periodic-timer programming setup a bit (by 
nature of physics they are usually already skewed a bit) so that the 
scheduler tick and timer tick are not coupled. This whole thing is not a 
big deal on embedded anyway. (you dont get students log in to the 
toaster or to the fridge to run timer exploits, do you? :-)

	Ingo
