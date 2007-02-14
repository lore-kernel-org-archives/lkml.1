Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXBNXkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXBNXkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964816AbXBNXkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:40:53 -0500
Received: from kanga.kvack.org ([66.96.29.28]:53557 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810AbXBNXkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:40:52 -0500
Date: Wed, 14 Feb 2007 18:40:30 -0500
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
Message-ID: <20070214234030.GO32271@kvack.org>
References: <20070214110419.GC4241@flint.arm.linux.org.uk> <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com> <20070214180344.GI32271@kvack.org> <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com> <20070214200347.GK32271@kvack.org> <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com> <20070214203438.GL32271@kvack.org> <Pine.LNX.4.64.0702141241030.7796@alien.or.mcafeemobile.com> <20070214214409.GM32271@kvack.org> <Pine.LNX.4.64.0702141452240.7796@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141452240.7796@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 03:17:59PM -0800, Davide Libenzi wrote:
> > That's an incorrect assumption.  Every task/thread in the system has FPU 
> > state associated with it, in part due to the fact that glibc has to change 
> > some of the rounding mode bits, making them different than the default from 
> > a freshly initialized state.
> 
> IMO I still belive this is not a huge problem. FPU state propagation/copy 
> can be done in a clever way, once we detect the in-async condition.

Show me.  clts() and stts() are expensive hardware operations which there 
is no means of avoiding as control register writes impact the CPU in a not 
trivial manner.  I've spent far too much time staring at profiles of what 
goes on in the context switch code in the process of looking for optimizations 
on this very issue to be ignored on this point.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.
