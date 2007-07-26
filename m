Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbXGZOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbXGZOtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbXGZOtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:49:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbXGZOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:49:08 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ankita Garg <ankita@in.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       linux@bohmer.net, LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>
	<1184615557.2698.3.camel@laptopd505.fenrus.org>
	<20070726072858.GC13061@in.ibm.com> <20070726133138.GA30559@Krystal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 26 Jul 2007 10:47:40 -0400
In-Reply-To: <20070726133138.GA30559@Krystal>
Message-ID: <y0mps2f1asz.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> [...]
> The problem is also in _stp_print_flush, not *only* in relay code:
> void _stp_print_flush (void)
> ...
>                 spin_lock(&_stp_print_lock);
>                 ...
>                 spin_unlock(&_stp_print_lock);
> 
> Those will turn into mutexes with -rt.

Indeed, plus systemtap-generated locking code uses rwlocks,
local_irq_save/restore or preempt_disable, in various places.  Could
someone point to a place that spells out what would be more
appropriate way of ensuring atomicity while being compatible with -rt?

- FChE
