Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZDMQ4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZDMQ4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZDMQ4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:56:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51108 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZDMQ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:56:34 -0400
Date: Mon, 13 Apr 2009 18:57:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090413165711.GA29389@elf.ucw.cz>
References: <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain> <20090412163356.GA2392@elte.hu> <49E2398A.3050405@redhat.com> <20090413041625.GF11652@elte.hu> <20090413042459.GA6479@elte.hu> <49E367E8.7080202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E367E8.7080202@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-04-13 09:27:20, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> >> Yes, we could do memory checks, and ... hey, we already do that:
> >>
> >>    bb577f9: x86: add periodic corruption check
> >>    5394f80: x86: check for and defend against BIOS memory corruption
> >>
> >> ... and i seem to be the one who implemented it! ;-)
> > 
> > s/implemented/merged+fixed :-)
> 
> Actually, what would probably be more productive than trying to track
> corruption would be to drop the low 1 MB of memory before suspend to RAM
> - make sure that it is as close to completely unused as possible.
> 
> All *known* cases of low memory corruption are either boot time or due
> to s2ram.
> 
> I don't know how realistic it is to make the low 1 MB completely unused
> over the s2ram cycle.  The trivial way of doing it is to simply not use
> it -- it's only some 600K after all; a more sophisticated way would be
> to explicitly constrain it to transient uses that would be dead at s2ram.

That should be doable... with memory hotplug support etc, eventually.

OTOH all known corruption is within 64K IIRC, and reserving that is
rather easy.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
