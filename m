Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYCUKPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYCUKPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYCUKPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:15:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbYCUKPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:15:18 -0400
Date: Fri, 21 Mar 2008 11:15:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: tick-common.c hack for s390 needed
Message-ID: <20080321101504.GI20420@elte.hu>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com> <20080319054545.GA18834@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319054545.GA18834@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Mar 18, 2008 at 10:31:19AM +0100, Heiko Carstens wrote:
> > Hi Thomas, Ingo,
> > 
> > I'm converting s390 from s390's NO_IDLE_HZ to GENERIC_CLOCKEVENTS and
> > therefore to the generic NO_HZ implementation.
> > One of the problems that need a patch for this is kernel/time/tick-common.c
> > which relies on the irq stuff present in include/linux/irq.h.
> > In particular s390 doesn't have something like irq_set_affinity which
> > causes this build error:
> 
> Generic code must never use linux/irq.h - it's more like asm-generic 
> file predating asm-generic.

agreed.

Heiko, if you remove all these:

 ./time/tick-broadcast.c:#include <linux/irq.h>
 ./time/tick-oneshot.c:#include <linux/irq.h>
 ./time/tick-common.c:#include <linux/irq.h>
 ./hrtimer.c:#include <linux/irq.h>

from kernel/*, do things improve on s390? If yes then please send a 
patch for it and i'll check whether there's any include file dependency 
fallout on x86.

	Ingo
