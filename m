Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXDZS6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXDZS6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXDZS6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:58:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51147 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbXDZS6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:58:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Thu, 26 Apr 2007 21:02:37 +0200
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
References: <20070425072350.GA6866@ucw.cz> <200704262040.31760.rjw@sisk.pl> <1177612802.6814.121.camel@johannes.berg>
In-Reply-To: <1177612802.6814.121.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262102.38568.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 April 2007 20:40, Johannes Berg wrote:
> On Thu, 2007-04-26 at 20:40 +0200, Rafael J. Wysocki wrote:
> 
> > >  * it surfaces kernel implementation details about pm_ops and thus makes
> > >    the whole thing very fragile
> > 
> > Can you elaborate?
> 
> Well it tells userspace about pm_ops->enter/prepare/finish etc.
> Also, it seems that it needs a "release memory now" operation instead of
> just releasing it when the fd is closed?

Yes.  That's because we want to be able to repeat creating the image
without closing the fd in some situations.

> > >  * it has yet another interface (yuck) to determine whether to reboot,
> > >    shut down etc, doesn't use /sys/power/disk
> > 
> > Yes.  In fact it was meant as a replacement for /sys/power/disk at one point.
> 
> Heh.
> 
> > >  * I generally had no idea wtf it is doing in some places
> > 
> > I could have told you if you had asked. :-)
> 
> I was offline ;)
> 
> > Do we need hibernate_ops at all?  There's only one user anyway and I'm not
> > sure there will be more of them in the future.
> 
> I'm pretty sure there won't be, but there's no way to do it cleanly
> without pm_ops since even acpi doesn't do this all the time but only
> when some set of conditions is true. Hence, it needs to be able to
> determine the availability of the platform mode at run time rather than
> build time (build time => we could use weak symbols, arch hooks, ...)

Still, we could use a global var 'platform_hibernation' or something like this,
I think.  Then, we can do

#define platform_hibernation	0

on the architectures that don't need it and make ACPI use it instead of this
"dynamic linking".

Greetings,
Rafael
