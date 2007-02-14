Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbXBNVO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbXBNVO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932617AbXBNVO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:14:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60303 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932615AbXBNVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:14:57 -0500
Date: Wed, 14 Feb 2007 22:12:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070214211231.GA18326@elte.hu>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070214210251.GA15025@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214210251.GA15025@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > And the whole "lock things down in memory" approach is bad. It's 
> > doing expensive things like mlock(), making the overhead for 
> > _single_ system calls much more expensive. [...]
> 
> hm, there must be some misunderstanding here. That mlock is /only/ 
> once per the lifetime of the whole 'head' - i.e. per 
> sys_async_register(). (And you can even forget i ever did it - it's 5 
> lines of code to turn the completion ring into a swappable entity.)
> 
> never does any MMU trick ever enter the picture during the whole 
> operation of this thing, and that's very much intentional.

to stress it: never does any mlocking or other lockdown happen of any 
syslet atom - it is /only/ the completion ring of syslet pointers that i 
made mlocked - but even that can be made generic memory no problem.

It's all about asynchronous system calls, and if you want you can have a 
terabyte of syslets in user memory, half of it swapped out. They have 
absolutely zero kernel context attached to them in the 'cached case' (be 
that locked memory or some other kernel resource).

	Ingo
