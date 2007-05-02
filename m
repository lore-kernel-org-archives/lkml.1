Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXEBHkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXEBHkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXEBHkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:40:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:41768 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992878AbXEBHkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cSDTXgOSpxkZHMXj+p1EmPnl76YyYeuQSLaRuTkKWm5h8ZFilIOPrVT34Y3/LkaIQtwkEoTbJgm9r3mJMQnYutY6+BgFnucyavqNhfPLW6K827qvkYUXkXhkP69XG0cj4eA8gaRJcj+vYUtCCCY9L2wOG3BKe7p8cAsu/XI1vdU=
Message-ID: <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
Date: Wed, 2 May 2007 00:40:17 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davi Arnaut" <davi@haxent.com.br>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070502053427.123392000@haxent.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502053427.123392000@haxent.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Davi Arnaut <davi@haxent.com.br> wrote:
> The pollable futex approach is far superior (send and receive events from
> userspace or kernel) to eventfd and fixes (supercedes) FUTEX_FD at the same time.
> [...]

You have to explain in detail how these interfaces are supposed to
work.  From first sight and without understanding (all) the it seems
it's far from useful.

Pollable futexes are useful, but any solution which gets implemented
must be sufficiently useful for all the uses we might have.

- the trivial is that you have a futex and you are just interest in
seeing it change.   The
  same as FUTEX_WAIT.  I cannot figure out how all this works in your
code.  Does your
  read() call (that's the one to wait, yes?) work with O_NONBLOCK or
how else do you get
  that behavior?

- more complicated case: I have to wait for multiple futexes and lock
them all at the same
  time or don't return at all.  This is possible with SysV semaphores
and generally useful
  and needed.  How can this be implemented with your scheme?

- how does it work with PI futexes?

- can I use a futex at the same time through this mechanism and using the normal
  FUTEX_WAIT operation?  This is a killer if it's not the case.

- if you have multiple threads polling a futex and the waker wakes up
one, what happens?
  It is simply not acceptable to have more than one thread return from
the poll() call, this
  would waste too many cycles, just to put all threads but one back to sleep.
