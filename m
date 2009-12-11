Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbZLKKlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbZLKKlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZLKKl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:41:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbZLKKl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:41:26 -0500
Date: Fri, 11 Dec 2009 11:41:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: jamie.iles@picochip.com, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, peterz@infradead.org
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
Message-ID: <20091211104126.GA22079@elte.hu>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
 <20091211102316.GB16882@elte.hu>
 <20091211.023808.233094506.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211.023808.233094506.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 11 Dec 2009 11:23:16 +0100
> 
> > 
> > * Jamie Iles <jamie.iles@picochip.com> wrote:
> > 
> >> +#ifdef __arm__
> >> +#include "../../arch/arm/include/asm/unistd.h"
> >> +#define rmb()		asm volatile("":::"memory")
> >> +#define cpu_relax()	asm volatile("":::"memory")
> >> +#endif
> > 
> > cpu_relax() looks fine, but rmb() seems not to match the one that can be 
> > found in arch/arm/:
> 
> I think he did it this way so it can compile in the meantime, and that 
> doing it right requires runtime cpu detection to select which barrier 
> instruction is even available on the current ARM cpu.

Yeah. We can merge a quick patch for it if runtime detection is 
difficult - but if then such a patch should err on the side of using the 
barrier instruction unconditionally - even if this causes perf to 
segfault on certain (older? UP configured?) ARM cores.

	Ingo
