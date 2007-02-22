Return-Path: <linux-kernel-owner+w=401wt.eu-S1751650AbXBVPeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbXBVPeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbXBVPeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:34:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbXBVPeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:34:15 -0500
Date: Thu, 22 Feb 2007 16:29:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: johnpol@2ka.mipt.ru, arjan@infradead.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       hch@infradead.org, akpm@zip.com.au, alan@lxorguk.ukuu.org.uk,
       zach.brown@oracle.com, suparna@in.ibm.com, davidel@xmailserver.org,
       jens.axboe@oracle.com, tglx@linutronix.de
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222152904.GA17799@elte.hu>
References: <20070222123929.GA5208@2ka.mipt.ru> <20070222.054127.104035694.davem@davemloft.net> <20070222143145.GA3246@elte.hu> <20070222.064704.71093028.davem@davemloft.net> <20070222151509.GA13670@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222151509.GA13670@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.8 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0017]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > The pushback to the primary thread you speak of is just extra work 
> > in my mind, for networking.  Better to just begin operations and sit 
> > in the primary thread(s) waiting for events, and when they arrive 
> > push the operations further along using non-blocking writes, reads, 
> > and accept() calls.  There is no blocking context really needed for 
> > these kinds of things, so a mechanism that tries to provide one is a 
> > waste.
> 
> one question is, what is cheaper, to block out of a read and a write and 
                                         ^-------to back out
> to set up the event notification and then to return to the user 
> context, or to just stay right in there with all the context already 
> constructed and on the stack, and schedule away and then come back and 
> queue back to the primary thread once the condition the thread is 
> waiting for is done? The latter isnt all that unattractive in my mind, 
> because it always does forward progress, with minimal 'backout' costs.

	Ingo
