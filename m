Return-Path: <linux-kernel-owner+w=401wt.eu-S1764348AbZCYSu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764348AbZCYSu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZCYSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:50:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56857 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752811AbZCYSur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:50:47 -0400
Date: Wed, 25 Mar 2009 18:49:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rees <drees76@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325184912.495124b6@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0903251122250.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	<20090324103111.GA26691@elte.hu>
	<20090324041249.1133efb6.akpm@linux-foundation.org>
	<20090325123744.GK23439@duck.suse.cz>
	<20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<72dbd3150903251109x75aa5d8ke8277247c2f292f9@mail.gmail.com>
	<alpine.LFD.2.00.0903251117380.3032@localhost.localdomain>
	<alpine.LFD.2.00.0903251122250.3032@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Again, good SSD's don't care. Disks do. It doesn't matter if you have a FC 
> disk array that can eat 300MB/s when streaming - once you start seeking, 
> that 300MB/s goes down like a rock. Battery-protected write caches will 
> help - but not a whole lot when streaming more data than they have RAM. 
> Basic queuing theory.

Subtly more complex than that. If your mashed up I/O streams fit into the
2GB or so of cache (minus one stream to disk) you win. You also win
because you take a lot of fragmented OS I/O and turn it into bigger
chunks of writing better scheduled. The latter win arguably shouldn't
happen but it does occur (I guess in part that says we suck) and it
occurs big time when you've got multiple accessors to a shared storage
system (where the host OS's can't help)

Alan
