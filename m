Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbZCYSeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbZCYSeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZCYSeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:34:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007AbZCYSeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:34:00 -0400
Date: Wed, 25 Mar 2009 11:26:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Rees <drees76@gmail.com>
cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <alpine.LFD.2.00.0903251117380.3032@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903251122250.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>  <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>  <20090324091545.758d00f5@lxorguk.ukuu.org.uk>  <20090324093245.GA22483@elte.hu>  <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
  <20090324103111.GA26691@elte.hu>  <20090324041249.1133efb6.akpm@linux-foundation.org>  <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu>  <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <72dbd3150903251109x75aa5d8ke8277247c2f292f9@mail.gmail.com>
 <alpine.LFD.2.00.0903251117380.3032@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Linus Torvalds wrote:
> 
> Even a suck-ass laptop drive can write streaming data fast enough that 
> people don't care. The problem is invariably that writes from different 
> sources (much of it being metadata) interact and cause seeking.

Actually, not just writes.

The IO priority thing is almost certainly that _reads_ (which get higher 
priority by default due to being synchronous) get interspersed with the 
writes, and then even if you _could_ be having streaming writes, what you 
actually end up with is lots of seeking.

Again, good SSD's don't care. Disks do. It doesn't matter if you have a FC 
disk array that can eat 300MB/s when streaming - once you start seeking, 
that 300MB/s goes down like a rock. Battery-protected write caches will 
help - but not a whole lot when streaming more data than they have RAM. 
Basic queuing theory.

			Linus
