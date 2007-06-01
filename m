Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXFAX2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXFAX2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXFAX2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:28:05 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2101 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbXFAX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:28:04 -0400
Date: Sat, 2 Jun 2007 00:27:56 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Deepak Saxena <dsaxena@plexity.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RT] Fix NR_syscalls in ARM
Message-ID: <20070601232756.GB5024@flint.arm.linux.org.uk>
Mail-Followup-To: Deepak Saxena <dsaxena@plexity.net>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org
References: <20070601231053.GA26602@plexity.net> <20070601231840.GA5024@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601231840.GA5024@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 12:18:40AM +0100, Russell King wrote:
> On Fri, Jun 01, 2007 at 04:10:53PM -0700, Deepak Saxena wrote:
> > The -rt patch adds a NR_syscalls symbol to the arm/unistd.h but
> > it is not the correct value as there are 348 syscalls on ARM
> > and the existing change sets the symbol to 322.
> > 
> > Russell: Why isn't this in mainline? Other arches all seem to have 
> > this symbol already defined.
> 
> The hint is that it isn't in mainline; it's just plainly not required.
> It's also the wrong place to define it; it's not a property that
> unistd.h should concern itself with - it's a property of the kernel's
> branch table for calling the syscalls, and on ARM we calculate that
> number directly from the size of the kernel's branch table.
> 
> It's also not just last_syscall_number+1 since the table is sized to
> make the assembly easy - iow, a number divisible by 4.
> 
> So all in all, NR_syscalls in unistd.h is just utterly wrong.

BTW, it should be pointed out that you've found the exact reason why
putting it in unistd.h is _wrong_.  It's all to easy for it to get
out of sync with updates to the place where it really matters - the
code which bounds-checks the syscall number (that being the assembly
code which indexes the branch table.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
