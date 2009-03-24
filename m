Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbZCXQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbZCXQfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763415AbZCXQew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:34:52 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:47115 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbZCXQet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:34:49 -0400
Message-ID: <49C90B91.9050002@krogh.cc>
Date: Tue, 24 Mar 2009 17:34:25 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <20090324133011.GB21720@elte.hu> <20090324135112.GM5814@mit.edu>
In-Reply-To: <20090324135112.GM5814@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Tue, Mar 24, 2009 at 02:30:11PM +0100, Ingo Molnar wrote:
>> i think the problem became visible via the rise in memory size, 
>> combined with the non-improvement of the performance of rotational 
>> disks.
>>
>> The disk speed versus RAM size ratio has become dramatically worse - 
>> and our "5% of RAM" dirty ratio on a 32 GB box is 1.6 GB - which 
>> takes an eternity to write out if you happen to sync on that. When 
>> we had 1 GB of RAM 5% meant 51 MB - one or two seconds to flush out 
>> - and worse than that, chances are that it's spread out widely on 
>> the disk, the whole thing becoming seek-limited as well.
> 
> That's definitely a problem too, but keep in mind that by default the
> journal gets committed every 5 seconds, so the data gets flushed out
> that often.  So the question is how quickly can you *dirty* 1.6GB of
> memory?

Say it's a file that you allready have in memory cache read in.. there
is plenty of space in 16GB for that.. then you can dirty it at 
memory-speed.. that about ½sec. (correct me if I'm wrong).

Ok, this is probably unrealistic, but memory grows the largest we have
at the moment is 32GB and its steadily growing with the core-counts.
Then the available memory is used to cache the "active" portion of the
filsystems. I would even say that in the NFS-servers I depend on it to
do this efficiently. (2.6.29-rc8 delivered 1050MB/s over af 10GbitE 
using nfsd - send speed to multiple clients).

The current workload is based of an active dataset of 600GB where
index'es are being generated and written back to the same disk. So
there is a fairly high read/write load on the machine (as you said was 
required). The majority (perhaps 550GB ) is only read once where the
rest of the time it is stuff in the last 50GB being rewritten.

> "dd if=/dev/zero of=/u1/dirty-me-harder" will certainly do it, but
> normally we're doing something useful, and so you're either copying
> data from local disk, at which point you're limited by the read speed
> of your local disk (I suppose it could be in cache, but how common of
> a case is that?), 

Increasingly the case as memory sizes grows.

 > *or*, you're copying from the network, and to copy
> in 1.6GB of data in 5 seconds, that means you're moving 320
> megabytes/second, which if we're copying in the data from the network,
> requires a 10 gigabit ethernet.

or just around being processed on the 16-32 cores on the system.


Jesper
-- 
Jesper
