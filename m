Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZC0WTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZC0WTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZC0WTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:19:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbZC0WTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:19:34 -0400
Date: Fri, 27 Mar 2009 15:10:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
In-Reply-To: <20090327213806.GG31071@duck.suse.cz>
Message-ID: <alpine.LFD.2.00.0903271508520.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
 <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326181106.GC17159@duck.suse.cz> <alpine.LFD.2.00.0903261534490.3032@localhost.localdomain> <20090326155725.c2150ab2.akpm@linux-foundation.org>
 <20090327213806.GG31071@duck.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Jan Kara wrote:
>
>   Doable but not fairly simple ;) Firstly you have to restart a transaction
> when you've used up all the credits you originally started with (easy),
> secondly ext3 uses lock order PageLock -> "transaction start" which is
> unusable for the scheme you suggest. So we'd have to revert that - which
> needs larger audit of our locking scheme and that's probably the reason
> why noone has done it yet.

It's also not clear that ext3 can really do much better than the regular 
generic_writepages() logic. I mean, seriously, what's there to improve on? 
The transaction code is all normally totally pointless, and I merged the 
patch that avoids it when not necessary. 

It might be different if more people used "data=journal", but I don't 
doubt that is very common. For data=writeback and data=ordered, I bet 
generic_writepages() is as good as anything ext3-specific could be.

			Linus
