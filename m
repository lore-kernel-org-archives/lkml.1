Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYGEMuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYGEMuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 08:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYGEMuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 08:50:05 -0400
Received: from nebensachen.de ([195.34.83.29]:47455 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYGEMuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 08:50:03 -0400
X-Hashcash: 1:20:080705:andi@firstfloor.org::MTXkBJ70EPgW6ks4:0000000000000000000000000000000000000000005pCT
X-Hashcash: 1:20:080705:alan@lxorguk.ukuu.org.uk::culeb3sn6eFW7xWy:00000000000000000000000000000000000000n0F
X-Hashcash: 1:20:080705:joe@skyrush.com::PiPAOpJ2u9B30ny9:002bqB
X-Hashcash: 1:20:080705:edwintorok@gmail.com::ysq1KECi/fCJs0FC:000000000000000000000000000000000000000000rPk
X-Hashcash: 1:20:080705:linux-kernel@vger.kernel.org::+evG1WgVa+P/LiSz:0000000000000000000000000000000005O+6
From: Elias Oltmanns <eo@nebensachen.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Peterson <joe@skyrush.com>,
       =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>
	<486E83C3.1040509@skyrush.com>
	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
	<871w29s5u2.fsf@basil.nowhere.org>
	<20080704221457.1f147225@lxorguk.ukuu.org.uk>
	<486E97F2.8020605@firstfloor.org>
	<20080704224441.63204bc4@lxorguk.ukuu.org.uk>
	<486E9F91.6010701@firstfloor.org>
	<20080705113434.41109492@lxorguk.ukuu.org.uk>
	<486F543D.8010409@firstfloor.org>
Date: Sat, 05 Jul 2008 14:49:47 +0200
In-Reply-To: <486F543D.8010409@firstfloor.org> (Andi Kleen's message of "Sat,
	05 Jul 2008 13:00:13 +0200")
Message-ID: <87y74gpkb8.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The discussion seems to have become a little heated, so allow me to step
in here ...

Andi Kleen <andi@firstfloor.org> wrote:
> Alan Cox wrote:
[...]
>  I can't reproduce it, nobody has provided
>> numbers so even if I wanted to work on it I couldn't do much.
>
> Well we had a patch (although I haven't tried it yet)
>
> http://marc.info/?l=linux-kernel&m=121489861508496&w=2
>
> Is that not concrete enough?

Actually, I'm not to sure whether this really fixes the root cause of
the problem -- I never have been and I meant to indicate as much in my
email. It's been the first time I looked at the tty code and the patch
was mainly guess work; all it does is reverting parts of a previous
patch. My hope was to direct other people's (read: those who no the tty
code) attention to a change that seemed to cause the problem. Perhaps I
didn't make it clear enough at the time that I didn't really know *why*
this change should cause any problem in the first place.

Now, the situation has become even more delicate. Joe has reported that
my patch breaks echoing in the xterm and, rather to my embarrassment, I
have to report that it doesn't even fix the issue I claumed it would.
All it apparently does is making the problem slightly harder to
reproduce which is why it didn't occur in my tests at the time.

Since I have been concentrating on other things over the last days, it's
been only today that I discovered this. Moreover, some more testing lead
me to believe that the root issue has been present in mainline at least
since 2.6.19 and Joe's change in 2.6.25 only made it visible because you
now occasionally get something like
^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z

on your screen when you keep pressing Ctrl+Z until the prompt appears;
in 2.6.24, for instance, there would just be a short delay but no
irritating output on the screen that makes you wonder.

Quite frankly, I'm a bit at a loss as to how I should go about debugging
this and what kind of data might be useful to others to do so. In
another email Alan talked about latency traces which is something new to
me. Since the OP talked about latencytop, I hope that this tool provides
the data Alan requires and will install and make use of it accordingly
(expect some results later today or tomorrow). Of course, I'm always
open to other / additional suggestions.

Regards,

Elias
