Return-Path: <linux-kernel-owner+w=401wt.eu-S934079AbXCTVdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbXCTVdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934086AbXCTVdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:33:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44832 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079AbXCTVdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:33:02 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: David Woodhouse <dwmw2@infradead.org>
To: David Lang <david.lang@digitalinsight.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <Pine.LNX.4.63.0703201049310.8684@qynat.qvtvafvgr.pbz>
References: <20070318162720.GI10459@waste.org>
	 <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron>
	 <20070320135231.GA6043@thunk.org>
	 <1174406395.30079.139.camel@zod.rchland.ibm.com>
	 <Pine.LNX.4.63.0703201049310.8684@qynat.qvtvafvgr.pbz>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 21:32:40 +0000
Message-Id: <1174426360.20505.15.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 10:58 -0800, David Lang wrote:
> What Matt and Ted are looking at is the question 'are flash devices close enough 
> to other block devices that it would make sense to change the existing linux 
> definition of a block device to handle the special requirements of flash'

I've seen no real proposals about how this could be done, so it's a
purely academic question. But I'm dubious. The block layer is optimised,
perhaps unsurprisingly, for block devices. Making it handle our special
case might be possible, but I don't really think it's likely to fly once
it becomes real code and not just mental self-abuse. Hell, we haven't
even got block _discard_ support merged yet, because it's too esoteric
for people to care about.

The MTD API does need to be re-thought. It's no longer quite so
unthinkable that we'll encounter flash sizes above 4GiB, and the way we
(theoretically) handle asynchronous erases while read and write are
synchronous is a bit icky. I'm not averse to using queues and making it
look a _bit_ like block devices in some respects, but in practice I
don't think it'll be very close at all.

The MTD API is intended to represent the raw capabilities of the
underlying flash devices, with all the bizarre restrictions and features
that the various types of flash chip have. If you want to use it as a
block device, that's what translation layers are for.

-- 
dwmw2

