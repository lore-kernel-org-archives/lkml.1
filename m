Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbXI1TCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbXI1TCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXI1TC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:02:29 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40920 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbXI1TC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:02:29 -0400
Subject: Re: [PATCH RFC] paravirt_ops: refactor struct paravirt_ops
	into	smaller pv_*_ops
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <46FD4CA2.30402@goop.org>
References: <46FD4388.6000106@goop.org>
	 <1191004776.18310.16.camel@bodhitayantram.eng.vmware.com>
	 <46FD4CA2.30402@goop.org>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 12:02:48 -0700
Message-Id: <1191006168.18310.28.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 11:49 -0700, Jeremy Fitzhardinge wrote:
> > We shouldn't need to export pv_init_ops.  
> 
> No.  The only ones I export are:
> 
> EXPORT_SYMBOL_GPL(pv_time_ops);
> EXPORT_SYMBOL_GPL(pv_cpu_ops);
> EXPORT_SYMBOL_GPL(pv_mmu_ops);
> EXPORT_SYMBOL_GPL(pv_apic_ops);
> EXPORT_SYMBOL    (pv_irq_ops);

Nicely done.  I know of some out of tree modules which use part of the
pv_cpu_ops and pv_mmu_ops, but we should not worry about such things,
and it turns out those modules don't need to be virtualized anyway.

> 
> 
> > It is debatable whether
> > CR2/CR3 should be part of CPU or MMU ops.
> 
> Yeah, I was in two minds.  CR3, at least, should be grouped with the
> other tlb operations, wherever they go.  And while they're privileged
> CPU instructions (cpu_ops), they're more logically related to the rest
> of the mmu state.  On the other hand, we could have an ops structure
> specifically dedicated to pagetable manipulations, and put the cr3/tlb
> ops elsewhere.

I'm not against either approach.  I think the way you did it is fine.
If it were up to me, I would probably have driven myself crazy splitting
hairs on it until I was bald.

> >   Also, can we drop write_cr2?
> > It isn't used anywhere, so the only reason to keep it is symmetry.
> > Which was a fine argument when it was an inline, but now it just adds
> > unused junk to the code.
> >   
> 
> I think its used in some cpu state save/restore code, but its not
> relevant to pv-ops.

Ah yes, it is used there.  We actually exercise some of those paths, but
they don't need to be strictly virtualized.

Zach

