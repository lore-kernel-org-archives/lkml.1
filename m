Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbXCSMlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbXCSMlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXCSMlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:41:24 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4516 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXCSMlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:41:23 -0400
Date: Mon, 19 Mar 2007 12:41:14 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: railroad seeker <railroad.seeker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Scheduling in interrupt and call trace
Message-ID: <20070319124114.GA13850@flint.arm.linux.org.uk>
Mail-Followup-To: railroad seeker <railroad.seeker@gmail.com>,
	linux-kernel@vger.kernel.org
References: <6eb6ed920703190537o3c4738d6l61dd946d9554b4a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6eb6ed920703190537o3c4738d6l61dd946d9554b4a3@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:37:57PM +0800, railroad seeker wrote:
> After that, the program counter must located in BUG(), that is something 
> like
> "(void *)0 = 0" if we really do scheduling in interrupt contxt, and
> should cause
> the kernel to panic. However, what i got is that the latest program
> counter is located within the do_IRQ() context when the kernel was
> crashed . But it
> seems that the stack trace is a kernel stack of process context since
> the bottom of the stack is ret_from_syscall. (I have not enabled the
> frame pointer when compiling the kernel, instead, I back traced by
> manually inspect each 32 bit value
> from the output of objdump) , and I think that the latest PC should
> point to the next instruction of "(void *) 0 = 0".
> 
> Is there any possibility with which we got this incorrect information,
> or I have
> misunderstanding about "kernel system to interrupt context switch?

Please enable frame pointers and show the resulting backtrace; it is
possible that trying to manually decode the stack without frame
pointers enabled will result in a confused backtrace.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
