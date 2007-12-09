Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXLIXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXLIXVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 18:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXLIXVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 18:21:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36660 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751075AbXLIXVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 18:21:23 -0500
Date: Mon, 10 Dec 2007 00:22:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071209232208.GA1726@elf.ucw.cz>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org> <20071209212513.GC24284@elf.ucw.cz> <20071209222928.3f7b63a4@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209222928.3f7b63a4@the-village.bc.nu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-09 22:29:28, Alan Cox wrote:
> On Sun, 9 Dec 2007 22:25:13 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Sun 2007-12-09 17:59:08, Andi Kleen wrote:
> > > > I mean, we expect 8usec delay -- historical ISA timing -- but when
> > > > _PCI_ card with leds is inserted, it is likely to be faster than old
> > > > ISA, right?
> > > 
> > > Yes, i guess switching to udelay at least on newer systems would
> > > be a good idea.  I'm not quite sure about systems without TSC though.
> > 
> > Something like this? (Warning, will not probably even compile on
> > x86-64, I do not have 64-bit compiler near me).
> 
> You need to stick in a bug trap to verify that the udelay is not called
> before the cpu timer has been set up.

Really? 

udelay() seems to use
... cpu_data(raw_smp_processor_id()).loops_per_jiffy .. 

..so it seems that bug trap is already there... because
raw_smp_processor_id() will probably just oops...

We could solve this by pre-initializing loops_per_jiffy to some huge
number, but I do not see convenient place where to do that.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
