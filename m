Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYJGPWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYJGPWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYJGPVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:21:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40312 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751194AbYJGPVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:21:54 -0400
Date: Tue, 7 Oct 2008 11:21:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: <20081007114006.GA25627@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0810071111281.2591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, K.Prasad wrote:

> This patch introduces two new files hw_breakpoint.[ch] which defines the 
> generic interfaces to use hardware breakpoint infrastructure of the system. 

...
> --- /dev/null
> +++ linux-bkpt-lkml-27-rc9/include/asm-generic/hw_breakpoint.h
> @@ -0,0 +1,236 @@
> +#ifndef	_ASM_GENERIC_HW_BREAKPOINT_H
> +#define	_ASM_GENERIC_HW_BREAKPOINT_H
> +
> +#ifndef __ARCH_HW_BREAKPOINT_H
> +#error "Please don't include this file directly"
> +#endif
> +
> +#ifdef	__KERNEL__
> +#include <linux/list.h>
> +#include <linux/types.h>
> +
> +/**
> + * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
> + * @node: internal linked-list management
> + * @triggered: callback invoked when the breakpoint is hit

The kerneldoc needs to be updated to match the structure.  @triggered
doesn't exist any more; instead there are @pre_handler and
@post_handler.

...
> + * When a breakpoint gets hit, the @triggered callback is invoked
> + * in_interrupt with a pointer to the %hw_breakpoint structure and the
> + * processor registers.  Execute-breakpoint traps occur before the
> + * breakpointed instruction runs; when the callback returns the
> + * instruction is restarted (this time without a debug exception).  All
> + * other types of trap occur after the memory access has taken place.
> + * Breakpoints are disabled while @triggered runs, to avoid recursive
> + * traps and allow unhindered access to breakpointed memory.

This paragraph needs to be fixed as well.

...
> +/*
> + * The following routines help the user determine if the architecture supports
> + * a trigger-before access/execution mechanism or a trigger-after
> + * access/execution. This is dependent on the type of breakpoint and the
> + * architecture
> + */
> +int trigger_before_arch(unsigned type);
> +int trigger_after_arch(unsigned type);

These routines should have hwbp_ in their name (or something similar).  
And they don't need to have _arch.

Alan Stern

