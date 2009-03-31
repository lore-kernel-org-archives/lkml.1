Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbZCaVad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbZCaVad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZCaVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:30:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56512 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZCaVaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:30:23 -0400
Message-ID: <49D28B1C.8030601@garzik.org>
Date: Tue, 31 Mar 2009 17:29:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Tejun Heo <tj@kernel.org>, Theodore Tso <tytso@mit.edu>,
       Chris Mason <chris.mason@oracle.com>,
       =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com
Subject: Re: [PATCH 2/7] ext3: call blkdev_issue_flush() on fsync()
References: <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B70E.8060506@oss.ntt.co.jp> <20090330140427.GG13356@mit.edu> <1238422551.30488.47.camel@think.oraclecorp.com> <20090330143343.GJ13356@mit.edu> <49D17162.1090207@kernel.org> <20090331111818.GL5178@kernel.dk>
In-Reply-To: <20090331111818.GL5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Mar 31 2009, Tejun Heo wrote:
>> Hello,
>>
>> Theodore Tso wrote:
>>> On Mon, Mar 30, 2009 at 10:15:51AM -0400, Chris Mason wrote:
>>>> I'm not sure we want to stick Fernando with changing how barriers are
>>>> done in individual filesystems, his patch is just changing the existing
>>>> call points.
>>> Well, his patch actually added some calls to block_issue_flush().  But
>>> yes, it's probably better if he just changes the existing call points,
>>> and we can have the relevant filesystem maintainers double check to
>>> make sure that there aren't any new call points which are needed.
>> How about having something like blk_ensure_cache_flushed() which
>> issues flush iff there hasn't been any write since the last flush?
>> It'll be easy to implement and will filter out duplicate flushes in
>> most cases.
> 
> My original ide implementation of flushes actually did this. My memory
> is a little hazy on why it was dropped, I'm guessing because it
> basically never triggered anyway.

Yeah, and it probably wouldn't trigger today unless we add new code that 
starts generating enough duplicate cache flushes for this to be 
significant...

And since duplicate cache flushes are harmless to the drive, you're only 
talking about no-op ATA command overhead.  Which is only mildly notable 
on legacy IDE (eight or so inb/outb operations).

I would put duplicate cache flush filtering way, way down on the 
priority list, IMO.

	Jeff




