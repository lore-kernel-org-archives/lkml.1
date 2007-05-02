Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbXEBHzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbXEBHzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXEBHzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:55:08 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:43559 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbXEBHzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:55:05 -0400
Date: Wed, 2 May 2007 09:55:03 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Ulrich Drepper" <drepper@gmail.com>
Cc: "Davi Arnaut" <davi@haxent.com.br>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Message-Id: <20070502095503.a06f5472.dada1@cosmosbay.com>
In-Reply-To: <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
References: <20070502052235.914764000@haxent.com.br>
	<20070502053427.123392000@haxent.com.br>
	<a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 00:40:17 -0700
"Ulrich Drepper" <drepper@gmail.com> wrote:

> - if you have multiple threads polling a futex and the waker wakes up
> one, what happens?
>   It is simply not acceptable to have more than one thread return from
> the poll() call, this
>   would waste too many cycles, just to put all threads but one back to sleep.
>

Well, poll() level edge semantic is well defined, you cannot cheat or change it.

If many threads call poll() on the same end point, they should *all* return POLLIN/whatever status.

This is why programs usually use one thread to dispatch events to workers, or at least dont queue XXXX threads calling poll() on one fd.

Only system calls that actually returns an 'work_done' can avoid waking all waiting threads and putting them back in queue. Example of such system calls are accept() or read()

