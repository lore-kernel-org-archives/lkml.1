Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbXEQWRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbXEQWRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbXEQWQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:16:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbXEQWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:16:56 -0400
Message-ID: <464CD44A.5000307@zytor.com>
Date: Thu, 17 May 2007 15:16:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Philipp Kohlbecher <pk031698@uni-greifswald.de>
CC: Dave Jones <davej@codemonkey.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, linux-assembly@vger.kernel.org
Subject: Re: [PATCH 2.6.21.1] i386: save registers before intra-privilege
 syscall
References: <20070517220638.GA6532@localhost.localdomain>
In-Reply-To: <20070517220638.GA6532@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Kohlbecher wrote:
> From: Philipp Kohlbecher <pk031698@uni-greifswald.de>
> 
> The kernel_execve function issues a software interrupt (int 0x80) to make
> a system call to sys_execve. This function expects to find the stack segment
> and stack pointer of the function that issued the system call in the pt_regs
> struct. The syscall entry code that sets up this struct expects the stack
> segment and the stack pointer of the issuing function already on the stack.
> But the Intel processor saves these registers only if a stack-switch occurs,
> i.e. for inter-privilege interrupts and exceptions (cf. Intel Software
> Developer’s Manual, Vol. 3A, p. 5-17,
> http://www.intel.com/design/processor/manuals/253668.pdf).
> For an intra-privilege interrupt like the one issued in kernel_execve, these
> registers must be saved manually.
> 

Could you describe the failure scenario this causes?  I'm trying to
understand how something that fundamental would have possibly slipped by
testing?

	-hpa
