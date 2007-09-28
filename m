Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbXI1R7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbXI1R7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbXI1R7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:59:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36093 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbXI1R7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:59:20 -0400
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com>
	 <20070919033643.763818012@sgi.com>
	 <200709280742.38262.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 19:55:19 +0200
Message-Id: <1191002119.18147.80.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-09-28 at 10:33 -0700, Christoph Lameter wrote:

> Again I have not seen any fallbacks to vmalloc in my testing. What we are 
> doing here is mainly to address your theoretical cases that we so far have 
> never seen to be a problem and increase the reliability of allocations of
> page orders larger than 3 to a usable level. So far I have so far not 
> dared to enable orders larger than 3 by default.

take a recent -mm kernel, boot with mem=128M.

start 2 processes that each mmap a separate 64M file, and which does
sequential writes on them. start a 3th process that does the same with
64M anonymous.

wait for a while, and you'll see order=1 failures.



