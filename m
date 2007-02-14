Return-Path: <linux-kernel-owner+w=401wt.eu-S964794AbXBNWE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794AbXBNWE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964796AbXBNWE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:04:57 -0500
Received: from kanga.kvack.org ([66.96.29.28]:52168 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964794AbXBNWE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:04:56 -0500
Date: Wed, 14 Feb 2007 17:04:44 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
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
Subject: Re: [patch] x86: split FPU state from task state
Message-ID: <20070214220443.GN32271@kvack.org>
References: <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu> <20070214110419.GC4241@flint.arm.linux.org.uk> <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com> <20070214180344.GI32271@kvack.org> <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com> <20070214200347.GK32271@kvack.org> <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com> <20070214203438.GL32271@kvack.org> <20070214214944.GA1082@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214214944.GA1082@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 10:49:44PM +0100, Ingo Molnar wrote:
> this can very much be done, with a straightforward extension of how we 
> handle FPU state. That makes sense independently of syslets/async as 
> well, so find below the standalone patch from Arjan. It's in my current 
> syslet queue and works great.

That patch adds a bunch of memory dereferences and another allocation 
to the thread creation code path -- a tax that all users must pay.  Granted, 
it's small, but at the very least should be configurable out for the 99.9% 
of users that will never use this functionality.

I'm willing to be convinced, it's just that I would like to see some 
numbers that scream out that this is a good thing.

		-ben
