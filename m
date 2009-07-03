Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZGCJZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZGCJZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZGCJY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:24:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZGCJYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:24:55 -0400
Date: Fri, 3 Jul 2009 11:24:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com, davidel@xmailserver.org
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090703092438.GE3902@elte.hu>
References: <20090703081219.GE2902@jolsa.lab.eng.brq.redhat.com> <20090703081445.GG2902@jolsa.lab.eng.brq.redhat.com> <20090703090606.GA3902@elte.hu> <4A4DCD54.1080908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A4DCD54.1080908@gmail.com>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Ingo Molnar a écrit :
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> >> +++ b/arch/x86/include/asm/spinlock.h
> >> @@ -302,4 +302,7 @@ static inline void __raw_write_unlock(raw_rwlock_t *rw)
> >>  #define _raw_read_relax(lock)	cpu_relax()
> >>  #define _raw_write_relax(lock)	cpu_relax()
> >>  
> >> +/* The {read|write|spin}_lock() on x86 are full memory barriers. */
> >> +#define smp_mb__after_lock() do { } while (0)
> > 
> > Two small stylistic comments, please make this an inline function:
> > 
> > static inline void smp_mb__after_lock(void) { }
> > #define smp_mb__after_lock
> > 
> > (untested)
> > 
> >> +/* The lock does not imply full memory barrier. */
> >> +#ifndef smp_mb__after_lock
> >> +#define smp_mb__after_lock() smp_mb()
> >> +#endif
> > 
> > ditto.
> > 
> > 	Ingo
> 
> This was following existing implementations of various smp_mb__??? helpers :
> 
> # grep -4 smp_mb__before_clear_bit include/asm-generic/bitops.h
> 
> /*
>  * clear_bit may not imply a memory barrier
>  */
> #ifndef smp_mb__before_clear_bit
> #define smp_mb__before_clear_bit()      smp_mb()
> #define smp_mb__after_clear_bit()       smp_mb()
> #endif

Did i mention that those should be fixed too? :-)

	Ingo
