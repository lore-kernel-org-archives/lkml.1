Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbXFVWeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbXFVWeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXFVWdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:33:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:41808 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbXFVWdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:33:52 -0400
Subject: Re: Fix signalfd interaction with thread-private signals
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070622160405.GA189@tv-sign.ru>
References: <20070620111415.GA91@tv-sign.ru>
	 <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
	 <20070621082509.GA88@tv-sign.ru>
	 <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
	 <20070621182340.GA92@tv-sign.ru>
	 <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
	 <20070621185856.GA153@tv-sign.ru>
	 <1182468604.24740.22.camel@localhost.localdomain>
	 <20070622084034.GA134@tv-sign.ru>
	 <1182512473.24740.54.camel@localhost.localdomain>
	 <20070622160405.GA189@tv-sign.ru>
Content-Type: text/plain
Date: Sat, 23 Jun 2007 08:33:38 +1000
Message-Id: <1182551618.24740.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> It does exactly so, please note this chunk
> 
>  @@ -330,7 +339,7 @@ asmlinkage long sys_signalfd(int ufd, si
> 
>                  init_waitqueue_head(&ctx->wqh);
>                  ctx->sigmask = sigmask;
>  -               ctx->tsk = current;
>  +               ctx->tsk = current->group_leader;
> 
> > It might well be that signalfd's concept of context is wrong in the
> > first place and it should be attached to processes rather than threads
> > and that made more explicit in the first place...

Yup, looks like I was looking at a wrong patch... I think it's the right
thing to do indeed.

Ben.


