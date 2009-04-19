Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZDSIRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZDSIRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZDSIRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:17:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47439 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZDSIRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:17:07 -0400
Date: Sun, 19 Apr 2009 10:16:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: mips build failure
Message-ID: <20090419081641.GA23906@elte.hu>
References: <20090419172436.6d0e741a.sfr@canb.auug.org.au> <1240126361.3423.5.camel@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240126361.3423.5.camel@falcon>
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


* Wu Zhangjin <wuzhangjin@gmail.com> wrote:

> On Sun, 2009-04-19 at 17:24 +1000, Stephen Rothwell wrote:
> > Hi Ralf,
> > 
> > You probably already now about this, but our build (mips ip32_defconfig)
> > of Linus' tree (commit aefe6475720bd5eb8aacbc881488f3aa65618562 "Merge
> > branch 'upstream-linus' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev") gets
> > these errors (we have actually been getting these errors since 2.6.30-rc1):
> > 
> > In file included from arch/mips/include/asm/compat.h:7,
> >                  from include/linux/compat.h:15,
> >                  from arch/mips/kernel/asm-offsets.c:12:
> > include/linux/seccomp.h: In function 'prctl_get_seccomp':
> > include/linux/seccomp.h:30: error: 'EINVAL' undeclared (first use in this function)
> > include/linux/seccomp.h:30: error: (Each undeclared identifier is reported only once
> > include/linux/seccomp.h:30: error: for each function it appears in.)
> > include/linux/seccomp.h: In function 'prctl_set_seccomp':
> > include/linux/seccomp.h:35: error: 'EINVAL' undeclared (first use in this function)
> > 
> 
> perhaps you can fix it like this:
> 
> include/linux/seccomp.h
> 
>  22 #else /* CONFIG_SECCOMP */
>  23 
>  24 +#include <asm-generic/errno-base.h>
>  25 
>  26 typedef struct { } seccomp_t;
> 
> in reality, there is a previous email sent by Ralf for it:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0904.2/01152.html

Yes, that looks like the right kind of fix.

Ralf, will you push that fix upstream, or should i do it?

Thanks,

	Ingo
