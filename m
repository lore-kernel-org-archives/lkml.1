Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbZCaBab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbZCaBab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZCaBaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:30:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:49193 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZCaBaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:30:20 -0400
Message-ID: <49D17162.1090207@kernel.org>
Date: Tue, 31 Mar 2009 10:26:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
       =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 2/7] ext3: call blkdev_issue_flush() on fsync()
References: <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B70E.8060506@oss.ntt.co.jp> <20090330140427.GG13356@mit.edu> <1238422551.30488.47.camel@think.oraclecorp.com> <20090330143343.GJ13356@mit.edu>
In-Reply-To: <20090330143343.GJ13356@mit.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 31 Mar 2009 01:26:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Theodore Tso wrote:
> On Mon, Mar 30, 2009 at 10:15:51AM -0400, Chris Mason wrote:
>> I'm not sure we want to stick Fernando with changing how barriers are
>> done in individual filesystems, his patch is just changing the existing
>> call points.
> 
> Well, his patch actually added some calls to block_issue_flush().  But
> yes, it's probably better if he just changes the existing call points,
> and we can have the relevant filesystem maintainers double check to
> make sure that there aren't any new call points which are needed.

How about having something like blk_ensure_cache_flushed() which
issues flush iff there hasn't been any write since the last flush?
It'll be easy to implement and will filter out duplicate flushes in
most cases.

Thanks.

-- 
tejun
