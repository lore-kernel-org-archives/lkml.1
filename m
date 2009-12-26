Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907AbZLZVdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbZLZVdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 16:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZLZVdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 16:33:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZLZVdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 16:33:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [RFC] Asynchronous suspend/resume - test results
Date: Sat, 26 Dec 2009 22:33:45 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200912210140.19713.rjw@sisk.pl> <200912242310.42615.rjw@sisk.pl> <4B35272D.7040207@crca.org.au>
In-Reply-To: <4B35272D.7040207@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912262233.45626.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 December 2009, Nigel Cunningham wrote:
> Rafael J. Wysocki wrote:
> > On Thursday 24 December 2009, Nigel Cunningham wrote:
> >> Hi.
> > 
> > Hi, 
> > 
> >> I built the async branch of your tree and tested it, also running
> >> 2.6.33-rc1 + TuxOnIce for comparison. Dmesg for both are attached. Is
> >> there anything I can/should be doing for you on top of this?
> > 
> > No, thanks a lot.
> > 
> >> I'll try Dmitry's patch on top of this a little later - other things to do first.
> > 
> > No need for that, the patchset contains an equivalent of the Dmitry's patch.
> > 
> >> I noticed that you were doing standard deviations in your stats - how
> >> many runs were you basing them on?
> > 
> > I usually run 10 iterations of suspend-resume for each configuration.
> > The raw data are at http://www.sisk.pl/kernel/data/async-suspend-updated.pdf
> > if you're interested.
> > 
> >> Not sure that I can be bothered to do too many - too much else to do!
> > 
> > Sure, thanks a lot anyway.  Your data confirn that there's a measurable gain
> > from suspending and resuming devices asynchronously.
> 
> It did? I thought it showed no difference at all!

Yes, it did.  Please compare these lines:

(from the "sync" dmesg):
[   31.640676] PM: freeze of devices complete after 709.277 msecs
[   37.087548] PM: restore of devices complete after 4973.508 msecs

(from the "async" dmesg):
[   25.600067] PM: freeze of devices complete after 620.429 msecs
[   29.195366] PM: restore of devices complete after 3057.982 msecs

So clearly, there's a difference. :-)

Of course, in terms of total hibernate/restore time this is only a little
improvement, but if that was suspend to RAM and resume, the reduction of
the device resume time by almost 2 s would be a big deal.

> I'll see if I can find the time to do the other computers, then.

I'd appreciate that very much.

> We're going away for a couple of weeks on Monday, though, so I'm not sure
> that I'll get the time beforehand.

OK

Rafael
