Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYE0VLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYE0VLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbYE0VK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:10:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:35080 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590AbYE0VK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:10:58 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
In-Reply-To: <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <1211859542.3286.46.camel@pasglop>
	 <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 07:10:21 +1000
Message-Id: <1211922621.3286.80.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 08:35 -0700, Linus Torvalds wrote:
> 
> On Tue, 27 May 2008, Benjamin Herrenschmidt wrote:
> > 
> > Yes. As it is today, tg3 for example is potentially broken on all archs
> > with newer gcc unless we either add "memory" clobber to readl/writel or
> > stick some wmb's in there (just a random driver I picked).
> > 
> > So Linus, what is your take on that matter ?
> 
> Let's just serialize the damn things, and add a memory clobber to them.
> 
> Expecting people to fix up all drivers is simply not going to happen. And 
> serializing things shouldn't be *that* expensive. People who cannot take 
> the expense can continue to use the magic __raw_writel() etc stuff.

Ok.

Do we also remove wmb/rmb/... from drivers then ? :-) I think ia64 would
need to be fixed to make their writel serializing...

Regarding __raw_* their semantics are dodgy ... we might want to provide
something better but it's a different subject.

Cheers,
Ben.


