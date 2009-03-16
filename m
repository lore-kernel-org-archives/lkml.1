Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbZCPHfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbZCPHfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZCPHe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:34:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:50541 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751961AbZCPHe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:34:58 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/SyhFXFfrS3v0j8tN5CpfYxVHkYB0YBUUqdQASAV
	xFG/quPHZONtFE
Message-ID: <49BE011D.5080807@fisher-privat.net>
Date: Mon, 16 Mar 2009 08:34:53 +0100
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: smart cache. ist is possible?
References: <49BD1EB7.6080109@fisher-privat.net> <20090315181315.GA4369@silver.sucs.org> <49BD7BEA.50307@fisher-privat.net> <20090315232614.GA27452@silver.sucs.org>
In-Reply-To: <20090315232614.GA27452@silver.sucs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sitsofe Wheeler schrieb:
> On Sun, Mar 15, 2009 at 11:06:34PM +0100, Alexey Fisher wrote:
>> It is not what i mean. I know how to clear cache but exactly i do not 
>> won't it. I will use cache and it's working perfectly with small files. 
> 
> I meant for timings on the small files otherwise how do you know which
> exactly pages were floating around the cache?
> 
>> But there is a problem with big files. For example i have 4GB RAM, if i 
>> read 4,6GB file the cache is useless. The question is; are there any way 
>> to workaround it, except more RAM?
> 
> I suspect what is happening is that you are cycling the cache. Because
> you can't hold everything and you are reading the file sequentially you
> will successfully have cleared the cache of the start of the file by the
> time you start again (so first bit gets evicted by the time last bit is
> read etc). If you use dd bs=1000M count=1 I think you will find that the
> kernel CAN cache pieces of files but as pointed out elsewhere, without
> knowing the future what do you decide to keep when your cache is full?
> 
> At a guess you either you need to provide a hint (e.g. bybassing the
> cache for some of the file so it doesn't become full or locking specific
> pages into RAM) or create a bigger cache somehow (e.g. by buying more
> RAM).

Just to make sure i understand you.
for example:
i have some smole RAM to cache 5 blocks from hard drive, and it's empty.
|0|0|0|0|0|
i read some file with 1-10 blocks ( dd if=somefile ). At the beginning
of read it will cache thirst 5  blocks ( |1|2|3|4|5| ) and after no
place left in cache it will replace old cache with new blocks(
|6|7|8|9|10| ).
If i read same somefile second time, normally will happen the same. It
tries to read block 1 and  this is not it cache, so it will be cached
and move block 6 out. ( |1|7|8|9|10| ) So it will complete replace
entire cache.
Or i can say, read somefile and only blocks 6-10 so i can use
performance from cache.
Or OS need to get a list of blocks from somefile and list of cached
blocks. And check if there is some of them cached. If they are, it
should lock the cache, read 1-5 without caching it and read 6-10 from
cache. After this unlock the cache. But this is not possible because
this operation is to expensive.
Is this what you mean?

Thank you.
Alexey.


