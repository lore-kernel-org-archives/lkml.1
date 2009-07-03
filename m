Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZGCJVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZGCJVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbZGCJUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:20:55 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:38692 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZGCJUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:20:55 -0400
Message-ID: <4A4DCD54.1080908@gmail.com>
Date: Fri, 03 Jul 2009 11:20:20 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com, davidel@xmailserver.org
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
References: <20090703081219.GE2902@jolsa.lab.eng.brq.redhat.com> <20090703081445.GG2902@jolsa.lab.eng.brq.redhat.com> <20090703090606.GA3902@elte.hu>
In-Reply-To: <20090703090606.GA3902@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 03 Jul 2009 11:20:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
>> +++ b/arch/x86/include/asm/spinlock.h
>> @@ -302,4 +302,7 @@ static inline void __raw_write_unlock(raw_rwlock_t *rw)
>>  #define _raw_read_relax(lock)	cpu_relax()
>>  #define _raw_write_relax(lock)	cpu_relax()
>>  
>> +/* The {read|write|spin}_lock() on x86 are full memory barriers. */
>> +#define smp_mb__after_lock() do { } while (0)
> 
> Two small stylistic comments, please make this an inline function:
> 
> static inline void smp_mb__after_lock(void) { }
> #define smp_mb__after_lock
> 
> (untested)
> 
>> +/* The lock does not imply full memory barrier. */
>> +#ifndef smp_mb__after_lock
>> +#define smp_mb__after_lock() smp_mb()
>> +#endif
> 
> ditto.
> 
> 	Ingo

This was following existing implementations of various smp_mb__??? helpers :

# grep -4 smp_mb__before_clear_bit include/asm-generic/bitops.h

/*
 * clear_bit may not imply a memory barrier
 */
#ifndef smp_mb__before_clear_bit
#define smp_mb__before_clear_bit()      smp_mb()
#define smp_mb__after_clear_bit()       smp_mb()
#endif


