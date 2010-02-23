Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0BWWYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:24:05 -0500
Received: from www.tglx.de ([62.245.132.106]:46561 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0BWWYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:24:03 -0500
Date: Tue, 23 Feb 2010 23:23:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
       Gleb Natapov <gleb@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: kvm: Convert i8254/i8259 locks to raw_spinlocks
In-Reply-To: <4B842A1F.50601@siemens.com>
Message-ID: <alpine.LFD.2.00.1002232321320.3232@localhost.localdomain>
References: <20100217135901.331576359@linutronix.de> <4B842A1F.50601@siemens.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Jan Kiszka wrote:

> Thomas Gleixner wrote:
> > The i8254/i8259 locks need to be real spinlocks on preempt-rt. Convert
> > them to raw_spinlock. No change for !RT kernels.
> 
> Doesn't fly for -rt anymore: pic_irq_update runs under this raw lock and
> calls kvm_vcpu_kick which tries to wake_up some thread -> scheduling
> while atomic.

Hmm, a wakeup itself is fine. Is that code waking a wake queue ?
 
> This used to work up to 956f97cf. -rt for 2.6.31 is not yet affected,
> but 2.6.33 should be broken (haven't checked, using kvm-kmod over 2.6.31
> ATM). I can provide a patch that restores the deferred kicking if it's
> acceptable for upstream.

Well, at least is would be nice to have one for -rt.

Thanks,

	tglx
