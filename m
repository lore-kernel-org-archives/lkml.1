Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbZDIFU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbZDIFU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbZDIFUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:20:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34117 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbZDIFUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:20:18 -0400
Date: Thu, 9 Apr 2009 07:20:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: powerpc: add nmi_enter/nmi_exit calls
Message-ID: <20090409052002.GE5352@elte.hu>
References: <18909.31952.873098.336615@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18909.31952.873098.336615@cargo.ozlabs.ibm.com>
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

> Impact: powerpc bug fix
> 
> Now that the core is using in_nmi() (added in e30e08f6, 
> "perf_counter: fix NMI race in task clock"), we need the powerpc 
> perf_counter_interrupt to call nmi_enter() and nmi_exit() in those 
> cases where the interrupt happens when interrupts are 
> soft-disabled.  If interrupts were soft-enabled, we can treat it 
> as a regular interrupt and do irq_enter/irq_exit around the whole 
> routine.  This lets us get rid of the test_perf_counter_pending() 
> call at the end of perf_counter_interrupt, thus simplifying things 
> a little.

applied, thanks Paul!

I'm wondering, what was the real impact? Was it a crash or some 
other misbehavior? This impact line:

	Impact: powerpc bug fix

is a bit too generic to be useful in practice. Something like:

	Impact: fix stuck NMIs on powerpc
	Impact: fix NMI crash on powerpc

would have been more descriptive about the real, hands-on impact of 
this patch.

	Ingo
