Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbXLYMO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbXLYMO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 07:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbXLYMOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 07:14:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36407 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750891AbXLYMOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 07:14:18 -0500
Date: Tue, 25 Dec 2007 13:12:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
	suspend-to-RAM
Message-ID: <20071225121231.GA31662@elf.ucw.cz>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712231730.34935.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712231730.34935.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Sunday, 23 of December 2007, Carlos Corbacho wrote:
> > Fix suspend-to-RAM on nForce 4 (CK804) boards by increasing
> > PCIBIOS_MIN_IO.
> > 
> > Fixes kernel bugzilla #9528
> > 
> > Problem:
> > 
> > Linus' patch (52ade9b3b97fd3bea42842a056fe0786c28d0555) to re-order
> > suspend (and fix fall out from Rafael's earlier suspend reordering work)
> > broke suspend-to-RAM on nForce 4 (CK804) boards.
> > 
> > Why:
> > 
> > After debugging _PTS() in the DSDT, it turns out these nVidia boards are
> > trying to write to an IO port > 0x1000 (0x142E) during suspend. Before the
> > re-ordering, we got away with this.
> > 
> > After the afore mentioned commit, we started hitting the PCIBIOS_MIN_IO
> > limit and suspend then broke on these machines (the machine simply hangs
> > when it reaches the 0x142E IO port write during suspend-to-RAM).
> > 
> > There was some previous work in the PCIBIOS_MIN_IO area over two years ago
> > (71db63acff69618b3d9d3114bd061938150e146b) which bumped this to 0x4000,
> > but this was reverted (2ba84684e8cf6f980e4e95a2300f53a505eb794e) after
> > causing new and entirely different problems on another nForce board.
> > 
> > 0x1500 has been picked here as a nice, round and more conservative value
> > than 0x4000, and which covers 0x142E.
> 
> The patch is fine by me, so if anyone has objections, please speak up.

Just.. I have been running with very similar patch for few years... it
fixes few prototype machines I have here.


> > diff --git a/include/asm-x86/pci.h b/include/asm-x86/pci.h
> > index e883619..03cb123 100644
> > --- a/include/asm-x86/pci.h
> > +++ b/include/asm-x86/pci.h
> > @@ -46,7 +46,7 @@ extern unsigned int pcibios_assign_all_busses(void);
> >  #define pcibios_scan_all_fns(a, b)	0
> >  
> >  extern unsigned long pci_mem_start;
> > -#define PCIBIOS_MIN_IO		0x1000
> > +#define PCIBIOS_MIN_IO		0x1500
> >  #define PCIBIOS_MIN_MEM		(pci_mem_start)
> >  
> >  #define PCIBIOS_MIN_CARDBUS_IO	0x4000


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
