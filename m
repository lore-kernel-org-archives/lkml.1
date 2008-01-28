Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYA1VqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYA1VqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYA1VqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:46:17 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46806 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYA1VqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:46:16 -0500
Date: Mon, 28 Jan 2008 23:46:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: ltp-list@lists.sourceforge.net, risrajak@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [LTP] [TEST] : LTP Build failure on 2.6.24 kernel
Message-ID: <20080128214642.GD8767@does.not.exist>
References: <1201508081.4029.4.camel@localhost.localdomain> <200801281543.17816.vapier@gentoo.org> <20080128211046.GC8767@does.not.exist> <200801281621.02758.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801281621.02758.vapier@gentoo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 04:21:01PM -0500, Mike Frysinger wrote:
> On Monday 28 January 2008, Adrian Bunk wrote:
> > On Mon, Jan 28, 2008 at 03:43:16PM -0500, Mike Frysinger wrote:
> > > On Monday 28 January 2008, Adrian Bunk wrote:
> > > > On Mon, Jan 28, 2008 at 06:53:15AM -0500, Mike Frysinger wrote:
> > > > > On Monday 28 January 2008, Rishikesh K. Rajak wrote:
> > > > > > Here i am getting failure on the x86_64 machine with new kernel.
> > > > > >
> > > > > > Here is the uname for that machine:
> > > > > >
> > > > > > rishi@:~/ltp-full-20071231# uname -a
> > > > > > Linux rishi.in.ibm.com 2.6.24 #1 SMP PREEMPT Mon Jan 28 06:47:28
> > > > > > UTC 2008 x86_64 GNU/Linux
> > > > >
> > > > > i'm guessing you're using ubuntu and thus dash is your /bin/sh ...
> > > > > shouldnt be a 2.6.24 issue
> > > > >
> > > > > > make[4]: Entering directory
> > > > > > `/root/ltp-full-20071231/testcases/network/tcp_cmds/ftp'
> > > > > > ../../generate.sh
> > > > > > ../../generate.sh: 60: arith: syntax error: "cnt=cnt-1"
> > > > >
> > > > > sadly, this is becoming a FAQ.  ubuntu ships a broken /bin/sh (dash)
> > > > > and thus some LTP scripts fall apart.  i would prefer to not change
> > > > > the scripts as the message is simple in LTP: fix your shell, dont add
> > > > > hacks to LTP.  otherwise we slowly back ourselves into this corner
> > > > > with the shell scripts where we try to support every craptastic shell
> > > > > out there and we're afraid to make any changes because we dont know
> > > > > what crappy shell is going to drop a brick.  LTP scripts are written
> > > > > to be POSIX complaint and only POSIX complaint shells should be
> > > > > provided by /bin/sh.
> > > >
> > > > You better fulfil your claim "LTP scripts are written to be POSIX
> > > > complaint" before complaining about shells being unhappy with your
> > > > script. E.g. where in IEEE 1003.1-2004 is the "local" you use
> > > > specified?
> > >
> > > yes, local is a bsd extension not in POSIX.  it has been implemented by
> > > every shell so far though.  as soon as someone complains, i'll be more
> > > than happy to fix it.
> >
> > David Korn's ksh93 (e.g. shipped in the Debian "ksh" package) disproves
> > your claim "it has been implemented by every shell so far".
> 
> sorry, i left out the operative word "relevant".  i dont care what random 
> shell fails unless people are actually utilizing it as their /bin/sh in any 
> sort of useful context.  as soon as someone complains for real and not just 
> to be annoying, i'll address their complaint then.
>...

You started with claiming "LTP scripts are written to be POSIX 
complaint" and now that I've shown you a not that uncommon IEEE POSIX 
1003.2 compliant shell that can't cope with your non-POSIX script you 
suddenly introduce the word "relevant".

But when you care only about "relevant" shells you could simply 
implementing my suggestion of placing a #!/bin/bash at the top of your 
scripts instead of defining your own POSIX superset that you require 
from a /bin/sh for allowing a user to execute your script...

> -mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

