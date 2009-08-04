Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZHDIVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZHDIVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZHDIVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:21:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbZHDIVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:21:02 -0400
Date: Tue, 4 Aug 2009 10:20:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Add diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090804082048.GA7433@elte.hu>
References: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org> <20090802202720.GA32360@elte.hu> <20090802221324.GP6854@linux.vnet.ibm.com> <20090803070458.GA27581@elte.hu> <20090804081850.GA21474@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804081850.GA21474@in.ibm.com>
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


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> On Mon, Aug 03, 2009 at 09:04:58AM +0200, Ingo Molnar wrote:
> > [    0.010000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> > [    0.010000] ... MAX_LOCKDEP_SUBCLASSES:  8
> > [    0.010000] ... MAX_LOCK_DEPTH:          48
> > [    0.010000] ... MAX_LOCKDEP_KEYS:        8191
> > [    0.010000] ... CLASSHASH_SIZE:          4096
> > [    0.010000] ... MAX_LOCKDEP_ENTRIES:     16384
> > [    0.010000] ... MAX_LOCKDEP_CHAINS:      32768
> > [    0.010000] ... CHAINHASH_SIZE:          16384
> > [    0.010000]  memory used by lock dependency info: 5823 kB
> > [    0.010000]  per task-struct memory footprint: 1920 bytes
> > [    0.010000] ------------------------
> > [    0.010000] | Locking API testsuite:
> > [    0.010000] ----------------------------------------------------------------------------
> > [    0.010000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> > [    0.010000]   --------------------------------------------------------------------------
> > [    0.010000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> > [    0.010000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> > [    0.010000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> > [    0.010000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> > [    0.010000]   --------------------------------------------------------------------------
> > [    0.010000]               recursive read-lock:             |  ok  |             |failed|
> > [    0.010000]            recursive read-lock #2:             |  ok  |             |failed|
> > [    0.010000]             mixed read-write-lock:             |failed|             |failed|
> > [    0.010000]             mixed write-read-lock:             |failed|             |failed|
> > [    0.010000]   --------------------------------------------------------------------------
> > [    0.010000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> > [    0.010000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> > [    0.010000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> > [    0.010000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> > [    0.010000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
> > [    0.010000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
> > [    0.010000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
> > [    0.010000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
> > [    0.010000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
> > [    0.010000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> > [    0.010000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> > [    0.010000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/123:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/123:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/132:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/132:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/213:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/213:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/231:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/231:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/312:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/312:failed|failed|  ok  |
> > [    0.010000]       hard-irq lock-inversion/321:failed|failed|  ok  |
> > [    0.010000]       soft-irq lock-inversion/321:failed|failed|  ok  |
> > [    0.010000]       hard-irq read-recursion/123:  ok  |
> > [    0.010000]       soft-irq read-recursion/123:  ok  |
> > [    0.010000]       hard-irq read-recursion/132:  ok  |
> > [    0.010000]       soft-irq read-recursion/132:  ok  |
> > [    0.010000]       hard-irq read-recursion/213:  ok  |
> > [    0.010000]       soft-irq read-recursion/213:  ok  |
> > [    0.010000]       hard-irq read-recursion/231:  ok  |
> > [    0.010000]       soft-irq read-recursion/231:  ok  |
> > [    0.010000]       hard-irq read-recursion/312:  ok  |
> > [    0.010000]       soft-irq read-recursion/312:  ok  |
> > [    0.010000]       hard-irq read-recursion/321:  ok  |
> > [    0.010000]       soft-irq read-recursion/321:  ok  |
> > [    0.010000] --------------------------------------------------------
> > [    0.010000] 133 out of 218 testcases failed, as expected. |
> > [    0.010000] ----------------------------------------------------
> 
> Hmm.. I tried to reproduce this on a similar 2 CPU machine running
> linux-2.6.31-rc5-tip. However, I couldn't reproduce this WARN_ON.
> 
> That aside, in my case, all the 218 lockdep test cases passed,
> while this bootlog shows quite a few failures.
> So, wondering if I am testing the right kernel version.

hm, maybe i sent the wrong config.

I'll try to reproduce it once more and will double check.

	Ingo
