Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbXFVQDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbXFVQDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXFVQD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:03:27 -0400
Received: from mail.screens.ru ([213.234.233.54]:46088 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004AbXFVQD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:03:26 -0400
Date: Fri, 22 Jun 2007 20:04:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070622160405.GA189@tv-sign.ru>
References: <20070620111415.GA91@tv-sign.ru> <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org> <20070621082509.GA88@tv-sign.ru> <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org> <20070621182340.GA92@tv-sign.ru> <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org> <20070621185856.GA153@tv-sign.ru> <1182468604.24740.22.camel@localhost.localdomain> <20070622084034.GA134@tv-sign.ru> <1182512473.24740.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182512473.24740.54.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Benjamin Herrenschmidt wrote:
> 
> That is, it -does- make sense to be able to create a signal singalfd in
> a process and have N threads reading from it and getting either shared
> signals or their local private signals.

Great.

> I just don't like the actual implementation of it by changing the task
> pointer on the fly...
>
> My main issue is a matter of consistency of the signalfd API as a
> whole... the whole bloody thing is instanciated & attached to a thread
> in the first place. Maybe we should change that and say that one
> instanciates a signalfd on a thread group... that is, it always gets
> attached to the leader.

It does exactly so, please note this chunk

 @@ -330,7 +339,7 @@ asmlinkage long sys_signalfd(int ufd, si

                 init_waitqueue_head(&ctx->wqh);
                 ctx->sigmask = sigmask;
 -               ctx->tsk = current;
 +               ctx->tsk = current->group_leader;

> It might well be that signalfd's concept of context is wrong in the
> first place and it should be attached to processes rather than threads
> and that made more explicit in the first place...

Exactly!

Oleg.

