Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbZBXVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbZBXVXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZBXVXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:23:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbZBXVXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:23:01 -0500
Date: Tue, 24 Feb 2009 22:22:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <t.schmidt@phoenixsoftware.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [2.6.28.7] BUG: using smp_processor_id() in preemptible
	[00000000] code: pageattr-test/207
Message-ID: <20090224212241.GC1157@elte.hu>
References: <49A2ECF5.80104@phoenixsoftware.de> <20090223151331.033e0bf5.akpm@linux-foundation.org> <49A343EE.20100@phoenixsoftware.de> <20090224083028.GA17355@elte.hu> <20090224004001.fc2246da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224004001.fc2246da.akpm@linux-foundation.org>
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

> On Tue, 24 Feb 2009 09:30:28 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Tilman Schmidt <t.schmidt@phoenixsoftware.de> wrote:
> > 
> > > On Mon, 23 Feb 2009 15:13:31 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > A 2.6.28.6 -> 2.6.28.7 regressionlet.
> > > > 
> > > > This, I bet:
> > > > 
> > > > commit 2cf155b300c4839a7238b825c7c5f417e9d7cc68
> > > > Author: Jeremy Fitzhardinge <jeremy@goop.org>
> > > > Date:   Wed Feb 11 09:32:19 2009 -0800
> > > > 
> > > >     x86/cpa: make sure cpa is safe to call in lazy mmu mode
> > > >     
> > > >     commit 4f06b0436b2ddbd3b67b10e77098a6862787b3eb upstream.
> > > 
> > > Jackpot! Reverted that commit on 2.6.28.7, and the BUG messages are gone.
> > 
> > should be fixed by this as well:
> > 
> > d85cf93: x86/paravirt: make arch_flush_lazy_mmu/cpu disable preemption
> > 
> 
> Yup, that patch got lost.
> 
> commit d85cf93da66977dbc645352be1b2084a659d8a0b
> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> Date:   Thu Feb 12 10:02:56 2009 -0800
> 
>     x86/paravirt: make arch_flush_lazy_mmu/cpu disable preemption
> 
> from Linus mainline is needed in 2.6.28.8, please.

agreed.

	Ingo
