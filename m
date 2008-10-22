Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYJVMZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYJVMZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYJVMZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:25:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40266 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752611AbYJVMZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:25:31 -0400
Date: Wed, 22 Oct 2008 13:25:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: kgdb 2.6.28 merge plans
Message-ID: <20081022132530.0c6bc859@lxorguk.ukuu.org.uk>
In-Reply-To: <48FEFB65.3090902@windriver.com>
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
	<20081021234911.3813f17d@lxorguk.ukuu.org.uk>
	<48FE8B6F.3050406@windriver.com>
	<20081022093413.23245ab6@lxorguk.ukuu.org.uk>
	<48FEFB65.3090902@windriver.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a discussion that needs to be hashed out.  It is a question of
> where would you like it discussed (IE: new thread in lmkl,
> linux-serial@...)?

Either of those. I'd also love to drive the sysrq hook out of every
driver in the process. It seems the sysrq key, and debugger activation
are all the same thing.

> It is a discussion more about general polled vs interrupt driven
> serial/tty APIs, not all of which are used for debuggers.  I am open
> to help fix/change/extend/refactor the existing kernel's CONSOLE_POLL
> API or even deprecate it in favor of something else so long as it
> leads to an interface which can allow the sharing of the hardware
> among various contexts with early_printk, console, tty, debugger,
> etc...

What I've done so far is begin to create a "tty_port" object, the idea
being that every tty device will eventually contain one which exists for
the lifetime of the hardware object and have enough methods for printk
console (and now for polled input)

> If it was all obvious and easy, it would have already been done.  Rome
> was not built in a day after all. :-)

Agreed entirely - and in this case we have to convert a twisty maze of
ad-hoc building into Rome without breaking it during the rennovations

I certainly was not expecting a quick follow up patch to fix all these
problems, rather that it gets tackled in an orderly manner for 2.6.29/30
somewhere.

Alan
