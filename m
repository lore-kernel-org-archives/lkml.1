Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbZCaTZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbZCaTZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZCaTZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:25:33 -0400
Received: from rtr.ca ([76.10.145.34]:55591 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZCaTZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:25:32 -0400
Message-ID: <49D26E28.1080203@rtr.ca>
Date: Tue, 31 Mar 2009 15:25:28 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain> <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com> <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain> <49D239A0.5080405@redhat.com>
In-Reply-To: <49D239A0.5080405@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
..
> As Mark pointed out, most S-ATA/SAS drives will flush the write cache 
> when they see a bus reset so even without barriers, the cache will be 
> preserved (or flushed) after a reboot or panic.  Power outages are the 
> problem barriers/flushes are meant to help with.
..

I still see barriers as a separate issue from flushes.
Flushes are there for power failures and hot-removable devices.

Barriers are there for that, but also for better odds of data integrity
in the even of a filesystem or kernel crash.

Even if I don't want the kernel needlessly flushing my battery-backed
write caches, I still do want the barrier ordering that improves the
odds of filesystem consistency in the event of a kernel crash.

Cheers
