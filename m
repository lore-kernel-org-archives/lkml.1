Return-Path: <linux-kernel-owner+w=401wt.eu-S1763237AbYGOUd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763237AbYGOUd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbYGOUdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:33:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41717 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbYGOUdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:33:14 -0400
Subject: Re: [PATCH 00/20] generic show_mem() v5
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@saeurebad.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
In-Reply-To: <20080715132203.a9482685.akpm@linux-foundation.org>
References: <20080704160737.750988999@saeurebad.de>
	 <1216148794.25942.11.camel@nimitz>
	 <20080715132203.a9482685.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:33:06 -0700
Message-Id: <1216153986.25942.31.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 13:22 -0700, Andrew Morton wrote:
> > The sections are 512MB, and you can see 6 valid ones
> > followed by two holes, and then two more valid ones.
> > 
> > Anyway, I believe this patch will fix the oops.
> 
> This looks like it might be suitable.  Can you please test it?

Yup, will do.  It's where I'm sending this email from, so I'll get to it
in a bit. :)

> > ---
> >  arch/x86/mm/pgtable_32.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
> > index 369cf06..eb2a480 100644
> > --- a/arch/x86/mm/pgtable_32.c
> > +++ b/arch/x86/mm/pgtable_32.c
> > @@ -37,6 +37,8 @@ void show_mem(void)
> >               for (i = 0; i < pgdat->node_spanned_pages; ++i) {
> >                       if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
> >                               touch_nmi_watchdog();
> > +                     if (!pfn_valid(pgdat->node_start_pfn + i))
> > +                             continue;
> >                       page = pgdat_page_nr(pgdat, i);
> >                       total++;
> >                       if (PageHighMem(page))
> 
> What change caused this oops to turn up now?

Me getting an extra 2GB (up to 4GB) of RAM for my laptop, which caused a
memory hole, which triggers only with SPARSEMEM=y.  Most people probably
don't run with sparsemem or a 32-bit kernel with that much RAM.

-- Dave

