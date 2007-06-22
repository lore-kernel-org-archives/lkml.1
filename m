Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbXFVIkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbXFVIkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbXFVIk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:40:28 -0400
Received: from mail.screens.ru ([213.234.233.54]:45258 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXFVIk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:40:27 -0400
Date: Fri, 22 Jun 2007 12:40:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070622084034.GA134@tv-sign.ru>
References: <20070619140646.GB27343@tv-sign.ru> <1182295473.26853.386.camel@localhost.localdomain> <20070620111415.GA91@tv-sign.ru> <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org> <20070621082509.GA88@tv-sign.ru> <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org> <20070621182340.GA92@tv-sign.ru> <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org> <20070621185856.GA153@tv-sign.ru> <1182468604.24740.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182468604.24740.22.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Benjamin Herrenschmidt wrote:
>
> Yeah well... I wanted to have the least surprise path... that is,
> without my patch, signalfd will "sometimes" steal the SIGSEGV depending
> on who races to the lock first, thus causing the target thread to
> re-execute the faulting instruction and taking another SIGSEGV, and
> sometimes not. It's bad from both the faulting thread point of view and
> the signalfd use who gets signals "sometimes" without any guarantee.
> 
> I like the current code that at least implement a precise semantic for
> all thread local signals -> they are only ever delivered to that thread,
> period. If you really want to do funky things from outside, you can
> still do ptrace ;-)

OK. But in that case I think we should go further, and make signalfd
"per process", not "per thread", see

	http://marc.info/?l=linux-kernel&m=118241815219430

Every thread gets its own local signals plus shared ones.

(I promise, this is the last piece of spam from me on this topic, but
 please-please-please nack this patch explicitly if you don't like it :)

Oleg.

