Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbXBNUf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbXBNUf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932573AbXBNUf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:35:56 -0500
Received: from kanga.kvack.org ([66.96.29.28]:51376 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbXBNUfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:35:55 -0500
Date: Wed, 14 Feb 2007 15:34:38 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
Message-ID: <20070214203438.GL32271@kvack.org>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu> <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu> <20070214110419.GC4241@flint.arm.linux.org.uk> <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com> <20070214180344.GI32271@kvack.org> <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com> <20070214200347.GK32271@kvack.org> <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 12:14:29PM -0800, Davide Libenzi wrote:
> I think you may have mis-interpreted my words. *When* a schedule would 
> block a synco execution try, then you do have a context switch. Noone 
> argue that, and the code is clear. The sys_async_exec thread will block, 
> and a newly woke up thread will re-emerge to sys_async_exec with a NULL 
> returned to userspace. But in a "cachehit" case (no schedule happens 
> during the syscall/*let execution), there is no context switch at all. 
> That is the whole point of the optimization.

And I will repeat myself: that cannot be done.  Tell me how the following 
what if scenario works: you're in an MMX optimized memory copy and you take 
a page fault.  How does returning to the submittor of the async operation 
get the correct MMX state restored?  It doesn't.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.
