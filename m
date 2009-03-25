Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZCYS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZCYS56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZCYS5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:57:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37421 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZCYS5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:57:48 -0400
Message-ID: <49CA7E21.6030409@redhat.com>
Date: Wed, 25 Mar 2009 14:55:29 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>	<20090324093245.GA22483@elte.hu>	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>	<20090324103111.GA26691@elte.hu>	<20090324041249.1133efb6.akpm@linux-foundation.org>	<20090325123744.GK23439@duck.suse.cz>	<20090325150041.GM32307@mit.edu>	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>	<72dbd3150903251109x75aa5d8ke8277247c2f292f9@mail.gmail.com>	<alpine.LFD.2.00.0903251117380.3032@localhost.localdomain>	<alpine.LFD.2.00.0903251122250.3032@localhost.localdomain> <20090325184912.495124b6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090325184912.495124b6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Again, good SSD's don't care. Disks do. It doesn't matter if you have a FC 
>> disk array that can eat 300MB/s when streaming - once you start seeking, 
>> that 300MB/s goes down like a rock. Battery-protected write caches will 
>> help - but not a whole lot when streaming more data than they have RAM. 
>> Basic queuing theory.
>>     
>
> Subtly more complex than that. If your mashed up I/O streams fit into the
> 2GB or so of cache (minus one stream to disk) you win. You also win
> because you take a lot of fragmented OS I/O and turn it into bigger
> chunks of writing better scheduled. The latter win arguably shouldn't
> happen but it does occur (I guess in part that says we suck) and it
> occurs big time when you've got multiple accessors to a shared storage
> system (where the host OS's can't help)
>
> Alan
>   

The other thing that can impact random writes on arrays is their 
internal "track" size - if the random write is of a partial track, it 
forces a read-modify-write with a back end disk read.  Some arrays have 
large internal tracks, others have smaller ones.

Again, not unlike what you see with some SSD's and their erase block 
size - give them even multiples of that and they are quite happy.

Ric

