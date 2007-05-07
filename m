Return-Path: <linux-kernel-owner+w=401wt.eu-S967192AbXEGXP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967192AbXEGXP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967187AbXEGXP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:15:57 -0400
Received: from haxent.com ([65.99.219.155]:3686 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967089AbXEGXP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:15:56 -0400
Message-ID: <463FB327.4070906@haxent.com.br>
Date: Mon, 07 May 2007 20:15:51 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
References: <20070504225730.490334000@haxent.com.br>	 <463BC3CA.6050109@haxent.com.br>	 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>	 <463CFA37.3020809@haxent.com.br>	 <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>	 <463F9B68.305@haxent.com.br> <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>
In-Reply-To: <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 5/7/07, Davi Arnaut <davi@haxent.com.br> wrote:
>> See Linus's message on this same thread.
> 
> No.  I'm talking about the userlevel side, not kernel side.

So you probably knew the answer before asking the question.

> If a thread is canceled *after* it returns from the syscall but before
> it reports the event to the call (i.e., while still in the syscall
> wrapper, thread cancellation rules require a check there) the event is
> lost.

Exactly. The same happens with sigwaitinfo(), and various other.

> Linus was only talking about the kernel side and how in the exit path
> such events are not lost.

Anyway, we could extend epoll to be mmapable...

--
Davi Arnaut
