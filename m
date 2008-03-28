Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYC1XrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYC1XrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYC1XrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:47:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364AbYC1Xq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:46:59 -0400
Date: Sat, 29 Mar 2008 00:46:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, aabdulla@nvidia.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 20/21] forcedeth: fix locking bug with netconsole
Message-ID: <20080328234628.GA8459@elte.hu>
References: <200803282141.m2SLfUwU011858@imap1.linux-foundation.org> <20080328.154353.43255092.davem@davemloft.net> <47ED75CE.1080400@garzik.org> <20080328164209.e8b723d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328164209.e8b723d8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > Please do not mix device driver changes with core networking 
> > > changes.
> > 
> > FWIW my plan was to snip the net/* stuff and only apply the 
> > forcedeth portion.
> > 
> > (leaving <whomever> to pick up the pieces, should they so desire)
> > 
> 
> Just drop 'em completely I'd say.

you mean the netpoll.c bits? sure.

> otoh, drivers do seem a bit flakey in the netpoll-support area, so a 
> bit of extra debug wouldn't hurt.  But checking irqs_disabled() either 
> side of a udelay() was a bit paranoid ;)

yeah. i completely forgot about those bits. But lets make sure the 
forcedeth.c fix gets into .25 - it's obvious and it fixes a nasty bug. 
Without that fix netconsole is unusable on forcedeth.

	Ingo
