Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZICMNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZICMNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 08:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbZICMNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 08:13:32 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:40742 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbZICMNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 08:13:31 -0400
Date: Thu, 3 Sep 2009 14:13:26 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: tip tree build warnings
Message-ID: <20090903121326.GA4724@osiris.boeblingen.de.ibm.com>
References: <20090903182510.8fd4d4d1.sfr@canb.auug.org.au>
 <20090903083844.GA9912@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903083844.GA9912@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 10:38:44AM +0200, Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Today's linux-next build (powerpc ppc64_defconfig) produced these warning:
> > 
> > In file included from include/trace/ftrace.h:285,
> >                  from include/trace/define_trace.h:61,
> >                  from include/trace/events/timer.h:342,
> >                  from kernel/timer.c:50:
> > include/trace/events/timer.h: In function 'ftrace_raw_output_itimer_state':
> > include/trace/events/timer.h:280: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'cputime_t'
> > include/trace/events/timer.h: In function 'ftrace_raw_output_itimer_expire':
> > include/trace/events/timer.h:317: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'cputime_t'
> 
> Should be harmless with no runtime effects - the fix would be to 
> harmonize the cputime_t types across architectures.
> 
> > Introduced by commit 3f0a525ebf4b8ef041a332bbe4a73aee94bb064b ("timers: Add tracepoints for itimer") from the tip tree.
> > 
> > cputime_t is variously "u64", "unsigned long long" and "unsigned 
> > long" on different architectures.
> 
> Should be unsigned long i think. Most architectures use it as 
> unsigned long via include/asm-generic/cputime.h, except these three:
> 
>  arch/ia64/include/asm/cputime.h:typedef u64 cputime_t;
>  arch/powerpc/include/asm/cputime.h:typedef u64 cputime_t;
>  arch/s390/include/asm/cputime.h:typedef unsigned long long cputime_t;
> 
> Or we could eliminate the type altogether as well and standardize on 
> u64. Thomas?

s390 uses 64 bit cputime_t because we want the high resolution also in
32 bit kernels. So standardizing on u64 would be the preferred solution
for us.
