Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbXCEANg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbXCEANg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXCEANf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:13:35 -0500
Received: from mail33.syd.optusnet.com.au ([211.29.132.104]:51282 "EHLO
	mail33.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbXCEANf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:13:35 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 5 Mar 2007 10:58:53 +1100
User-Agent: KMail/1.9.5
Cc: Al Boldi <a1426z@gawab.com>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703050849.29674.kernel@kolivas.org> <20070304231312.GA2268@1wt.eu>
In-Reply-To: <20070304231312.GA2268@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051058.54234.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 10:13, Willy Tarreau wrote:
> I've now given it a try with HZ=250 on my dual-athlon.

Great, thanks. The HZ should make very little difference, except for slightly 
lower latencies as you increase the HZ.

> It works 
> beautifully. I also quickly checked that playing mp3 doesn't skip during
> make -j4, and that gears runs fairly smoothly, since those are the
> references people often use.

Good. I obviously need to ensure that these remain well managed since I, for 
one, never want linux to suck on the desktop. In your case, I was more 
interested in your real world problems you were having so the rest of your 
report is even more important to me.

> But with real work, it's excellent too. When I saturate my CPUs by
> injecting HTTP traffic on haproxy, the load is stable and the command line
> perfectly responsive, while in the past the load would oscillate and the
> command line sometimes stopped to respond for a few seconds.
>
> I've also launched my scheddos program (you may remember, the one we did a
> few experiments with). I could not cause any freeze at all. Plain 2.6.20
> had already improved a lot in this area, but above 4 processes/CPU,
> occasional short freezes did still occur. This time, even at 100 processes,
> the system was rather slow (of course!) but just as expected, and nothing
> more.
>
> I also tried the good old "dd if=/dev/zero bs=1|...|dd bs=1 of=/dev/null"
> and it did not cause any trouble.
>
> I will boot 2.6 slightly more often to test the code under various
> conditions, and I will recommend it to a few people I know who tend to
> switch back to 2.4 after one day full of 2.6 jerkiness.
>
> Overall, you have done a great job !

Thank you very much. I think you have nicely pointed out some of the real 
world advantages to this design. Those testcases are good for testing average 
latency, fairness, and consistency of both of them under various loads so 
they are excellent real world examples. If you extrapolate those facts to 
server loads you can understand how the fairness and latency can translate 
into advantages anywhere.

> I hope that more people will give it a try, first to help find possible
> remaining bugs, and to pronounce in favour of its inclusion in mainline.

Thanks. I've already had a hundred or so people testing this code (thanks to 
the -ck mailing list people!) without any recent bugs prior to announcing it 
to lkml so I believe it is quite safe for testing.

-- 
-ck
