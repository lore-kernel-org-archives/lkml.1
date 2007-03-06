Return-Path: <linux-kernel-owner+w=401wt.eu-S965363AbXCFR14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363AbXCFR14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXCFR14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:27:56 -0500
Received: from terminus.zytor.com ([192.83.249.54]:56878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965363AbXCFR1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:27:55 -0500
Message-ID: <45EDA478.6060605@zytor.com>
Date: Tue, 06 Mar 2007 09:27:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <45ED08A9.9050501@cosmosbay.com> <45ED96A6.3000704@zytor.com> <200703061812.28478.dada1@cosmosbay.com> <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 6 Mar 2007, Eric Dumazet wrote:
>> Something like :
>>
>> [PATCH] : Use reciprocal divides in sprintf()
> 
> Try this on Core 2, and I suspect that you'll find that the hardware is 
> actually *faster* than doing the shift/test, function call and the 
> two multiplies.
> 
>> Using reciprocal divides permits to change each divide by two multiplies, less 
>> expensive on current CPUS.
> 
> Are you sure?
> 

For base 8 and 16, this is shift and mask, respectively, so it's bound 
to be faster (although modern hardware can often optimize this, embedded 
hardware definitely can't.)  Base 10, which even in the Linux kernel is 
almost certainly the most common case, is a lot iffier.

	-hpa
