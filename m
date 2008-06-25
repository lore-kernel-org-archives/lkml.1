Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbYFYMEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbYFYMEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbYFYMEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:04:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:34948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbYFYMEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:04:04 -0400
Date: Wed, 25 Jun 2008 14:04:41 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, x86@kernel.org, vgoyal@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] e820_update_range(): Strip size of original region
Message-ID: <20080625140441.0328bbb3@halley.suse.de>
In-Reply-To: <86802c440806241257m4401300aq6ce24787ec80b5cd@mail.gmail.com>
References: <1214318125-32619-1-git-send-email-bwalle@suse.de>
	<1214318125-32619-2-git-send-email-bwalle@suse.de>
	<86802c440806241257m4401300aq6ce24787ec80b5cd@mail.gmail.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu [2008-06-24 12:57]:
>
> On Tue, Jun 24, 2008 at 7:35 AM, Bernhard Walle <bwalle@suse.de> wrote:
> > This patch fixes a bug in e820_update_range(): Previously, if a region was
> > partially covered, then e820_update_range() only added a new E820 range but
> > didn't update the end/size of the previous range. That lead to duplicate
> > covering of a region.
> >
> > Patch tested on i386 and x86-64 with patch that uses e820_update_range()
> > to limit the E820 map when "mem" parameter is specified on the command line.
> >
> >
> > Signed-off-by: Bernhard Walle <bwalle@suse.de>
> > ---
> >  arch/x86/kernel/e820.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> > index e285ea3..e466073 100644
> > --- a/arch/x86/kernel/e820.c
> > +++ b/arch/x86/kernel/e820.c
> > @@ -422,6 +422,7 @@ u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
> >                final_end = min(start + size, ei->addr + ei->size);
> >                if (final_start >= final_end)
> >                        continue;
> > +               ei->size -= final_end - final_start;
> >                e820_add_region(final_start, final_end - final_start,
> >                                         new_type);
> >                real_updated_size += final_end - final_start;
> > --
> 
> thanks for finding it, but fix is not complete. could have problem
> with fore boundary overlapping. need to update the ei->addr
> 
> please check attached patch

Thanks, works. I added this to my patch series and reposted them.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
