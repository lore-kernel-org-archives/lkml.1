Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXCUNHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXCUNHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXCUNHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:07:17 -0400
Received: from lazybastard.de ([212.112.238.170]:43923 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbXCUNHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:07:15 -0400
Date: Wed, 21 Mar 2007 14:03:21 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Lang <david.lang@digitalinsight.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070321130320.GC495@lazybastard.org>
References: <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron> <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron> <20070320135231.GA6043@thunk.org> <1174406395.30079.139.camel@zod.rchland.ibm.com> <Pine.LNX.4.63.0703201049310.8684@qynat.qvtvafvgr.pbz> <1174426360.20505.15.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174426360.20505.15.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*sigh*

I really did not want to become involved in this.  So please be nice and
leave the flamethrower in your weapon closet or I will disappear again
before you can say "fire".

On Tue, 20 March 2007 21:32:40 +0000, David Woodhouse wrote:
> On Tue, 2007-03-20 at 10:58 -0800, David Lang wrote:
> > What Matt and Ted are looking at is the question 'are flash devices close enough 
> > to other block devices that it would make sense to change the existing linux 
> > definition of a block device to handle the special requirements of flash'
> 
> I've seen no real proposals about how this could be done, so it's a
> purely academic question.

What you have seen and shot down were patches to make mtd more generic.
So let me just assume both mtd and jffs2 were generic, even though they
currently aren't.

In very broad terms, an mtd is a device with:
1. a read operation
2. a write operation
3. an erase operation
4. a minimal write blocksize
5. a minimal erase blocksize
6. a method to query bad eraseblocks
7. a method to mark bad eraseblocks

Anything else?  There are many more fields, but I believe this is the
essential.  point() and unpoint() were omitted, because they are just
one option to provide XIP.  filemap_xip.c is another used for block
devices.

In very broad terms, a block device has:
1. a read operation
2. a write operation
3. some devices have an ioctl() for erase, but that is uncommon
4. a blocksize

What is missing?  Obviously the erase operation needs to become a
first-class citizen and block devices need two fields for the two
meaningful blocksizes.  And they need methods to query and set bad
blocks.

So far it looks simple enough.  Obviously there are many messy details
left out, so it will be a lot of work in practice.  So the question is:
is it worth it?

What are the gains from combining mtd and block devices?

[ And at this point I would like to state again that I don't want to
become involved in the UBI discussion.  The question whether two
seperate subsystems make sense is quite independent and I don't want
both discussions to get mixed up. ]

Jörn

-- 
He who knows others is wise.
He who knows himself is enlightened.
-- Lao Tsu
