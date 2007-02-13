Return-Path: <linux-kernel-owner+w=401wt.eu-S1751339AbXBMWUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbXBMWUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbXBMWUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:20:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbXBMWUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:20:16 -0500
Date: Tue, 13 Feb 2007 23:18:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213221810.GF22104@elte.hu>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org> <20070213165642.GB16394@elte.hu> <20070213185636.GA23987@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213185636.GA23987@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> [...] it still has a problem - syscall blocks and the same thread thus 
> is not allowed to continue execution and fill the pipe - so what if 
> system issues thousands of requests and there are only tens of working 
> thread at most. [...]

the same thread is allowed to continue execution even if the system call 
blocks: take a look at async_schedule(). The blocked system-call is 'put 
aside' (in a sleeping thread), the kernel switches the user-space 
context (registers) to a free kernel thread and switches to it - and 
returns to user-space as if nothing happened - allowing the user-space 
context to 'fill the pipe' as much as it can. Or did i misunderstand 
your point?

basically there's SYSLET_ASYNC for 'always async' and SYSLET_SYNC for 
'always sync' - but the default syslet behavior is: 'try sync and switch 
transparently to async on demand'. The testcode i sent very much uses 
this. (and this mechanism is in essence Zach's fibril-switching thing, 
but done via kernel threads.)

	Ingo
