Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYCJDnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYCJDnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 23:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYCJDnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 23:43:41 -0400
Received: from ozlabs.org ([203.10.76.45]:45439 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbYCJDnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 23:43:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5/5] typesafe: TIMER_INITIALIZER and setup_timer
Date: Mon, 10 Mar 2008 14:42:58 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200802042311.18762.rusty@rustcorp.com.au> <200803101207.20151.rusty@rustcorp.com.au> <20080310020314.GG27894@ZenIV.linux.org.uk>
In-Reply-To: <20080310020314.GG27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803101442.58811.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008 13:03:14 Al Viro wrote:
> On Mon, Mar 10, 2008 at 12:07:19PM +1100, Rusty Russell wrote:
> >    Worst, I can't see a way to apply your technique in general, for
> > non-void-returning functions (eg. interrupt handlers).
>
> Interrupt handlers are easy.  Just switch irqreturn_t from into to
> struct {int x;}, adjust the rest of irqreturn.h accordingly, add
> extern void want_irqreturn_t(irqreturn_t);
> then replace 0 ? (f)(x) : (void)0 with want_irqreturn_t((f)(x)) in the
> expression under sizeof and we are all set (assuming Jeff's elimination
> of irq number in place by then or done in parallel).

Hmm, I was hoping we'd kill irqreturn_t some day: I don't think 2.4 
compatibility is worth much any more.

That means doing similar things for stop_machine and kthread_create (just from 
looking at this patch series).

The benefits of natural-typed callback args drops if the return type pays the 
price.

Cheers,
Rusty.

