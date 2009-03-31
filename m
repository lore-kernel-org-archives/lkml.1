Return-Path: <linux-kernel-owner+w=401wt.eu-S1761735AbZCaPJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735AbZCaPJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760780AbZCaPJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:09:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760610AbZCaPJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:09:19 -0400
Date: Tue, 31 Mar 2009 07:55:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ric Wheeler <rwheeler@redhat.com>
cc: Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
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
In-Reply-To: <49D1FB64.8000505@redhat.com>
Message-ID: <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain>
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk>
 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
 <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Mar 2009, Ric Wheeler wrote:
> 
> Now you are just being silly. The drive and the write cache - without barriers
> or similar tagged operations - will almost certainly reorder all of the IO's
> internally.

You do realize that the "drive" may not be a drive at all?

But apparently you don't. You really seem to see just your own case, and 
have blinders on for everything else.

That "drive" may be some virtualized device. It may be some super-fancy 
memory mapped and largely undocumented random flash thing. It might be a 
network block device, it may be somebody's IO trace dummy layer, it may be 
anything at all.

Your filesystem doesn't know. It damn well not even _try_ to know, because 
it isn't the low-level driver.

The low-level driver - which you don't have a friggin clue about - may say 
that it doesn't support barrier IO for any random reason that has 
absolutely _nothing_ to do with any write caches or anything else. Maybe 
the device has the same ordering semantics as an Intel CPU has: writes are 
always seen in order on the disk, and reads are always speculated but will 
snoop in write buffers, and ther is no way to not do that.

See? EOPNOTSUPP means just that - it means that the driver doesn't support 
the notion of ordered IO. But that does not necessarily mean that the 
writes aren't always in order. It may well just mean that the drive is a 
thin shimmy layer over something else (for example, just a user level 
pipe), and the driver has NO IDEA what the end result is, and the protocol 
is simplistic and is just 'read' and 'write' and absolutely nothing else.

But you seem to NOT UNDERSTAND THIS.

I'm not interested in your inane drivel. Let's just say that your lack of 
understanding just means that your input is irrelevant, and leave it at 
that. Ok? Until you can see the bigger picture, just don't bother.

			Linus
