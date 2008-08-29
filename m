Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYH2D71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYH2D71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 23:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYH2D7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 23:59:19 -0400
Received: from web82103.mail.mud.yahoo.com ([209.191.84.216]:26095 "HELO
	web82103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751327AbYH2D7S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 23:59:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=B41WKyNhorDlkGhnsvhTL0dQBmSzuPZLIlxJSx58eRHYYRL9Gz6ECmSzAvDw2bLbXjUmPXNrCcL/pBMi7ECaXYivm2ed80JQ7aGEfFlxPjQ5oZsutRtcD0QL2e8xu1AqCZxpRJBmt7pq0OQaU/qAHG8dXqYQ4k5mFDCzBmMAkJA=;
X-YMail-OSG: nvMJ15kVM1mEU9gjGvaearjNxcwd2nAG_XYhVYQc2cF0EDHMZSv7qpCiZiqJoy8mIA--
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218.2
Date: Thu, 28 Aug 2008 20:59:17 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <476505.29876.qm@web82103.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> From: Ingo Molnar <mingo@elte.hu>
> To: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>; David Witbrodt <dawitbro@sbcglobal.net>; Thomas Gleixner <tglx@linutronix.de>; H. Peter Anvin <hpa@zytor.com>; Andrew Morton <akpm@linux-foundation.org>; Jesse Barnes <jbarnes@virtuousgeek.org>; linux-kernel@vger.kernel.org
> Sent: Thursday, August 28, 2008 4:58:28 PM
> Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
> 
> 
> * Yinghai Lu wrote:
> 
> > On Thu, Aug 28, 2008 at 1:40 PM, Linus Torvalds
> > wrote:
> > > On Thu, 28 Aug 2008, Yinghai Lu wrote:
> > >>
> > >> v2: insert e820 reserve resources before pnp_system_init
> > >
> > > Looks ok by me. Now it just needs testing ;)
> > >
> > > Does it actually fix the HPET regression on that odd machine (without the
> > > special hacks to recognize HPET explicitly)?
> > 
> > David,
> > 
> > can you test attached patch?
> > also you may try to revert the old patch.
> 
> great - i've done the revert of a2bd7274b471 and have applied your patch 
> and pushed it out into -tip. David, could you please test whether 
> tip/master works for you out of box?


===== SHELL OUTPUT (for sanity) =====
commit e3fc96d5aca609bcf6ab0327850a109df65c1dbb
Merge: 6b8c836... a36d241...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Aug 28 22:57:20 2008 +0200

    Merge branch 'x86/core'
=====================================

Results:  both ECS AMD690GM-M2 machines boot fine...

- no need for "hpet=disable"
- no error messages in 'dmesg' (except that annoying TSC b.s.)


More good news:  the user who first reported the regression in May
(he uses Intel Q6600 CPU + Abit F-190HD mboard, while I use AMD 
Athlon 64 X2 3600+ CPU + ECS mboard) posted a followup on his blog:

===== http://ciaranm.wordpress.com/2008/05/18/yay-for-git/#comments =====
Oh good. Looks like git head works just fine now for me, so whatever
it was appears to be fixed.

Comment by Ciaran McCreesh — August 26, 2008 @ 6:25 pm 
=========================================================================

I was afraid that Yinghai's original patch (many days ago) which
worked for me was too AMD-specific, and would not work for this other
user experiencing the regression against commit 3def3d6d...

When you (Ingo) and Yinghai made it more generic afterwards, I
feared that it was too HPET-specific.

I tried to get Ciaran here, so that the problems he and I were
having could both be solved.  It's not clear what change solved his
regression -- clearly it's not today's patch, since his blog post
is dated 2 days ago! -- but I'm glad to see that all is well in
the world again.


Ingo, could you do me a favor?

Mr. Anvin's inbox got badly messed up because of me:

> From: H. Peter Anvin <hpa@zytor.com>
[...]
> Sent: Thursday, August 28, 2008 8:21:09 PM
[...]
> This may be a rehash of things previously discussed in this thread; my 
> email seems to be a bit flakey to the point that I don't know if I have 
> gotten all the messages.

Could you explain this to him for me?  I don't want to post any more than 
this one message, just making a bad situation worse.  (Sorry about the 
threading, Peter!)

Since Monday I have gone back to work on my LAN.  RAID was quickly set up
on the fileserver, but the backup of the P4 isn't finished so I _still_
haven't been able to pull the hard disk from it for the webserver.  Only
after that will I be able to get the MTA arrangement I want, and banish
this webmail client FOREVER!  (I should have done all of this while I was
helping you troubleshoot the regression, since my 2.6.25 kernels work fine,
but I was too excited about being able to help to think that clearly.)


Thanks all!
Dave Witbrodt
