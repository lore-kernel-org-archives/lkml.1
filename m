Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbXJ0TAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbXJ0TAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbXJ0TAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:00:34 -0400
Received: from colin.muc.de ([193.149.48.1]:3568 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJ0TAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:00:34 -0400
Date: 27 Oct 2007 21:00:31 +0200
Date: Sat, 27 Oct 2007 21:00:31 +0200
From: Andi Kleen <ak@muc.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Adding TIF_TRACE_KERNEL to x86_64
Message-ID: <20071027190031.GA97563@muc.de>
References: <20071026193738.GA1591@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026193738.GA1591@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 03:37:38PM -0400, Mathieu Desnoyers wrote:
> 
> 1 - process A enters in a syscall, TIF_KERNEL_TRACE is cleared
> 2 - we activate TIF_KERNEL_TRACE
> 3 - process A returns from syscall (with wrong top of stack ?) -> segfault.
> 
> Am I on the right track ?

Yes. The code was not designed to allow that. The syscall path
has been optimized to go as fast as possible.

> 
> Can this be a concern with TIF_SYSCALL_TRACE also ? (potential race in
> ptrace ?)

ptrace only changes state in stopped processes; and those are not hanging
in syscalls. So no there is no race in a standard kernel.

If you wanted to change it the right way would be probably to test
for SYSCALL_TRACE too in the work flags and handle it there

-Andi

