Return-Path: <linux-kernel-owner+w=401wt.eu-S1762753AbXKTVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753AbXKTVVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbXKTVVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:21:32 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59054 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523AbXKTVVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:21:31 -0500
Date: Wed, 21 Nov 2007 00:20:32 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] kill PT_PTRACED
Message-ID: <20071120212031.GA157@tv-sign.ru>
References: <20071120152133.GA4546@tv-sign.ru> <20071120210840.94CB726F8BE@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120210840.94CB726F8BE@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20, Roland McGrath wrote:
>
> Subject should be "kill PT_ATTACHED".
> 
> > -	    (!(child->ptrace & PT_ATTACHED) || child->real_parent != current)
> > -	    && child->signal != NULL) {
> > +	     child->sighand != NULL) {
> 
> This does s/signal/sighand/ without comment.

Ah yes, sorry, forgot to add the comment.

This is microoptimization, both ->signal and ->sighand are cleared at the same
time in __exit_signal(), so we can check either. But we are using the value of
->sighand below, so it makes sense to read ->sighand, not ->signal.

Andrew, it is very easy to send the new patch to fix the code, but is it possible
to fix the changelog somehow for the patch in -mm tree?

Oleg.

