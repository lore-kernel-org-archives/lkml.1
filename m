Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbYEGXKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbYEGXKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYEGXJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:09:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39961 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbYEGXJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:09:55 -0400
Date: Thu, 8 May 2008 01:10:43 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507231042.GN18516@elf.ucw.cz>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <20080507212343.GB14951@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de> <20080507221435.GH18516@elf.ucw.cz> <86802c440805071522r424b2011v7c0d852db4c4abfd@mail.gmail.com> <20080507223705.GJ18516@elf.ucw.cz> <alpine.LFD.1.10.0805080059430.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805080059430.3318@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-05-08 01:02:52, Thomas Gleixner wrote:
> On Thu, 8 May 2008, Pavel Machek wrote:
> > On Wed 2008-05-07 15:22:37, Yinghai Lu wrote:
> > > On Wed, May 7, 2008 at 3:14 PM, Pavel Machek <pavel@suse.cz> wrote:
> > > >  3) copy&paste code remained in the patch
> > > 
> > > i thought to keep the stub so could add more other stuff in the switch
> > > like 64 bit
> > 
> > This is _not_ good enough reason to copy&paste. Just do it like this:
> > 
> > >         switch (c->x86_vendor) {
> > >         case X86_VENDOR_AMD:
> > >                 early_init_amd(c);
> > >                 break;
> > >         case X86_VENDOR_INTEL:
> > >                 early_init_intel(c);
> > >                 break;
> > >         case X86_VENDOR_CENTAUR:
> > >                 early_init_centaur(c);
> > >                 break;
> > >         }
> > 
> > #         clear_cpu_cap(c, X86_FEATURE_PAT);
> > #
> > #         switch (c->x86_vendor) {
> > #         case X86_VENDOR_AMD:
> > #                if (c->x86 >= 0xf && c->x86 <= 0x11)
> > #                         set_cpu_cap(c, X86_FEATURE_PAT);
> > #                 break;
> > #         case X86_VENDOR_INTEL:
> > #                 if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
> > #                         set_cpu_cap(c, X86_FEATURE_PAT);
> > #                 break;
> > #         }
> > 
> > And then, factor out code marked # into separate function, and call it
> > from all three places.
> 
> And while you are at it, why don't you send a patch which makes this
> all go away instead of wasting time producing pseudo code?

Because I expect Ingo & Yinghai to do the work, and then test it, and
then add changelog, and then commit it. I expect Yinghai to learn how
to use functions in the process.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
