Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYDGVHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYDGVHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYDGVH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:07:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60480 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYDGVH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:07:26 -0400
Message-ID: <47FA8CB0.6070106@cs.helsinki.fi>
Date: Tue, 08 Apr 2008 00:05:52 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>  <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>  <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy> <Pine.LNX.4.64.0804072121320.28744@blonde.site> <47FA8B5A.5090104@cs.helsinki.fi>
In-Reply-To: <47FA8B5A.5090104@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Although you weren't convinced by my arguments, I still have 
> difficulties understanding why this kind of bad behavior would be 
> acceptable in an embedded environment and why we don't need to fix it 
> for the SLOB case as well.
> 
> But you do bring up a good point of SLUB changing the behavior on OOM 
> situations for which SLAB_NOMERGE sounds like a good-enough stop-gap 
> measure for the short term. I would prefer some other fix even if it 
> means getting rid of slab merging competely (which would suck as it's 
> very nice for making memory footprint smaller).

I wonder if we can get away with a SLAB_IO flag that you can use to 
annotate caches that participate in writeout and the allocator could 
keep some spare pages around that can be handed out for them in case of 
OOM...

		Pekka
