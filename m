Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbZFXIlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbZFXIlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZFXIkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:40:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZFXIkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:40:51 -0400
Date: Wed, 24 Jun 2009 10:40:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
Message-ID: <20090624084033.GA18713@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain> <20090623195656.GC8777@elte.hu> <1245795173.26280.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245795173.26280.17.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Tue, 2009-06-23 at 21:56 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > After :
> > > 
> > >  Performance counter stats for 'ls -lR /usr/include/':
> > > 
> > >       259250339  L1-d-load-refs        (scaled from 22.73%)
> > >         1187200  L1-d-load-miss        (scaled from 23.01%)
> > >          150454  L1-d-store-refs       (scaled from 23.01%)
> > >          494252  L1-d-prefetch-refs    (scaled from 23.29%)
> > >          362661  L1-d-prefetch-miss    (scaled from 23.73%)
> > >       247343449  L1-i-load-refs        (scaled from 23.71%)
> > >         4804990  L1-i-load-miss        (scaled from 23.85%)
> > >          108711  L1-i-prefetch-refs    (scaled from 23.83%)
> > >         6260313  L2-load-refs          (scaled from 23.82%)
> > >          605425  L2-load-miss          (scaled from 23.82%)
> > >         6898075  L2-store-refs         (scaled from 23.96%)
> > >       248334160  d-TLB-load-refs       (scaled from 23.95%)
> > >         3812835  d-TLB-load-miss       (scaled from 23.87%)
> > >       253208496  i-TLB-load-refs       (scaled from 23.73%)
> > >            5873  i-TLB-load-miss       (scaled from 23.46%)
> > >       110891027  Branch-load-refs      (scaled from 23.21%)
> > >         5529622  Branch-load-miss      (scaled from 23.02%)
> > 
> > here's an edited version of my suggestions:
> > 
> > >       259250339  dL1-loads              (scaled from 22.73%)
> > >         1187200  dL1-load-misses        (scaled from 23.01%)
> > >          150454  dL1-stores             (scaled from 23.01%)
> > >          494252  dL1-prefetches         (scaled from 23.29%)
> > >          362661  dL1-prefetch-misses    (scaled from 23.73%)
> > >       247343449  iL1-loads              (scaled from 23.71%)
> > >         4804990  iL1-load-misses        (scaled from 23.85%)
> > >          108711  iL1-prefetches         (scaled from 23.83%)
> > >         6260313  LLC-loads              (scaled from 23.82%)
> > >          605425  LLC-load-misses        (scaled from 23.82%)
> > >         6898075  LLC-stores             (scaled from 23.96%)
> > >       248334160  dTLB-loads             (scaled from 23.95%)
> > >         3812835  dTLB-load-misses       (scaled from 23.87%)
> > >       253208496  iTLB-loads             (scaled from 23.73%)
> > >            5873  iTLB-load-misses       (scaled from 23.46%)
> > >       110891027  branches               (scaled from 23.21%)
> > >         5529622  branch-misses          (scaled from 23.02%)
> > 
> > We can leave out 'refs' i think - without any qualification 
> > statements like '247343449 iL1-loads' are still unambigious i think.
> > 
> 
> Looks good.
> 
> > Plus we can abbreviate dL1/iL1/dTLB/iTLB. The capitalization 
> > matters. Also, note that it's LLC (Last Level Cache), not L2.
> > 
> > ( Sidenote: L2 can still be an alias for LLC, even though some CPUs 
> >   have a L3 too. )
> > 
> 
> Ok, I will fix it and also set the alias.
> 
> > Note, branches are special - we dont really have 'branch loads', 
> > branches are executions. 'Branches' and 'Branch-misses' are the 
> > right term.
> > 
> > Do you agree?
> > 
> 
> Event we used for (BPU, READ, ACCESS) is 'branch instructions 
> retired'
> 
> So 'branch loads' we mean 'branch instruction loaded and retired'
> 
> I like all of them : 'branch loads', 'branch retired' or 
> 'branches'

There's two things:

Firstly, there are "loads" are when data is loaded into the CPU. It 
has a very firm meaning.

Secondly, the "loading an instruction into the CPU" idiom you 
mention is not really correct - what we generally say is to "fetch 
an instruction".

In that sense using 'branch loads' is confusing, and that's why i 
corrected it. 'branches' is perfectly fine shortcut for 'branch 
instructions executed'. (or branch instructions fetched and retired)

	Ingo
