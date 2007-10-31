Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbXJaAa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbXJaAa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXJaAaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:30:52 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:51287 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXJaAaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:30:52 -0400
Date: Tue, 30 Oct 2007 20:30:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
In-Reply-To: <p73odeg2l9v.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.58.0710302022510.5021@gandalf.stny.rr.com>
References: <1193788979.5623.43.camel@localhost.localdomain>
 <p73odeg2l9v.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--
On Wed, 31 Oct 2007, Andi Kleen wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
>
> > Is there any reason why we don't do a dump_stack on panic?
>
> One (mostly psychological, but still serious) problem is that stack
> dumps make panics always look like kernel bugs.  But there are panics
> which are definitely not kernel bugs: like the popular cannot mount
> root or machine checks or a couple of others.

Good point.

>
> We do not want users to send all these panics to linux-kernel
> and they would if they look too much like kernel bugs.
>
> I think it's in principle a good idea, but only if you
> distingush the cases which are not kernel bugs.
> e.g. use a different panic() call for them that does not dump.
>

Do you think adding a panic_nodump() call would be fine for those few
locations that is obviously a user/machine bug. This way we could make a
wrapper for panic. Change panic to have a dump parameter.

e.g.

  void __panic(int dump, const char * fmt, ...);

  #define panic(x...) __panic(1, x)
  #define panic_nodump(x...) __panic(0, x)

hmm, that will cause the print format to need to be changed, and if
someone screws up their formanting, the offset of parameters will be off.

Perhaps stripping most of the panic code into separate static functions,
and having two normal functions panic and panic_nodump might be better.

Thoughts?

-- Steve

