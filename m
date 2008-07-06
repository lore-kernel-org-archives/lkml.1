Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYGFOOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYGFOOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbYGFOON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:14:13 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:15844 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755877AbYGFOOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:14:12 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2008 10:14:12 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgEANexXkh5LDuR/2dsb2JhbACBWoldowc
X-IronPort-AV: E=Sophos;i="4.30,310,1212330600"; 
   d="scan'208";a="151182161"
Date: Mon, 7 Jul 2008 00:08:58 +1000 (EST)
From: Tim Connors <tim.w.connors@gmail.com>
To: Joe Peterson <joe@skyrush.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Alan Cox <alan@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: tty session leader issue (was Re: 2.6.25.3: su gets stuck for
 root)
In-Reply-To: <486BC30C.6010705@skyrush.com>
Message-ID: <alpine.DEB.1.10.0807062353450.30385@scuzzie.rather.puzzling.org>
References: <48438126.3080308@t-online.de>  <20080604171056.GB17875@devserv.devel.redhat.com>  <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>  <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>  <485323C5.4030002@skyrush.com> 
 <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>  <48540343.4010200@skyrush.com>  <19f34abd0806141334w67547e84hf1021c0fd1139b8b@mail.gmail.com>  <48542F75.5070605@skyrush.com> <19f34abd0806141426o7ba13f91h6720db3609146e16@mail.gmail.com>
 <486BC30C.6010705@skyrush.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008, Joe Peterson wrote:

> I have done some more investigation on this problem, and I am posting
> here my results in hope that someone can point me in the right direction
> for further investigation...
>
> Summary: during the initialization of a new bash shell, the terminal
> foreground process group often reverts back to that of the parent of the
> bash shell (after being set *to* the bash shell pgrp by bash),
> prohibiting commands like stty from being run by the init scripts.  The
> result is that the execution of these commands will hang until killed,
> causing the bash prompt to not appear.  Adding a delay in the script
> (using sleep) increases the chance of this having time to happen.
...
> So here is the question: is there a way/reason the kernel would revert
> the pgrp of the session leader after bash sets it?  Is there some more
> instrumenting in the kernel or in bash that might reveal what is going
> on?  I have heard yet another report of this happening since I added to
> the thread, and I can get it to happen easily on two different machines
> (a desktop and a laptop).

In fact, in various laptops (Eeeepc, dell inspiron 1520, Dell inspiron
4000), I've got various tty screwups that have been introduced since
circa 2.6.19.

The 6 year old inspiron 4000 gets stuck at stty erase ^? .  Randomly, but
most of the time.

All of my machines exhibit the ctrl-C being slower than ctrl-Z discussed
elswhere (I've almost developed a habit of typing ctrl-Z kill %1 <RET>).
Although even ctrl-Z recently has been reluctant to always work.  I wonder
if this is the cause of dpkg recently not responding to ctrl-Z's? (debian
bug #486222).  dpkg does respond to kill -STOP

ctrl-s doesn't always work anymore.  Again, what prompted me to write this
email, was I couldn't pause dpkg.  It's particularly unreliable at
stopping scrolling messages at bootup, and if I press it at the wrong time
at bootup (not a specific place - it can be starting up any number of
scripts), something deadlocks and won't resume upon a ctrl-q.
alt-sysrq-k is enough to kill whatever has deadlocked.  I have a feeling,
but don't want to test on this system right now, that pressing scroll-lock
as opposed to ctrl-q once unlocked such a stuck display.

In summary, something in tty is certainly screwed.  Does anyone see a
connection between all of these?

-- 
TimC
> cat ~/.signature
Electromagnetic pulse received (core dumped)
