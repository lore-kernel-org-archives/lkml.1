Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbZFWWNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbZFWWNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZFWWNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:13:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:40440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbZFWWN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:13:29 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090623195656.GC8777@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 03:42:53 +0530
Message-Id: <1245795173.26280.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 21:56 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > After :
> > 
> >  Performance counter stats for 'ls -lR /usr/include/':
> > 
> >       259250339  L1-d-load-refs        (scaled from 22.73%)
> >         1187200  L1-d-load-miss        (scaled from 23.01%)
> >          150454  L1-d-store-refs       (scaled from 23.01%)
> >          494252  L1-d-prefetch-refs    (scaled from 23.29%)
> >          362661  L1-d-prefetch-miss    (scaled from 23.73%)
> >       247343449  L1-i-load-refs        (scaled from 23.71%)
> >         4804990  L1-i-load-miss        (scaled from 23.85%)
> >          108711  L1-i-prefetch-refs    (scaled from 23.83%)
> >         6260313  L2-load-refs          (scaled from 23.82%)
> >          605425  L2-load-miss          (scaled from 23.82%)
> >         6898075  L2-store-refs         (scaled from 23.96%)
> >       248334160  d-TLB-load-refs       (scaled from 23.95%)
> >         3812835  d-TLB-load-miss       (scaled from 23.87%)
> >       253208496  i-TLB-load-refs       (scaled from 23.73%)
> >            5873  i-TLB-load-miss       (scaled from 23.46%)
> >       110891027  Branch-load-refs      (scaled from 23.21%)
> >         5529622  Branch-load-miss      (scaled from 23.02%)
> 
> here's an edited version of my suggestions:
> 
> >       259250339  dL1-loads              (scaled from 22.73%)
> >         1187200  dL1-load-misses        (scaled from 23.01%)
> >          150454  dL1-stores             (scaled from 23.01%)
> >          494252  dL1-prefetches         (scaled from 23.29%)
> >          362661  dL1-prefetch-misses    (scaled from 23.73%)
> >       247343449  iL1-loads              (scaled from 23.71%)
> >         4804990  iL1-load-misses        (scaled from 23.85%)
> >          108711  iL1-prefetches         (scaled from 23.83%)
> >         6260313  LLC-loads              (scaled from 23.82%)
> >          605425  LLC-load-misses        (scaled from 23.82%)
> >         6898075  LLC-stores             (scaled from 23.96%)
> >       248334160  dTLB-loads             (scaled from 23.95%)
> >         3812835  dTLB-load-misses       (scaled from 23.87%)
> >       253208496  iTLB-loads             (scaled from 23.73%)
> >            5873  iTLB-load-misses       (scaled from 23.46%)
> >       110891027  branches               (scaled from 23.21%)
> >         5529622  branch-misses          (scaled from 23.02%)
> 
> We can leave out 'refs' i think - without any qualification 
> statements like '247343449 iL1-loads' are still unambigious i think.
> 

Looks good.

> Plus we can abbreviate dL1/iL1/dTLB/iTLB. The capitalization 
> matters. Also, note that it's LLC (Last Level Cache), not L2.
> 
> ( Sidenote: L2 can still be an alias for LLC, even though some CPUs 
>   have a L3 too. )
> 

Ok, I will fix it and also set the alias.

> Note, branches are special - we dont really have 'branch loads', 
> branches are executions. 'Branches' and 'Branch-misses' are the 
> right term.
> 
> Do you agree?
> 

Event we used for (BPU, READ, ACCESS) is 'branch instructions retired'

So 'branch loads' we mean 'branch instruction loaded and retired'

I like all of them : 'branch loads', 'branch retired' or 'branches'

Please let me know, which one is best option so that I can prepare the
patch.

Thanks,
--
JSR 



