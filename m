Return-Path: <linux-kernel-owner+w=401wt.eu-S1765114AbYEAT7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765114AbYEAT7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYEAT7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:59:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbYEAT7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:59:07 -0400
Date: Thu, 1 May 2008 12:58:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, w@1wt.eu, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080501125843.61adbe20.akpm@linux-foundation.org>
In-Reply-To: <20080501193714.GC5882@ZenIV.linux.org.uk>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200805011259.47343.rjw@sisk.pl>
	<alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org>
	<200805011909.40203.rjw@sisk.pl>
	<alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
	<20080501181157.GB5882@ZenIV.linux.org.uk>
	<alpine.LFD.1.10.0805011116060.5994@woody.linux-foundation.org>
	<20080501193714.GC5882@ZenIV.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 20:37:14 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> 	* patches should be visible *when* *they* *can* *be* *changed*.
> If it's "Linus had pulled from linux-foo.git and that included a merge
> from linux-foobar.git, which is developed on foobar-wank@hell.knows.where",
> it's too late.  It's not just that you don't revert; it's that you _can't_
> realistically revert in such situation - not without very massive work.
> And I don't know what _can_ be done about that, other than making it
> socially discouraged.  To some extent it's OK, but my impression is that
> some areas are as bad as CVS-based "communities" had been and switch to
> git has simply hidden the obvious signs of trouble...

Yup.  I think the only sane+scalable way of making this happen is to
prevail upon the 100-odd subsystem maintainers to keep an eye out for code
which should be exposed to additional eyes.

There are of course many reasons _why_ such code needs the attention of
others, and those reasons have varying strengths.  Off the top of my head:

- modifies stuff outside the designated subsystem (eg: lib/pcounter.c -
  thanks Pavel)

- (having just spent an hour looking at drivers/net/sfc/ and having
  boggled at its bitmap.h): adds generic-looking infrastructure which
  should be in core kernel.  Or already _is_ in core kernel.

- Adds any kernel<->user interface which is not of the the most
  trivial&standard form

- Futzes with memory management internals, adds pagefault handlers, etc.

- Ditto vfs things, I guess

- In any way attempts to work around _any_ shortcoming of any other part
  of the kernel!

- Does anything RCU related.  Every time I cc Paul on an rcu-using patch,
  he finds holes in it.

- add your own here.



But we won't find such code by going out and looking for it - we do need
the recipients of that code to say "hey, others might want to see this". 
That's very low-effort for the hey-sayer, so I expect we can do better here
quite easily.

