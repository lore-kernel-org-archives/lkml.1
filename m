Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbXIPFKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbXIPFKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 01:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXIPFKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 01:10:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXIPFKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 01:10:15 -0400
Date: Sat, 15 Sep 2007 22:08:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <ak@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-Id: <20070915220845.89d7445a.akpm@linux-foundation.org>
In-Reply-To: <20070915183623.GB14501@one.firstfloor.org>
References: <20070911201219.GA9674@uranus.ravnborg.org>
	<200709112138.11247.ak@suse.de>
	<20070911211422.GU3563@stusta.de>
	<20070915023258.cb5b8048.akpm@linux-foundation.org>
	<20070915183623.GB14501@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007 20:36:23 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> On Sat, Sep 15, 2007 at 02:32:58AM -0700, Andrew Morton wrote:
> > On Tue, 11 Sep 2007 23:14:22 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > People do not expect code under arch/i386/ to be used by code under 
> > > arch/x86_64/ and vice versa.
> > 
> > [OT: it drives me batshit that we ended up including stuff in both directions]
> 
> Why? 

It's more complex, obviously.  More surprising.  It used to be the case that
arch/x86^4 files were xx86_64 and arch/i386 files were i386 and possibly
x86_64.  Now it's the case that arch/x86_64 files are x86_64 and maybe i386
and arch/i386 files are i386 and maybe x86_64.  Additional and quite
unnecessary complexity.

I mean, how often do x86_64 changes in your tree break i386?  Once every
3ish weeks would be my guess.  Often this will be because the person making
(and reviewing) the x86_64 change didn't know (or forgot) that the file is
also used by x86_64.

> Anyways, i wouldn't have a problem with putting the already shared
> files into a different directory or move it over to one of the architectures, 
> although I must admit I personally wouldn't see a big benefit from it. But if 
> it gives people a warm fuzzy feeling I'm all for it.

Doing something like that would reduce complexity, reduce surprise and
increase maintainability.  That's more than warm-and-fuzzies.
