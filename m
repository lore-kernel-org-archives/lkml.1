Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667AbXB0QXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbXB0QXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbXB0QXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:23:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbXB0QXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:23:10 -0500
Date: Tue, 27 Feb 2007 17:16:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@argo.co.il>
Cc: suparna@in.ibm.com, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org,
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
Message-ID: <20070227161617.GA16774@elte.hu>
References: <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com> <45E43827.4000102@argo.co.il> <20070227152507.GA8294@elte.hu> <45E45915.20204@argo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E45915.20204@argo.co.il>
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


* Avi Kivity <avi@argo.co.il> wrote:

> > yeah - that's what testing on ramdisk (Jens') or on a loopback block 
> > device (mine) approximates to a certain degree.
> 
> Ramdisks or fully cached loopback return immediately, so cache 
> thrashing effects don't show up.

even fully cached loopback schedules the loopback kernel thread - but i 
agree that it's inaccurate: hence the 'approximates to a certain 
degree'.

> Maybe a device mapper delay target or nbd + O_DIRECT can insert delays 
> to make the workload more disk-like.

yeah. I'll hack a small timeout into loopback requests i think. But then 
real disk-platter effects are left out ... so it all comes down to 
eventually having to try it on real disks too :)

	Ingo
