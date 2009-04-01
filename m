Return-Path: <linux-kernel-owner+w=401wt.eu-S1762572AbZDABHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762572AbZDABHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbZDABGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:06:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:57341 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbZDABGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:06:53 -0400
Message-ID: <49D2BD59.6020106@kernel.org>
Date: Wed, 01 Apr 2009 10:03:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Theodore Tso <tytso@mit.edu>,
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
References: <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B70E.8060506@oss.ntt.co.jp> <20090330140427.GG13356@mit.edu> <1238422551.30488.47.camel@think.oraclecorp.com> <20090330143343.GJ13356@mit.edu> <49D17162.1090207@kernel.org> <20090331111818.GL5178@kernel.dk> <49D28B1C.8030601@garzik.org>
In-Reply-To: <49D28B1C.8030601@garzik.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 01:03:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jens Axboe wrote:
>> On Tue, Mar 31 2009, Tejun Heo wrote:
>>> Hello,
>>>
>>> Theodore Tso wrote:
>>>> On Mon, Mar 30, 2009 at 10:15:51AM -0400, Chris Mason wrote:
>>>>> I'm not sure we want to stick Fernando with changing how barriers are
>>>>> done in individual filesystems, his patch is just changing the
>>>>> existing
>>>>> call points.
>>>> Well, his patch actually added some calls to block_issue_flush().  But
>>>> yes, it's probably better if he just changes the existing call points,
>>>> and we can have the relevant filesystem maintainers double check to
>>>> make sure that there aren't any new call points which are needed.
>>> How about having something like blk_ensure_cache_flushed() which
>>> issues flush iff there hasn't been any write since the last flush?
>>> It'll be easy to implement and will filter out duplicate flushes in
>>> most cases.
>>
>> My original ide implementation of flushes actually did this. My memory
>> is a little hazy on why it was dropped, I'm guessing because it
>> basically never triggered anyway.
> 
> Yeah, and it probably wouldn't trigger today unless we add new code that
> starts generating enough duplicate cache flushes for this to be
> significant...

Well, the thread was about adding such a call, so...

> And since duplicate cache flushes are harmless to the drive, you're only
> talking about no-op ATA command overhead.  Which is only mildly notable
> on legacy IDE (eight or so inb/outb operations).
> 
> I would put duplicate cache flush filtering way, way down on the
> priority list, IMO.

Yeap, unless FS guys need it, there's no reason to push it.
Although having dup flush detection Theodore described (w/ callstack
saving at issue time) would be nice for debugging.

Thanks.

-- 
tejun
