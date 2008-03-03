Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYCCOpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYCCOpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYCCOny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:43:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37164 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYCCOnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:43:53 -0500
Date: Mon, 3 Mar 2008 13:17:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080303121735.GE28369@elf.ucw.cz>
References: <20080228150444.GG17932@hjernemadsen.org> <47C6F4F9.90700@zytor.com> <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301094525.GQ17932@hjernemadsen.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Klaus S. Madsen wrote:
> > >> open("/dev/mem", O_RDWR)                = 5
> > >> mmap2(NULL, 1282, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED|MAP_FIXED, 5, 0) = 0
> > >> mmap2(0xa0000, 393216, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_FIXED, 5, 0xa0) = 0xa0000
> > >                          ^^^^^^^^^^^^^^^^^^^^
> > >> close(5)                                = 0
> > >> ioperm(0, 0x400, 0x1)                   = 0
> > >> iopl(0x3)                               = 0
> > >> access("/sys/bus/pci", R_OK)            = 0
> > >> write(1, "Calling get_mode\n", 17)      = 17
> > >> vm86(0x1, 0xb7f14ccc, 0xb7f14830, 0xc000, 0x18b6 <unfinished ...>
> > >> --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> > >> +++ killed by SIGSEGV (core dumped) +++
> > >
> > > This is the VGA BIOS being mapped, it's mapped PROT_READ|PROT_WRITE, but  
> > > no PROT_EXEC; if the kernel is NX-capable it *should* segfault trying to 
> > > execute out of this area, which is exactly what will happen when vm86 
> > > executes INT 10h.
> > >
> > > If we can find that mmap() in the s2ram source code and add PROT_EXEC 
> > > to it, it would be interesting.
> > 
> > Klaus, could you send your .config as well? Lets make sure that NX is 
> > even relevant in this context.
> Allright. The mmap in question is in the x86-common.c file in libx86,
> and adding PROT_EXEC to it solves the problem.

Ok, sw should probably fix that in s2ram... can you mail a patch to
me, and suspend-devel?

> I have attached my .config.
> 
> The only thing I don't understand is why this is suddenly a problem with
> 2.6.25, and not with 2.6.24? Is there a bug in 2.6.24 and previously
> that allows real-mode execution of non-executable pages?

It is strange indeed... Should it be traced as an regression?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
