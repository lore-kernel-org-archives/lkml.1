Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbXFDWOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbXFDWOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbXFDWOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:14:08 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50414 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbXFDWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:14:06 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Richard Purdie <rpurdie@openedhand.com>
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
Date: Mon, 4 Jun 2007 18:13:55 -0400
User-Agent: KMail/1.9.6
Cc: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Woodhouse <dwmw2@infradead.org>,
       Nitin Gupta <nitingupta910@gmail.com>
References: <1180971378.6313.72.camel@localhost.localdomain> <200706041337.51563.dhazelton@enter.net> <1180989955.6313.168.camel@localhost.localdomain>
In-Reply-To: <1180989955.6313.168.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041813.55419.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 16:45:55 Richard Purdie wrote:
> On Mon, 2007-06-04 at 13:37 -0400, Daniel Hazelton wrote:
> > Yes - most of that work, IIRC, is related to the alignment issues that
> > Herr Oberhumer noted. As it stands, the alternative does work well for a
> > large number of the platforms that the kernel supports. With a little
> > Kconfig magic it could be made available *only* for those platforms that
> > it currently supports. Then people can help work on the alignment issues
> > - possibly by providing platform conditional code.
>
> My patch was actually written with ARM machines in mind and has been
> extremely well tested on it. A version which doesn't run on ARM is not
> acceptable. Its also ironic that "platform conditional code" is what a
> lot of that bloat you're so keen to remove is about.

Done in a very poor manner.

> > I'm not familiar with the zlib code, but it was included a long time ago
> > - since zlib was included I'm pretty certain that if it had been proposed
> > today it would have been NACK'd for the style violations and bloat.
>
> Adrian's covered this. I also know how hard updating something like zlib
> is (I was the last person to do it).

I do agree. I have looked over the zlib code and it is very involved - I, 
personally, would not like to have to maintain it if I couldn't easily diff 
it against userspace.

> > You can take the time to produce a patch and spread FUD about the speed
> > of a competing patches code but you don't have the time to work on fixing
> > a cleaner implementation? I'll admit that actually working on fixing
> > problems in code can take more time, but still - the time taken for those
> > pursuits *could* have been spent actually working on fixing the problems.
>
> I *have* spent some time on it.
>
> My speed comments were actually pretty positive. Yes, I screwed up one
> of the benchmarks (as have others proving its easily done) but I did
> admit to it. My others were fair comment and some issues were addressed
> as a result (but not all).

I've looked back over the entire spread of the messages, both from before I 
wrote that quick&dirty benchmark and after. Maintainability is a good thing 
to aim for, however the style used to achieve the complete cross-platform 
mobility could be handled a lot cleaner - give me a few days to really study 
the LZO code and I'll see if I can't reach a middle-ground - code that is 
easy to maintain (and diff against userspace) as well as being stripped to 
its core and very cleanly implemented.

I can't promise results, but I figure I'm at fault for really starting this 
current spate of flames so I should at least take responsibility and do 
something to try and put them out. What I can say, at this point, is that a 
lot of my changes will be in making the code comply to kernel-style in a 
manner *similar* to how Nitin has done it - collapse redundant code together, 
replace open-coded blocks with calls to library functions, etc...


> I'm going to stop here. I don't agree with the rest of your email and
> you've a distorted view of whats been said.

Hindsight is sometimes too perfect. I should have returned to the early posts 
for clarity before making a lot of the comments I did. It shames me to admit 
that I've made such a nasty mistake and made myself seem like nothing more 
than a common troll.

Apologetically,
DRH
