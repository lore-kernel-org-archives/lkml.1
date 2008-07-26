Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbYGZLW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbYGZLW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 07:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbYGZLWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 07:22:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51942 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYGZLWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 07:22:21 -0400
Date: Sat, 26 Jul 2008 13:22:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] hugetlbfs: fix build failure on 64-bit x86
Message-ID: <20080726112212.GC11591@elte.hu>
References: <20080726091654.GA18341@elte.hu> <20080726025839.39a11b66.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726025839.39a11b66.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 26 Jul 2008 11:16:54 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > [resend, still relevant to -git]
> > 
> > >From 5215af24a20e5f448ee45cd1d97c4118b876c0f6 Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Fri, 25 Jul 2008 20:45:52 +0200
> > Subject: [PATCH] hugetlbfs: fix build failure on 64-bit x86
> > 
> > fix:
> > 
> >  arch/x86/mm/built-in.o: In function `setup_hugepagesz':
> >  hugetlbpage.c:(.init.text+0xb49): undefined reference to `hugetlb_add_hstate'
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/mm/hugetlbpage.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> > index 8f307d9..977d185 100644
> > --- a/arch/x86/mm/hugetlbpage.c
> > +++ b/arch/x86/mm/hugetlbpage.c
> > @@ -425,7 +425,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
> >  
> >  #endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
> >  
> > -#ifdef CONFIG_X86_64
> > +#if defined(CONFIG_X86_64) && defined(CONFIG_SYSCTL)
> >  static __init int setup_hugepagesz(char *opt)
> >  {
> >  	unsigned long ps = memparse(opt, &opt);
> 
> Seems wrong that a __setup handler would vanish if CONFIG_SYSCTL=n.
> 
> I think Nishanth's patch (sent to Linus a few hours ago) fixes this
> correctly, by making hugetlb_add_hstate available if CONFIG_SYSCTL=n:

agreed, that's cleaner/better.

> From: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> Fixes a build failure reported by Alan Cox:
> 
> mm/hugetlb.c: In function `hugetlb_acct_memory': mm/hugetlb.c:1507:
> error: implicit declaration of function `cpuset_mems_nr'

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
