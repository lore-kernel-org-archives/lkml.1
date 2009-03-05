Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZCEKIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZCEKIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZCEKIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:08:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56258 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbZCEKIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:08:05 -0500
Date: Thu, 5 Mar 2009 11:07:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] perfcounters: provide expansion room in the ABI
Message-ID: <20090305100748.GB29499@elte.hu>
References: <18862.19599.929591.3109@cargo.ozlabs.ibm.com> <20090304104945.GB4879@elte.hu> <18863.1197.527693.75146@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18863.1197.527693.75146@drongo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar wrote:
> 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git rfc
> > > 
> > >  include/linux/perf_counter.h |   12 +++++++++---
> > >  include/linux/syscalls.h     |    2 +-
> > >  kernel/perf_counter.c        |   10 +++++++---
> > >  3 files changed, 17 insertions(+), 7 deletions(-)
> > 
> > Pulled into tip:perfcounters/core, thanks Paul!
> 
> Actually, I goofed slightly.  In this bit of the patch:
> 
> @@ -80,10 +81,15 @@ struct perf_counter_hw_event {
>  				exclude_user   :  1, /* don't count user      */
>  				exclude_kernel :  1, /* ditto kernel          */
>  				exclude_hv     :  1, /* ditto hypervisor      */
> +				exclude_idle   :  1, /* don't count when idle */
>  
> -				__reserved_1 : 23;
> +				__reserved_1 : 55;
> +
> 
> the 55 should have been 54 if we want those bitfields to 
> occupy 64 bits.  With 55 there, __reserved_1 will go in the 
> next 64-bit quadword (x86-speak, or doubleword in 
> powerpc-speak).
> 
> Do you think that's worth changing?  If so I'll do a commit 
> changing the 55 to 54.

How about extending it to 118 instead? The creation of a counter 
is a slow path in any case.

	Ingo
