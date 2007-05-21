Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbXEUQE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbXEUQE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbXEUQEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:04:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204AbXEUQEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:04:49 -0400
Date: Mon, 21 May 2007 08:57:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anant Nitya <kernel@prachanda.info>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] CFS scheduler, -v13
In-Reply-To: <200705200246.22444.kernel@prachanda.hub>
Message-ID: <alpine.LFD.0.98.0705210851450.3890@woody.linux-foundation.org>
References: <20070517174533.GA538@elte.hu> <200705180317.06014.kernel@prachanda.hub>
 <20070518102607.GA23151@elte.hu> <200705200246.22444.kernel@prachanda.hub>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 20 May 2007, Anant Nitya wrote:
> 
> After digging in a bit I found that problem is only occurring in 
> 2.6.22-rc1 and it get fired by network usage while transmitting data 
> upstream.

Can you bisect it? Just do

	git bisect start
	git bisect good v2.6.21
	git bisect bad v2.6.22-rc1

and start testing the end result. The bisection thing is pretty efficient, 
so while there's almost 5000 commits in there, you realy shouldn't need to 
test more than ten kernels to get it narrowed down to just five commits or 
so, and since it seems to be very repeatable and noticeable for you, 
bisecting should be the trivial thing to figure out what broke.

David: all the blather about network drivers and/or /proc/net/tcp being 
slow anyway misses the *big* point: it didn't use to do this. So there's a 
new bug there. Maybe something keeps sockets around in a dead state on the 
hash lists or whatever. Mayube something else breaks his bittorrent 
client. Whatever. We don't know. But it's a regression.

		Linus
