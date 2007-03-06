Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbXCFLJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbXCFLJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965844AbXCFLJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:09:43 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36119 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964959AbXCFLJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:09:41 -0500
Date: Tue, 6 Mar 2007 03:09:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2
Message-Id: <20070306030927.bc2f15fc.akpm@linux-foundation.org>
In-Reply-To: <20070306192718.999e114d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<20070306192718.999e114d.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 19:27:18 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> Following panic ouccurred (always) on ia64/NUMA(with empty node.)
> 
> Bug in here.
> ==
> void move_native_irq(int irq)
> {
>         struct irq_desc *desc = irq_desc + irq;
> 
>         if (likely(!(desc->status & IRQ_MOVE_PENDING)))
>                 return;
> 
>         if (unlikely(desc->status & IRQ_DISABLED))
>                 return;
> 
>         desc->chip->mask(irq);  <---------maybe this *mask* is NULL pointer
>         move_masked_irq(irq);
>         desc->chip->unmask(irq);
> }
> ==
> 
> Is "mask"  always valid pointer ?

I can only find two `struct irq_chip's in arch/ia64 and they both have a
.mask.  And a .unmask.  So perhaps that is a misreading of what oopsed.

There are no changes in kernel/irq/ in -mm.  Are you sure mainline doesn't
do this too?

Anyway, can you please take a closer look at exactly what pointer it is
oopsing on?

