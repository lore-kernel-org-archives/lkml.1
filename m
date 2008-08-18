Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYHRWDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYHRWDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHRWDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:03:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52995 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYHRWC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:02:59 -0400
Date: Tue, 19 Aug 2008 00:04:19 +0200
From: Pavel Machek <pavel@suse.cz>
To: David Fries <david@fries.net>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818220419.GB2053@elf.ucw.cz>
References: <20080818040340.GB17528@spacedout.fries.net> <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl> <20080818125803.GC17528@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818125803.GC17528@spacedout.fries.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-08-18 07:58:03, David Fries wrote:
> On Mon, Aug 18, 2008 at 05:14:50AM +0100, Maciej W. Rozycki wrote:
> > On Sun, 17 Aug 2008, David Fries wrote:
> > > +	/* cr4 was introduced in the Pentium CPU */
> > 
> >  NACK.  Later i486 chips do have CR4 -- for PSE, VME, etc. (the set of
> > features varies across the line).  Use a fixup as elsewhere or something.

> 
> That's what I get for reading the Intel instruction set reference,
> "The CR4 register was added to the Intel Architecture beginning with
> the Pentium processor."
> 
> Ingo Molnar, thanks, I'll try the read_cr4_safe() version tonight (the
> computer is in the trunk of my car and I'm about ready to head to
> work).
> 
> In light of the above, how about updating the comments
> -       /* cr4 was introduced in the Pentium CPU */
> -       jecxz   1f      # cr4 Pentium and higher, skip if zero
> +       /* cr4 not in i386 only some i486, skip if zero */
> +       jecxz   1f      # cr4 not in i386 only some i486, skip if zero

Okay, can it happen that that cr4 is zero legitimately? If newer 486SX
chips support cr4 but not coprocessor...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
