Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbYCCJrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbYCCJrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYCCJrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:47:31 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47214 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbYCCJrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:47:31 -0500
Date: Mon, 3 Mar 2008 11:45:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303094556.GD4457@cs181133002.pp.htv.fi>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080303091714.GA18250@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:17:14AM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Mon, Mar 03, 2008 at 09:57:20AM +0100, Ingo Molnar wrote:
> > > 
> > > * Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > On Sat, Mar 01, 2008 at 09:26:41PM +0300, Alexey Starikovskiy wrote:
> > > > > May I keep them inline?
> > > > 
> > > > The problem with such manual inlines is that we force gcc to always 
> > > > inline them - and history has shown that functions grow without the 
> > > > "inline" being removed.
> > > 
> > > what do you mean by "we force gcc to always inline them"?
> > 
> > #define inline          inline          __attribute__((always_inline))
> > 
> > > gcc is free to decide whether to inline or to not inline.
> > 
> > Not with __attribute__((always_inline)).
> 
> but that wasnt used in the code you patched:
> 
>   -inline int acpi_battery_present(struct acpi_battery *battery)
>   +static int acpi_battery_present(struct acpi_battery *battery)

It was used, since the #define affects all inline's in the kernel.

> > > (and CONFIG_FORCED_INLINING got removed from 2.6.25)
> > 
> > CONFIG_FORCED_INLINING never had any effect.
> 
> my experience was that it had effects. Why do you say it 'never had any 
> effect'?

I don't see how it could have possibly had any effect.

Which effects did you experience?

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

