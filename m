Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYDOHrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYDOHrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYDOHqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:46:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbYDOHqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:46:50 -0400
Date: Tue, 15 Apr 2008 09:46:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Erik Bosman <ebn310@few.vu.nl>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
Message-ID: <20080415074630.GA16721@elte.hu>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl> <20080415002918.6a3b40b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415002918.6a3b40b6.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > --- a/arch/x86/kernel/process_32.c
> > +++ b/arch/x86/kernel/process_32.c
> > @@ -36,6 +36,7 @@
> >  #include <linux/personality.h>
> >  #include <linux/tick.h>
> >  #include <linux/percpu.h>
> > +#include <linux/prctl.h>
> > 
> >  #include <asm/uaccess.h>
> >  #include <asm/pgtable.h>
> > @@ -528,11 +529,12 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
> >  }
> >  EXPORT_SYMBOL_GPL(start_thread);
> > 
> > -#ifdef CONFIG_SECCOMP
> > +#ifdef CONFIG_DISABLE_TSC
> >  static void hard_disable_TSC(void)
> >  {
> >  	write_cr4(read_cr4() | X86_CR4_TSD);
> >  }
> 
> Won't this break this build if CONFIG_DISABLE_TSC=n and 
> CONFIG_SECCOMP=y?

it would break - but there was an update patch to this 2/3 patch which 
was the one i picked up into x86.git yesterday and which worked fine in 
500 overnight randconfig build and bootup tests.

	Ingo
