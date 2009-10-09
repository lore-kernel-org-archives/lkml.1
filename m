Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbZJIK2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbZJIK2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760726AbZJIK2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:28:06 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:51606 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760722AbZJIK2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:28:05 -0400
Date: Fri, 9 Oct 2009 12:28:14 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] kernel/time/tick-sched.c: fix warning of printk's
	argument format
Message-ID: <20091009102814.GA619@linux-mips.org>
References: <1255013172-31599-1-git-send-email-wuzhangjin@gmail.com> <alpine.LFD.2.01.0910080755390.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910080755390.3432@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 08:03:40AM -0700, Linus Torvalds wrote:

> > This patch will fix the following warning:
> 
> No it won't. It will add a lot of new warnings.
> 
> The thing is, almost all architectures (including x86) have
> 
> 	unsigned int __softirq_pending;
> 
> but then in <asm-generic/hardirq.h> we have
> 
> 	unsigned long __softirq_pending;
> 
> for some unfathomable reason. Quite frankly, I think Arnd just screwed up 
> the "generic" version, and the fix is almost certainly to just make the 
> generic version match all the main architectures. 
> 
> I don't have any architectures using the generic header file, though, so 
> I'm not going to do that change blindly. People who do should look at it 
> (alpha, powerpc and mips look like the only ones that might be 64-bit, but 
> I didn't check very carefully - just grepped for it)
> 
> Added Cc's for some people that have worked on, or used, that generic 
> header file. Is there any possible reason why it is "unsigned long" in 
> that one?

I think for no other reason than many other bitfields in kernel being
unsigned long or arrays of unsigned long.  Except of course that
__softirq_pending is never being used with the <asm/bitops.h> operations
that operate on unsigned longs.

Patch in followup email.

  Ralf
