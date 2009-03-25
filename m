Return-Path: <linux-kernel-owner+w=401wt.eu-S1764387AbZCYSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764387AbZCYSvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZCYSvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:51:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40092 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760854AbZCYSvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:51:13 -0400
Message-ID: <49CA7C6E.5010103@redhat.com>
Date: Wed, 25 Mar 2009 14:48:14 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Rees <drees76@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>  <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>  <20090324091545.758d00f5@lxorguk.ukuu.org.uk>  <20090324093245.GA22483@elte.hu>  <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>  <20090324103111.GA26691@elte.hu>  <20090324041249.1133efb6.akpm@linux-foundation.org>  <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu>  <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <72dbd3150903251109x75aa5d8ke8277247c2f292f9@mail.gmail.com> <alpine.LFD.2.00.0903251117380.3032@localhost.localdomain> <alpine.LFD.2.00.0903251122250.3032@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903251122250.3032@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 25 Mar 2009, Linus Torvalds wrote:
>   
>> Even a suck-ass laptop drive can write streaming data fast enough that 
>> people don't care. The problem is invariably that writes from different 
>> sources (much of it being metadata) interact and cause seeking.
>>     
>
> Actually, not just writes.
>
> The IO priority thing is almost certainly that _reads_ (which get higher 
> priority by default due to being synchronous) get interspersed with the 
> writes, and then even if you _could_ be having streaming writes, what you 
> actually end up with is lots of seeking.
>
> Again, good SSD's don't care. Disks do. It doesn't matter if you have a FC 
> disk array that can eat 300MB/s when streaming - once you start seeking, 
> that 300MB/s goes down like a rock. Battery-protected write caches will 
> help - but not a whole lot when streaming more data than they have RAM. 
> Basic queuing theory.
>
> 			Linus
>   

This is actually not really true - random writes to an enterprise disk 
array will make your Intel SSD look slow. Effectively, they are 
extremely large, battery backed banks of DRAM with lots of fibre channel 
ports.  Some of the bigger ones can have several hundred GB of DRAM and 
dozens of fibre channel ports to feed them.

Of course, if your random writes exceed the cache capacity and you fall 
back to their internal disks (SSD or traditional), your random write 
speed will drop.

Ric

