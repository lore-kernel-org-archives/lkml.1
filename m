Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXJNIza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXJNIza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 04:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXJNIzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 04:55:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40603 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbXJNIzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 04:55:15 -0400
Date: Sun, 14 Oct 2007 11:55:12 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Willy Tarreau <w@1wt.eu>
cc: Adrian Bunk <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       stable@kernel.org, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.21 review 12/35] TCP: Fix TCP handling of SACK in
 bidirectional flows.
In-Reply-To: <20071013181045.GB18155@1wt.eu>
Message-ID: <Pine.LNX.4.64.0710141129190.24841@kivilampi-30.cs.helsinki.fi>
References: <20071013142822.%N@1wt.eu> <20071013143452.%N@1wt.eu>
 <Pine.LNX.4.64.0710132007430.27718@kivilampi-30.cs.helsinki.fi>
 <20071013172214.GA18155@1wt.eu> <20071013175036.GD4211@stusta.de>
 <20071013181045.GB18155@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007, Willy Tarreau wrote:
> On Sat, Oct 13, 2007 at 07:50:36PM +0200, Adrian Bunk wrote:
> > On Sat, Oct 13, 2007 at 07:22:14PM +0200, Willy Tarreau wrote:
> > >...
> > > Thanks for your help, I really appreciate it. In fact, I've reviewed them
> > > four, but two of them did not apply and the code looked somewhat different,
> > > so I considered them irrelevant to 2.6.20. I didn't understand that they
> > > were all related, so maybe I checked them in a wrong order.
> > > 
> > > I'll recheck all that in the right sequence and will merge them four, or
> > > get back to you if something still puzzles me.
> > 
> > I discussed this issue with Ilpo just yesterday regarding 2.6.16, and 
> > the result of our discussion was that I reverted it.
> 
> OK.
> 
> > TCP being in some situations a bit more conservative than it should be 

This of course understatement from what I wrote about the performance:
"I would rather put it this way: Without those four patches TCP
just is very much more conservative than with them but still
works. " Emphasis on word very. Yet this isn't a correctness issue.

> > isn't a big issue and not worth backporting with a risk of introducing
> > a regression.

I agree that it's not that big issue due to the cases that are affected. 
The flow must simulataneously be bidirectional and get at least one of the 
directions to suffer from congestion. Considering that this problem has 
been there very long (definately predates 2.6 series, probably it has 
occured since ratehalving was added, I don't know when), and nobody has 
complained because of poor performance, I'd claim it's highly unlikely 
they will, in the near future... :-)

> I agree with this. The impression I got from the description of the two
> patches I merged was that the problems they fix were quite annoying. But
> maybe I should take that with a grain of salt.

No, it's not a grain of salt. I would say its utterly broken, out loud. 
But many people are not that much into time-seq graphs (that I'm familiar 
with), they are pleased when it seems to work well enough even though 
from my perspective, it is simply unacceptable in worst cases (not 
speaking of theoretical ones here, have seen very bad performance). Not 
that it always is that bad, depends on phase of the opposite direction 
what happens.

Somebody asked me when those four patches were made about this, I put 
these there back then:

http://www.cs.helsinki.fi/u/ijjarvin/bidir-showcase/

They are generated from my old test archives and thus may have a bit 
differences in TCP variant, which may slightly differ from mainline
here and there (my point was just to show how it breaks). Typical 
people wouldn't even notice those minor differences compared with the 
bidir brokeness which is very visible in all except in the fixed "ok"
case. Please judge for yourself whether I overexaggrated or not... :-)


-- 
 i.
