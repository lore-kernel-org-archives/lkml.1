Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbXD0KOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbXD0KOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXD0KOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:14:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55042 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbXD0KOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:14:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Fri, 27 Apr 2007 12:18:05 +0200
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
References: <20070425072350.GA6866@ucw.cz> <200704262102.38568.rjw@sisk.pl> <1177666915.7828.35.camel@johannes.berg>
In-Reply-To: <1177666915.7828.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271218.07120.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 11:41, Johannes Berg wrote:
> On Thu, 2007-04-26 at 21:02 +0200, Rafael J. Wysocki wrote:
> 
> > Yes.  That's because we want to be able to repeat creating the image
> > without closing the fd in some situations.
> 
> Oh yeah, I just checked and it's not in fact necessary. I'm just
> confused.
> 
> > Still, we could use a global var 'platform_hibernation' or something like this,
> > I think.  Then, we can do
> > 
> > #define platform_hibernation	0
> > 
> > on the architectures that don't need it and make ACPI use it instead of this
> > "dynamic linking".
> 
> No, because acpi doesn't know at build time whether it can actually do
> S4 or not.

That's not a problem, I think.

1) We define platform_hibernation if CONFIG_ACPI is set.

2) In the ACPI code we do

if (can do S4)
	platform_hibernation = 1;

3) We have functions arch_platform_prepare()/finish()/enter() that are defined
to be noops for anything but ACPI systems and for ACPI systems they are
defined like this:

int arch_platform_enter(void)
{
	if (!platform_hibernation)
		return 0;

	...
}

I think it should work.

Greetings,
Rafael
