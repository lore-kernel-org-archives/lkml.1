Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZDAAsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZDAAsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZDAAsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:48:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:55137 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZDAAsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:48:05 -0400
Message-ID: <49D2B8B5.9040602@kernel.org>
Date: Wed, 01 Apr 2009 09:43:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain> <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com> <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain> <49D239A0.5080405@redhat.com> <alpine.LFD.2.00.0903310854570.4093@localhost.localdomain> <20090331164312.GP5178@kernel.dk> <20090331170319.GT5178@kernel.dk>
In-Reply-To: <20090331170319.GT5178@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 00:43:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Mar 31 2009, Jens Axboe wrote:
>> On Tue, Mar 31 2009, Linus Torvalds wrote:
>>>
>>> On Tue, 31 Mar 2009, Ric Wheeler wrote:
>>>> The question is really what we do when you have a storage device in your box
>>>> with a volatile write cache that does support flush or fua or similar.
>>> Ok. Then you are talking about a different case - not EOPNOTSUPP.
>> So here's a test patch that attempts to just ignore such a failure to
>> flush the caches. It will still flag the bio as BIO_EOPNOTSUPP, but
>> that's merely maintaining the information in case the caller does want
>> to see if that barrier failed or not. It may not actually be useful, in
>> which case we can just kill that flag.
> 
> Updated version, the previous missed most of the buffer_eopnotsupp()
> checking. So this one also gets rid of the file system retry logic.
> Thanks to gfs2 Steve for pointing out that I missed gfs2, made me
> realize that I missed a lot more as well.

Wouldn't it be cleaner to simply finish with success status from
blk_do_ordered()?  That is the single place that all flush/barrier ops
go through and semantically better place too.

Thanks.

-- 
tejun
