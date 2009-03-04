Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZCDKuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZCDKuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZCDKt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:49:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41217 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbZCDKt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:49:57 -0500
Date: Wed, 4 Mar 2009 11:49:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] perfcounters: provide expansion room in the ABI
Message-ID: <20090304104945.GB4879@elte.hu>
References: <18862.19599.929591.3109@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18862.19599.929591.3109@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Impact: ABI change
> 
> This expands several fields in the perf_counter_hw_event 
> struct and adds a "flags" argument to the perf_counter_open 
> system call, in order that features can be added in future 
> without ABI changes.
> 
> In particular the record_type field is expanded to 64 bits, 
> and the space for flag bits has been expanded from 32 to 64 
> bits.
> 
> This also adds some new fields:
> 
> * read_format (64 bits) is intended to provide a way to specify what
>   userspace wants to get back when it does a read() on a simple
>   (non-interrupting) counter;
> 
> * exclude_idle (1 bit) provides a way for userspace to ask that events
>   that occur when the cpu is idle be excluded;
> 
> * extra_config_len will provide a way for userspace to supply an
>   arbitrary amount of extra machine-specific PMU configuration data
>   immediately following the perf_counter_hw_event struct, to allow
>   sophisticated users to program things such as instruction matching
>   CAMs and address range registers;
> 
> * __reserved_3 and __reserved_4 provide space for future expansion.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> This should provide plenty of room for future expansion, in fact maybe
> it's a little over the top.

Yeah - but i think it does not hurt to be defensive when it 
comes to ABI extensibility.

Your changes look very good to me.

> Ingo, if this looks OK, you can pull it from the rfc branch of my
> perfcounters.git tree at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git rfc
> 
>  include/linux/perf_counter.h |   12 +++++++++---
>  include/linux/syscalls.h     |    2 +-
>  kernel/perf_counter.c        |   10 +++++++---
>  3 files changed, 17 insertions(+), 7 deletions(-)

Pulled into tip:perfcounters/core, thanks Paul!

	Ingo
