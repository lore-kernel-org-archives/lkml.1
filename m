Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYGUSqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYGUSqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYGUSqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:46:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58398 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbYGUSqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:46:39 -0400
Date: Mon, 21 Jul 2008 20:46:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [crash] kernel BUG at net/core/dev.c:1328!
Message-ID: <20080721184616.GA8442@elte.hu>
References: <20080720.104411.81744468.davem@davemloft.net> <20080721133059.GA30637@elte.hu> <20080721134506.GA27598@elte.hu> <20080721182318.GA20940@elte.hu> <alpine.LFD.1.10.0807211131390.31863@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807211131390.31863@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 21 Jul 2008, Ingo Molnar wrote:
> >
> > [   24.434799] kernel BUG at net/core/dev.c:1328!
> 
> Ok, it is now a WARN_ON_ONCE() in my tree (which I _just_ pushed out). 
> 
> So it's going to cause irritating messages (once), but the machine should 
> hopefully work.
> 
> > Should i spend time on bisecting this, or is this known already?
> 
> It's going to bisect down to the same commit you already bisected 
> once, it's the networking code that changed some of the rules, so 
> various network drivers that didn't follow the expected rules are now 
> unhappy.
> 
> Maybe the network drivers are few enough that it will get fixed, or 
> maybe the WARN_ON_ONCE() will just be removed and the rule not 
> reinforced.

ok, have updated the testboxes to your latest push.

Btw., otherwise the big networking pull held up pretty well on a healthy 
range of testboxes i have, it looked a lot scarier to me in the morning 
than it turned out to be during the day. A couple of hundred tests 
passed already and no indication of any runtime fragility so far. Boot 
crashes/warnings can be annoying and hard to get a proper log of but 
once the log is available they are normally quite easy for developers to 
act upon.

	Ingo
