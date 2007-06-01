Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbXFAXS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbXFAXS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbXFAXSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:18:51 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3957 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbXFAXSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:18:50 -0400
Date: Sat, 2 Jun 2007 00:18:40 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RT] Fix NR_syscalls in ARM
Message-ID: <20070601231840.GA5024@flint.arm.linux.org.uk>
Mail-Followup-To: Deepak Saxena <dsaxena@plexity.net>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org
References: <20070601231053.GA26602@plexity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601231053.GA26602@plexity.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 04:10:53PM -0700, Deepak Saxena wrote:
> The -rt patch adds a NR_syscalls symbol to the arm/unistd.h but
> it is not the correct value as there are 348 syscalls on ARM
> and the existing change sets the symbol to 322.
> 
> Russell: Why isn't this in mainline? Other arches all seem to have 
> this symbol already defined.

The hint is that it isn't in mainline; it's just plainly not required.
It's also the wrong place to define it; it's not a property that
unistd.h should concern itself with - it's a property of the kernel's
branch table for calling the syscalls, and on ARM we calculate that
number directly from the size of the kernel's branch table.

It's also not just last_syscall_number+1 since the table is sized to
make the assembly easy - iow, a number divisible by 4.

So all in all, NR_syscalls in unistd.h is just utterly wrong.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
