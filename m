Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYKSSSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYKSSSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYKSSSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:18:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52839 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYKSSSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:18:15 -0500
Date: Wed, 19 Nov 2008 18:17:44 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       ink@jurassic.park.msu.ru, starvik@axis.com, tony.luck@intel.com,
       takata@linux-m32r.org, ralf@linux-mips.org, grundler@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       wli@holomorphy.com, davem@davemloft.net, jdike@addtoit.com,
       mingo@redhat.com
Subject: Re: [PATCH 1/2] cpumask: centralize cpu_online_map and cpu_possible_map
Message-ID: <20081119181743.GA31357@flint.arm.linux.org.uk>
References: <200811200107.18162.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811200107.18162.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 01:07:16AM +1030, Rusty Russell wrote:
> diff -r c8ab7f6fc5e8 kernel/cpu.c
> --- a/kernel/cpu.c	Fri Oct 31 10:48:30 2008 +1100
> +++ b/kernel/cpu.c	Fri Oct 31 11:22:29 2008 +1100
> @@ -24,19 +24,20 @@ cpumask_t cpu_present_map __read_mostly;
>  cpumask_t cpu_present_map __read_mostly;
>  EXPORT_SYMBOL(cpu_present_map);
>  
> -#ifndef CONFIG_SMP
> -
>  /*
>   * Represents all cpu's that are currently online.
>   */
> -cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
> +cpumask_t cpu_online_map __read_mostly;

Just a question: in the uniprocessor case, does this mean that
cpu_online_map becomes zero or do we mark cpu0 as online somewhere?
I couldn't see it in this patch.

I'm just wondering from a review point of view whether this change
of initialization could have undesirable side effects.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
