Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbXEUEP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbXEUEP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXEUEPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:15:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1777 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXEUEPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:15:16 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 20 May 2007 21:14:38 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Davi Arnaut <davi@haxent.com.br>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] signalfd: retrieve multiple signals with one read() call
In-Reply-To: <20070520210210.9a895eec.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705202112230.22011@alien.or.mcafeemobile.com>
References: <464F912F.3040205@haxent.com.br> <20070520210210.9a895eec.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Andrew Morton wrote:

> If 'count' is not a multiple of sizeof(struct signalfd_siginfo)), the read()
> will return the next smallest multiple of `count'.
> 
> That is, unless `count' happens to be less than 1*sizeof(struct
> signalfd_siginfo)), in which case we return -EINVAL.
> 
> This seems inconsistent.

I think it fits the rule "buffer must be big enough for at least one sigingo".
We use the special return 0; as indicator that the process we were 
monitoring signals, detached the sighand.



> Also, I'm desperately hunting for the place where we zero out that local
> siginfo_t, and I ain't finding it.  Someone please convince me that we're
> not leaking bits of kernel memory out to userspace in that thing.

Hmm, __clear_user()?


- Davide


