Return-Path: <linux-kernel-owner+w=401wt.eu-S1761039AbXE1SGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039AbXE1SGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 14:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXE1SFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 14:05:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbXE1SFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 14:05:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Date: Mon, 28 May 2007 20:11:36 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Herbert Xu <herbert@gondor.apana.org.au>
References: <200705270012.59177.rjw@sisk.pl> <200705281009.06685.rjw@sisk.pl> <20070528103011.GC18807@elf.ucw.cz>
In-Reply-To: <20070528103011.GC18807@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705282011.37626.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 12:30, Pavel Machek wrote:
> Hi!
> 
> > > This patch is on top of the "Freezer: Avoid freezing kernel threads prematurely"
> > > patch that I posted yestarday, available at http://lkml.org/lkml/2007/5/25/199
> > > (updated version that applies cleanly on top of 2.6.22-rc3, is available at
> > > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/07-freezer-avoid-freezing-kernel-threads-prematurely.patch).
> > > It has been tested on a couple of machines and doesn't seem to break anything.
> > > 
> > > [As you can see there are quite a lot of files affected, so I didn't add all
> > > maintainers of them to the CC list.  In fact, I'm not sure how to handle
> > > notifying them of the change, so please advise.]
> > 
> > Does the lack of comments mean that everyone on the CC list agrees with this
> > approach? ;-)
> > 
> > In the meantime, it turns out that this patch fixes the hibernation/suspend
> > problem with cryptd discussed in the thread at
> > http://lkml.org/lkml/2007/5/26/24 .
> > 
> > The problem is that cryptd doesn't call try_to_freeze() and doesn't set
> > PF_NOFREEZE for itself, so the freezer cannot handle it properly.  In principle
> > we can add either try_to_freeze() or the setting of PF_NOFREEZE to it, but if
> > the approach in the $subject patch is acceptable, we'll need to remove that
> > soon.  So, what should we do?
> 
> I'd add PF_NONFREEZE. Changing the defaults in freezer is obviously
> not 2.6.22 material.

OK

Rafael
