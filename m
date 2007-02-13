Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbXBMRAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbXBMRAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbXBMRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:00:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54613 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbXBMRAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:00:04 -0500
Date: Tue, 13 Feb 2007 17:56:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213165642.GB16394@elte.hu>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213145848.GS18311@kvack.org>
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


* Benjamin LaHaise <bcrl@kvack.org> wrote:

> > > Open issues:
> > 
> > Let me add some more
> 
> Also: FPU state (especially important with the FPU and SSE memory copy 
> variants), segment register bases on x86-64, interaction with 
> set_fs()...

agreed - i'll fix this. But i can see no big conceptual issue here - 
these resources are all attached to the user context, and that doesnt 
change upon an 'async context-switch'. So it's "only" a matter of 
properly separating the user execution context from the kernel execution 
context. The hardest bit was getting the ptregs details right - the 
FPU/SSE state is pretty much async already (in the hardware too) and 
isnt even touched by any of these codepaths.

	Ingo
