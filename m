Return-Path: <linux-kernel-owner+w=401wt.eu-S1765971AbYDOTy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765971AbYDOTy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbYDOTyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:54:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368AbYDOTyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:54:51 -0400
Date: Tue, 15 Apr 2008 21:54:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415195430.GA23015@elte.hu>
References: <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 15 Apr 2008, Linus Torvalds wrote:
> 
> > On Tue, 15 Apr 2008, Ingo Molnar wrote:
> > > 
> > > btw., now with a second full day spent on this regression, i have 
> > > figured out a workaround the hard way: increasing SECTION_SIZE_BITS in 
> > > include/asm-x86/sparsemem.h from 26 to 27 makes it go away.
> > 
> > Interesting.
> 
> Hmmmm. SECTION_SIZE_BITS == 26 means SECTIONS_SHIFT == 6. Increasing 
> SECTION_SIZE_BITS to 27 reduces SECTION_SHIFT to 5. Thereby the number 
> of sparsemem sections (NR_MEM_SECTIONS) is reduced to half (64 to 32).

yes, as i said in this thread already earlier today, the sparse chunking 
goes from 64MB to 128MB. (and hence, by virtue of !PAE having a 4GB 
physical address space, the # of sparse sections goes from 64 to 32 - 
you can see the full sparse sections printout in my latest crashlog in 
my previous mail, including the NR_MEM_SECTIONS printout.)

Pretty please, could you pay more than cursory attention to this bug i 
already spent two full days on and which is blocking the v2.6.25 
release?

Your commits are all over the place in this code, and you are one of the 
maintainers as well. We've got 5000 lines of flux in mm/* in v2.6.25.

I'm just guessing my way around, but right now my impression is that the 
current early memory setup code is unrobust, over-complex, occasionally 
butt-ugly to read code in high need of cleanups, simplifications and 
debug facilities, visibly plagued by hit-and-run changes with frequent 
typos and everything else you normally dont want to see in the core 
kernel. (Did i get your attention now? ;-)

	Ingo
