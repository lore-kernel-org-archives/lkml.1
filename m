Return-Path: <linux-kernel-owner+w=401wt.eu-S1764838AbZDJKoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764838AbZDJKoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757849AbZDJKnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:43:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51085 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZDJKny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:43:54 -0400
Date: Fri, 10 Apr 2009 12:46:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090410104648.GA31516@elf.ucw.cz>
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410103934.GA21506@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-04-10 12:39:34, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Hi!
> > 
> > > x86, setup: "glove box" BIOS calls -- infrastructure
> > > 
> > > Impact: new interfaces (not yet used)
> > > 
> > > For all the platforms out there, there is an infinite number of buggy
> > > BIOSes.  This adds infrastructure to treat BIOS interrupts more like
> > > toxic waste and "glove box" them -- we switch out the register set,
> > > perform the BIOS interrupt, and then restore the previous state.
> > > 
> > > LKML-Reference: <49DE7F79.4030106@zytor.com>
> > > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > > Cc: Pavel Machek <pavel@ucw.cz>
> > 
> > Sounds quite sane. Disadvantage is that we will no longer detect 
> > those buggy BIOSen.
> 
> I'd call that an advantage: sandboxing BIOS calls as much as we can 
> and trusting all data from it as if it were a random packet from the 
> Internet is the only sane way forward IMHO.

Well, difference is that you can defend against arbitrary network
packet, but you can't defend against arbitrarily broken BIOS. If it
loops forever, or overwrites random memory place, we lost...

> If we really care we could put in checks for unexpected register 
> state changes ... but is it worth the trouble?

So maybe we do need to cooperate with BIOS people, making them fix
their code. Checking for unexpected changes would certainly be good
idea for firmware testing kit... and it would probably make sense to
complain during regular boot, too.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
