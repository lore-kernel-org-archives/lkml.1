Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbXE3NWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbXE3NWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbXE3NW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:22:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbXE3NW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:22:26 -0400
Date: Wed, 30 May 2007 15:20:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530132030.GA22330@elte.hu>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org> <20070530130237.GA19162@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530130237.GA19162@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> epoll is very much is capable of doing it - but why bother if 
> something more flexible than a ring can be used and the performance 
> difference is negligible? (Read my other reply in this thread for 
> further points.)

in particular i'd like to (re-)stress this point:

 Thirdly, our main problem was not the structure of epoll, our main
 problem was that event APIs were not widely available, so applications
 couldnt go to a pure event based design - they always had to handle
 certain types of event domains specially, due to lack of coverage. The
 latest epoll patches largely address that. This was a huge barrier
 against adoption of epoll.

starting with putting limits into the design by going to over-smart data 
structures like rings is just stupid. Lets fix, enhance and speed up 
what we have now (epoll) so that it becomes ubiquitous, and _then_ we 
can extend epoll to maybe fill events into rings. We should have our 
priorities right and should stop rewriting the whole world, especially 
when it comes to user APIs. Right now we have _no_ event API with 
complete coverage, and that's far more of a problem than the actual 
micro-structure of the API.

	Ingo
