Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYGRUfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYGRUfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760249AbYGRUfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:35:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39360 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760151AbYGRUf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:35:29 -0400
Date: Fri, 18 Jul 2008 22:35:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] cpumask: Optimize cpumask_of_cpu in
	lib/smp_processor_id.c
Message-ID: <20080718203511.GA24194@elte.hu>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <20080715211430.306421000@polaris-admin.engr.sgi.com> <20080718203321.GA21280@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718203321.GA21280@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> hmmm:
> 
> > --- linux-2.6.tip.orig/lib/smp_processor_id.c
> > +++ linux-2.6.tip/lib/smp_processor_id.c
> 
> >  	unsigned long preempt_count = preempt_count();
> >  	int this_cpu = raw_smp_processor_id();
> > -	cpumask_t this_mask;
> > +	cpumask_of_cpu_ptr_declare(this_mask);
> 
> > -	this_mask = cpumask_of_cpu(this_cpu);
> > +	cpumask_of_cpu_ptr_next(this_mask, cpu);
> 
> 'cpu' is not declared ...

commit 06f8d00e9eecb738c99b737ac38a585ea7583ad5
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jul 18 22:34:00 2008 +0200

    cpumask: Optimize cpumask_of_cpu in lib/smp_processor_id.c, fix
    
    fix typo.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/smp_processor_id.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 9fb2df0..c4381d9 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -23,7 +23,7 @@ notrace unsigned int debug_smp_processor_id(void)
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	cpumask_of_cpu_ptr_next(this_mask, cpu);
+	cpumask_of_cpu_ptr_next(this_mask, this_cpu);
 
 	if (cpus_equal(current->cpus_allowed, *this_mask))
 		goto out;
