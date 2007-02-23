Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbXBWPEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbXBWPEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbXBWPEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:04:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37586 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbXBWPEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:04:47 -0500
Date: Fri, 23 Feb 2007 15:58:26 +0100
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
Message-ID: <20070223145826.GA32465@elte.hu>
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk> <20070223135525.GA31569@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223135525.GA31569@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Suparna Bhattacharya <suparna@in.ibm.com> wrote:

> As a really crude (and not very realistic) example of the potential 
> impact of large numbers of outstanding IOs, I tried some quick direct 
> IO comparisons using fio:
> 
> [global]
> ioengine=syslet-rw
> buffered=0
> rw=randread
> bs=64k
> size=1024m
> iodepth=64

could you please try those iodepth=20000 tests with the latest 
fio-testing branch of fio as well? Jens wrote a new, smarter syslet 
plugin for FIO. You'll need the v3 syslet kernel plus:

 git-clone git://git.kernel.dk/data/git/fio.git
 cd fio
 git-checkout syslet-testing

my expectation is that it should behave better with iodepth=20000 
(although i havent tried that yet).

	Ingo
