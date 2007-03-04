Return-Path: <linux-kernel-owner+w=401wt.eu-S1750895AbXCDXNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895AbXCDXNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXCDXNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:13:25 -0500
Received: from 1wt.eu ([62.212.114.60]:4945 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbXCDXNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:13:24 -0500
Date: Mon, 5 Mar 2007 00:13:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Al Boldi <a1426z@gawab.com>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Message-ID: <20070304231312.GA2268@1wt.eu>
References: <200703042335.26785.a1426z@gawab.com> <200703050849.29674.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703050849.29674.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 08:49:29AM +1100, Con Kolivas wrote:
(...)
> > That's just what it did, but when you "nice make -j4", things (gears) start
> > to stutter.  Is that due to the staircase?
> 
> gears isn't an interactive task. Apart from using it as a background load to 
> check for starvation because it loads up the cpu fully (which a gpu intensive 
> but otherwise simple app like this should _not_ do) graphics card drivers and 
> interrupts and so on, I wouldn't put much credence on gears as anything else. 
> However I suspect that gears will still get a fair share of the cpu on RSDL 
> which almost never happens on any other scheduler.

Con,

I've now given it a try with HZ=250 on my dual-athlon. It works beautifully.
I also quickly checked that playing mp3 doesn't skip during make -j4, and
that gears runs fairly smoothly, since those are the references people often
use.

But with real work, it's excellent too. When I saturate my CPUs by injecting
HTTP traffic on haproxy, the load is stable and the command line perfectly
responsive, while in the past the load would oscillate and the command line
sometimes stopped to respond for a few seconds.

I've also launched my scheddos program (you may remember, the one we did a
few experiments with). I could not cause any freeze at all. Plain 2.6.20 had
already improved a lot in this area, but above 4 processes/CPU, occasional
short freezes did still occur. This time, even at 100 processes, the system
was rather slow (of course!) but just as expected, and nothing more.

I also tried the good old "dd if=/dev/zero bs=1|...|dd bs=1 of=/dev/null" and
it did not cause any trouble.

I will boot 2.6 slightly more often to test the code under various conditions,
and I will recommend it to a few people I know who tend to switch back to 2.4
after one day full of 2.6 jerkiness.

Overall, you have done a great job !

I hope that more people will give it a try, first to help find possible
remaining bugs, and to pronounce in favour of its inclusion in mainline.

Cheers,
Willy

