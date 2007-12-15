Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbXLOXAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbXLOXAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 18:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbXLOXA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 18:00:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37792 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755413AbXLOXA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 18:00:26 -0500
Date: Sun, 16 Dec 2007 00:00:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071215230036.GF2434@elf.ucw.cz>
References: <1181682498.8176.224.camel@chaos> <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214131502.GA14359@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-12-14 14:15:03, Ingo Molnar wrote:
> 
> * David P. Reed <dpreed@reed.com> wrote:
> 
> > Replace use of outb to "unused" diagnostic port 0x80 for time delay 
> > with udelay based time delay on x86_64 architecture machines.  Fix for 
> > bugs 9511 and 6307 in bugzilla, plus bugs reported in 
> > bugzilla.redhat.com.
> >
> > Derived from suggestion (that didn't compile) by Pavel Machek, and 
> > tested, also based on measurements of typical timings of out's 
> > collated by Rene Herman from many in the community.
> >
> > This patch fixes a number of bugs known to cause problems on HP
> > Pavilion dv9000z and dv6000z laptops - in the form of solid freezes
> > when hwclock is used to show or set the time.  Also, it potentially
> > improves bus utilization on SMP machines, by using a waiting process
> > that doesn't tie up the ISA/LPC bus for 1 or 2 microseconds.
> >
> > i386 family fixes (completely parallel) were not included, considering 
> > that such machines might involve more risk of problems on legacy 
> > machines.
> 
> wow, cool fix! (I remember that there were other systems as well that 
> are affected by port 0x80 muckery - i thought we had removed port 0x80 
> accesses long ago.)
> 
> how about the simpler fix below, as a first-level approach? We can then 
> remove the _p in/out sequences after this.
> 
> this is also something for v2.6.24 merging.

As much as I like this patch, I do not think it is suitable for
.24. Too risky, I'd say.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
