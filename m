Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZCKKwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZCKKwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZCKKwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:52:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbZCKKwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:52:24 -0400
Date: Wed, 11 Mar 2009 11:52:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Lowengrub <lowdanie@gmail.com>, linux-mm@kvack.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: use list.h for vma list
Message-ID: <20090311105210.GB2282@elte.hu>
References: <8c5a844a0903110255q45b7cdf4u1453ce40d495ee2c@mail.gmail.com> <20090311104018.GA2376@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311104018.GA2376@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Mar 11, 2009 at 11:55:48AM +0200, Daniel Lowengrub wrote:
> > Use the linked list defined list.h for the list of vmas that's stored
> > in the mm_struct structure.  Wrapper functions "vma_next" and
> > "vma_prev" are also implemented.  Functions that operate on more than
> > one vma are now given a list of vmas as input.
> 
> > Signed-off-by: Daniel Lowengrub
> 
> That's not how S-o-b line should look like.
> 
> > --- linux-2.6.28.7.vanilla/arch/alpha/kernel/osf_sys.c
> > +++ linux-2.6.28.7/arch/alpha/kernel/osf_sys.c
> > @@ -1197,7 +1197,7 @@
> >  		if (!vma || addr + len <= vma->vm_start)
> >  			return addr;
> >  		addr = vma->vm_end;
> > -		vma = vma->vm_next;
> > +		vma = vma_next(vma);
> 
> Well, this bloats both mm_struct and vm_area_struct.

here's some hard numbers from an earlier submission:

| I made a script that runs 'time ./mmap-perf' 100 times and 
| outputs the average.
|
| The output on the standard kernel was:
|
|   real: 1.022600
|   user: 0.135900
| system: 0.852600
|
| The output after the patch was:
|
|   real: 0.815400
|   user: 0.113200
| system: 0.622200

Which is a 25% speedup in MM performance - which looks very 
significant.

Note: i have not repeated the measurements, and it still looks a 
bit too good - i'd have expected if there's such a low hanging 
25% fruit in the MM we'd have fixed it already.

( Daniel - please preserve such measurements in changelogs. )

	Ingo
