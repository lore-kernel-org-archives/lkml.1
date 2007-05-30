Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbXE3WY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbXE3WY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbXE3WYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:24:15 -0400
Received: from holomorphy.com ([66.93.40.71]:55037 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250AbXE3WYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:24:14 -0400
Date: Wed, 30 May 2007 15:24:44 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530222444.GD31925@holomorphy.com>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 02:27:52PM -0700, Linus Torvalds wrote:
> Well, don't think of it as a special case at all: think of bit 30 as a 
> "the user asked for a non-linear fd".
> In fact, to make it effective, I'd suggest literally scrambling the low 
> bits (using, for example, some silly per-boot xor value to to actually 
> generate the "true" index - the equivalent of a really stupid randomizer). 
> That way you'd have the legacy "linear" space, and a separate "non-linear 
> space" where people simply *cannot* make assumptions about contiguous fd 
> allocations. There's no special case there - it's just an extension which 
> explicitly allows us to say "if you do that, your fd's won't be allocated 
> the traditional way any more, but you *can* mix the traditional and the 
> non-linear allocation".

One could always stuff a seed or per-cpu seeds in the files_struct and
use a PRNG. The only trick would be cacheline bounces and/or space
consumption of seeds. Another possibility would be bitreversed
contiguity or otherwise a bit permutation of some contiguous range,
modulo (of course) the high bit used to tag the randomized range.

With "truly" random/sparse fd numbers it may be meaningful to use a
different data structure from a bitmap to track them in-kernel, though
xor and other easily-computed mappings to/from contiguous ranges won't
need such in earnest.


-- wli
