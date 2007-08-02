Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbXHBMKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbXHBMKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXHBMK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:10:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49420 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbXHBMKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:10:25 -0400
Date: Thu, 2 Aug 2007 14:10:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
Message-ID: <20070802121018.GA11900@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins> <20070731085713.GA15136@elte.hu> <1186011827.2482.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186011827.2482.1.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kasper Sandberg <lkml@metanurb.dk> wrote:

> > ah, indeed, that makes quite a bit of sense. Almost all of the 
> > Reiser3 code runs under the BKL, and the only other major kernel 
> > infrastructure that has BKL dependencies is the TTY code. Kasper, as 
> > a debugging matter, could you try to move that spamassassin workload 
> > off into a non-Reiser3 filesystem and/or disable PREEMPT_BKL? If 
> > that makes a noticeable difference (for the better ;) then we can 
> > continue figuring out what's happening exactly.
> 
> the pricess is as this:
> mail client fetches mail
> mail client invokes spamasassin
>  if spam -> spam
>  else filtering
> if it matches certain filters, it gets put into my imap server, which is
> reiserfs.

do you have any filesystem that is not reiserfs? If yes, could you, as a 
test, check whether file activities on _that_ file system still cause 
these lags, or is the lag purely connected to the reiser3 filesystem?

	Ingo
