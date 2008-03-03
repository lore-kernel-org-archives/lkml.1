Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbYCCJun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbYCCJun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYCCJue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:50:34 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56047 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYCCJue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:50:34 -0500
Date: Mon, 3 Mar 2008 11:48:59 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303094859.GE4457@cs181133002.pp.htv.fi>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080303093103.GA23651@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:31:03AM +0100, Sam Ravnborg wrote:
> On Mon, Mar 03, 2008 at 10:17:14AM +0100, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > On Mon, Mar 03, 2008 at 09:57:20AM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Adrian Bunk <bunk@kernel.org> wrote:
> > > > 
> > > > > On Sat, Mar 01, 2008 at 09:26:41PM +0300, Alexey Starikovskiy wrote:
> > > > > > May I keep them inline?
> > > > > 
> > > > > The problem with such manual inlines is that we force gcc to always 
> > > > > inline them - and history has shown that functions grow without the 
> > > > > "inline" being removed.
> > > > 
> > > > what do you mean by "we force gcc to always inline them"?
> > > 
> > > #define inline          inline          __attribute__((always_inline))
> > > 
> > > > gcc is free to decide whether to inline or to not inline.
> > > 
> > > Not with __attribute__((always_inline)).
> > 
> > but that wasnt used in the code you patched:
> > 
> >   -inline int acpi_battery_present(struct acpi_battery *battery)
> >   +static int acpi_battery_present(struct acpi_battery *battery)
> 
> >From compiler-gcc.h:
> 
> #define inline          inline          __attribute__((always_inline))
> 
> So unless I am missing something obvious then each time we
> say inline to a function we require gcc to inline the function.

Exactly.

> It is my impression that today we only say inline if really needed
> and otherwise let gcc decide. So in almost all cases inlise should
> just be nuked?

The rule is:
- all static functions in headers should be marked inline
- no functions in .c files should be marked inline

For the latter there are a _few_ exceptions in hotpaths where doing so 
brings measurable advantages.

But generally (and especially long-term) it's best to let gcc decide 
which static functions in .c files should be inlined.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

