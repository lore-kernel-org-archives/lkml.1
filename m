Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYAGRRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYAGRRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYAGRRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:17:16 -0500
Received: from ns.suse.de ([195.135.220.2]:59432 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbYAGRRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:17:14 -0500
Date: Mon, 7 Jan 2008 18:17:12 +0100
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 1 of 8] x86: page.h: unify constants
Message-ID: <20080107171712.GE2998@bingen.suse.de>
References: <patchbomb.1199391057@localhost> <ba0ec40a50a7aef1a315.1199391058@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba0ec40a50a7aef1a315.1199391058@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +
> +#define LARGE_PAGE_SIZE		(_AC(1,UL) << PMD_SHIFT)
> +#define LARGE_PAGE_MASK		(~(LARGE_PAGE_SIZE-1))
> +
> +#define HPAGE_SHIFT		PMD_SHIFT
> +#define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
> +#define HPAGE_MASK		(~(HPAGE_SIZE - 1))
> +#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)

This will actually stop being the same soon with GB pages which
are only supported on 64bit.

> +
> +#ifdef CONFIG_X86_64
> +#define THREAD_ORDER	1
> +#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
> +#define CURRENT_MASK (~(THREAD_SIZE-1))
> +
> +#define EXCEPTION_STACK_ORDER 0
> +#define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
> +
> +#define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
> +#define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
> +
> +#define IRQSTACK_ORDER 2
> +#define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)

This all seems hardly 64bit specific (except for THREAD_ORDER
but you can probably handle that in Kconfig or just get rid
of it for 32bit)

> +#define __PHYSICAL_START	CONFIG_PHYSICAL_START

Also not 64bit specific

> +#ifdef CONFIG_X86_PAE
> +#define __PHYSICAL_MASK_SHIFT	36

I originally added the PHYSICAL_MASK stuff to deal with masking off NX,
but I must admit it wasn't the best idea I ever had. It would be probably
better to just get rid of it and always mask off the high reserved flags bit
explicitely. If you make that 0 then there should be no special
case for PAE.

-Andi
