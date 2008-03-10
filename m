Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYCJCDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYCJCDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 22:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYCJCDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 22:03:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57413 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYCJCDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 22:03:23 -0400
Date: Mon, 10 Mar 2008 02:03:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/5] typesafe: TIMER_INITIALIZER and setup_timer
Message-ID: <20080310020314.GG27894@ZenIV.linux.org.uk>
References: <200802042311.18762.rusty@rustcorp.com.au> <200803051355.36502.rusty@rustcorp.com.au> <20080306104034.GB27894@ZenIV.linux.org.uk> <200803101207.20151.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803101207.20151.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 12:07:19PM +1100, Rusty Russell wrote:

>    Worst, I can't see a way to apply your technique in general, for 
> non-void-returning functions (eg. interrupt handlers).

Interrupt handlers are easy.  Just switch irqreturn_t from into to
struct {int x;}, adjust the rest of irqreturn.h accordingly, add
extern void want_irqreturn_t(irqreturn_t);
then replace 0 ? (f)(x) : (void)0 with want_irqreturn_t((f)(x)) in the
expression under sizeof and we are all set (assuming Jeff's elimination
of irq number in place by then or done in parallel).
