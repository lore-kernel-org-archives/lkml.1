Return-Path: <linux-kernel-owner+w=401wt.eu-S1031426AbXDZSgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031426AbXDZSgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031430AbXDZSgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:36:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51049 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031426AbXDZSgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:36:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Thu, 26 Apr 2007 20:40:30 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Nick Piggin <npiggin@suse.de>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
References: <20070425072350.GA6866@ucw.cz> <20070426113005.GU17387@elf.ucw.cz> <1177605074.6814.93.camel@johannes.berg>
In-Reply-To: <1177605074.6814.93.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262040.31760.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 April 2007 18:31, Johannes Berg wrote:
> On Thu, 2007-04-26 at 13:30 +0200, Pavel Machek wrote:
> 
> > > From looking at pm_ops which I was recently working with a lot, it seems
> > > that it was designed by somebody who was reading the ACPI documentation
> > > and was otherwise pretty clueless, even at that level std tries to look
> > > like suspend. IMHO that is one of the first things that should be ripped
> > > out, no pm_ops for STD, it's a pain to work with.
> > 
> > That code goes back to Patrick, AFAICT. (And yes, ACPI S3 and ACPI S4
> > low-level enter is pretty similar).
> > 
> > Patches would be welcome
> 
> That was easier than I thought. This applies on top of a patch that
> makes kernel/power/user.c optional since I had no idea how to fix it,
> problems I see:
>  * it surfaces kernel implementation details about pm_ops and thus makes
>    the whole thing very fragile

Can you elaborate?

>  * it has yet another interface (yuck) to determine whether to reboot,
>    shut down etc, doesn't use /sys/power/disk

Yes.  In fact it was meant as a replacement for /sys/power/disk at one point.

>  * I generally had no idea wtf it is doing in some places

I could have told you if you had asked. :-)

> Anyway, this patch is only compile tested, it
>  * introduces include/linux/hibernate.h with hibernate_ops and
>    a new hibernate() function to hibernate the system

Do we need hibernate_ops at all?  There's only one user anyway and I'm not
sure there will be more of them in the future.

>  * rips apart a lot of the suspend code and puts it back together using
>    the hibernate_ops
>  * switches ACPI to hibernate_ops (the only user of pm_ops.pm_disk_mode)
>  * might apply/compile against -mm, I have all my and some of Rafael's
>    suspend/hibernate work in my tree.
>  * breaks user suspend as I noted above
>  * is incomplete, somewhere pm_suspend_disk() is still defined iirc

I think I can fix it up, just give me some time.

The idea is good, I think we should do someting like this.

Greetings,
Rafael
