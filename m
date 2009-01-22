Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZAVILe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZAVILe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZAVILY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:11:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZAVILX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:11:23 -0500
Date: Thu, 22 Jan 2009 09:11:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: yinghai@kernel.org, mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: sparc64 build breakage...
Message-ID: <20090122081101.GA32212@elte.hu>
References: <20090121.171553.142827920.davem@davemloft.net> <20090121.172451.72573335.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121.172451.72573335.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Wed, 21 Jan 2009 17:15:53 -0800 (PST)
> 
> > 
> > This change:
> > 
> > commit d7e51e66899f95dabc89b4d4c6674a6e50fa37fc
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Wed Jan 7 15:03:13 2009 -0800
> > 
> >     sparseirq: make some func to be used with genirq
> > 
> > breaks the sparc64 build:
> ..
> > This should fix it:
> > 
> > sparc64: Fix build by using kstat_irqs_cpu().
> 
> And here is a mix for the next failure.

Applied your fixes to tip/irq/sparseirq:

 e81838d: sparc64: Fix build by using kstat_irqs_cpu()
 623d3f0: sparc64: Fix build by including linux/irq.h into time_64.c

thanks David!

> But really, either linux/kernel_stat.h provides the 
> kstat_incr_irqs_this_cpu interface or linux/irq.h does, not both.

Yes, but every time someone tries to clean those dependencies up, it gets 
held up by non-genirq architectures:

 /*
  * Please do not include this file in generic code.  There is currently
  * no requirement for any architecture to implement anything held
  * within this file.
  *
  * Thanks. --rmk
  */

Meanwhile that particular comment is moot because ARM is genirq - but 
there's a handful of other non-genirq architectures so this area of code 
continues to be a mess.

I guess we could move all the APIs to kernel_stat.h. Yinghai?

	Ingo
