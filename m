Return-Path: <linux-kernel-owner+w=401wt.eu-S1030278AbXBZOZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278AbXBZOZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030280AbXBZOZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:25:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51071 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030278AbXBZOZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:25:02 -0500
Date: Mon, 26 Feb 2007 15:18:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070226141808.GB24683@elte.hu>
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk> <20070223135525.GA31569@in.ibm.com> <20070223145826.GA32465@elte.hu> <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226141315.GA15631@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Suparna Bhattacharya <suparna@in.ibm.com> wrote:

> > syslet still on top. Measuring O_DIRECT reads (of 4kb size) on ramfs 
> > with 100 processes each with a depth of 200, reading a per-process 
> > private file of 10mb (need to fit in my ram...) 10 times each. IOW, 
> > doing 10,000MiB of IO in total:
> 
> But, why ramfs ? Don't we want to exercise the case where O_DIRECT 
> actually blocks ? Or am I missing something here ?

ramfs is just the easiest way to measure the pure CPU overhead of a 
workload without real IO delays (and resulting idle time) getting in the 
way. It's certainly not the same thing, but still it's pretty useful 
most of the time. I used a different method, loopback block device, and 
got similar results. [ Real IO shows similar results as well, but is a 
lot more noisy and hence harder to interpret (and thus easier to get 
wrong). ]

	Ingo
