Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0BMDo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:44:27 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56299 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0BMDo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 22:44:26 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 12 Feb 2010 19:44:13 -0800
In-Reply-To: <1266029390-30907-1-git-send-email-yinghai@kernel.org> (Yinghai Lu's message of "Fri\, 12 Feb 2010 18\:49\:42 -0800")
Message-ID: <m1zl3dre9e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> ---------spareirq radix tree related ----------------
> 94007e8: irq: remove not need bootmem code
> 4b0d3fa: radix: move radix init early
> 56af1a9: sparseirq: change irq_desc_ptrs to static
> b236235: sparseirq: use radix_tree instead of ptrs array
> 5918787: x86: remove arch_probe_nr_irqs
>
> so could reduce nr_irqs limitation for bunch ixgbe...
>
> ---------------x86 logical flat related -----------
> f5954c4: use nr_cpus= to set nr_cpu_ids early
> 7b8d6a9: x86: use num_processors for possible cpus
> d79d1de: x86: make 32bit apic flat to physflat switch like 64bit

Thanks for keeping this work alive.

I just skimmed through do_IRQ and I happened to notice that
we have an unnecessary inefficiency that using a radix tree for
irq_to_desc will magnify.

handle_irq should take an struct irq_desc * instead of a unsigned int irq.

and the per cpu vector_irq array should become a per cpu vector_desc array.

As soon as irq_to_desc is more than &irq_desc[irq] this saves us work
and cache line misses  at the cost of a simple code cleanup.


Eric
