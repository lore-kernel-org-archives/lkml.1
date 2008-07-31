Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969AbYGaUUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbYGaUUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYGaUUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:20:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYGaUUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:20:30 -0400
Date: Thu, 31 Jul 2008 13:16:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
In-Reply-To: <20080731155701.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <alpine.LFD.1.10.0807311310090.3277@nehalem.linux-foundation.org>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org> <20080731151625.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311235350.3277@nehalem.linux-foundation.org> <20080731155701.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Dmitry Torokhov wrote:
> 
> Sometimes we do need to upgrade userspace though. Can we make
> Documentation/Changes more prominent? Maybe have it published on
> kernel.org?

We basically _never_ have to upgrade userspace that aggressively. We can 
have a Changes file that talks about things that will eventually break 
when we remove support for it eventually, but it should never EVER be used 
as an excuse for "I needed to break it now".

So no, I refuse to make it any more prominent. Because it would just be 
used as an excuse for behavior that I consider unacceptable. It was 
different back when we had 3-year development windows and people upgrading 
from 2.4.x to 2.6.x had to learn new things, but for 2.6.26 to .27 or 
similar it's simply not acceptable.

Look at the VFS layer. Look at how we have multiple different versions of 
"readdir()" (well, getdents, really), and "stat()". Exactly because we 
don't break user space.

> It did specify the size. Something 448 more bytes than it allocated:
> 
>     unsigned long evbits[NBITS(KEY_MAX)];
> 
>     /* Check for ABS_X, ABS_Y, ABS_PRESSURE and BTN_TOOL_FINGER */
> 
>     SYSCALL(ret = ioctl(fd, EVIOCGBIT(0, KEY_MAX), evbits));
> 
> So we allocate 64 bytes on stack and then as kernel to fill it with
> 511 bytes worth of data.

Ok, I can see how it's confused, asking for KEY_MAX _bits_. If this is the 
main user, why not just change the definition to be in bits?

> >  - help fix up the userspace driver regardless
> 
> In progress.
> > 
> >  - a year down the line, maybe breakage will be a non-issue.
> 
> Around when 2.6.28 is released, right? ;)

A year down the line would be 2.6.30 or so.

> We do need more keycodes. People are coming wioth more and more. The
> patch following the one in question adds about 10 new kodes for remote
> controls/phones. And we will get more.

Maybe the problem is a bad design that encourages people to just create 
new keycodes when they really shouldn't? 

			Linus
