Return-Path: <linux-kernel-owner+w=401wt.eu-S932654AbXBNViD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbXBNViD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932653AbXBNViC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:38:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649AbXBNViA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:38:00 -0500
Date: Wed, 14 Feb 2007 22:35:05 +0100
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
Message-ID: <20070214213505.GA24812@elte.hu>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070214210251.GA15025@elte.hu> <Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But the whole point is that the notion of a "register" is wrong in the 
> first place. [...]

forget about it then. The thing we "register" is dead-simple:

 struct async_head_user {
         struct syslet_uatom __user              **completion_ring;
         unsigned long                           ring_size_bytes;
         unsigned long                           max_nr_threads;
 };

this can be passed in to sys_async_exec() as a second pointer, and the 
kernel can put the expected-completion pointer (and the user ring idx 
pointer) into its struct atom. It's just a few instructions, and only in 
the cachemiss case.

that would make completions arbitrarily split-up-able. No registration 
whatsoever. A waiter could specify which ring's events it is interested 
in. A 'ring' could be a single-entry thing as well, for a single 
instance of pending IO.

	Ingo
