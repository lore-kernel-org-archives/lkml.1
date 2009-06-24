Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbZFXSAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbZFXSAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbZFXSAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:00:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:54995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbZFXSAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:00:24 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090624084033.GA18713@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
	 <1245795173.26280.17.camel@localhost.localdomain>
	 <20090624084033.GA18713@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 23:29:53 +0530
Message-Id: <1245866393.3181.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 10:40 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Tue, 2009-06-23 at 21:56 +0200, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > here's an edited version of my suggestions:
> > > 
> > > >       259250339  dL1-loads              (scaled from 22.73%)
> > > >         1187200  dL1-load-misses        (scaled from 23.01%)
> > > >          150454  dL1-stores             (scaled from 23.01%)
> > > >          494252  dL1-prefetches         (scaled from 23.29%)
> > > >          362661  dL1-prefetch-misses    (scaled from 23.73%)
> > > >       247343449  iL1-loads              (scaled from 23.71%)
> > > >         4804990  iL1-load-misses        (scaled from 23.85%)
> > > >          108711  iL1-prefetches         (scaled from 23.83%)
> > > >         6260313  LLC-loads              (scaled from 23.82%)
> > > >          605425  LLC-load-misses        (scaled from 23.82%)
> > > >         6898075  LLC-stores             (scaled from 23.96%)
> > > >       248334160  dTLB-loads             (scaled from 23.95%)
> > > >         3812835  dTLB-load-misses       (scaled from 23.87%)
> > > >       253208496  iTLB-loads             (scaled from 23.73%)
> > > >            5873  iTLB-load-misses       (scaled from 23.46%)
> > > >       110891027  branches               (scaled from 23.21%)
> > > >         5529622  branch-misses          (scaled from 23.02%)
> > > 
> > > We can leave out 'refs' i think - without any qualification 
> > > statements like '247343449 iL1-loads' are still unambigious i think.
> > > 
> > 
> > Looks good.
> > 
> > > Plus we can abbreviate dL1/iL1/dTLB/iTLB. The capitalization 
> > > matters. Also, note that it's LLC (Last Level Cache), not L2.
> > > 
> > > ( Sidenote: L2 can still be an alias for LLC, even though some CPUs 
> > >   have a L3 too. )
> > > 
> > 
> > Ok, I will fix it and also set the alias.
> > 
> > > Note, branches are special - we dont really have 'branch loads', 
> > > branches are executions. 'Branches' and 'Branch-misses' are the 
> > > right term.
> > > 
> > > Do you agree?
> > > 
> > 
> > Event we used for (BPU, READ, ACCESS) is 'branch instructions 
> > retired'
> > 
> > So 'branch loads' we mean 'branch instruction loaded and retired'
> > 
> > I like all of them : 'branch loads', 'branch retired' or 
> > 'branches'
> 
> There's two things:
> 
> Firstly, there are "loads" are when data is loaded into the CPU. It 
> has a very firm meaning.
> 
> Secondly, the "loading an instruction into the CPU" idiom you 
> mention is not really correct - what we generally say is to "fetch 
> an instruction".
> 
> In that sense using 'branch loads' is confusing, and that's why i 
> corrected it. 'branches' is perfectly fine shortcut for 'branch 
> instructions executed'. (or branch instructions fetched and retired)
> 


OK, We will show :
'branch loads'           -> 'branches'
'branch load-misses'     -> 'branch-misses'

now issue is how we can show :

'branch stores'          ->  ?
'branch store-misses'    ->  ?

'branch prefetches'      ->  ?
'branch prefetch-misses' ->  ?

Thanks,
--
JSR

