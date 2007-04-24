Return-Path: <linux-kernel-owner+w=401wt.eu-S1423118AbXDXVbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423118AbXDXVbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423119AbXDXVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:31:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33333 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423118AbXDXVbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:31:06 -0400
Date: Tue, 24 Apr 2007 23:29:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070424212956.GE16457@elf.ucw.cz>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424205416.GA23032@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424205416.GA23032@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I have not a frigging clue whether that is the case in suspend2 vs 
> > uswsusp, but I object to this idiotic argument of counting "kernel 
> > code". That's simply not a valid argument. It never was.
> 
> the raw linecount appears to be the following:
> 
>  suspend2-2.2.9.12-for-2.6.21-rc6.patch
> 
>    89 files changed, 16452 insertions(+), 69 deletions(-)
> 
>  $ suspend-0.5> countlines
>  32260

(I'm getting very different numbers here. Userland part:)

pavel@amd:~/sf/suspend$ wc -l *.c
   125 bootsplash.c
    12 breakit.c
   119 config.c
   136 delme.c
   207 dmidecode.c
    92 encrypt.c
   222 keygen.c
   447 md5.c
   286 radeontool.c
   870 resume.c
   434 s2ram.c
    78 splash.c
    73 splashy_funcs.c
  1481 suspend.c
   117 swap-offset.c
    11 vfork_test.c
   123 vt.c
   413 whitelist.c
   136 whitelist2.c
  5382 total
pavel@amd:~/sf/suspend$ wc -l *.h
    23 bootsplash.h
    26 config.h
    62 encrypt.h
   106 md5.h
  1764 radeon_reg.h
    20 s2ram.h
    26 splash.h
    25 splashy_funcs.h
   217 swsusp.h
    10 vt.h
  2279 total
pavel@amd:~/sf/suspend$

> so, while it's probably apples to oranges, uswsusp seems to be larger, 
> while there's at least one feature that it is missing.

(We are talking "save 100% memory" here).

As I said, that one feature is doable in uswsusp, too. It is 200
lines. It also makes mm <-> swsusp interaction _way_ more complex, and
noone was able to review it. It will corrupt memory if we got it
wrong.

(Suspend2 has the same problem. It includes that same feature, and
noone is able to review it. It has few more problems.).

> also, from the structure of the suspend2 patch it seemed to me that they 
> could peacefully coexist in the kernel without stepping on each other's 
> toes - why not do that? Users will then pick the winner.

We do not want to fragment the testing base, and suspend2 does not
really have any interesting features over uswsusp.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
