Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZE1IgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZE1IgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZE1IgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:36:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbZE1If7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:35:59 -0400
Date: Thu, 28 May 2009 10:35:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, rostedt@goodmis.org, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter tools: Introduce stricter
	C code checking
Message-ID: <20090528083548.GB7530@elte.hu>
References: <20090526222155.GJ4424@ghostprotocols.net> <tip-16f762a2ac5ecf8a11f6f0332e46cc3459220da5@git.kernel.org> <18974.2897.822557.905261@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18974.2897.822557.905261@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> tip-bot for Ingo Molnar writes:
> 
> > perf_counter tools: Introduce stricter C code checking
> > 
> > Tighten up our C code requirements:
> > 
> >  - disallow warnings
> 
> This causes failures when I compile it as a 64-bit executable on
> powerpc:
> 
>     CC builtin-record.o
> builtin-record.c: In function 'pid_synthesize_mmap_events':
> builtin-record.c:241: warning: format '%llx' expects type 'long long unsigned int *', but argument 3 has type '__u64 *'
> builtin-record.c:241: warning: format '%llx' expects type 'long long unsigned int *', but argument 4 has type '__u64 *'
> builtin-record.c:241: warning: format '%llx' expects type 'long long unsigned int *', but argument 9 has type '__u64 *'
> 
> This is because u64 is an unsigned long in userspace for a 64-bit 
> build, not unsigned long long.  I'm not sure how best to solve 
> this problem.

We could perhaps use __u64 consistently? (can we?)

> If I compile it as a 32-bit executable, it doesn't generate warnings,
> but when I try to run "perf top" (this is on a 64-bit kernel, of
> course, since 32-bit powerpc kernels don't currently support
> perf_counters), I get:
> 
> # perf top
>  left: 0000000000000000
>    ip: 00000000000891a4
> right: 00000000ffffffff
> KernelTop refresh period: 2 seconds
> perf: builtin-top.c:453: record_ip: Assertion `left <= ip && ip <= right' failed.
> Aborted

mind trying a 'git bisect run' session - which commit broke things 
for you? Or is this related to the type problems?

	Ingo
