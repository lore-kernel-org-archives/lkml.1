Return-Path: <linux-kernel-owner+w=401wt.eu-S932774AbYCFMUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbYCFMUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbYCFMTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:19:52 -0500
Received: from smtp7.yandex.ru ([213.180.200.45]:55337 "EHLO smtp7.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbYCFMTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:19:52 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 07:19:51 EST
X-Yandex-Spam: 1 
X-Yandex-Front: smtp7
X-Yandex-TimeMark: 1204805469
X-MsgDayCount: 4
X-Comment: RFC 2476 MSA function at smtp7.yandex.ru logged sender identity as: dmantipov
Message-ID: <47CFDF55.6030103@yandex.ru>
Date: Thu, 06 Mar 2008 15:11:01 +0300
From: Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
References: <1389671204703217@webmail34.yandex.ru> <20080305.000014.245410231.davem@davemloft.net> <47CE6C41.3090303@cosmosbay.com> <200803060120.38032.nickpiggin@yahoo.com.au>
In-Reply-To: <200803060120.38032.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> One thing to try is pinning both processes on the same CPU. This
> may be what the FreeBSD scheduler is preferring to do, and it ends
> up being really a tradeoff that helps some workloads and hurts
> others. With a very unscientific test with an old kernel, the
> pipe.c test gets anywhere from about 1.5 to 3 times faster when
> running it as taskset 1 ./pipe

Sounds interesting. What kernel version did you tried? Can you
send your .config to me?

I've tried this trick on 2.6.25-rc4, and got ~20% more throughput for
large (> 8K) buffers at the cost of going ~30% down for the small ones.

Dmitry
