Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbZBCV0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbZBCV0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZBCV0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:26:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44541 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbZBCV0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:26:00 -0500
Date: Tue, 3 Feb 2009 22:25:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, x86@kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: Re: mmotm 2009-02-02-17-12 uploaded (x86/nopmd etc.)
Message-ID: <20090203212538.GB20527@elte.hu>
References: <200902030112.n131CNiq010549@imap1.linux-foundation.org> <498893C8.6080506@oracle.com> <20090203191804.GA24698@elte.hu> <20090203121706.423d5cab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203121706.423d5cab.akpm@linux-foundation.org>
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

> On Tue, 3 Feb 2009 20:18:04 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > akpm@linux-foundation.org wrote:
> > > > The mm-of-the-moment snapshot 2009-02-02-17-12 has been uploaded to
> > > > 
> > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > > 
> > > > and will soon be available at
> > > > 
> > > >    git://git.zen-sources.org/zen/mmotm.git
> > > 
> > > 
> > > There seems to be some kind of #include hell here.  I moved a few lines
> > > around in include/asm-generic/pgtable-nopmd.h & that makes the build
> > > get further, but it still has header problems (BUG() is undefined).
> > 
> > problem caused by which commit?
> > 
> 
> mm-unify-some-pmd_-functions-and-move-them-in-a-distinct-include.patch
> 
> This is getting painful.

the include file spaghetti is ... interesting there, and it's historic.

I could blame it on highmem, PAE or paravirt - but i'll only blame it on 
paravirt for now because those developers are still around! ;-)

Jeremy, any ideas how to reduce the historic dependency mess in that area?
I think we should go on three routes at once:

 - agressive splitup and separation of type definitions from method
   declaration (+ inline definitions). The spinlock_types.h / spinlock.h 
   splitup was really nice in solving such dependency problems.

 - uninlining of methods: instead of macro-ing them - wherever possible. 
   It's really hard to mess up type + externs headers - while headers with 
   inlines and macros mixed in get painful quickly.

 - removal of spurious pile of dozens of #include lines in header files.

If anyone sends such patches i could try them on the -tip build machinery 
and help shake out collateral damage - which there will be for sure.

	Ingo
