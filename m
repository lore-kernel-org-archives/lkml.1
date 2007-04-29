Return-Path: <linux-kernel-owner+w=401wt.eu-S1161306AbXD2U7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161306AbXD2U7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161295AbXD2U7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:59:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:38035 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161151AbXD2U71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:59:27 -0400
Cc: linux-dvb@linuxtv.org, mkruky@linuxtv.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 29 Apr 2007 22:59:25 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
Message-ID: <20070429205925.129920@gmx.net>
MIME-Version: 1.0
References: <20070429182209.267430@gmx.net>
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
Subject: Re: Critical points about kernel 2.6.21 and pseudo-authorities
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18+JYQFZQM+vTosqcNOa7SisIMK2kuCJwyOCfFfaC
 GCgVGOsOEugoSQoPn6uhoYVK0odR4S99f6MQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: FD8DD4h1QEV/CjO4FnVprOpCNzg2NYJg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Sun, 29 Apr 2007 11:49:40 -0700 (PDT)
Von: Linus Torvalds <torvalds@linux-foundation.org>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mchehab@infradead.org, mkruky@linuxtv.org, linux-dvb@linuxtv.org
Betreff: Re: Critical points about kernel 2.6.21 and pseudo-authorities

> 
> 
> On Sun, 29 Apr 2007, Uwe Bugla wrote:
> > 
> > And now comes the critical point:
> > If I use kernel 2.6.21 in connection with git2 (NOT: git1) everything is
> fine so far.
> 
> Sounds like the sis900 network driver problem.

Hi Linus,
I thought that this problem could be reduced to the sis900 driver issue, but today I found out that I was wrong. In so far:
The kernel 2.6.21 official kernel makes my router hang up
The kernel 2.6.21-git1 makes my router hang up

Simply the 2.6.21-git2 is running stable.

CLEARER: The sis900 patch is part of git1. In so far it cannot and will never be the real reason for the kernel Oopses on my router.

I have been trying diff and other tools in various variants (except git-bisect that I cannot handle because I do not understand the practice of it).
I did not manage to find out what part of the git2-code is necessary to make my AMD K7 router run stable. It is somewhere right between git1 and git2 - that is all I can say about that. It is definitely NOT the NIC issue.
> 
> > BUT: This 2.6.21-git2 is unusable in so far as it contains regressive
> code
> > in the dvb-section, authored by Trent Piepho, acked by Michael Krufky,
> and signed-off-by Mauro Carvalho Chehab:
> 
> You never explained what the problem even was, apart from compiling in 
> some code that you didn't need to before. Didn't it work in the end?

Yes it works, but it is a regression in so far as I was fighting and arguing to get rid of some useless module attachments in the past which was then put into practice as solution done by Michael Krufky in a very sophisticated and fine manner.

With the git2 solution I am condemned to waste RAM with at least one module that my card and a whole lot of other cards never needed. In so far it is a fallback and regression (like the router code that made floppy mounting impossible at the beginning of 2.6.21-rc1 or so, if you can remember this...
You decided to rip that buggy stuff out - and this was a fine decision!

I like small and effective kernels instead of blown up RAM waste.
This is no Windoze, man, this is Linux!
> 
> If it worked, I don't see what the big issue was. You are getting a _lot_ 
> of other code in the kernel that you probably never use, you may not even 
> have realized.

May be, don't know! But wouldn't it be a nice trait to at least get rid of unusable code that the specific machine does not need at all?

Now, if that aim sounds too abrasive, what's the use of kernel compilation then?
Do you expect me to accept a Kernel of a size of 2 or 3 Megabytes, with module support completely disabled and the RAM overcrowded with modules that I never needed?

In the specific example of git2's dvb code you cannot disable the compilation of dvb-pll.c if you use the v4l normal layer (VIDEO_V4L1).

If you are forced to use the v4l compat layer (VIDEO_V4L1_COMPAT) to enable a specific group of cards you do not have any chance to get rid of this module!

Now - if this is no serious bug or regression, please what else is a serious bug or regression then?

> 
> Uwe, you really aren't helping yourself by being so damn abrasive. I know 
> for a fact that your bug-reports are going ignored by some people, and I'm
> not surprised at all.

Now what a gesture?
I can show you a ten Emails long ping pong game between Mauro and me which will prove you simply that Mauro Chehab never even did a five minutes look on my contributions.
Instead he spent three quarters of an hour or so to offer me nothing but
1. Lies
2. Unproved Theses
3. Unproved Assumptions

With only one strategic aim: Fighting me down to make me give up, nothing else!

Now Linus, how would you feel in my situation?
Should I call this man a maintainer?
Would you call this man a maintainer?

See, I have had such a many positive experiences since I actively engaged in Linux.
With maintainers, with quite a lots of other real fine people.

And above that, I obviously am not alone at all. It was nobody but Johannes Stezenbach himself who uttered great sorrow where the personnel of linuxtv.org is going to (see mail list please).

It seems like a 4 cylinder machine running on 2 or 3 cylinders, you know....
> 
> 			Linus

Yours sincerely

Uwe

P. S.: If there are further questions I'd appreciate you to ask.

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
