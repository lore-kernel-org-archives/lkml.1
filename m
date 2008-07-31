Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbYGaTrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbYGaTrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbYGaTr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:47:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831AbYGaTrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:47:25 -0400
Date: Thu, 31 Jul 2008 12:44:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
In-Reply-To: <20080731151625.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <alpine.LFD.1.10.0807311235350.3277@nehalem.linux-foundation.org>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org> <20080731151625.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Dmitry Torokhov wrote:
> 
> Does it have to be papered over in the kernel though?

Yes. It's how we have worked. Asking people to upgrade big core programs 
is not reasonable.

Think of it this way: we absolutely _want_ people to run the latest 
kernel. We want it for their own sake (security etc fixes), but we want it 
even more for *our* own sake (testing, fixes etc).

And if we want to encourage people to upgrade their kernel very 
aggressively (and we absolutely do!), then that means that we have to also 
make sure it doesn't require them upgrading anything else.

> We can only guarantee one thing - ABI. And that is kept intact. But I
> literally have no idea if a kernel breaks a random program out there
> that happens to have a bug.

There are gray areas, yes. For example, timing changes do mean that a new 
kenrel can easily break a program that used to work. We cannot handle 
_everyting_. 

But when the ABI in question is some very specific one, that some 
important program uses (even if the "uses" is "misuses") then it really 
isn't a gray area any more.

And quite frankly, the ABI was apparently pretty bad to begin with, if 
user space got an array back but didn't get to specify the size. So you 
may want to say that user space was broken, but on the other hand, it's 
equally arguable that the ABI was crap.

(Which is something you can pretty much take for granted with ioctl's, of 
course. DO NOT CHANGE IOCTL'S. EVER!)

> We have 3 options now:
> 
> 1. Never change KEY_MAX and dont add any new key definitions.
> 2. Introduce a new ioctl and have all wel-behaving programs rewritten
>    to support it.
> 3. Fix userspace driver (patch is available).

You ignore the obvious choice, which is how we _usually_ do it:

 - help fix up the userspace driver regardless

 - a year down the line, maybe breakage will be a non-issue.

 - but at least _think_ about the fact that yes, most ioctl interfaces are 
   pure and utter sh*t, and the problem was probably not so much the user 
   space driver as the crap interface to begin with!

and discuss whether KEY_MAX really needs to be changed that much. I 
suspect that the change was done without even realizing just how painful 
it was, and that if you look at the original reason for it with the 
hindsight of knowing that it was painful, maybe it wasn't that critical to 
do it after all?

		Linus
