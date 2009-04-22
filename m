Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZDVKgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZDVKgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZDVKgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:36:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49833 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZDVKgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:36:45 -0400
Date: Wed, 22 Apr 2009 12:36:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the
	synchronization logic
Message-ID: <20090422103609.GE1115@elte.hu>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth> <20090422101811.GA1115@elte.hu> <b647ffbd0904220333n7bf7c35sdbdcec036963fa75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0904220333n7bf7c35sdbdcec036963fa75@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> 2009/4/22 Ingo Molnar <mingo@elte.hu>:
> >
> > * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> >
> >> +static long collect_cpu_info_local(void *arg)
> >> +{
> >> +     struct collect_for_cpu *cfc = arg;
> >> +
> >> +     BUG_ON(cfc->cpu != raw_smp_processor_id());
> >> +
> >> +     return microcode_ops->collect_cpu_info(cfc->cpu, cfc->cpu_sig);
> >> +}
> >> +
> >> +static int collect_cpu_info_on_target(int cpu, struct cpu_signature *cpu_sig)
> >> +{
> >> +     struct collect_for_cpu cfc = { .cpu_sig = cpu_sig, .cpu = cpu };
> >> +
> >> +     return work_on_cpu(cpu, collect_cpu_info_local, &cfc);
> >> +}
> >
> > Couldnt this be done without work_on_cpu(), by using
> > smp_call_function()?
> 
> It should be definitely possible. Will send an updated version.
> 
> p.s. grrr... this idea should have come into my mind in the first place :-/

well you made all the hard work of tightening all the locking to 
make this all real easy, right?

	Ingo
