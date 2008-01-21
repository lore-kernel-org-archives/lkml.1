Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbYAUIbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbYAUIbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 03:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbYAUIbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 03:31:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbYAUIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:31:43 -0500
Subject: Re: [patch/rfc 2.6.24-rc8-git] genirq: partial lockdep fixes
From: Peter Zijlstra <peterz@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com
In-Reply-To: <200801181429.00485.david-b@pacbell.net>
References: <200801181429.00485.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 09:31:39 +0100
Message-Id: <1200904299.6341.2.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 14:29 -0800, David Brownell wrote:
> EXPERIMENTAL and incomplete patch to make LOCKDEP behave better in
> the face of irq chaining, by annotating irqs with a lock_class which
> can reflect that hierarchy.

This is too short for me (who has no clue about genirq) to understand
what this patch does or why it does it.

> This version of the patch is incomplete in at least two respects:
> 
>  - There's no spin_lock_irq_nested() primitive, so that locking calls
>    on irq probing (yeech!) paths must ignore the annotations.
> 
> 	==> LOCKDEP feature is evidently missing:
> 		spin_lock_irq_nested(lock_ptr, lock_class)

This rant is more lines than adding the API :-/ the reason for it not
being there is simple, it wasn't needed up until now.

>  - We'd really need new API to declare the parent/child relationships
>    between IRQs to handle this properly.  Lacking such calls, this just
>    piggybacks set_irq_chained_handler() to modify the parent's class.
>    That's a problem, since only the lowest level of any lock tree gets
>    accurate nesting annotations.  On the plus side: no platform changes
>    are needed this way, so testing is easy.
> 
> 	==> GENIRQ programming interface evidently missing
> 		set_irq_parent(parent_irqnum, child_irqnum) (?)
> 
> Example:  when a GPIO controller's set_wake() handler needs to call its
> parent's set_irq_wake() method to ensure all appropriate signal paths are
> set up, that currently generates a bogus lockdep warning.  This patch
> removes those bogus warnings ... when there's only one level of parent.

OK.... still need a bit more detail here.

