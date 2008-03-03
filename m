Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbYCCLgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbYCCLgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYCCLg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:36:28 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37095 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYCCLgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:36:25 -0500
Date: Mon, 3 Mar 2008 13:34:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303113451.GF4457@cs181133002.pp.htv.fi>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080303103933.GC21190@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 11:39:33AM +0100, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > >From compiler-gcc.h:
> > >
> > > #define inline          inline          __attribute__((always_inline))
> > 
> > So unless I am missing something obvious then each time we say inline 
> > to a function we require gcc to inline the function.
> > 
> > It is my impression that today we only say inline if really needed and 
> > otherwise let gcc decide. So in almost all cases inlise should just be 
> > nuked?
> 
> no, what we should nuke is this always_inline definition. That was 
> always the intention of FORCED_INLINE, and the removal of FORCED_INLINE 
> was to _remove the forcing_, not to make it unconditional.

It was always unconditional, and neither adding, toggling nor removing 
of CONFIG_FORCED_INLINING changed this invariant.

And what we should do is to attack the excessive wrong usage of inlines 
in .c files, not messing with a global #define in a way that the results 
on 24 architectures with 7 different releases of gcc would be unpredictable.

> so Adrian, if you knew about this bug all along, you might as well have 
> reported it :-/

http://lkml.org/lkml/2007/1/19/36
http://lkml.org/lkml/2007/4/9/363

are the result of a quick Google search of me stating this previously on 
linux-kernel. It might have been more often, but I'm too lame too 
search further.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

