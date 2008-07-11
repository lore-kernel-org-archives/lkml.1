Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbYGKPU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbYGKPU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbYGKPRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:17:20 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:39438 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbYGKPRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:17:19 -0400
Message-ID: <4877799F.4040104@fastmq.com>
Date: Fri, 11 Jul 2008 17:17:51 +0200
From: Martin Sustrik <sustrik@fastmq.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Martin Lucina <mato@kotelna.sk>,
       linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk>	<20080709222701.8eab4924.akpm@linux-foundation.org>	<4875C45C.2010901@fastmq.com> <20080710093109.46db7c40@the-village.bc.nu>
In-Reply-To: <20080710093109.46db7c40@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> Which disk scheduler are you using - some of the disk schedulers
> intentionally delay writes to try and get better block merging.

We've run the test with different I/O schedulers. We've found out that 
poor performance we've seen before was due to the short AIO queue size. 
Now, when queue size is big enough to hold all the write requests in the 
test, the results are much better. Have a look here for the code of the 
test and the results in form of graphs:

http://www.zeromq.org/results:aio

There are still at least two problems I see:

1. Enqueueing of writes seems to block every now and then although the 
size of AIO queue is large enough to hold all the requests in the test.

2. We've observed that messages are batched for writes by approximately 
30 per batch. The latency impact of messages 2-30 is almost zero, 
however, the impact of the first message is much higher than expected. I 
would expect latency of one disk revolving (8.3 ms) + optionally latency 
of head movement (say 10 us). What we are seing are latencies of 30-60 ms.

Martin
