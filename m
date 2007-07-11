Return-Path: <linux-kernel-owner+w=401wt.eu-S1762887AbXGKKUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762887AbXGKKUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760690AbXGKKU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:20:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49069 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760331AbXGKKUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:20:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 12:27:51 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, Pavel Machek <pavel@ucw.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200707081737.21932.a1426z@gawab.com> <46940F45.3090005@goop.org> <200707110711.26767.a1426z@gawab.com>
In-Reply-To: <200707110711.26767.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111227.52609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 July 2007 06:11, Al Boldi wrote:
> Jeremy Fitzhardinge wrote:
> > Jeremy Maitin-Shepard wrote:
> > >   In
> > > addition, I recall that the Linux boot procedure on x86 and on some
> > > other platforms necessarily uses certain low-address memory, like the
> > > first 640K, which must be backed up regardless.
> >
> > Well, the traditional framebuffer/ISA space between 640k and 1M probably
> > needs to be identity mapped, but I don't think there's anything in there
> > which specifically needs to be save/restored (except framebuffer
> > contents, maybe?).
> >
> > > For these reasons, it seems that it would be easiest to simply backup
> > > the first e.g. 16 or 64 MB of memory, and not have to worry about
> > > loading the kernel at a non-standard address and specifying a
> > > complicated exact memmap.  Someone might prove me wrong, though.
> >
> > Yes, I suppose.  You're certain the old kernel's devices are completely
> > quiescent at that point?
> 
> That's exactly the problem; trying to save a state from within the kernel 
> would probably necessitate a freezer hack, which we are trying so dearly to 
> avoid.

Well, I don't think that avoiding the freezer whatever it takes would be a good
idea.  There needs to be some balance. ;-)

> The only way the kexec approach may be successful, is by completely relying 
> on the kexec'd hibernate-mode kernel to save state, otherwise we would be 
> back to square one.  And if that required a special boot procedure for the 
> kexec'd hibernate-mode kernel, then why not?

Because such things are very difficult for many users.  My experience with
the userland suspend shows that clearly.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
