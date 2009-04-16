Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZDPJ0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZDPJ0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZDPJ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:26:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZDPJ0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:26:30 -0400
Date: Thu, 16 Apr 2009 11:25:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] irq: make set_affinity to return status -v2
Message-ID: <20090416092531.GM9813@elte.hu>
References: <49E68C41.4020801@kernel.org> <49E68CBC.8090507@kernel.org> <20090416090826.GG9813@elte.hu> <1239873477.14053.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239873477.14053.9.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Thu, 2009-04-16 at 11:08 +0200, Ingo Molnar wrote:
> > >  arch/alpha/kernel/sys_dp264.c         |    8 +++-
> > >  arch/alpha/kernel/sys_titan.c         |    4 +-
> > >  arch/arm/common/gic.c                 |    4 +-
> > >  arch/cris/arch-v32/kernel/irq.c       |    4 +-
> > >  arch/ia64/hp/sim/hpsim_irq.c          |    3 +
> > >  arch/ia64/kernel/iosapic.c            |   10 +++--
> > >  arch/ia64/kernel/msi_ia64.c           |   16 +++++---
> > >  arch/ia64/sn/kernel/irq.c             |    4 +-
> > >  arch/ia64/sn/kernel/msi_sn.c          |    8 ++--
> > >  arch/mips/cavium-octeon/octeon-irq.c  |    8 +++-
> > >  arch/mips/include/asm/irq.h           |    2 -
> > >  arch/mips/kernel/irq-gic.c            |    5 +-
> > >  arch/mips/mti-malta/malta-smtc.c      |    4 +-
> > >  arch/mips/sibyte/bcm1480/irq.c        |    8 ++--
> > >  arch/mips/sibyte/sb1250/irq.c         |    8 ++--
> > >  arch/parisc/kernel/irq.c              |    6 ++-
> > >  arch/powerpc/platforms/pseries/xics.c |   12 +++---
> > >  arch/powerpc/sysdev/mpic.c            |    4 +-
> > >  arch/sparc/kernel/irq_64.c            |   12 ++++--
> > >  arch/x86/kernel/apic/io_apic.c        |   64 +++++++++++++++++++++-------------
> > >  drivers/parisc/iosapic.c              |    6 ++-
> > >  drivers/xen/events.c                  |   12 +++---
> > >  include/linux/irq.h                   |    2 -
> > >  23 files changed, 140 insertions(+), 74 deletions(-)
> []
> > There is one omission: this should be Cc:-ed to 
> > linux-arch@vger.kernel.org, because it affects all architectures.
> 
> How is one supposed to know this tidbit?

by hanging around on lkml long enough? :)

If you think about automating it into scripts/get_maintainer.pl - 
maybe you could add a trigger that if a change affects more than a 
single arch/* architecture then linux-arch should be generated too 
for the Cc: list? It would be nice to have.

	Ingo
