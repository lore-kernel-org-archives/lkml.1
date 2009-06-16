Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZFPKqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZFPKqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZFPKqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:46:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50400 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZFPKqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:46:09 -0400
Date: Tue, 16 Jun 2009 12:45:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616104559.GA29880@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com> <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk> <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk> <20090616100015.GD6432@elte.hu> <20090616110419.14bc9485@lxorguk.ukuu.org.uk> <20090616101240.GB28204@elte.hu> <20090616102509.GA32717@elte.hu> <20090616102910.GA11011@elte.hu> <20090616103435.GI5139@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616103435.GI5139@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Tue, Jun 16, 2009 at 12:29:10PM +0200, Ingo Molnar wrote:
> > We are now well below the limit for stack-trace entries.
> > 
> > This is something we noticed recently: dma-debug uses a lot of 
> > lock classes and thus creates a really large lock-graph, 
> > depleting the reserves quickly.
> 
> Is this considered a problem? I increased the hash-size to 1024 
> for performance reasons (== 1024 spin_locks). But if it hurts to 
> much in other places this can be reverted.

Lockdep running out of stack slots is a problem - but we dont want 
to revert your patch: lockdep is really a helper to development, it 
just observes, never hinders changes like that.

The good news is that the (untested) patch i sent should largely 
solve this problem and reduce dma-debug's lockdep footprint by a 
factor of 1024.

Reverting your change would only be a workaround really.

	Ingo
