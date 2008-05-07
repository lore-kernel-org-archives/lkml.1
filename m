Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYEGXEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYEGXEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYEGXDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:03:44 -0400
Received: from www.tglx.de ([62.245.132.106]:38141 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYEGXDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:03:42 -0400
Date: Thu, 8 May 2008 01:02:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@suse.cz>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <20080507223705.GJ18516@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0805080059430.3318@apollo.tec.linutronix.de>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <20080507212343.GB14951@cs181133002.pp.htv.fi>
 <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de> <20080507221435.GH18516@elf.ucw.cz> <86802c440805071522r424b2011v7c0d852db4c4abfd@mail.gmail.com> <20080507223705.GJ18516@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Pavel Machek wrote:
> On Wed 2008-05-07 15:22:37, Yinghai Lu wrote:
> > On Wed, May 7, 2008 at 3:14 PM, Pavel Machek <pavel@suse.cz> wrote:
> > >  3) copy&paste code remained in the patch
> > 
> > i thought to keep the stub so could add more other stuff in the switch
> > like 64 bit
> 
> This is _not_ good enough reason to copy&paste. Just do it like this:
> 
> >         switch (c->x86_vendor) {
> >         case X86_VENDOR_AMD:
> >                 early_init_amd(c);
> >                 break;
> >         case X86_VENDOR_INTEL:
> >                 early_init_intel(c);
> >                 break;
> >         case X86_VENDOR_CENTAUR:
> >                 early_init_centaur(c);
> >                 break;
> >         }
> 
> #         clear_cpu_cap(c, X86_FEATURE_PAT);
> #
> #         switch (c->x86_vendor) {
> #         case X86_VENDOR_AMD:
> #                if (c->x86 >= 0xf && c->x86 <= 0x11)
> #                         set_cpu_cap(c, X86_FEATURE_PAT);
> #                 break;
> #         case X86_VENDOR_INTEL:
> #                 if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
> #                         set_cpu_cap(c, X86_FEATURE_PAT);
> #                 break;
> #         }
> 
> And then, factor out code marked # into separate function, and call it
> from all three places.

And while you are at it, why don't you send a patch which makes this
all go away instead of wasting time producing pseudo code?

Thanks,

	tglx
