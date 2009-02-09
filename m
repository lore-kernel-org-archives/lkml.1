Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZBILTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZBILTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZBILTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:19:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51760 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbZBILTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:19:09 -0500
Date: Mon, 9 Feb 2009 12:18:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86/xen: Use xen-specific path for interrupt
	delivery
Message-ID: <20090209111856.GB4626@elte.hu>
References: <498CD755.5030301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498CD755.5030301@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Rather than mapping event channels to vectors and then using the  
> vector->irq mapping for interrupt delivery, just cut out the middleman  
> and directly map event channels to irqs.  This allows for some more  
> cleanups in the event handling code.
>
> The following changes since commit 637f52a7cc5b3ae22354b7e45397375a17d626af:
>  Jeremy Fitzhardinge (1):
>        x86: unify do_IRQ()
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git jsgf/xen/irq
>
> Jeremy Fitzhardinge (5):
>      xen: set irq_chip disable
>      xen: use our own eventchannel->irq path
>      xen: pack all irq-related info together
>      xen: remove irq bindcount
>      xen: make sure that softirqs get handled at the end of event processing
>
> arch/x86/include/asm/xen/events.h |    6 -
> arch/x86/xen/irq.c                |   17 +---
> drivers/xen/events.c              |  224 +++++++++++++++++++++++++------------
> 3 files changed, 155 insertions(+), 92 deletions(-)

Ok, never mind my comment on the do_IRQ() detail, this looks good after all,
you just consolidated what is there already in essence.

Pulled into tip/x86/apic [which had dependencies here], thanks Jeremy!

Btw., please remove leftover bits like:

+       //printk("cpu %d handling irq %d\n", smp_processor_id(), info->irq);


	Ingo
