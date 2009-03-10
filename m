Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZCJRqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZCJRqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbZCJRpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:45:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59756 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885AbZCJRpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:45:46 -0400
Date: Tue, 10 Mar 2009 18:45:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
Message-ID: <20090310174535.GA2963@elte.hu>
References: <1236684201.3301.11.camel@localhost.localdomain> <20090310122806.GE5794@elte.hu> <1236697752.3387.2.camel@localhost.localdomain> <20090310152029.GN3850@elte.hu> <1236701373.3387.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1236701373.3387.4.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Tue, 2009-03-10 at 16:20 +0100, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > +#include <linux/interrupt.h>
> > > +#include <linux/compiler.h>
> > > +#include <linux/kprobes.h>
> > > +#include <linux/signal.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/errno.h>
> > > +#include <linux/sched.h>
> > > +#include <linux/types.h>
> > > +#include <linux/init.h>
> > > +#include <linux/smp.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/percpu.h>
> > > +#include <linux/debugfs.h>
> > > +#include <linux/seq_file.h>
> > 
> > If you look at arch/x86/mm/fault.c, they are sorted by length, 
> > and within the same length they are sorted alphabetically.
> 
> Ok fixed, new pull request:
> 
> The following changes since commit 23eeaab0397190b112591dab13d1fb196f099254:
>   Ingo Molnar (1):
>         Merge branch 'tracing/ftrace'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> 
> Jaswinder Singh Rajput (1):
>       x86: cpu architecture debug code
> 
>  arch/x86/Kconfig                 |    6 +
>  arch/x86/include/asm/cpu_debug.h |  193 ++++++++++
>  arch/x86/kernel/cpu/Makefile     |    2 +
>  arch/x86/kernel/cpu/cpu_debug.c  |  784 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 985 insertions(+), 0 deletions(-)
>  create mode 100755 arch/x86/include/asm/cpu_debug.h
>  create mode 100755 arch/x86/kernel/cpu/cpu_debug.c

Thanks - picked it up into tip:x86/debug. (Note that i 
rearranged the Makefile details a bit so that it does not 
conflict with tip:perfcounters)

Not yet in tip:master, because it triggers this build failure:

arch/x86/kernel/cpu/cpu_debug.c: In function ‘print_dt’:
arch/x86/kernel/cpu/cpu_debug.c:475: error: implicit declaration of function ‘store_ldt’

	Ingo
