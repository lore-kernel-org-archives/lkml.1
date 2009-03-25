Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZCYSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZCYSqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZCYSqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:46:24 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:44488 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbZCYSqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:46:23 -0400
Message-ID: <49CA7BEC.1020707@krogh.cc>
Date: Wed, 25 Mar 2009 19:46:04 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: David Rees <drees76@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>	 <49C87B87.4020108@krogh.cc>	 <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>	 <49C88C80.5010803@krogh.cc>	 <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>	 <49CA6D09.1020401@krogh.cc> <72dbd3150903251116ie84b9e9ib998ac0283e6cfbb@mail.gmail.com>
In-Reply-To: <72dbd3150903251116ie84b9e9ib998ac0283e6cfbb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rees wrote:
>>> writes.  How fast is the array in practice?
>> Thats allways a good question.. This is by far not being the only user
>> of the array at the time of testing.. (there are 4 FC-channel connected to a
>> switch). Creating a fresh slice.. and just dd'ing onto it from /dev/zero
>> gives:
>> jk@hest:~$ sudo dd if=/dev/zero of=/dev/sdh bs=1M count=10000
>> 10000+0 records in
>> 10000+0 records out
>> 10485760000 bytes (10 GB) copied, 78.0557 s, 134 MB/s
>> jk@hest:~$ sudo dd if=/dev/zero of=/dev/sdh bs=1M count=1000
>> 1000+0 records in
>> 1000+0 records out
>> 1048576000 bytes (1.0 GB) copied, 8.11019 s, 129 MB/s
>>
>> Watching using dstat while dd'ing it peaks at 220M/s
> 
> Hmm, not as fast as I expected.

Me neither, but I always get disappointed.

>> It has 2GB of battery backed cache. I'm fairly sure that when it was new
>> (and I only had connected one host) I could get it up at around 350MB/s.
> 
> With 2GB of BBC, I'm surprised you are seeing as much latency as you
> are.  It should be able to suck down writes as fast as you can throw
> at it.  Is the array configured in writeback mode?

Yes, but I triple checked.. the memory upgrade hadn't been installed, so 
its actually only 512MB.

> 
>>> On a 32GB system that's 1.6GB of dirty data, but your array should be
>>> able to write that out fairly quickly (in a couple seconds) as long as
>>> it's not too random.  If it's spread all over the disk, write
>>> throughput will drop significantly - how fast is data being written to
>>> disk when your system suffers from large write latency?
>> Thats another thing. I havent been debugging while hitting it (yet) but if I
>> go ind and do a sync on the system manually. Then it doesn't get above
>> 50MB/s in writeout (measured using dstat). But even that doesn't sum up to 8
>> minutes .. 1.6GB at 50MB/s ..=> 32 s.
> 
> Have you also tried increasing the IO priority of the kjournald
> processes as a workaround as Arjan van de Ven suggests?

No. I'll try to slip that one in.

-- 
Jesper
