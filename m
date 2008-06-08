Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYFHXg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYFHXg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 19:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbYFHXgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 19:36:48 -0400
Received: from wsip-70-184-212-2.om.om.cox.net ([70.184.212.2]:41709 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbYFHXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 19:36:47 -0400
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: bcm33xx port
Date: Sun, 8 Jun 2008 18:36:37 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
References: <200806072113.26433.luke@dashjr.org> <200806081527.31221.luke@dashjr.org> <Pine.LNX.4.55.0806082249330.15673@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806082249330.15673@cliff.in.clinika.pl>
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081836.42351.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 June 2008, Maciej W. Rozycki wrote:
> On Sun, 8 Jun 2008, Luke -Jr wrote:
> > Is merging with mainline something I can help with, being a beginner in
> > this area generally and not having any part in writing them?
>
>  Well, you can certainly serve as a messenger telling them if they want
> people to get proper support from upstream maintainers they better merge
> sooner rather than later.

Apparently the reason for lack of merge is due to missing (proprietary?) 
drivers for DSL, Ethernet, and WiFi on the bcm63xx platform. I'll pass on 
the "incomplete is ok" message, though, and hopefully that will help :)

>  The general principle is: "merge as soon as you can, even if code is
> incomplete" as you get more attention and perhaps developers involved as a
> result, some free support (e.g. with bulk changes done automatically to
> all the relevant bits in the tree) and avoid duplicated work; also when at
> the time of the merge you are told to rewrite your code differently.

Does this apply even to my trivial/barely begun attempts so far? When bcm63xx 
gets merged, should I be planning to merge my stuff even before it boots?

> > >  Not exactly.  Try harder -- this is simple arithmetic and you've got
> > > all the data given above already. :)
> >
> > 200 / 2? I'm not really sure what a 'jiffy' is..
>
>  Hmm, I have thought it can be inferred from the code involved or failing
> that -- Google...  Well, anyway, a jiffy is a tick of the kernel timer or,
> specifically in this context and to be more precise, the interval between
> such two consecutive ticks or, in other words, 1/HZ.

jiffy = 1 / 200000 HZ = 0.000005 sec/tick
loop = 200000 instructions / 2 instructions per loop = 100000 loops/sec

So 0.00000000005 loops per jiffy? But it can't be, since loops_per_jiffy isn't 
floating point... :/

> > >  I have seen that already and wrote these stores in __bzero are
> > > protected. Perhaps the fixup fails for some reason, but you need to
> > > investigate it and this is why I suggested to see how the RI handler is
> > > reached.  Since this is a known point the failure leads to, you should
> > > be able to work backwards from there quite easily.
> >
> > Ah, so what you're saying is that perhaps the 'sw' is triggering a TLB
> > exception, and the handler for *that* is causing the RI problem?
>
>  This is almost certain what happens here.  The pointer involved is a
> valid (user) address and is correctly aligned, so you cannot get an
> address error exception.  A TLB exception is next on the list to check.

Is there an easy way to printk out a complete trace of the exception stack?
