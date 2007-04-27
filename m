Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbXD0MFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbXD0MFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbXD0MFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:05:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56092 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbXD0MFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:05:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Fri, 27 Apr 2007 14:09:55 +0200
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
References: <20070425072350.GA6866@ucw.cz> <200704271218.07120.rjw@sisk.pl> <1177669179.7828.53.camel@johannes.berg>
In-Reply-To: <1177669179.7828.53.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271409.56687.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 12:19, Johannes Berg wrote:
> On Fri, 2007-04-27 at 12:18 +0200, Rafael J. Wysocki wrote:
> 
> > 1) We define platform_hibernation if CONFIG_ACPI is set.
> 
> Let's just define it always then in the common code so we don't have
> even more magic bits platforms need to define even if they don't care at
> all. And please don't put #ifdef CONFIG_ACPI into the common code ;)
> Maybe #ifdef CONFIG_ARCH_NEEDS_HIBERNATE_HOOKS or something.
> 
> > 2) In the ACPI code we do
> > 
> > if (can do S4)
> > 	platform_hibernation = 1;
> 
> Gotcha.
> 
> > 3) We have functions arch_platform_prepare()/finish()/enter() that are defined
> > to be noops for anything but ACPI systems and for ACPI systems they are
> > defined like this:
> > 
> > int arch_platform_enter(void)
> > {
> > 	if (!platform_hibernation)
> > 		return 0;
> > 
> > 	...
> > }
> > 
> > I think it should work.
> 
> You could reduce code churn in all other platforms by making these weak
> symbols like the irq hooks I did for pm_ops. It looks like it can work
> and possibly is even less intrusive than my hibernate_ops patch. Though
> then again my hibernate_ops patch removed a lot of stuff that is now no
> longer necessary, and also completely removed the PM_SUSPEND_DISK foo...
> we probably want that regardless of how we invoke ACPI.

Yes.  Still, I'd like to rework your patch to deal with ACPI without
introducing hibernate_ops .  I'm going to do this later today if you don't
mind. :-)

Rafael
