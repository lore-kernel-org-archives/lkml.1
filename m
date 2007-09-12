Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbXILAaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbXILAaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 20:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXILAaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 20:30:08 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:44239 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbXILAaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 20:30:05 -0400
Date: Wed, 12 Sep 2007 09:29:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andi Kleen <ak@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070912002953.GA26293@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@suse.de>,
	Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20070911201219.GA9674@uranus.ravnborg.org> <200709112138.11247.ak@suse.de> <20070911211422.GU3563@stusta.de> <200709112234.24155.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709112234.24155.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 10:34:23PM +0100, Andi Kleen wrote:
> > People do not expect code under arch/i386/ to be used by code under
> > arch/x86_64/ and vice versa.
> >
> > That regularly results in people sending patches that don't compile on
> > the other architecture.
> >
> > With one architecture it's much more obvious that the code is shared.
> 
> Will that cause people to compile test both? I have my doubts that 
> will really work.
> 
> e.g. a similar example would be CONFIG_MMU=n. The code 
> is mostly shared and in the same directories, but people still
> break the MMUless architectures all the time. 
> 
As I was the first one to do CONFIG_MMU=y/n in the same arch directory,
since 2.5, I can tell you that that's simply crap. The only reason
CONFIG_MMU=n gets broken all the time is because people don't think about
it in generic code, it's rarely broken in the architecture code, and even
with the most occasional of build tests most of that gets caught in a
hurry.

You do of course have to consider both cases when writing new code, but
those things tend to be pretty obvious. It's a bit more work for the arch
maintainer, but it's certainly far less confusing and problematic than
separating things out.

In fact, going the opposite route is what leads to endless trouble in the
long run, since you brought up the MMUless example, m68knommu is a good
example. Rather than beginning life in arch/m68k, it was forked off,
mostly to deal with the ColdFire CPUs that weren't planned to have MMUs.
Now that the product line has moved along, adding an MMU to it is in the
roadmap, which means that inevitably they're both going to have to be
combined anyways. Simply dealing with the initial trouble of having them
combined initially would have solved a lot of that mess.

You can ignore the added maintenance for as long as possible, but sooner
or later it's going to be a problem. Procrastination is not something
that bodes particularly well for divergent hardware support.
